trigger Task_Trigger on Project_Task__c ( before insert, before update, after insert, after update, after delete) {
    if(trigger.isBefore) {
        if(Trigger.isInsert || Trigger.isUpdate ){
            TaskWapper process = new TaskWapper(Trigger.new);
            
            //自动填充字段
            process.AutoPopField();      

        }
        if(Trigger.isUpdate){
             for(Project_Task__c rc : trigger.new) {
                /** 该部分功能取消 **
                if( rc.TaskStatus__c == '已接受' && rc.TaskStatus__c != trigger.oldMap.get(rc.id).TaskStatus__c){
                    Integer TimeCount = [SELECT COUNT() FROM Time__c 
                              WHERE Project_Task__c = :rc.id];
                              if(TimeCount == 0){
                                rc.addError('接受任务/工单前，请填写工时信息');
                              }
                }*/
                if(rc.Department__c != trigger.oldMap.get(rc.id).Department__c){
                    rc.TaskStatus__c = '未接受';
                }
             }
         }
        for( Project_Task__c rec : trigger.new ){ 
            if (rec.Complete__c == false && rec.Days_Late_Formula__c > 0) {
                rec.Days_Late__c = rec.Days_Late_Formula__c;
            } else {
                rec.Days_Late__c = 0; 
            }
        }
        Set<ID> MilestoneIds = new Set<ID>();
        Set<ID> EmployeeIds = new Set<ID>();
        Map<Id, String> EmployeeIDUserId = new Map<Id, String>();
        Map<Id, String> EmployeeIDEmail = new Map<Id, String>();
        //Map<Id, String> EmployeeIDApproverId = new Map<Id, String>();
        
        if(trigger.isInsert || trigger.isUpdate ){
            for(Project_Task__c rec : Trigger.new) 
            {
                if(rec.Project_Milestone__c != null){
                    MilestoneIds.add(rec.Project_Milestone__c);
                    EmployeeIds.add(rec.Employee__c);
                }else{
                    EmployeeIds.add(rec.Employee__c);
                }
                EmployeeIds.add(rec.Assigned_To__c);
            }
            list<Milestone__c> milestoneList = [SELECT id, Project__c, Project__r.Project_Manager__c, Project__r.name FROM Milestone__c WHERE id in :MilestoneIds]; 
            for(Milestone__c milestone : milestoneList) {
                EmployeeIds.add(milestone.Project__r.Project_Manager__c);
            }
            if(EmployeeIds.size() > 0){
                List<Employee__c> employees = [select id, DepartmentManager__c,  n_EmployeeName__c, Employee_Email__c  from Employee__c where id in :EmployeeIds ];
                for(Employee__c ep : employees) {
                    EmployeeIDUserId.put(ep.id, ep.n_EmployeeName__c);
                    EmployeeIDEmail.put(ep.id, ep.Employee_Email__c);
                    //EmployeeIDApproverId.put(ep.id, ep.DepartmentManager__c);
                }
            }
            for(Project_Task__c pTask : Trigger.new) { 
                if(pTask.Project_Milestone__c != null){
                    
                    for(Milestone__c milestone : milestoneList) {
                        if(pTask.Project_Milestone__c == milestone.Id ){
                            pTask.Project__c = milestone.Project__c;
                            //pTask.Approver__c = EmployeeIDApproverId.get(milestone.Project__r.Project_Manager__c);
                            pTask.Approver__c = EmployeeIDUserId.get(pTask.Employee__c);
                            pTask.OwnerId = EmployeeIDUserId.get(pTask.Assigned_To__c);
                            pTask.Employee_Email__c = EmployeeIDEmail.get(pTask.Assigned_To__c);
                            pTask.ApplyEmployee_Email__c = EmployeeIDEmail.get(pTask.Employee__c);
                        }
                        
                    }
                }else{
                    pTask.Approver__c = EmployeeIDUserId.get(pTask.Employee__c);
                    if(pTask.Assigned_To__c != null){
                        pTask.OwnerId = EmployeeIDUserId.get(pTask.Assigned_To__c);
                    }
                    pTask.Employee_Email__c = EmployeeIDEmail.get(pTask.Assigned_To__c);
                    pTask.ApplyEmployee_Email__c = EmployeeIDEmail.get(pTask.Employee__c);
                }
            }
            
        }

    } 
        
    if(trigger.isAfter) {

        
        Set<ID> milestoneIds = new Set<ID>();
        list<Project_Task__c> TaskList = new list<Project_Task__c>();
        if(trigger.isdelete) {
            TaskList = trigger.old;
        }else{
            TaskList = trigger.new;
        }
        for(Project_Task__c rec : TaskList) 
        { 
            if(rec.Project_Milestone__c != null){
                milestoneIds.add(rec.Project_Milestone__c); 
            }
        }
        list<Milestone__c> milestoneList = [SELECT id, Estimated_Expense_From_Tasks__c, Estimated_Hours_From_Tasks__c, Actual_Expense_From_Tasks__c, Actual_Hours_From_Task__c, Blocked_Tasks__c, Late_Tasks__c, Complete_Tasks__c, Open_Tasks__c FROM Milestone__c WHERE Id in :milestoneIds]; 
        list<Project_Task__c> FullTaskList = [SELECT id, Project_Milestone__c , Estimated_Expense__c, Estimated_Hours__c, Total_Expense__c, Total_Hours__c, Blocked__c, Days_Late__c, Complete__c  FROM Project_Task__c WHERE Project_Milestone__c in :milestoneIds];
        for(Milestone__c milestone : milestoneList){
            milestone.Estimated_Expense_From_Tasks__c = 0;
            milestone.Estimated_Hours_From_Tasks__c = 0;
            milestone.Actual_Expense_From_Tasks__c = 0;
            milestone.Actual_Hours_From_Task__c = 0;
            milestone.Blocked_Tasks__c = 0;
            milestone.Open_Tasks__c = 0;
            milestone.Late_Tasks__c = 0;
            milestone.Complete_Tasks__c = 0;
            
            for(Project_Task__c TaskDetail : FullTaskList){
               if(milestone.id == TaskDetail.Project_Milestone__c){
                    milestone.Estimated_Expense_From_Tasks__c += TaskDetail.Estimated_Expense__c;
                    milestone.Estimated_Hours_From_Tasks__c += TaskDetail.Estimated_Hours__c;
                    if(TaskDetail.Blocked__c == true){
                        milestone.Blocked_Tasks__c += 1;
                    }
                    if(TaskDetail.Days_Late__c > 0){
                        milestone.Late_Tasks__c += 1;
                    }
                    if(TaskDetail.Complete__c == true){
                        milestone.Complete_Tasks__c += 1;
                        milestone.Actual_Expense_From_Tasks__c += TaskDetail.Total_Expense__c;
                        milestone.Actual_Hours_From_Task__c += TaskDetail.Total_Hours__c;
                    }else{
                        milestone.Open_Tasks__c += 1;
                    }
               }
            }
        }
        update milestoneList;
        if(trigger.isInsert || trigger.isUpdate){
            Map<Id, String> ProjectIDName = new Map<Id, String>();
            list<Milestone__c> milestoneListAfter = [SELECT id, Project__c, Project__r.Project_Manager__c, Project__r.name FROM Milestone__c WHERE id in :MilestoneIds]; 
                for(Milestone__c milestone : milestoneListAfter) {
                    ProjectIDName.put(milestone.Project__c, milestone.Project__r.name);
                }
            for(Project_Task__c pTask : Trigger.new) { 
                if(trigger.isInsert || trigger.isUpdate && pTask.Assigned_To__c != trigger.oldMap.get(pTask.id).Assigned_To__c){
                            if(pTask.Employee_Email__c != null){
                                String str=System.Url.getSalesforceBaseUrl().toExternalForm();
                                String[] toAddresses=new String[]{pTask.Employee_Email__c};
                                Messaging.Singleemailmessage email=new Messaging.Singleemailmessage();
                                email.setSubject('任务分配提醒');
                                email.setToAddresses(toAddresses);
                                email.setSaveAsActivity(false);
                                email.setPlainTextBody('您好：'+'\n'+'您有一个新的任务/工单待处理,'+'\n'+'项目名称:'+ProjectIDName.get(pTask.Project__c)+'\n'+'任务名称:'+pTask.Name+'\n'+'详细信息请看'+'\n'+str+'/'+pTask.id);        
                                Messaging.Sendemailresult[] r=Messaging.sendEmail(new Messaging.Singleemailmessage[]{email});
                            }
               }

            }
        }

        
        //------------------2015/02/13--Start-----------------------
        if(trigger.isUpdate){
            
            TaskWapper process = new TaskWapper(Trigger.new);
            
            //共享给项目负责人
            process.shareTaskToProjectManager();
            //工单状态为完成时，发邮件给申请人和分配人，请他们互评。
            //process.evalutionMailNotification();
        }
        //------------------2015/02/13--End--------------------------

        if(trigger.isInsert){
        List<ID> employeeIdList = new List<ID>();
        Map<Id, Id> userIdMap = new Map<Id, Id>();
        List<ID> pjIdList = new List<ID>();
        Map<Id, List<Project_TeamMember__c>> pjtsMap = new Map<Id, List<Project_TeamMember__c>>();
        for(Project_Task__c pTaskE : Trigger.new) { 
                employeeIdList.add(pTaskE.Assigned_To__c);
                pjIdList.add(pTaskE.project__c);
            }

            /*
            List<Project__Share> psList = new List<Project__Share>();
            try{
                    for(Project_Task__c taskE : Trigger.new) {
                        psList.add(new Project__Share(ParentId = taskE.project__c,
                                                        UserOrGroupId = userIdMap.get(taskE.Assigned_To__c), 
                                                        AccessLevel =  'Edit'));
                    }
                
                if(psList.size() > 0) Database.SaveResult[] lsr = Database.insert(psList,false);
                    
            } catch(exception ex) {
                System.debug('共享 任务人员 失败 : ' + ex);
            }
            */
            List<Project_TeamMember__c> pjtms = [SELECT Id, Project__c, Team_Member__c 
            FROM Project_TeamMember__c where Project__c in :pjIdList];
            for(Project_TeamMember__c pjtm : pjtms) {
                employeeIdList.add(pjtm.Team_Member__c);
                if(pjtsMap.keyset().contains(pjtm.Project__c)) {
                    pjtsMap.get(pjtm.Project__c).add(pjtm);
                } else {
                    List<Project_TeamMember__c> dpjts = new List<Project_TeamMember__c>();
                    dpjts.add(pjtm);
                    pjtsMap.put(pjtm.Project__c,dpjts);
                }
            }
            List<Employee__c> employees = [select id, n_EmployeeName__c from Employee__c where Id in :employeeIdList];
            for(Employee__c u : employees) {
                userIdMap.put(u.id, u.n_EmployeeName__c );
            }
            List<Project_Task__Share> ptsList = new List<Project_Task__Share>();
            List<Project_Task__Share> pTaskShareList = new List<Project_Task__Share>();
                    for(Project_Task__c taskE : Trigger.new) {
                        if(taskE.Approver__c != null && taskE.OwnerId != taskE.Approver__c){
                            ptsList.add(new Project_Task__Share(ParentId = taskE.Id,
                                                            UserOrGroupId = taskE.Approver__c, 
                                                            AccessLevel =  'Edit'));
                        }
                        if(pjtms.size() > 0){
                            for(Project_TeamMember__c pTm : pjtsMap.get(taskE.project__c)) {
                                if(userIdMap.get(pTm.Team_Member__c) != null && taskE.OwnerId != userIdMap.get(pTm.Team_Member__c) ){
                                    system.debug('+++userIdMap+'+userIdMap);
                                    system.debug('+++pTmid+'+pTm.id);
                                    pTaskShareList.add(new Project_Task__Share(ParentId = taskE.Id,
                                                            UserOrGroupId = userIdMap.get(pTm.Team_Member__c), 
                                                            AccessLevel =  'Edit'));
                                }
                        
                            }
                        }
                    }
                
                if(ptsList.size() > 0) insert ptsList;
                if(pTaskShareList.size() > 0)insert pTaskShareList;
        }
    }

}