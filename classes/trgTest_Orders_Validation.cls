//Orders_Validation的测试类
//lurrykong
//2013.5.15
@isTest(SeeAlldata=true) 
private class trgTest_Orders_Validation {      
 
    static testMethod void myUnitTest() 
    {
    	Pricebook2 pricebook = [select Id from Pricebook2 where isStandard=true limit 1];
    	Profile profile=[Select p.Name, p.Id From Profile p where Name='Chatter External User'];
        list<RecordType> listrtp=[Select r.Name, r.Id, r.Description,r.DeveloperName,r.SobjectType From RecordType r where DeveloperName='ChannelCustomers'];										//渠道代理商 
	 	list<RecordType> listrtpSales= [Select r.Name, r.Id, r.Description,r.DeveloperName,r.SobjectType From RecordType r where DeveloperName='salesOrders' and SobjectType='Orders__c'];			//销售订单								//
 		list<RecordType> listrtptoSales= [Select r.Name, r.Id, r.Description,r.DeveloperName,r.SobjectType From RecordType r where DeveloperName='YahuoOrdersSales' and SobjectType='Orders__c'];	//压货转销售订单
	 	list<RecordType> listrtpNei= [Select r.Name, r.Id, r.Description,r.DeveloperName,r.SobjectType From RecordType r where DeveloperName='InternalPrototypeOrders' and SobjectType='Orders__c'];//内部样机订单 							
    	list<RecordType> listrtpHeSuan= [Select r.Name, r.Id, r.Description,r.DeveloperName,r.SobjectType From RecordType r where DeveloperName='RecordType1' and SobjectType='Orders__c'];			//内部核算订单 
    	list<RecordType> listrtpTuiHuo= [Select r.Name, r.Id, r.Description,r.DeveloperName,r.SobjectType From RecordType r where DeveloperName='RecordTypeByReturn' and SobjectType='Orders__c']; 	//退货订单
    	list<RecordType> listrtpHuanHuo= [Select r.Name, r.Id, r.Description,r.DeveloperName,r.SobjectType From RecordType r where DeveloperName='RecordTypeByExchange'and SobjectType='Orders__c'];//换货订单 
    	list<RecordType> listrtpQuDao= [Select r.Name, r.Id, r.Description,r.DeveloperName,r.SobjectType From RecordType r where DeveloperName='ChannelPrototypeOrders'and SobjectType='Orders__c'];//渠道样机订单 
    	list<RecordType> listrtpYaHuo= [Select r.Name, r.Id, r.Description,r.DeveloperName,r.SobjectType From RecordType r where DeveloperName='YahuoOrders' and SobjectType='Orders__c'];			//压货订单
    	 
    	User user=new User();											 
	    user.Phone='87413065';   
	    user.MobilePhone='15167988026';
	    user.Username='LurryKong@fccz.com23';
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
        acc.RecordTypeId=listrtp[0].id;
        acc.PrimaryIndustry__c='金融';
		acc.TwoIndustries__c='债券';
		acc.ThreeIndustries__c='银行';
		acc.SellArea__c=SalesRegion.id;
		acc.Province__c='北京';
        insert acc;
    	
    	list<Orders__c> listord=new list<Orders__c>();								//listOrder
    	
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
	    
	    Quote quote=new Quote();
        quote.OpportunityId=opp.Id;
        quote.Pricebook2Id=pricebook.Id;
        quote.Name='报价';
        quote.Status='已批准';
        quote.yanhoukaipiaoliyouField3__c='开票信息';
        insert quote;
        
        //销售订单
        Orders__c orders=new Orders__c();
        orders.Name='testorders';
        orders.SalesOpportunities__c=opp.id;
        orders.Quote__c=quote.id;  
        orders.RecordTypeId=listrtpSales[0].id;
        orders.customer__c = acc.Id;
        orders.Partners__c=acc.Id;
   		orders.Payer__c=acc.id;
		listord.add(orders);
   		//压货转销售
   		Orders__c ordersTwo=new Orders__c();
        ordersTwo.Name='testordersthree';
        ordersTwo.SalesOpportunities__c=opp.id;
        ordersTwo.Quote__c=quote.id;  
        ordersTwo.RecordTypeId=listrtptoSales[0].id;
        ordersTwo.Partners__c=acc.Id;
        ordersTwo.customer__c = acc.Id;
        ordersTwo.Payer__c=acc.id;
   		listord.add(ordersTwo);
   		//内部样机
   		Orders__c ordersThree=new Orders__c();
        ordersThree.Name='testordersdddd';
        ordersThree.SalesOpportunities__c=opp.id;
        ordersThree.Quote__c=quote.id;  
        ordersThree.RecordTypeId=listrtpNei[0].id;
        ordersThree.customer__c = acc.Id;
        ordersThree.Payer__c=acc.id;
   		listord.add(ordersThree);
   		//内部核算订单
   		Orders__c ordersFour=new Orders__c();
        ordersFour.Name='testorders';
        ordersFour.SalesOpportunities__c=opp.id;
        ordersFour.Quote__c=quote.id;  
        ordersFour.RecordTypeId=listrtpHeSuan[0].id;
        ordersFour.AboutOrder__c=ordersThree.id;
        ordersFour.customer__c = acc.Id;
        ordersFour.Payer__c=acc.id;
   		listord.add(ordersFour);
   		//换货订单
   		Orders__c ordersFive=new Orders__c();
        ordersFive.Name='testorders';
        ordersFive.SalesOpportunities__c=opp.id;
        ordersFive.Quote__c=quote.id;  
        ordersFive.RecordTypeId=listrtpHuanHuo[0].id;
        ordersFive.customer__c = acc.Id;
   		ordersFive.Payer__c=acc.id;
   		listord.add(ordersFive);
   		//渠道样机订单
   		Orders__c ordersSix=new Orders__c();
        ordersSix.Name='testorders';
        ordersSix.SalesOpportunities__c=opp.id;
        ordersSix.Quote__c=quote.id;  
        ordersSix.RecordTypeId=listrtpQuDao[0].id;
        ordersSix.customer__c = acc.Id;
   		ordersSix.Payer__c=acc.id;
   		listord.add(ordersSix);
		//压货订单
   		Orders__c ordersSeven=new Orders__c();
        ordersSeven.Name='testorders';
        ordersSeven.SalesOpportunities__c=opp.id;
        ordersSeven.Quote__c=quote.id;  
        ordersSeven.RecordTypeId=listrtpYaHuo[0].id;
        ordersSeven.customer__c = acc.Id;
   		ordersSeven.Payer__c=acc.id;	
   		listord.add(ordersSeven);
   		//退货订单
   		Orders__c ordersEight=new Orders__c();
        ordersEight.Name='testorders';
        ordersEight.SalesOpportunities__c=opp.id;
        ordersEight.Quote__c=quote.id;  
        ordersEight.RecordTypeId=listrtpTuiHuo[0].id;
        ordersEight.customer__c = acc.Id;  
        ordersEight.ReturnPayAccount__c=acc.Id;
        ordersEight.Payer__c=acc.id;	
   		listord.add(ordersEight);
   		insert listord;
   		
   		orders.Name='testorderstwo';
   		update orders;   		
   		
   		
   		
   		/*
   		Orders__c orders=new Orders__c();
        orders.Name='testorders';
        orders.SalesOpportunities__c=opp.id;
        orders.Quote__c=quote.id;  
        orders.RecordTypeId=rtpSeven.id;
        orders.customer__c = acc.Id;
   		insert orders;
   		Orders__c orders=new Orders__c();
        orders.Name='testorders';
        orders.SalesOpportunities__c=opp.id;
        orders.Quote__c=quote.id;  
        orders.RecordTypeId=rtpEight.id;
        orders.customer__c = acc.Id;
   		insert orders;
   		Orders__c orders=new Orders__c();
        orders.Name='testorders';
        orders.SalesOpportunities__c=opp.id;
        orders.Quote__c=quote.id;  
        orders.RecordTypeId=rtpNine.id;
        orders.customer__c = acc.Id;
   		insert orders;
   		*/
    }

    
}