global class CreateProjectService{

    webservice static String CreateProject(Id SupportProjectApplyId) {

        SupportProjectApply__c supportProjectApplyDetail = [select id , Opportunity__r.Name, Project_Manager__c, Opportunity__r.Id, recordtypeId from SupportProjectApply__c where id = :SupportProjectApplyId];
        Opportunity  opp = [select id, SalesRegion__r.SEPersonInCharge__c, SalesRegion__c from Opportunity where id = :supportProjectApplyDetail.Opportunity__r.Id];
        system.debug('++++111'+supportProjectApplyDetail.Project_Manager__c);
        List<Employee__c> employees = new List<Employee__c>();
        if(supportProjectApplyDetail.Project_Manager__c != null){
        	employees = [select id, name ,n_EmployeeAear__c from Employee__c where Id = :supportProjectApplyDetail.Project_Manager__c limit 1];
        }else{
        	employees = [select id, name ,n_EmployeeAear__c from Employee__c where n_EmployeeName__c = :opp.SalesRegion__r.SEPersonInCharge__c limit 1];
        }
        
        

        Project__c Project = new Project__c();
        
        if(supportProjectApplyDetail.recordtypeId == Schema.SObjectType.SupportProjectApply__c.getRecordTypeInfosByName().get('签约前技术资源申请').getRecordTypeId()){
        	Project.Name = supportProjectApplyDetail.Opportunity__r.Name+'售前项目';
        	Project.recordtypeId = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('售前项目').getRecordTypeId();
        	
        }else if (supportProjectApplyDetail.recordtypeId == Schema.SObjectType.SupportProjectApply__c.getRecordTypeInfosByName().get('签约后技术资源申请').getRecordTypeId()){
        	Project.Name = supportProjectApplyDetail.Opportunity__r.Name+'售后项目';
        	Project.recordtypeId = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('售后项目').getRecordTypeId();
        }
        for(Employee__c employee : employees){
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
        if(supportProjectApplyDetail.recordtypeId == Schema.SObjectType.SupportProjectApply__c.getRecordTypeInfosByName().get('签约前技术资源申请').getRecordTypeId()){
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
        	
        }else if (supportProjectApplyDetail.recordtypeId == Schema.SObjectType.SupportProjectApply__c.getRecordTypeInfosByName().get('签约后技术资源申请').getRecordTypeId()){
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
        
        return Project.id;
    }
    
}