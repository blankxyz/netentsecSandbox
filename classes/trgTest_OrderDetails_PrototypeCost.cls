/**
*Test:trgTest_OrderDetails_PrototypeCost
*Author:Vito_He
*Time:2013年5月13日16:43:21 
**/
@isTest(SeeAllData=true)
private class trgTest_OrderDetails_PrototypeCost {
 
    static testMethod void myUnitTest() {
    	 
        Pricebook2 pricebook = [select Id from Pricebook2 where isStandard=true limit 1];   
    	list<RecordType> listrtpQuDao=[Select r.Name, r.Id, r.Description From RecordType r where Name='渠道代理商']; 
	 	list<RecordType> listrtpSales= [Select r.Name, r.Id, r.Description From RecordType r where Name='内部样机订单'];
    	Profile profile=[Select p.Name, p.Id From Profile p where Name='Chatter External User'];
    	User user=new User();											 
	    user.Phone='87413065';   
	    user.MobilePhone='15167988026'; 
	    user.Username='LurryKong@fccz.com20';
	    user.Alias='DeLi';  //匿称
	    user.CommunityNickname='DeLi';//绰号
	    user.TimeZoneSidKey='Australia/Sydney';
	    user.LocaleSidKey='en_AU';
	    user.EmailEncodingKey='ISO-8859-1';
	    user.ProfileId=profile.Id;
	    user.LanguageLocaleKey='en_US';
	    user.FirstName='于';
	    user.LastName='NN';
	    user.Fax='0031388';
	    user.Email='dlwork123@163.com';
	    insert user;
        
        SalesRegion__c salesregion=new SalesRegion__c();
		salesregion.OfficeDirector__c=user.id;
		salesregion.Name='日本';
		insert salesregion; 
        
        Account acc=new Account();
        acc.Name='五粮液';
        acc.Fax='8088';
        acc.Description='五粮液';
        acc.Phone='053187401697';
        acc.Industry='Finance';
        acc.RecordTypeId=listrtpQuDao[0].id;
        acc.PrimaryIndustry__c='金融';
		acc.TwoIndustries__c='债券';
		acc.ThreeIndustries__c='银行';
		acc.SellArea__c=SalesRegion.id;
		acc.Province__c='北京';
        insert acc;
    	
    	   	
    	
    	String Closetime='2005'+'-'+'10'+'-'+'5';
        Date dte=date.valueOf(Closetime);
	   	Opportunity opp=new Opportunity();    	
	    opp.OppProperties__c='商业市场';       
        opp.Name='五粮液商机';
        opp.Description='业务机会';
        opp.CloseDate=dte;  
        opp.AccountId=acc.Id;
        opp.StageName='关单';
        opp.Probability=100;					//可行性
        opp.SalesRegion__c = salesregion.Id;
	    insert opp;

        list<Orders__c> orderList = new list<Orders__c>();
	    Orders__c orders=new Orders__c();
        orders.Name='testorders';
        orders.SalesOpportunities__c=opp.id;
        orders.RecordTypeId=listrtpSales[0].id;
        orders.customer__c = acc.Id;
        orders.SalesRegion__c=salesregion.Id;
        orders.ApprovalStatus__c='已审批';
   		orderList.add(orders);
   		
   		Orders__c orders2=new Orders__c();
        orders2.Name='testorders2';
        orders2.SalesOpportunities__c=opp.id;
        orders2.RecordTypeId=listrtpSales[0].id;
        orders2.customer__c = acc.Id;
        orders2.SalesRegion__c=salesregion.Id;
        orders2.ApprovalStatus__c='审批中';
        orderList.add(orders2);
   		insert orderList;
   		
   		 
   		list<OrderDetails__c> listOrderdetail=new list<OrderDetails__c>();
   		
    	OrderDetails__c ordetail=new OrderDetails__c();
    	ordetail.n_OrderNo__c=orders.id;
    	ordetail.n_ProCount__c=1;
    	ordetail.PracticalExpectPrice__c = 5000;
    	ordetail.TestStatus__c = '测试中';
    	ordetail.PredictStartYear__c='2013';
    	ordetail.PredictStartQuarter__c='第一季度';
    	ordetail.Field1__c=2000;
    	listOrderdetail.add(ordetail);  
    	
    	OrderDetails__c ordetail2=new OrderDetails__c(); 
    	ordetail2.n_OrderNo__c=orders.id;
    	ordetail2.n_ProCount__c=1;
    	ordetail2.PracticalExpectPrice__c = 5000;  
    	ordetail2.TestStatus__c = '测试中'; 
    	ordetail2.PredictStartYear__c='2013';
    	ordetail2.PredictStartQuarter__c='第一季度';
    	ordetail2.Field1__c=1000; 
    	listOrderdetail.add(ordetail2);
    	   
    	
    	OrderDetails__c ordetail3=new OrderDetails__c();
    	ordetail3.n_OrderNo__c=orders2.id; 
    	ordetail3.n_ProCount__c=1;
    	ordetail3.PracticalExpectPrice__c = 5000; 
    	ordetail3.TestStatus__c = '测试中';
    	ordetail3.PredictStartYear__c='2013';
    	ordetail3.PredictStartQuarter__c='第一季度'; 
    	ordetail3.Field1__c=1000;
    	listOrderdetail.add(ordetail3);
    	
    	OrderDetails__c ordetail4=new OrderDetails__c();
    	ordetail4.n_OrderNo__c=orders2.id; 
    	ordetail4.n_ProCount__c=1;
    	ordetail4.PracticalExpectPrice__c = 5000; 
    	ordetail4.TestStatus__c = '测试中';
    	ordetail4.PredictStartYear__c='2013';
    	ordetail4.PredictStartQuarter__c='第一季度'; 
    	ordetail4.Field1__c=1000;
    	listOrderdetail.add(ordetail4);
    	 
    	test.startTest();
    	
    	insert listOrderdetail;
    	
    	listOrderdetail.clear();
    	date startDate = date.newInstance(2013, 1, 1);
		date dueDate = date.newInstance(2013, 2, 24);
    	ordetail.Demostar__c = startDate;
    	ordetail.Demoend__c = dueDate;
    	listOrderdetail.add(ordetail);
    	
    	ordetail2.Demostar__c = startDate;
    	ordetail2.Demoend__c = dueDate;
    	listOrderdetail.add(ordetail2); 
    	
    	ordetail3.Demostar__c = startDate;
    	ordetail3.Demoend__c = dueDate;
    	listOrderdetail.add(ordetail3);
    	
    	update listOrderdetail;
    	
    	delete listOrderdetail;
        
    	test.stopTest();
    }
}