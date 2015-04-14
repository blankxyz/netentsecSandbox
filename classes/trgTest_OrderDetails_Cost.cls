/**
*Dis:订单明细借用人签收后，查看本季度，本部门的费用指标是否超过预算金额的50%，80%，100% ,然后给费用指标赋值
*Author:Vito_He
*Time:2013年5月14日 14:51:42
**/
@isTest(SeeAlldata=true) 
private class trgTest_OrderDetails_Cost {

    static testMethod void myUnitTest() {   
    	
    	
    	list<OrderDetails__c> detailListInsert = new list<OrderDetails__c> ();
    	list<OrderDetails__c> detailListUpdate = new list<OrderDetails__c> ();
    	list<OrderNumber__c> ords = new list<OrderNumber__c>();
    	list<OfYahuoTurnSeller__c> sns = new list<OfYahuoTurnSeller__c>();
    	list<PrototypeCosts__c> proList = new list<PrototypeCosts__c>();
    	
    	Profile p = [SELECT Id FROM Profile WHERE Name='Chatter External User'];  
        User u = new User(Alias = 'standt', Email='234486580@qq.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='2344@testorg.com');
        
        User u2 = new User(Alias = 'vito', Email='234486580@qq.com', 
        EmailEncodingKey='UTF-8', LastName='viTest', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='234df4@testorg.com');
        
        insert u;
        insert u2; 
        
    	list<RecordType> listrtp=[Select r.Name, r.Id, r.Description From RecordType r where Name='渠道代理商'];
    	RecordType rType = [select Id from RecordType where Name='内部样机订单' limit 1];
    	
    	SalesRegion__c salesregion=new SalesRegion__c();
		salesregion.Name='china';
		salesregion.SEPersonInCharge__c = u.id; 
		salesregion.OfficeDirector__c = u2.id; 
		insert salesregion;   
		
    	Account acc=new Account(); 
        acc.Name='五粮液';
        acc.Fax='8088';
        acc.Description='五粮液';
        acc.Phone='053187401697';
        acc.Industry='Finance';
        acc.RecordTypeId=listrtp[0].id;
        acc.PrimaryIndustry__c='金融';
		acc.TwoIndustries__c='债券';
		acc.ThreeIndustries__c='银行';
		acc.SellArea__c=SalesRegion.id;
		acc.Province__c='北京';
        insert acc;
    	
    	
        Opportunity opp=new Opportunity();    
	    opp.OppProperties__c='商业市场';       
        opp.Name='五粮液商机'; 
        opp.Description='业务机会';
        opp.CloseDate=date.today(); 
        opp.AccountId=acc.Id;
        opp.StageName='关单'; 
        opp.Probability=100;					//可行性
        opp.SalesRegion__c = salesregion.Id;
	    insert opp; 
    	
    	 
    	Orders__c o1=new Orders__c();
        o1.RecordTypeId = rType.id;
        o1.Name='testo1';
        o1.SalesOpportunities__c=opp.id; 
        o1.customer__c = acc.Id; 
        o1.ApprovalStatus__c = '已审批'; 
        o1.Payer__c = acc.id; 
        o1.SalesRegion__c = salesregion.id; 
   		insert o1; 
   		
   		OrderDetails__c oc1 = new OrderDetails__c();
    	oc1.n_OrderNo__c = o1.id;	
    	oc1.TestStatus__c='测试中'; 
    	detailListInsert.add(oc1);
    	
    	
    	OrderDetails__c oc2 = new OrderDetails__c();
    	oc2.n_OrderNo__c = o1.id;
    	oc2.TestStatus__c='测试中'; 
    	detailListInsert.add(oc2);	 
    	
    	OrderDetails__c oc3 = new OrderDetails__c();
    	oc3.n_OrderNo__c = o1.id; 
    	oc3.TestStatus__c='测试中'; 
    	detailListInsert.add(oc3);	 
    	
    	insert detailListInsert;
    	
    	test.startTest();
    	
    	PrototypeCosts__c pro1 = new PrototypeCosts__c();
    	pro1.n_SaleArea__c = salesregion.id;
    	pro1.n_BudgetAmount__c = 5000;
    	pro1.n_Year__c = '2013';
    	pro1.n_Month__c = '1';
    	pro1.Quarter__c = '第一季度';
    	proList.add(pro1);
    	
    	PrototypeCosts__c pro2 = new PrototypeCosts__c();
    	pro2.n_SaleArea__c = salesregion.id;
    	pro2.n_BudgetAmount__c = 5000;
    	pro2.n_Year__c = '2013';
    	pro2.n_Month__c = '2';
    	pro2.Quarter__c = '第一季度';
    	proList.add(pro2);
    	
    	PrototypeCosts__c pro3 = new PrototypeCosts__c();
    	pro3.n_SaleArea__c = salesregion.id;
    	pro3.n_BudgetAmount__c = 5000;
    	pro3.n_Year__c = '2013';
    	pro3.n_Month__c = '3';
    	pro3.Quarter__c = '第一季度'; 
    	proList.add(pro3);
    	insert proList;
		    	
    	OfYahuoTurnSeller__c osn1 = new OfYahuoTurnSeller__c();
    	//osn1.RecordTypeId = rType.id;
    	osn1.orders__c = oc1.id;
    	sns.add(osn1);
    	OfYahuoTurnSeller__c osn2 = new OfYahuoTurnSeller__c();
    	//osn2.RecordTypeId = rType.id; 
    	osn2.orders__c = oc2.id; 
    	sns.add(osn2);
    	OfYahuoTurnSeller__c osn3 = new OfYahuoTurnSeller__c();
    	//osn3.RecordTypeId = rType.id;
    	osn3.orders__c = oc3.id;
    	sns.add(osn3);  
    	
    	insert sns; 
   		
   		 
    	oc1.PracticalExpectPrice__c = 1000000;
    	oc1.BorrowerReceiptDate__c = date.valueOf('2013-1-1');
		detailListUpdate.add(oc1);
    	oc2.PracticalExpectPrice__c = 100;
    	oc2.BorrowerReceiptDate__c = date.valueOf('2013-1-1');
    	detailListUpdate.add(oc2);  
    	oc3.PracticalExpectPrice__c = 100;
    	oc3.BorrowerReceiptDate__c = date.valueOf('2013-1-1');
    	detailListUpdate.add(oc3); 
    	update detailListUpdate; 
    	
    	//oc1.PracticalExpectPrice__c = 7600;
    	//update oc1;
    	
    	//oc1.PracticalExpectPrice__c = 12000;
    	//update oc1;
    	
    	
    	test.stopTest();
    	//delete detailList;
    }
}