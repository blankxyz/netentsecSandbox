/**
*Dis:新样机转旧样机提醒,给管理员发邮件
*Author:vito_He
*Time:2013年4月23日 10:20:05
**/
@isTest(SeeAlldata=true) 
private class trg_TestclsOrderDatailsAutoInfo {

    static testMethod void myUnitTest() {  
    	
    	RecordType rType = [select Id from RecordType where Name='内部样机订单'];
    	RecordType rtp= [Select r.Name, r.Id, r.Description From RecordType r where Name='渠道代理商'];
    	
    	Profile p = [SELECT Id FROM Profile WHERE Name='Chatter External User'];  
        User u = new User(Alias = 'standt', Email='234486580@qq.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='2344@testorg.com');  
        
        SalesRegion__c sc = new SalesRegion__c();
    	sc.Name ='test区域';
    	sc.OfficeDirector__c = u.Id; 
    	sc.SEPersonInCharge__c = u.Id;
    	insert sc;
        
    	Account acc=new Account();
        acc.Name='李强';
        acc.Fax='8088';
        acc.Description='传智播客李强'; 
        acc.Phone='053187401697';
        acc.Industry='Dress';
        acc.RecordTypeId=rtp.id; 
        acc.PrimaryIndustry__c='金融';
		acc.TwoIndustries__c='债券';
		acc.ThreeIndustries__c='银行';
		acc.SellArea__c=sc.id;
		acc.Province__c='北京';
        insert acc; 
    	
    	
    	
    	
    	Opportunity opp=new Opportunity(); 
        opp.Name='2013年西门子北京总部-网络安全8000K';
        opp.Description='业务机会';
        opp.CloseDate=date.today();
        opp.AccountId=acc.Id;
        opp.StageName='初步接洽';
        opp.SalesRegion__c = sc.id;
        insert opp; 	 
    	
    	Orders__c oc = new Orders__c();
    	oc.Name = 'vito测试数据oooo';
    	oc.RecordTypeId=rType.Id;  
    	oc.SalesOpportunities__c=opp.Id;
    	insert oc;
    	
    	OrderDetails__c odc = new OrderDetails__c(); 
    	odc.whether_send_message__c = false; 
    	odc.BorrowerReceiptDate__c = Date.today().addDays(-100);
    	odc.n_OrderNo__c = oc.Id; 
    	insert odc;
    	
    	Test.startTest(); 
    	scheduleOrderDatailsAutoInfo soda = new scheduleOrderDatailsAutoInfo();
    	clsOrderDatailsAutoInfo coda = new clsOrderDatailsAutoInfo();
    	Database.executeBatch(coda,50);
    	string schLead = DateTime.now().second()+' '+DateTime.now().minute()+' '+DateTime.now().hour()+' * * ?';
    	system.schedule('testOrderDetailsAutoInfo',schLead,soda);
    	Test.stopTest(); 
    	
    	OrderDetails__c odc2=[select Id,whether_send_message__c from OrderDetails__c where id =:odc.Id];
    	System.assertEquals(odc2.whether_send_message__c,true); 
    	delete oc; 
    } 
}