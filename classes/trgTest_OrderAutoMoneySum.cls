/**
*Test: OrderAutoMoneySum
*Author:Vito_He
*Time:2013年4月28日16:01:21
**/
@isTest(SeeAllData=true) 
private class trgTest_OrderAutoMoneySum {

    static testMethod void myUnitTest() {
    	Pricebook2 pricebook = [select Id from Pricebook2 where isStandard=true limit 1];   
    	list<RecordType> listrtpQuDao=[Select r.Name, r.Id, r.Description From RecordType r where DeveloperName='ChannelCustomers']; 
	 	list<RecordType> listrtptuiHuo= [Select r.Name, r.Id, r.Description From RecordType r where DeveloperName='RecordTypeByReturn'];
	 	list<RecordType> listrtquDaoY = [Select r.Name, r.Id, r.Description From RecordType r where DeveloperName='ChannelPrototypeOrders'];
	 	list<RecordType> listrtpxs= [Select r.Name, r.Id, r.Description From RecordType r where DeveloperName='salesOrders'];	
	 	list<RecordType> listUnOrd= [Select r.Name, r.Id, r.Description,r.DeveloperName,r.SobjectType From RecordType r where DeveloperName='QXDD' and SobjectType='Orders__c'];			//取消订单 	
    	Profile profile=[Select p.Name, p.Id From Profile p where Name='Chatter External User'];
    	User user=new User();											 
	    user.Phone='87413065';   
	    user.MobilePhone='15167988026';  
	    user.Username='LurryKong@fccz.com15';
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

	    Quote quote=new Quote();				//报价
        quote.OpportunityId=opp.Id;
        quote.Pricebook2Id=pricebook.Id;
        quote.Name='2013网康服务器报价';
        quote.Status='已批准';
        quote.yanhoukaipiaoliyouField3__c='延后开票';
        insert quote;
        
        ProductModelSeries__c pms=new ProductModelSeries__c();	//产品型号系列
        pms.Name='NF-3000系列';
        insert pms;
        list<ProductionLevel__c> listprod=new list<ProductionLevel__c>();
    	ProductionLevel__c pleone=new ProductionLevel__c();		//产品级别
        pleone.Name='产成品';
        pleone.n_level__c='一级';
        pleone.n_levelNO__c='B';
        listprod.add(pleone);
        ProductionLevel__c pleTwo=new ProductionLevel__c();		//产品级别
        pleTwo.Name='天晶政府';
        pleTwo.n_level__c='二级';
        pleTwo.n_levelNO__c='B';
        listprod.add(pleTwo);
        ProductionLevel__c pleThree=new ProductionLevel__c();		//产品级别
        pleThree.Name='配件';
        pleThree.n_level__c='三级';
        pleThree.n_levelNO__c='B';
        listprod.add(pleThree);
        ProductionLevel__c pleFour=new ProductionLevel__c();		//产品级别
        pleFour.Name='硬件';
        pleFour.n_level__c='四级';
        pleFour.n_levelNO__c='B';
        listprod.add(pleFour);
        
        Product2 prod=new Product2();						//产品
       	prod.Name='prodone';
        prod.n_Unit__c='个';									//计量单位
        prod.productmodelseries__c=pms.id;					//产品型号系列
    	prod.n_FirstLevel__c=pleone.id;						//一级产品
        prod.n_SecondLevel__c=pleTwo.id;					//二级产品
        prod.n_ThirdLevel__c=pleThree.id;					//三级产品
        prod.n_FourLevel__c=pleFour.id;						//四级产品
        prod.Family='ICG';
        insert prod;
        
        list<Orders__c> listOrder=new list<Orders__c>();
	    Orders__c orders=new Orders__c();
        orders.Name='testorders';
        orders.SalesOpportunities__c=opp.id;
        orders.Quote__c=quote.id;  
        orders.RecordTypeId=listrtptuiHuo[0].id;
        orders.customer__c = acc.Id;
        orders.SalesRegion__c=salesregion.Id;
        orders.Payer__c = acc.Id;
        orders.ReturnPayAccount__c = acc.id; 
        orders.ApprovalStatus__c ='已审批';
   		listOrder.add(orders);
   		
   		Orders__c orderhuanhuo=new Orders__c();
        orderhuanhuo.Name='testhuanhuoorders';
        orderhuanhuo.RecordTypeId=listrtpxs[0].id;		//换货订单 
        orderhuanhuo.Replacement1__c = acc.Id;				//换货方 
        orderhuanhuo.ReplacementReason__c='质量换货';
        orderhuanhuo.SalesRegion__c=salesregion.Id;
        orderhuanhuo.Payer__c=acc.id;
        orderhuanhuo.ReturnPayAccount__c= acc.id;
        orderhuanhuo.ApprovalStatus__c ='已审批';
   		listOrder.add(orderhuanhuo);   
   		
   		Orders__c orderyahuo=new Orders__c();
        orderyahuo.Name='ddffwf';
        orderyahuo.RecordTypeId=listrtptuiHuo[0].id;		
        orderyahuo.Partners__c=acc.Id;
        orderyahuo.SalesRegion__c=salesregion.Id;
   		orderyahuo.customer__c=acc.Id;		
   		orderyahuo.Payer__c = acc.id;	
   		orderyahuo.ReturnPayAccount__c = acc.id;
   		orderyahuo.ApprovalStatus__c ='已审批';	
   		listOrder.add(orderyahuo); 
   		
   		Orders__c orderInner=new Orders__c();
        orderInner.Name='eee';
        orderInner.RecordTypeId=listrtquDaoY[0].id;		
        orderInner.Partners__c=acc.Id;
        orderInner.SalesRegion__c=salesregion.Id;
   		orderInner.customer__c=acc.Id;		
   		orderInner.Payer__c = acc.id;	
   		orderInner.ReturnPayAccount__c = acc.id;	
   		orderInner.ApprovalStatus__c ='已审批';
   		listOrder.add(orderInner);
   		insert listOrder; 
		/***************取消订单测试类********************/
		   		
   		OrderDetails__c orderDetailsa = new OrderDetails__c();
		orderDetailsa.n_OrderNo__c = orderInner.Id;
		orderDetailsa.n_ProductByOrd__c=prod.id;									//产品
    	orderDetailsa.n_ProCount__c=1;					 						//数量
    	orderDetailsa.n_PriceByord__c=400;										//成交价
	    insert orderDetailsa;
		
   		Orders__c unOdes = new Orders__c();
   		unOdes.RecordTypeId=listrtptuiHuo[0].id;		
        unOdes.Partners__c=acc.Id;
        unOdes.SalesRegion__c=salesregion.Id;
   		unOdes.customer__c=acc.Id;		
   		unOdes.Payer__c = acc.id;	
   		unOdes.ReturnPayAccount__c = acc.id;	
   		unOdes.ApprovalStatus__c ='已审批';
   		unOdes.AboutOrder__c =orderInner.Id;

	    system.Test.startTest();
   		insert unOdes;
   		unOdes.RecordTypeId = listUnOrd[0].id;	
   		update unOdes;
		/***************取消订单测试类********************/   		
   		update listOrder;  
   		delete listOrder;
   		system.Test.stopTest();
    }
}