public class Project_TeamMember_Trigger_Utility{
    // insert Project_TeamMember sharing records
    public static void shareToUserInsert(List<Project_TeamMember__c> ptList) {
       // Savepoint sp = Database.setSavepoint();
        List<ID> userIdList = new List<ID>();
        List<ID> pjIdList = new List<ID>();
        Map<Id, List<Project_Task__c>> pjtsMap = new Map<Id, List<Project_Task__c>>();
        for(Project_TeamMember__c ct : ptList) {
            userIdList.add(ct.Team_Member__c);
            pjIdList.add(ct.project__c);
        }
        List<Project_Task__c> pjts = [SELECT Id, Project__c
            FROM Project_Task__c where Project__c in :pjIdList];
        for(Project_Task__c pjt : pjts) {
            if(pjtsMap.keyset().contains(pjt.Project__c)) {
                pjtsMap.get(pjt.Project__c).add(pjt);
            } else {
                List<Project_Task__c> dpjts = new List<Project_Task__c>();
                dpjts.add(pjt);
                pjtsMap.put(pjt.Project__c,dpjts);
            }
        }
        Map<Id, Id> userIdMap = new Map<Id, Id>();
        List<Employee__c> employees = [select id, n_EmployeeName__c from Employee__c where Id in :userIdList];
        for(Employee__c u : employees) {
            userIdMap.put(u.id, u.n_EmployeeName__c );
        }
        List<Project__Share> psList = new List<Project__Share>();
        List<Project_Task__Share> pTaskShareList = new List<Project_Task__Share>();
       // try{
            if(ptList.size() > 0) {
                for(Project_TeamMember__c ct : ptList) {
                    psList.add(new Project__Share(ParentId = ct.project__c,
                                                    UserOrGroupId = userIdMap.get(ct.Team_Member__c), 
                                                    AccessLevel =  'Edit'));
                                                    system.debug('ctprojectc++++'+ct.project__c);
                                                    system.debug('pjtsMap++++'+pjtsMap);
                    if(pjts.size() > 0){
                        for(Project_Task__c pTask : pjtsMap.get(ct.project__c)) {
                            pTaskShareList.add(new Project_Task__Share(ParentId = pTask.Id,
                                                        UserOrGroupId = userIdMap.get(ct.Team_Member__c), 
                                                        AccessLevel =  'Edit'));
                        
                        }
                    }
                }
            
            if(psList.size() > 0) Database.SaveResult[] lsr = Database.insert(psList,false);
            if(pTaskShareList.size() > 0) Database.SaveResult[] lsr = Database.insert(pTaskShareList,false);
                
            // Process the save results
            }
        //} catch(exception ex) {
        //    Database.rollback(sp);
       //     System.debug('share TeamMember failed : ' + ex);
        //}
    }
    
    // delete TeamMember sharing records
    public static void shareToUserDelete(List<Project_TeamMember__c> ptList) {
        Savepoint sp = Database.setSavepoint();
        List<Project__Share> psList = new List<Project__Share>();
        List<Project__Share> csDelList = new List<Project__Share>();
        List<ID> userIdList = new List<ID>();
        List<ID> pjIdList = new List<ID>();
        try{
            List<ID> employeeIdList = new List<ID>();
            for(Project_TeamMember__c ct : ptList) {
                employeeIdList.add(ct.Team_Member__c);
            }
            Map<Id, Id> userIdMap = new Map<Id, Id>();
            List<Employee__c> employees = [select id, n_EmployeeName__c from Employee__c where Id in :employeeIdList];
            for(Employee__c u : employees) {
                userIdList.add(u.n_EmployeeName__c);
            }
            if(ptList.size() > 0) {
                for(Project_TeamMember__c ct : ptList) {
                    //userIdList.add(ct.Team_Member__c);
                    pjIdList.add(ct.project__c);
                }
                
                psList = [select Id, UserOrGroupId, AccessLevel, RowCause from Project__Share
                            where ParentId in :pjIdList and UserOrGroupId in :userIdList];
                
                for(Integer i = 0; i < ptList.size(); i++) {
                    for(Integer j = 0; j < psList.size(); j++) {
                        if(psList[j].UserOrGroupId == ptList[i].Team_Member__c && (psList[j].RowCause <> 'Owner' || psList[j].RowCause <> 'Administrator')) {
                            csDelList.add(psList[j]);
                            break;
                        }
                    }
                }
                
                if(csDelList.size() > 0) Database.DeleteResult[] lsr = Database.delete(csDelList,false);
            }
        } catch(exception ex) {
            Database.rollback(sp);
            System.debug('share Campaign failed : ' + ex);          
        }
    }
}