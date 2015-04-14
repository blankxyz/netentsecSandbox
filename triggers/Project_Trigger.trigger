trigger Project_Trigger on Project__c ( after insert,after update) {
    Set<ID> EmployeeIds = new Set<ID>();
    //待评价项目集合
    Set<Id> waittingEvaPs = new Set<Id>();
    //共享项目
    Set<Id> sharePs = new Set<Id>();

    for(Project__c rec : Trigger.new) {

        if(trigger.isInsert || trigger.isUpdate && rec.Project_Manager__c != trigger.oldMap.get(rec.id).Project_Manager__c){
            EmployeeIds.add(rec.Project_Manager__c);
        }

        //项目完成后评价功能--------------------------------
        if ((trigger.isInsert ||
            (trigger.isUpdate && rec.Status__c != trigger.oldMap.get(rec.id).Status__c )
            ) && 
            (rec.Status__c == '已完成赢单' || rec.Status__c == '已完成丢单')){
            waittingEvaPs.add(rec.Id);
        }
        //项目完成后评价功能--------------------------------
        //项目共享功能-------------------------------------
        if ((trigger.isInsert || 
            (trigger.isUpdate && rec.Opportunity__c != trigger.oldMap.get(rec.id).Opportunity__c)) &&
            rec.Opportunity__c != null
            ){
            sharePs.add(rec.Id);
        }
        //项目共享功能-------------------------------------

    }


    if(EmployeeIds.size() > 0){
        List<Employee__c> employees = [select id, Name from Employee__c where id in :EmployeeIds ];
        Map<Id, String> EmployeeIDEmployeeName = new Map<Id, String>();
        for(Employee__c ep : employees) {
            EmployeeIDEmployeeName.put(ep.id, ep.Name);
        }

        List<Project_TeamMember__c> ProjectMembers = new List<Project_TeamMember__c>();
        for(Project__c rec : Trigger.new) {
            if(trigger.isInsert || trigger.isUpdate && rec.Project_Manager__c != trigger.oldMap.get(rec.id).Project_Manager__c){
                Project_TeamMember__c ProjectMember = new Project_TeamMember__c();
                ProjectMember.Name = EmployeeIDEmployeeName.get(rec.Project_Manager__c);
                ProjectMember.project__c = rec.id;
                if(trigger.isInsert){
                    ProjectMember.Project_Role__c = '技术主管';
                }else{
                    ProjectMember.Project_Role__c = '项目负责人';
                }
                ProjectMember.Team_Member__c = rec.Project_Manager__c;
                ProjectMembers.add(ProjectMember);
            }
        }
        insert ProjectMembers;
    }

    //项目完成后评价功能  2015/02/11
    if(waittingEvaPs.size() > 0){
        //项目完成评价流程
        ProjectWapperA.createProjectEvaProcess(waittingEvaPs);

    }

    //项目共享给销售人员功能
    if(sharePs.size() > 0){
        ProjectWapperA.shareToSalesProcess(sharePs);
    }



}