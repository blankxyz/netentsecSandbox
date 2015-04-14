/**
*Test:TestclsLeadAutoCheck
*Author:Gary_Hu
*Time:2013年4月11日16:01:21
**/
@isTest
private class trg_TestclsLeadAutoCheck {
    static testMethod void myUnitTestA() {
    	DateTime nowToday = Date.today();
    	RecordType rType = [select Id from RecordType where Name='自主获取'];
    	User u = [select Id from User where id =: UserInfo.getUserId()];


    	 // 任务和活动为空
    	Lead lead = new Lead();
    	lead.LastName = 'test渠道代理商';
    	lead.Company = 'testCompany';
    	lead.RecordTypeId = rType.Id;
    	lead.OwnerId = u.id;
    	lead.IsConverted = false;
    	insert lead;
    	
    	//任务时间不为空
    	Lead leada = new Lead();
    	leada.LastName = 'test渠道代理商';
    	leada.Company = 'testCompany';
    	leada.RecordTypeId = rType.Id;
    	leada.OwnerId = u.id;
    	leada.IsConverted = false;
    	insert leada;
    	Task task = new Task();
		task.WhoId =  leada.Id;
		task.Subject = '电子邮件';
		task.Status = '未开始';
		task.Priority = '普通';
		insert task;
    	
    
    	//活动时间不为空
    	Lead leadb = new Lead();
    	leadb.LastName = 'test渠道代理商';
    	leadb.Company = 'testCompany';
    	leadb.RecordTypeId = rType.Id;
    	leadb.OwnerId = u.id;
    	insert leadb;
    	
    	Event event = new Event();
		event.WhoId =  leadb.Id;
		event.Subject = '电子邮件';
		event.StartDateTime = nowToday;
		event.EndDateTime = nowToday.addDays(1);
		insert event;

    	
    	//活动和任务都不为空
    	Lead leadc = new Lead();
    	leadc.LastName = 'test渠道代理商';
    	leadc.Company = 'testCompany';
    	leadc.RecordTypeId = rType.Id;
    	leadc.OwnerId = u.id;
    	leadc.IsConverted = false;
    	insert leadc;
    
    	
    	Task taskx = new Task();
		taskx.WhoId = leadc.Id;
		taskx.Subject = '电子邮件';
		taskx.Status = '未开始';
		taskx.Priority = '普通';
		insert taskx;
	
		
    	Event eventx = new Event();
		eventx.WhoId = leadc.Id;
		eventx.Subject = '电子邮件';
		eventx.StartDateTime = nowToday;
		eventx.EndDateTime = nowToday.addDays(1);
		insert eventx;


    	

    	
    	
    	System.Test.startTest();
    	scheduleLeadAutoCheck slead = new scheduleLeadAutoCheck();	
 	    clsLeadAutoCheck LeadBatch = new clsLeadAutoCheck(4);
   		Database.executeBatch(LeadBatch,50);
	 	string schLead=DateTime.now().second()+' '+DateTime.now().minute()+' '+DateTime.now().hour()+' * * ?';
		system.schedule('MergeLead Job', schLead,slead);
		System.Test.stopTest();

    }
  
}