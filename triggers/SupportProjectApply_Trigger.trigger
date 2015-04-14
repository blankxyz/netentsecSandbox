trigger SupportProjectApply_Trigger on SupportProjectApply__c (Before insert, Before update, After insert,After update) {
	if(Trigger.isBefore){
		if(Trigger.isInsert){
			Map<Id, Id> spOppId = new Map<Id, Id>();
			Map<Id, Id> spOrderId = new Map<Id, Id>();
			Map<Id, Id> OrderIDOpportunityId = new Map<Id, Id>();
	        Map<Id, Opportunity> oppIDOpportunity = new Map<Id, Opportunity>();
	        for(SupportProjectApply__c rc : trigger.new) {
	        	if(rc.Order__c != null) {
	                    spOrderId.put(rc.id, rc.Order__c);
	            }

	        }
	        for(Orders__c o : [select id, SalesOpportunities__c from Orders__c where id in :spOrderId.values()]){
	                 OrderIDOpportunityId.put(o.id, o.SalesOpportunities__c);
	        }

	         for(SupportProjectApply__c rc : trigger.new) {
	                if(rc.Opportunity__c != null && rc.Approver__c == null) {
	                    spOppId.put(rc.id, rc.Opportunity__c);
	                }else if(rc.Order__c != null) {
	                	rc.Opportunity__c = OrderIDOpportunityId.get(rc.Order__c);
	                	spOppId.put(rc.id, rc.Opportunity__c);
	                }
	         }
	         system.debug('spOppId+++++'+spOppId);
	         if(spOppId.size()>0){
	             for(Opportunity a : [select id, SalesRegion__r.SEPersonInCharge__c, SalesRegion__c from Opportunity where id in :spOppId.values()]){
	                 oppIDOpportunity.put(a.id, a);
	             }
	             for(SupportProjectApply__c sp : trigger.new) {
	             	if(sp.Opportunity__c != null && sp.Approver__c == null) {
	                     sp.Approver__c = oppIDOpportunity.get(sp.Opportunity__c).SalesRegion__r.SEPersonInCharge__c;
	             	}
	             }
	         }


		}
         if(Trigger.isUpdate){
	         for(SupportProjectApply__c rc : trigger.new) {
                if(rc.approve_status__c == '审批成功' && rc.Project_Manager__c != trigger.oldMap.get(rc.id).Project_Manager__c){
                	rc.approve_status__c = '已建项目';
                }
	         }
         }
	}
    if(Trigger.isAfter){

    	
	        //共享销售机会给审批者
	    //--------------------------------------------------------------------
	        List<OpportunityShare> oppShares = new List<OpportunityShare>();

			for(SupportProjectApply__c rc : trigger.new) {
				if((Trigger.isInsert 
					|| (Trigger.isUpdate && rc.Approver__c != trigger.oldMap.get(rc.id).Approver__c))
				   && rc.Approver__c != null){
				    OpportunityShare os = new OpportunityShare();
				    os.OpportunityId = rc.Opportunity__c; 
				    os.OpportunityAccessLevel = 'Read';
				    os.UserOrGroupId = rc.Approver__c;
				    //os.RowCause = 'Manual Sharing';
				    oppShares.add(os); 
				}

			}
			system.debug('--------共享记录：' + oppShares +'-------------');
			if(oppShares.size()>0){
				Database.SaveResult[] result = Database.insert(oppShares, false);
			}
		
	    //----------------------------------------------------------------------    		
    	
        //Map<Id, Id> spOppId = new Map<Id, Id>();
        //Map<Id, Opportunity> oppIDOpportunity = new Map<Id, Opportunity>();
        
         //for(SupportProjectApply__c rc : trigger.new) {
         //       if(rc.Opportunity__c != null) {
         //           spOppId.put(rc.id, rc.Opportunity__c);
         //       }
         //}
         //system.debug('spOppId+++++'+spOppId);
         //if(spOppId.size()>0){
             //for(Opportunity a : [select id, SalesRegion__r.SEPersonInCharge__c, SalesRegion__c from Opportunity where id in :spOppId.values()]){
             //    oppIDOpportunity.put(a.id, a);
             //}
             //system.debug('oppIDOpportunity+++++'+oppIDOpportunity);
             List<OpportunityShare> osList = new List<OpportunityShare>();
             List<SupportProjectApply__Share> ssList = new List<SupportProjectApply__Share>();
             for(SupportProjectApply__c sp : trigger.new) {
             	if(Trigger.isInsert || (Trigger.isUpdate && sp.Approver__c != trigger.oldMap.get(sp.id).Approver__c)){
                 if(sp.Opportunity__c != null) {
                    
                     //sp.Approver__c = oppIDOpportunity.get(sp.Opportunity__c).SalesRegion__r.SEPersonInCharge__c;
                     system.debug('spApproverc+++++'+sp.Approver__c);
                      osList.add(new OpportunityShare(OpportunityId = sp.Opportunity__c,
                                                            UserOrGroupId = sp.Approver__c, 
                                                            OpportunityAccessLevel =  'Read'));
                  }
                  ssList.add(new SupportProjectApply__Share(ParentId = sp.id,
	                                                            UserOrGroupId = sp.Approver__c, 
	                                                            AccessLevel =  'Edit'));
                  
             	}
             }
             if(ssList.size() > 0) Database.insert(ssList,false);
             if(osList.size() > 0) Database.insert(osList,false);
         //}
     }
     if(trigger.isUpdate && Trigger.isAfter){
     	Set<ID> EmployeeIds = new Set<ID>();
     	Set<ID> spOppId = new Set<ID>();
     	Map<Id, String> oppIDName = new Map<Id, String>();
     	for(SupportProjectApply__c rc : trigger.new) {
                if(rc.approve_status__c == '已建项目' && rc.approve_status__c != trigger.oldMap.get(rc.id).approve_status__c){
                    EmployeeIds.add(rc.Project_Manager__c);
                    spOppId.add(rc.Opportunity__c);
                }
         }
         if(EmployeeIds.size() > 0){
         	for(Opportunity a : [select id, Name from Opportunity where id in :spOppId]){
	                 oppIDName.put(a.id, a.name);
	         }
	         List<Employee__c> employees = [select id, n_EmployeeName__c, Employee_Email__c from Employee__c where id in :EmployeeIds ];
	         Map<Id, ID> EmployeeIDUserId = new Map<Id, Id>();
	         Map<Id, String> EmployeeIDEmail = new Map<Id, String>();
	         for(Employee__c ep : employees) {
	            EmployeeIDUserId.put(ep.id, ep.n_EmployeeName__c);
	            EmployeeIDEmail.put(ep.id, ep.Employee_Email__c);
	         }
	         List<SupportProjectApply__Share> ssList = new List<SupportProjectApply__Share>();
	         List<OpportunityShare> osList = new List<OpportunityShare>();
	             for(SupportProjectApply__c sp : trigger.new) {
	             	if(sp.approve_status__c == '已建项目' && sp.approve_status__c != trigger.oldMap.get(sp.id).approve_status__c){
	             		
			            SupportProjectApply__c supportProjectApplyDetail = [select id , Order__c, Opportunity__r.Name, Project_Manager__c, Opportunity__r.Id, recordtypeId from SupportProjectApply__c where id = :sp.id];
			            Opportunity  opp;
			            if(supportProjectApplyDetail.Opportunity__r.Id != null){
				        	opp = [select id, SalesRegion__r.SEPersonInCharge__c, SalesRegion__c from Opportunity where id = :supportProjectApplyDetail.Opportunity__r.Id];
			            }
				        system.debug('++++111'+supportProjectApplyDetail.Project_Manager__c);
				        List<Employee__c> employeesP = new List<Employee__c>();
				        if(supportProjectApplyDetail.Project_Manager__c != null ){
				        	employeesP = [select id, name ,n_EmployeeAear__c from Employee__c where Id = :supportProjectApplyDetail.Project_Manager__c limit 1];
				        }else if (supportProjectApplyDetail.Opportunity__r.Id != null){
				        	employeesP = [select id, name ,n_EmployeeAear__c from Employee__c where n_EmployeeName__c = :opp.SalesRegion__r.SEPersonInCharge__c limit 1];
				        }
				        
				        
				
				        Project__c Project = new Project__c();
				        
				        if(supportProjectApplyDetail.recordtypeId == Schema.SObjectType.SupportProjectApply__c.getRecordTypeInfosByName().get('售前项目支持申请').getRecordTypeId()){
				        	Project.Name = supportProjectApplyDetail.Opportunity__r.Name+String.valueOf(System.today().year())+String.valueOf(date.today().month())+String.valueOf(date.today().day())+'售前项目';
				        	Project.recordtypeId = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('售前项目').getRecordTypeId();
				        	
				        }else if (supportProjectApplyDetail.recordtypeId == Schema.SObjectType.SupportProjectApply__c.getRecordTypeInfosByName().get('售后项目支持申请').getRecordTypeId()){
				        	Project.Name = supportProjectApplyDetail.Opportunity__r.Name+String.valueOf(System.today().year())+String.valueOf(date.today().month())+String.valueOf(date.today().day())+'售后项目';
				        	Project.recordtypeId = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('售后项目').getRecordTypeId();
				        	Project.Order__c = supportProjectApplyDetail.Order__c;
				        }
				        for(Employee__c employee : employeesP){
				        	Project.Project_Manager__c = employee.id;
				        	Project.EmployeeAear__c = employee.n_EmployeeAear__c;
				        }
				        Project.Opportunity__c = supportProjectApplyDetail.Opportunity__r.Id;
				        insert Project;
				        
				        /*
				        Project_TeamMember__c ProjectMember = new Project_TeamMember__c();
				        
				        for(Employee__c employee : employees){
				        	ProjectMember.Name = employee.name;
				        	ProjectMember.project__c = Project.id;
				        	ProjectMember.Project_Role__c = '项目负责人';
				        	ProjectMember.Team_Member__c = employee.id;
				        }
				        insert ProjectMember;
				        */
				        List<Milestone__c> msList = new List<Milestone__c>();
				        if(supportProjectApplyDetail.recordtypeId == Schema.SObjectType.SupportProjectApply__c.getRecordTypeInfosByName().get('售前项目支持申请').getRecordTypeId()){
				        	Milestone__c ms1 = new Milestone__c();
					        ms1.Project__c = Project.id;
					        ms1.Name = '方案阶段';
					        Milestone__c ms2 = new Milestone__c();
					        ms2.Project__c = Project.id;
					        ms2.Name = '测试阶段';
					        Milestone__c ms3 = new Milestone__c();
					        ms3.Project__c = Project.id;
					        ms3.Name = '采购阶段';
					        msList.add(ms1);
					        msList.add(ms2);
					        msList.add(ms3);
				        	
				        }else if (supportProjectApplyDetail.recordtypeId == Schema.SObjectType.SupportProjectApply__c.getRecordTypeInfosByName().get('售后项目支持申请').getRecordTypeId()){
				        	Milestone__c ms4 = new Milestone__c();
					        ms4.Project__c = Project.id;
					        ms4.Name = '交付阶段';
					        Milestone__c ms5 = new Milestone__c();
					        ms5.Project__c = Project.id;
					        ms5.Name = '服务阶段';
					        msList.add(ms4);
				        	msList.add(ms5);
				        }
				        insert msList;
	             		
	             		if(sp.Project_Manager__c != null){
	                      ssList.add(new SupportProjectApply__Share(ParentId = sp.id,
	                                                            UserOrGroupId = EmployeeIDUserId.get(sp.Project_Manager__c), 
	                                                            AccessLevel =  'Edit'));
	                        if(EmployeeIDEmail.get(sp.Project_Manager__c) != null){
			                    String str=System.Url.getSalesforceBaseUrl().toExternalForm();
							    String[] toAddresses=new String[]{EmployeeIDEmail.get(sp.Project_Manager__c)};
							    Messaging.Singleemailmessage email=new Messaging.Singleemailmessage();
							    email.setSubject('项目分配提醒');
							    email.setToAddresses(toAddresses);
							    email.setSaveAsActivity(false);
							    //email.setPlainTextBody('您好：'+'\n'+'您有一个新的项目待处理,详细信息请看'+'\n'+str+'/'+sp.id);	      
							    email.setPlainTextBody('您好：'+'\n'+'您有一个新的项目待处理,'+'\n'+'业务机会名称:'+oppIDName.get(sp.Opportunity__c)+'\n'+'详细信息请看'+'\n'+str+'/'+Project.id);	   
							    Messaging.Sendemailresult[] r=Messaging.sendEmail(new Messaging.Singleemailmessage[]{email});
	                        }
	                      osList.add(new OpportunityShare(OpportunityId = sp.Opportunity__c,
	                                                            UserOrGroupId = EmployeeIDUserId.get(sp.Project_Manager__c), 
	                                                            OpportunityAccessLevel =  'Read'));
	             		}
	             	}
	             }
             if(ssList.size() > 0) Database.insert(ssList,false);
             if(osList.size() > 0) Database.insert(osList,false);
         }
     }

}