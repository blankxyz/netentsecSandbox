//clsPredictActualPrice的测试类
//lurrykong
//2013
@isTest(SeeAllData=true)
private class cls_TestclsPredictActualPrice {

    static testMethod void myUnitTest() 														/****************************订单没超标新样机***************************/			
    {
    	Pricebook2 pricebook = [select Id from Pricebook2 where isStandard=true limit 1];
    	list<RecordType> listrtp=[Select Name, Id, Description From RecordType];
    	map<string,RecordType> maprtp=new map<string,RecordType>();
    	if(listrtp.size()>0)
    	{
    		for(RecordType rt:listrtp)
    		{
    			if(!maprtp.containsKey(rt.Name))
    				maprtp.put(rt.Name,rt);
    		}
    	}
    	RecordType listrtpQuDao=maprtp.get('渠道代理商'); 
    	RecordType listrtpInside=maprtp.get('内部样机订单');
    	RecordType listrtpZuiZhong=maprtp.get('最终客户');
    	RecordType listrtpDetailsType=maprtp.get('内部样机');    	   
    	Profile profile=[Select p.Name, p.Id From Profile p where Name='Chatter External User'];
    	User user=new User();											 
	    user.Phone='87413065';   
	    user.MobilePhone='15167988026';
	    user.Username='LurryKong@fccz.com3';
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
        acc.RecordTypeId=listrtpQuDao.id;
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
        quote.yanhoukaipiaoliyouField3__c='延后开票信息';
        insert quote;
        
        ProductModelSeries__c pms=new ProductModelSeries__c();	//产品型号系列
        pms.Name='NF-3000系列';
        pms.NewProductPrice__c = Double.valueOf(1000);
        pms.OldProductPrice__c = Double.valueOf(100);
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
	    
	    Orders__c orders=new Orders__c();					//订单未超标,订单延期
        orders.Name='testorders';
        orders.SalesOpportunities__c=opp.id;
        orders.Quote__c=quote.id;  
        orders.RecordTypeId=listrtpInside.id;
        orders.customer__c = acc.Id;
        orders.Partners__c = acc.Id;
        orders.SalesRegion__c=salesregion.Id;
        orders.ApprovalStatus__c='已审批';
        orders.IfCostOverWeight__c=false;
        orders.WhetherTheDelay__c=true;
		listOrder.add(orders);

	    Orders__c ordersDelay=new Orders__c();					//订单未超标,订单延期
        ordersDelay.Name='testordersTwo';
        ordersDelay.SalesOpportunities__c=opp.id;
        ordersDelay.Quote__c=quote.id;  
        ordersDelay.RecordTypeId=listrtpInside.id;
        ordersDelay.customer__c = acc.Id;
        ordersDelay.Partners__c = acc.Id;
        ordersDelay.SalesRegion__c=salesregion.Id;
        ordersDelay.ApprovalStatus__c='延期已审批';
        ordersDelay.IfCostOverWeight__c=false;
        ordersDelay.WhetherTheDelay__c=true;
		listOrder.add(ordersDelay);


		insert listOrder;

		DateTime dtToday = Date.today();
		system.Test.startTest();
		//订单明细
		DateTime nowToday = Date.today();
		date startDate = date.newInstance(2013,1,1);
		date dueDate = date.newInstance(2013,3,24);		
		
		date dueDateAddDatemaxMonth=date.newInstance(2013,5,15);
		date dueDateAddDateminMonth=date.newInstance(2013,4,25);
				
		list<OrderDetails__c> list_orDetails = new list<OrderDetails__c>();		
		
		OrderDetails__c orderDetailnew = new OrderDetails__c();				//订单未超标,新样机,有延期,延期超过1个月,当前时间>延期时间,当前时间-延期时间>30
		orderDetailnew.RecordTypeId = listrtpDetailsType.id;
		orderDetailnew.n_OrderNo__c = ordersDelay.Id;
		orderDetailnew.n_ProductByOrd__c=prod.id;									
    	orderDetailnew.n_ProCount__c=1;					 						
    	orderDetailnew.n_PriceByord__c=400;										
    	orderDetailnew.TestStatus__c = '测试中';
       	orderDetailnew.Demostar__c=date.newInstance(2013,1,1);
    	orderDetailnew.Demoend__c=date.newInstance(2013,2,5);
    	orderDetailnew.AddDate__c=date.newInstance(2013,4,6);
    	orderDetailnew.IfNewProduct__c=true;
    	orderDetailnew.WhetherTheDelay__c=true;
       	list_orDetails.add(orderDetailnew);  

   		OrderDetails__c orderDetailnewTwo = new OrderDetails__c();			//订单未超标,新样机,有延期,延期超过1个月,当前时间>延期时间,当前时间-延期时间<30
		orderDetailnewTwo.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewTwo.n_OrderNo__c = ordersDelay.Id;
		orderDetailnewTwo.n_ProductByOrd__c=prod.id;									//产品
    	orderDetailnewTwo.n_ProCount__c=1;					 						//数量
    	orderDetailnewTwo.n_PriceByord__c=400;										//成交价
    	orderDetailnewTwo.TestStatus__c = '测试中';
       	orderDetailnewTwo.Demostar__c=date.newInstance(2013,1,1);
    	orderDetailnewTwo.Demoend__c=date.newInstance(2013,2,5);
    	orderDetailnewTwo.AddDate__c=date.newInstance(2013,5,14);
    	orderDetailnewTwo.IfNewProduct__c=true;
    	orderDetailnewTwo.WhetherTheDelay__c=true;
       	list_orDetails.add(orderDetailnewTwo);  

  		OrderDetails__c orderDetailnewThree = new OrderDetails__c();		//订单未超标,新样机,有延期,延期超过1个月,当前时间<延期时间
		orderDetailnewThree.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewThree.n_OrderNo__c = ordersDelay.Id;
		orderDetailnewThree.n_ProductByOrd__c=prod.id;									//产品
    	orderDetailnewThree.n_ProCount__c=1;					 						//数量
    	orderDetailnewThree.n_PriceByord__c=400;										//成交价
    	orderDetailnewThree.TestStatus__c = '测试中';
       	orderDetailnewThree.Demostar__c=date.newInstance(2013,1,1);
    	orderDetailnewThree.Demoend__c=date.newInstance(2013,2,5);
    	orderDetailnewThree.AddDate__c=date.newInstance(2013,10,14);
    	orderDetailnewThree.IfNewProduct__c=true;
    	orderDetailnewThree.WhetherTheDelay__c=true;
       	list_orDetails.add(orderDetailnewThree);  

  		OrderDetails__c orderDetailnewFour = new OrderDetails__c();			//订单未超标,新样机,有延期,延期不超过1个月,当前时间>延期时间,当前时间-延期时间>30
		orderDetailnewFour.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewFour.n_OrderNo__c = ordersDelay.Id;
		orderDetailnewFour.n_ProductByOrd__c=prod.id;									//产品
    	orderDetailnewFour.n_ProCount__c=1;					 							//数量
    	orderDetailnewFour.n_PriceByord__c=400;											//成交价
    	orderDetailnewFour.TestStatus__c = '测试中';
       	orderDetailnewFour.Demostar__c=date.newInstance(2013,1,1);
    	orderDetailnewFour.Demoend__c=date.newInstance(2013,2,5);
    	orderDetailnewFour.AddDate__c=date.newInstance(2013,2,19);
    	orderDetailnewFour.IfNewProduct__c=true;
    	orderDetailnewFour.WhetherTheDelay__c=true;
       	list_orDetails.add(orderDetailnewFour);  
		
		
		OrderDetails__c orderDetailnewFive = new OrderDetails__c();			//订单未超标,新样机,有延期,延期不超过1个月,当前时间>延期时间,当前时间-延期时间<30
		orderDetailnewFive.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewFive.n_OrderNo__c = ordersDelay.Id;
		orderDetailnewFive.n_ProductByOrd__c=prod.id;								//产品
    	orderDetailnewFive.n_ProCount__c=1;					 						//数量
    	orderDetailnewFive.n_PriceByord__c=400;										//成交价
    	orderDetailnewFive.TestStatus__c = '测试中';
       	orderDetailnewFive.Demostar__c=date.newInstance(2013,5,1);
    	orderDetailnewFive.Demoend__c=date.newInstance(2013,5,5);
    	orderDetailnewFive.AddDate__c=date.newInstance(2013,5,15);
    	orderDetailnewFive.IfNewProduct__c=true;
    	orderDetailnewFive.WhetherTheDelay__c=true;
       	list_orDetails.add(orderDetailnewFive);  

		OrderDetails__c orderDetailnewSix = new OrderDetails__c();			//订单未超标,新样机,有延期,延期不超过1个月,当前时间<延期时间
		orderDetailnewSix.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewSix.n_OrderNo__c = ordersDelay.Id;
		orderDetailnewSix.n_ProductByOrd__c=prod.id;								//产品
    	orderDetailnewSix.n_ProCount__c=1;					 						//数量
    	orderDetailnewSix.n_PriceByord__c=400;										//成交价
    	orderDetailnewSix.TestStatus__c = '测试中';
       	orderDetailnewSix.Demostar__c=date.newInstance(2013,5,1);
    	orderDetailnewSix.Demoend__c=date.newInstance(2013,5,5);
    	orderDetailnewSix.AddDate__c=date.newInstance(2013,5,28);
    	orderDetailnewSix.IfNewProduct__c=true;
    	orderDetailnewSix.WhetherTheDelay__c=true;
       	list_orDetails.add(orderDetailnewSix); 		

		OrderDetails__c orderDetailnewSeven = new OrderDetails__c();			//订单未超标,新样机,无延期,当前时间>预计结束时间,当前时间-预计结束时间>30
		orderDetailnewSeven.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewSeven.n_OrderNo__c = orders.Id;
		orderDetailnewSeven.n_ProductByOrd__c=prod.id;								//产品
    	orderDetailnewSeven.n_ProCount__c=1;					 					//数量
    	orderDetailnewSeven.n_PriceByord__c=400;									//成交价
    	orderDetailnewSeven.TestStatus__c = '测试中';
       	orderDetailnewSeven.Demostar__c=date.newInstance(2013,4,1);
    	orderDetailnewSeven.Demoend__c=date.newInstance(2013,4,5);
    	orderDetailnewSeven.IfNewProduct__c=true;
    	orderDetailnewSeven.WhetherTheDelay__c=false;
       	list_orDetails.add(orderDetailnewSeven); 		

		OrderDetails__c orderDetailnewEight = new OrderDetails__c();			//订单未超标,新样机,无延期,当前时间>预计结束时间,当前时间-预计结束时间<30
		orderDetailnewEight.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewEight.n_OrderNo__c = orders.Id;
		orderDetailnewEight.n_ProductByOrd__c=prod.id;								//产品
    	orderDetailnewEight.n_ProCount__c=1;					 						//数量
    	orderDetailnewEight.n_PriceByord__c=400;										//成交价
    	orderDetailnewEight.TestStatus__c = '测试中';
       	orderDetailnewEight.Demostar__c=date.newInstance(2013,5,1);
    	orderDetailnewEight.Demoend__c=date.newInstance(2013,5,5);
    	orderDetailnewEight.IfNewProduct__c=true;
    	orderDetailnewEight.WhetherTheDelay__c=false;
       	list_orDetails.add(orderDetailnewEight);

		OrderDetails__c orderDetailnewNine = new OrderDetails__c();			//订单未超标,新样机,无延期,当前时间<预计结束时间
		orderDetailnewNine.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewNine.n_OrderNo__c = orders.Id;
		orderDetailnewNine.n_ProductByOrd__c=prod.id;								//产品
    	orderDetailnewNine.n_ProCount__c=1;					 						//数量
    	orderDetailnewNine.n_PriceByord__c=400;										//成交价
    	orderDetailnewNine.TestStatus__c = '测试中';
       	orderDetailnewNine.Demostar__c=date.newInstance(2013,5,1);
    	orderDetailnewNine.Demoend__c=date.newInstance(2013,5,5);
    	orderDetailnewNine.IfNewProduct__c=true;
    	orderDetailnewNine.WhetherTheDelay__c=false;
       	list_orDetails.add(orderDetailnewNine);
    	insert list_orDetails;
    	
		scheduleOrderDetailAutoUpdate slordAut=new scheduleOrderDetailAutoUpdate();	
 	    clsPredictActualPrice LeadBatch = new clsPredictActualPrice();
   		Database.executeBatch(LeadBatch,50);
		
   		system.Test.stopTest();    
    }
    static testMethod void myUnitTestTwo() 												/****************************订单没超标 旧样机***************************/
    {
    	Pricebook2 pricebook = [select Id from Pricebook2 where isStandard=true limit 1];
    	list<RecordType> listrtp=[Select Name, Id, Description From RecordType];
    	map<string,RecordType> maprtp=new map<string,RecordType>();
    	if(listrtp.size()>0)
    	{
    		for(RecordType rt:listrtp)
    		{
    			if(!maprtp.containsKey(rt.Name))
    				maprtp.put(rt.Name,rt);
    		}
    	}
    	RecordType listrtpQuDao=maprtp.get('渠道代理商'); 
    	RecordType listrtpInside=maprtp.get('内部样机订单');
    	RecordType listrtpZuiZhong=maprtp.get('最终客户');
    	RecordType listrtpDetailsType=maprtp.get('内部样机');    	   
    	Profile profile=[Select p.Name, p.Id From Profile p where Name='Chatter External User'];
    	User user=new User();											 
	    user.Phone='87413065';   
	    user.MobilePhone='15167988026';
	    user.Username='LurryKong@fccz.com4';
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
        
        Account acc=new Account();
        acc.Name='五粮液';
        acc.Fax='8088';
        acc.Description='五粮液';
        acc.Phone='053187401697';
        acc.Industry='Finance';
        acc.RecordTypeId=listrtpQuDao.id;
        insert acc;
    	
    	SalesRegion__c salesregion=new SalesRegion__c();
		salesregion.OfficeDirector__c=user.id;
		salesregion.Name='日本';
		insert salesregion;    	
    	
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
        pms.NewProductPrice__c = Double.valueOf(1000);
        pms.OldProductPrice__c = Double.valueOf(100);
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
	    
	    Orders__c orders=new Orders__c();					//订单未超标,订单延期
        orders.Name='testorders';
        orders.SalesOpportunities__c=opp.id;
        orders.Quote__c=quote.id;  
        orders.RecordTypeId=listrtpInside.id;
        orders.customer__c = acc.Id;
        orders.Partners__c = acc.Id;
        orders.SalesRegion__c=salesregion.Id;
        orders.ApprovalStatus__c='已审批';
        orders.IfCostOverWeight__c=false;
        orders.WhetherTheDelay__c=true;
		listOrder.add(orders);
		
		Orders__c ordersDelay=new Orders__c();					//订单未超标,订单延期
        ordersDelay.Name='testordersTwo';
        ordersDelay.SalesOpportunities__c=opp.id;
        ordersDelay.Quote__c=quote.id;  
        ordersDelay.RecordTypeId=listrtpInside.id;
        ordersDelay.customer__c = acc.Id;
        ordersDelay.Partners__c = acc.Id;
        ordersDelay.SalesRegion__c=salesregion.Id;
        ordersDelay.ApprovalStatus__c='延期已审批';
        ordersDelay.IfCostOverWeight__c=false;
        ordersDelay.WhetherTheDelay__c=true;
		listOrder.add(ordersDelay);

		insert listOrder;

		DateTime dtToday = Date.today();
		system.Test.startTest();
		//订单明细
		DateTime nowToday = Date.today();
		date startDate = date.newInstance(2013,1,1);
		date dueDate = date.newInstance(2013,3,24);		
		
		date dueDateAddDatemaxMonth=date.newInstance(2013,5,15);
		date dueDateAddDateminMonth=date.newInstance(2013,4,25);
				
		list<OrderDetails__c> list_orDetails = new list<OrderDetails__c>();		
		
		OrderDetails__c orderDetailnew = new OrderDetails__c();				//订单未超标,新样机,有延期,延期超过1个月,当前时间>延期时间,当前时间-延期时间>30
		orderDetailnew.RecordTypeId = listrtpDetailsType.id;
		orderDetailnew.n_OrderNo__c = ordersDelay.Id;
		orderDetailnew.n_ProductByOrd__c=prod.id;									
    	orderDetailnew.n_ProCount__c=1;					 						
    	orderDetailnew.n_PriceByord__c=400;										
    	orderDetailnew.TestStatus__c = '测试中';
       	orderDetailnew.Demostar__c=date.newInstance(2013,1,1);
    	orderDetailnew.Demoend__c=date.newInstance(2013,2,5);
    	orderDetailnew.AddDate__c=date.newInstance(2013,4,6);
    	orderDetailnew.IfNewProduct__c=false;
    	orderDetailnew.WhetherTheDelay__c=true;
       	list_orDetails.add(orderDetailnew);  

   		OrderDetails__c orderDetailnewTwo = new OrderDetails__c();			//订单未超标,新样机,有延期,延期超过1个月,当前时间>延期时间,当前时间-延期时间<30
		orderDetailnewTwo.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewTwo.n_OrderNo__c = ordersDelay.Id;
		orderDetailnewTwo.n_ProductByOrd__c=prod.id;									//产品
    	orderDetailnewTwo.n_ProCount__c=1;					 						//数量
    	orderDetailnewTwo.n_PriceByord__c=400;										//成交价
    	orderDetailnewTwo.TestStatus__c = '测试中';
       	orderDetailnewTwo.Demostar__c=date.newInstance(2013,1,1);
    	orderDetailnewTwo.Demoend__c=date.newInstance(2013,2,5);
    	orderDetailnewTwo.AddDate__c=date.newInstance(2013,5,14);
    	orderDetailnewTwo.IfNewProduct__c=false;
    	orderDetailnewTwo.WhetherTheDelay__c=true;
       	list_orDetails.add(orderDetailnewTwo);  

  		OrderDetails__c orderDetailnewThree = new OrderDetails__c();		//订单未超标,新样机,有延期,延期超过1个月,当前时间<延期时间
		orderDetailnewThree.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewThree.n_OrderNo__c = ordersDelay.Id;
		orderDetailnewThree.n_ProductByOrd__c=prod.id;									//产品
    	orderDetailnewThree.n_ProCount__c=1;					 						//数量
    	orderDetailnewThree.n_PriceByord__c=400;										//成交价
    	orderDetailnewThree.TestStatus__c = '测试中';
       	orderDetailnewThree.Demostar__c=date.newInstance(2013,1,1);
    	orderDetailnewThree.Demoend__c=date.newInstance(2013,2,5);
    	orderDetailnewThree.AddDate__c=date.newInstance(2013,10,14);
    	orderDetailnewThree.IfNewProduct__c=false;
    	orderDetailnewThree.WhetherTheDelay__c=true;
       	list_orDetails.add(orderDetailnewThree);  

  		OrderDetails__c orderDetailnewFour = new OrderDetails__c();			//订单未超标,新样机,有延期,延期不超过1个月,当前时间>延期时间,当前时间-延期时间>30
		orderDetailnewFour.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewFour.n_OrderNo__c = ordersDelay.Id;
		orderDetailnewFour.n_ProductByOrd__c=prod.id;									//产品
    	orderDetailnewFour.n_ProCount__c=1;					 							//数量
    	orderDetailnewFour.n_PriceByord__c=400;											//成交价
    	orderDetailnewFour.TestStatus__c = '测试中';
       	orderDetailnewFour.Demostar__c=date.newInstance(2013,1,1);
    	orderDetailnewFour.Demoend__c=date.newInstance(2013,2,5);
    	orderDetailnewFour.AddDate__c=date.newInstance(2013,2,19);
    	orderDetailnewFour.IfNewProduct__c=false;
    	orderDetailnewFour.WhetherTheDelay__c=true;
       	list_orDetails.add(orderDetailnewFour);  
		
		
		OrderDetails__c orderDetailnewFive = new OrderDetails__c();			//订单未超标,新样机,有延期,延期不超过1个月,当前时间>延期时间,当前时间-延期时间<30
		orderDetailnewFive.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewFive.n_OrderNo__c = ordersDelay.Id;
		orderDetailnewFive.n_ProductByOrd__c=prod.id;								//产品
    	orderDetailnewFive.n_ProCount__c=1;					 						//数量
    	orderDetailnewFive.n_PriceByord__c=400;										//成交价
    	orderDetailnewFive.TestStatus__c = '测试中';
       	orderDetailnewFive.Demostar__c=date.newInstance(2013,5,1);
    	orderDetailnewFive.Demoend__c=date.newInstance(2013,5,5);
    	orderDetailnewFive.AddDate__c=date.newInstance(2013,5,15);
    	orderDetailnewFive.IfNewProduct__c=false;
    	orderDetailnewFive.WhetherTheDelay__c=true;
       	list_orDetails.add(orderDetailnewFive);  

		OrderDetails__c orderDetailnewSix = new OrderDetails__c();			//订单未超标,新样机,有延期,延期不超过1个月,当前时间<延期时间
		orderDetailnewSix.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewSix.n_OrderNo__c = ordersDelay.Id;
		orderDetailnewSix.n_ProductByOrd__c=prod.id;								//产品
    	orderDetailnewSix.n_ProCount__c=1;					 						//数量
    	orderDetailnewSix.n_PriceByord__c=400;										//成交价
    	orderDetailnewSix.TestStatus__c = '测试中';
       	orderDetailnewSix.Demostar__c=date.newInstance(2013,5,1);
    	orderDetailnewSix.Demoend__c=date.newInstance(2013,5,5);
    	orderDetailnewSix.AddDate__c=date.newInstance(2013,5,28);
    	orderDetailnewSix.IfNewProduct__c=false;
    	orderDetailnewSix.WhetherTheDelay__c=true;
       	list_orDetails.add(orderDetailnewSix); 		

		OrderDetails__c orderDetailnewSeven = new OrderDetails__c();			//订单未超标,新样机,无延期,当前时间>预计结束时间,当前时间-预计结束时间>30
		orderDetailnewSeven.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewSeven.n_OrderNo__c = orders.Id;
		orderDetailnewSeven.n_ProductByOrd__c=prod.id;								//产品
    	orderDetailnewSeven.n_ProCount__c=1;					 					//数量
    	orderDetailnewSeven.n_PriceByord__c=400;									//成交价
    	orderDetailnewSeven.TestStatus__c = '测试中';
       	orderDetailnewSeven.Demostar__c=date.newInstance(2013,4,1);
    	orderDetailnewSeven.Demoend__c=date.newInstance(2013,4,5);
    	orderDetailnewSeven.IfNewProduct__c=false;
    	orderDetailnewSeven.WhetherTheDelay__c=false;
       	list_orDetails.add(orderDetailnewSeven); 		

		OrderDetails__c orderDetailnewEight = new OrderDetails__c();			//订单未超标,新样机,无延期,当前时间>预计结束时间,当前时间-预计结束时间<30
		orderDetailnewEight.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewEight.n_OrderNo__c = orders.Id;
		orderDetailnewEight.n_ProductByOrd__c=prod.id;								//产品
    	orderDetailnewEight.n_ProCount__c=1;					 						//数量
    	orderDetailnewEight.n_PriceByord__c=400;										//成交价
    	orderDetailnewEight.TestStatus__c = '测试中';
       	orderDetailnewEight.Demostar__c=date.newInstance(2013,5,1);
    	orderDetailnewEight.Demoend__c=date.newInstance(2013,5,5);
    	orderDetailnewEight.IfNewProduct__c=false;
    	orderDetailnewEight.WhetherTheDelay__c=false;
       	list_orDetails.add(orderDetailnewEight);

		OrderDetails__c orderDetailnewNine = new OrderDetails__c();			//订单未超标,新样机,无延期,当前时间<预计结束时间
		orderDetailnewNine.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewNine.n_OrderNo__c = orders.Id;
		orderDetailnewNine.n_ProductByOrd__c=prod.id;								//产品
    	orderDetailnewNine.n_ProCount__c=1;					 						//数量
    	orderDetailnewNine.n_PriceByord__c=400;										//成交价
    	orderDetailnewNine.TestStatus__c = '测试中';
       	orderDetailnewNine.Demostar__c=date.newInstance(2013,5,1);
    	orderDetailnewNine.Demoend__c=date.newInstance(2013,5,5);
    	orderDetailnewNine.IfNewProduct__c=false;
    	orderDetailnewNine.WhetherTheDelay__c=false;
       	list_orDetails.add(orderDetailnewNine);
    	insert list_orDetails;
    	
		scheduleOrderDetailAutoUpdate slordAut=new scheduleOrderDetailAutoUpdate();	
 	    clsPredictActualPrice LeadBatch = new clsPredictActualPrice();
   		Database.executeBatch(LeadBatch,50);
		
   		system.Test.stopTest();    
    }
    static testMethod void myUnitTestThree() 											/****************************订单超标新样机***************************/
    {
    	Pricebook2 pricebook = [select Id from Pricebook2 where isStandard=true limit 1];
    	list<RecordType> listrtp=[Select Name, Id, Description From RecordType];
    	map<string,RecordType> maprtp=new map<string,RecordType>();
    	if(listrtp.size()>0)
    	{
    		for(RecordType rt:listrtp)
    		{
    			if(!maprtp.containsKey(rt.Name))
    				maprtp.put(rt.Name,rt);
    		}
    	}
    	RecordType listrtpQuDao=maprtp.get('渠道代理商'); 
    	RecordType listrtpInside=maprtp.get('内部样机订单');
    	RecordType listrtpZuiZhong=maprtp.get('最终客户');
    	RecordType listrtpDetailsType=maprtp.get('内部样机');    	   
    	Profile profile=[Select p.Name, p.Id From Profile p where Name='Chatter External User'];
    	User user=new User();											 
	    user.Phone='87413065';   
	    user.MobilePhone='15167988026';
	    user.Username='LurryKong@fccz.com5';
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
        
        Account acc=new Account();
        acc.Name='五粮液';
        acc.Fax='8088';
        acc.Description='五粮液';
        acc.Phone='053187401697';
        acc.Industry='Finance';
        acc.RecordTypeId=listrtpQuDao.id;
        insert acc;
    	
    	SalesRegion__c salesregion=new SalesRegion__c();
		salesregion.OfficeDirector__c=user.id;
		salesregion.Name='日本';
		insert salesregion;    	
    	
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
        pms.NewProductPrice__c = Double.valueOf(1000);
        pms.OldProductPrice__c = Double.valueOf(100);
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
	    
	    Orders__c orders=new Orders__c();					//订单未超标,订单延期
        orders.Name='testorders';
        orders.SalesOpportunities__c=opp.id;
        orders.Quote__c=quote.id;  
        orders.RecordTypeId=listrtpInside.id;
        orders.customer__c = acc.Id;
        orders.Partners__c = acc.Id;
        orders.SalesRegion__c=salesregion.Id;
        orders.ApprovalStatus__c='已审批';
        orders.IfCostOverWeight__c=true;
        orders.WhetherTheDelay__c=true;
		listOrder.add(orders);
		
        Orders__c ordersDelay=new Orders__c();					//订单未超标,订单延期
        ordersDelay.Name='testordersTwo';
        ordersDelay.SalesOpportunities__c=opp.id;
        ordersDelay.Quote__c=quote.id;  
        ordersDelay.RecordTypeId=listrtpInside.id;
        ordersDelay.customer__c = acc.Id;
        ordersDelay.Partners__c = acc.Id;
        ordersDelay.SalesRegion__c=salesregion.Id;
        ordersDelay.ApprovalStatus__c='延期已审批';
        ordersDelay.IfCostOverWeight__c=false;
        ordersDelay.WhetherTheDelay__c=true;
		listOrder.add(ordersDelay);
		insert listOrder;

		DateTime dtToday = Date.today();
		system.Test.startTest();
		//订单明细
		DateTime nowToday = Date.today();
		date startDate = date.newInstance(2013,1,1);
		date dueDate = date.newInstance(2013,3,24);		
		
		date dueDateAddDatemaxMonth=date.newInstance(2013,5,15);
		date dueDateAddDateminMonth=date.newInstance(2013,4,25);
				
		list<OrderDetails__c> list_orDetails = new list<OrderDetails__c>();		
		
		OrderDetails__c orderDetailnew = new OrderDetails__c();				//订单未超标,新样机,有延期,延期超过1个月,当前时间>延期时间,当前时间-延期时间>30
		orderDetailnew.RecordTypeId = listrtpDetailsType.id;
		orderDetailnew.n_OrderNo__c = ordersDelay.Id;
		orderDetailnew.n_ProductByOrd__c=prod.id;									
    	orderDetailnew.n_ProCount__c=1;					 						
    	orderDetailnew.n_PriceByord__c=400;										
    	orderDetailnew.TestStatus__c = '测试中';
       	orderDetailnew.Demostar__c=date.newInstance(2013,1,1);
    	orderDetailnew.Demoend__c=date.newInstance(2013,2,5);
    	orderDetailnew.AddDate__c=date.newInstance(2013,4,6);
    	orderDetailnew.IfNewProduct__c=true;
    	orderDetailnew.WhetherTheDelay__c=true;
       	list_orDetails.add(orderDetailnew);  

   		OrderDetails__c orderDetailnewTwo = new OrderDetails__c();			//订单未超标,新样机,有延期,延期超过1个月,当前时间>延期时间,当前时间-延期时间<30
		orderDetailnewTwo.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewTwo.n_OrderNo__c = ordersDelay.Id;
		orderDetailnewTwo.n_ProductByOrd__c=prod.id;									//产品
    	orderDetailnewTwo.n_ProCount__c=1;					 						//数量
    	orderDetailnewTwo.n_PriceByord__c=400;										//成交价
    	orderDetailnewTwo.TestStatus__c = '测试中';
       	orderDetailnewTwo.Demostar__c=date.newInstance(2013,1,1);
    	orderDetailnewTwo.Demoend__c=date.newInstance(2013,2,5);
    	orderDetailnewTwo.AddDate__c=date.newInstance(2013,5,14);
    	orderDetailnewTwo.IfNewProduct__c=true;
    	orderDetailnewTwo.WhetherTheDelay__c=true;
       	list_orDetails.add(orderDetailnewTwo);  

  		OrderDetails__c orderDetailnewThree = new OrderDetails__c();		//订单未超标,新样机,有延期,延期超过1个月,当前时间<延期时间
		orderDetailnewThree.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewThree.n_OrderNo__c = ordersDelay.Id;
		orderDetailnewThree.n_ProductByOrd__c=prod.id;									//产品
    	orderDetailnewThree.n_ProCount__c=1;					 						//数量
    	orderDetailnewThree.n_PriceByord__c=400;										//成交价
    	orderDetailnewThree.TestStatus__c = '测试中';
       	orderDetailnewThree.Demostar__c=date.newInstance(2013,1,1);
    	orderDetailnewThree.Demoend__c=date.newInstance(2013,2,5);
    	orderDetailnewThree.AddDate__c=date.newInstance(2013,10,14);
    	orderDetailnewThree.IfNewProduct__c=true;
    	orderDetailnewThree.WhetherTheDelay__c=true;
       	list_orDetails.add(orderDetailnewThree);  

  		OrderDetails__c orderDetailnewFour = new OrderDetails__c();			//订单未超标,新样机,有延期,延期不超过1个月,当前时间>延期时间,当前时间-延期时间>30
		orderDetailnewFour.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewFour.n_OrderNo__c = ordersDelay.Id;
		orderDetailnewFour.n_ProductByOrd__c=prod.id;									//产品
    	orderDetailnewFour.n_ProCount__c=1;					 							//数量
    	orderDetailnewFour.n_PriceByord__c=400;											//成交价
    	orderDetailnewFour.TestStatus__c = '测试中';
       	orderDetailnewFour.Demostar__c=date.newInstance(2013,1,1);
    	orderDetailnewFour.Demoend__c=date.newInstance(2013,2,5);
    	orderDetailnewFour.AddDate__c=date.newInstance(2013,2,19);
    	orderDetailnewFour.IfNewProduct__c=true;
    	orderDetailnewFour.WhetherTheDelay__c=true;
       	list_orDetails.add(orderDetailnewFour);  
		
		
		OrderDetails__c orderDetailnewFive = new OrderDetails__c();			//订单未超标,新样机,有延期,延期不超过1个月,当前时间>延期时间,当前时间-延期时间<30
		orderDetailnewFive.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewFive.n_OrderNo__c = ordersDelay.Id;
		orderDetailnewFive.n_ProductByOrd__c=prod.id;								//产品
    	orderDetailnewFive.n_ProCount__c=1;					 						//数量
    	orderDetailnewFive.n_PriceByord__c=400;										//成交价
    	orderDetailnewFive.TestStatus__c = '测试中';
       	orderDetailnewFive.Demostar__c=date.newInstance(2013,5,1);
    	orderDetailnewFive.Demoend__c=date.newInstance(2013,5,5);
    	orderDetailnewFive.AddDate__c=date.newInstance(2013,5,15);
    	orderDetailnewFive.IfNewProduct__c=true;
    	orderDetailnewFive.WhetherTheDelay__c=true;
       	list_orDetails.add(orderDetailnewFive);  

		OrderDetails__c orderDetailnewSix = new OrderDetails__c();			//订单未超标,新样机,有延期,延期不超过1个月,当前时间<延期时间
		orderDetailnewSix.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewSix.n_OrderNo__c = ordersDelay.Id;
		orderDetailnewSix.n_ProductByOrd__c=prod.id;								//产品
    	orderDetailnewSix.n_ProCount__c=1;					 						//数量
    	orderDetailnewSix.n_PriceByord__c=400;										//成交价
    	orderDetailnewSix.TestStatus__c = '测试中';
       	orderDetailnewSix.Demostar__c=date.newInstance(2013,5,1);
    	orderDetailnewSix.Demoend__c=date.newInstance(2013,5,5);
    	orderDetailnewSix.AddDate__c=date.newInstance(2013,5,28);
    	orderDetailnewSix.IfNewProduct__c=true;
    	orderDetailnewSix.WhetherTheDelay__c=true;
       	list_orDetails.add(orderDetailnewSix); 		

		OrderDetails__c orderDetailnewSeven = new OrderDetails__c();			//订单未超标,新样机,无延期,当前时间>预计结束时间,当前时间-预计结束时间>30
		orderDetailnewSeven.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewSeven.n_OrderNo__c = orders.Id;
		orderDetailnewSeven.n_ProductByOrd__c=prod.id;								//产品
    	orderDetailnewSeven.n_ProCount__c=1;					 					//数量
    	orderDetailnewSeven.n_PriceByord__c=400;									//成交价
    	orderDetailnewSeven.TestStatus__c = '测试中';
       	orderDetailnewSeven.Demostar__c=date.newInstance(2013,4,1);
    	orderDetailnewSeven.Demoend__c=date.newInstance(2013,4,5);
    	orderDetailnewSeven.IfNewProduct__c=true;
    	orderDetailnewSeven.WhetherTheDelay__c=false;
       	list_orDetails.add(orderDetailnewSeven); 		

		OrderDetails__c orderDetailnewEight = new OrderDetails__c();			//订单未超标,新样机,无延期,当前时间>预计结束时间,当前时间-预计结束时间<30
		orderDetailnewEight.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewEight.n_OrderNo__c = orders.Id;
		orderDetailnewEight.n_ProductByOrd__c=prod.id;								//产品
    	orderDetailnewEight.n_ProCount__c=1;					 						//数量
    	orderDetailnewEight.n_PriceByord__c=400;										//成交价
    	orderDetailnewEight.TestStatus__c = '测试中';
       	orderDetailnewEight.Demostar__c=date.newInstance(2013,5,1);
    	orderDetailnewEight.Demoend__c=date.newInstance(2013,5,5);
    	orderDetailnewEight.IfNewProduct__c=true;
    	orderDetailnewEight.WhetherTheDelay__c=false;
       	list_orDetails.add(orderDetailnewEight);

		OrderDetails__c orderDetailnewNine = new OrderDetails__c();			//订单未超标,新样机,无延期,当前时间<预计结束时间
		orderDetailnewNine.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewNine.n_OrderNo__c = orders.Id;
		orderDetailnewNine.n_ProductByOrd__c=prod.id;								//产品
    	orderDetailnewNine.n_ProCount__c=1;					 						//数量
    	orderDetailnewNine.n_PriceByord__c=400;										//成交价
    	orderDetailnewNine.TestStatus__c = '测试中';
       	orderDetailnewNine.Demostar__c=date.newInstance(2013,5,1);
    	orderDetailnewNine.Demoend__c=date.newInstance(2013,5,5);
    	orderDetailnewNine.IfNewProduct__c=true;
    	orderDetailnewNine.WhetherTheDelay__c=false;
       	list_orDetails.add(orderDetailnewNine);
    	insert list_orDetails;
    	
		scheduleOrderDetailAutoUpdate slordAut=new scheduleOrderDetailAutoUpdate();	
 	    clsPredictActualPrice LeadBatch = new clsPredictActualPrice();
   		Database.executeBatch(LeadBatch,50);
		
   		system.Test.stopTest();    		
    }
    static testMethod void myUnitTestFour()																/****************************订单超标旧样机***************************/ 	
    {
    	Pricebook2 pricebook = [select Id from Pricebook2 where isStandard=true limit 1];
    	list<RecordType> listrtp=[Select Name, Id, Description From RecordType];
    	map<string,RecordType> maprtp=new map<string,RecordType>();
    	if(listrtp.size()>0)
    	{
    		for(RecordType rt:listrtp)
    		{
    			if(!maprtp.containsKey(rt.Name))
    				maprtp.put(rt.Name,rt);
    		}
    	}
    	RecordType listrtpQuDao=maprtp.get('渠道代理商'); 
    	RecordType listrtpInside=maprtp.get('内部样机订单');
    	RecordType listrtpZuiZhong=maprtp.get('最终客户');
    	RecordType listrtpDetailsType=maprtp.get('内部样机');    	   
    	Profile profile=[Select p.Name, p.Id From Profile p where Name='Chatter External User'];
    	User user=new User();											 
	    user.Phone='87413065';   
	    user.MobilePhone='15167988026';
	    user.Username='LurryKong@fccz.com6';
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
        
        Account acc=new Account();
        acc.Name='五粮液';
        acc.Fax='8088';
        acc.Description='五粮液';
        acc.Phone='053187401697';
        acc.Industry='Finance';
        acc.RecordTypeId=listrtpQuDao.id;
        insert acc;
    	
    	SalesRegion__c salesregion=new SalesRegion__c();
		salesregion.OfficeDirector__c=user.id;
		salesregion.Name='日本';
		insert salesregion;    	
    	
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
        pms.NewProductPrice__c = Double.valueOf(1000);
        pms.OldProductPrice__c = Double.valueOf(100);
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
	    
	    Orders__c orders=new Orders__c();					//订单未超标,订单延期
        orders.Name='testorders';
        orders.SalesOpportunities__c=opp.id;
        orders.Quote__c=quote.id;  
        orders.RecordTypeId=listrtpInside.id;
        orders.customer__c = acc.Id;
        orders.Partners__c = acc.Id;
        orders.SalesRegion__c=salesregion.Id;
        orders.ApprovalStatus__c='已审批';
        orders.IfCostOverWeight__c=true;
        orders.WhetherTheDelay__c=true;
		listOrder.add(orders);
		
		Orders__c ordersDelay=new Orders__c();					//订单未超标,订单延期
        ordersDelay.Name='testordersTwo';
        ordersDelay.SalesOpportunities__c=opp.id;
        ordersDelay.Quote__c=quote.id;  
        ordersDelay.RecordTypeId=listrtpInside.id;
        ordersDelay.customer__c = acc.Id;
        ordersDelay.Partners__c = acc.Id;
        ordersDelay.SalesRegion__c=salesregion.Id;
        ordersDelay.ApprovalStatus__c='延期已审批';
        ordersDelay.IfCostOverWeight__c=false;
        ordersDelay.WhetherTheDelay__c=true;
		listOrder.add(ordersDelay);
		insert listOrder;

		DateTime dtToday = Date.today();
		system.Test.startTest();
		//订单明细
		DateTime nowToday = Date.today();
		date startDate = date.newInstance(2013,1,1);
		date dueDate = date.newInstance(2013,3,24);		
		
		date dueDateAddDatemaxMonth=date.newInstance(2013,5,15);
		date dueDateAddDateminMonth=date.newInstance(2013,4,25);
				
		list<OrderDetails__c> list_orDetails = new list<OrderDetails__c>();		
		
		OrderDetails__c orderDetailnew = new OrderDetails__c();				//订单未超标,新样机,有延期,延期超过1个月,当前时间>延期时间,当前时间-延期时间>30
		orderDetailnew.RecordTypeId = listrtpDetailsType.id;
		orderDetailnew.n_OrderNo__c = ordersDelay.Id;
		orderDetailnew.n_ProductByOrd__c=prod.id;									
    	orderDetailnew.n_ProCount__c=1;					 						
    	orderDetailnew.n_PriceByord__c=400;										
    	orderDetailnew.TestStatus__c = '测试中';
       	orderDetailnew.Demostar__c=date.newInstance(2013,1,1);
    	orderDetailnew.Demoend__c=date.newInstance(2013,2,5);
    	orderDetailnew.AddDate__c=date.newInstance(2013,4,6);
    	orderDetailnew.IfNewProduct__c=false;
    	orderDetailnew.WhetherTheDelay__c=true;
       	list_orDetails.add(orderDetailnew);  

   		OrderDetails__c orderDetailnewTwo = new OrderDetails__c();			//订单未超标,新样机,有延期,延期超过1个月,当前时间>延期时间,当前时间-延期时间<30
		orderDetailnewTwo.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewTwo.n_OrderNo__c = ordersDelay.Id;
		orderDetailnewTwo.n_ProductByOrd__c=prod.id;									//产品
    	orderDetailnewTwo.n_ProCount__c=1;					 						//数量
    	orderDetailnewTwo.n_PriceByord__c=400;										//成交价
    	orderDetailnewTwo.TestStatus__c = '测试中';
       	orderDetailnewTwo.Demostar__c=date.newInstance(2013,1,1);
    	orderDetailnewTwo.Demoend__c=date.newInstance(2013,2,5);
    	orderDetailnewTwo.AddDate__c=date.newInstance(2013,5,14);
    	orderDetailnewTwo.IfNewProduct__c=false;
    	orderDetailnewTwo.WhetherTheDelay__c=true;
       	list_orDetails.add(orderDetailnewTwo);  

  		OrderDetails__c orderDetailnewThree = new OrderDetails__c();		//订单未超标,新样机,有延期,延期超过1个月,当前时间<延期时间
		orderDetailnewThree.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewThree.n_OrderNo__c = ordersDelay.Id;
		orderDetailnewThree.n_ProductByOrd__c=prod.id;									//产品
    	orderDetailnewThree.n_ProCount__c=1;					 						//数量
    	orderDetailnewThree.n_PriceByord__c=400;										//成交价
    	orderDetailnewThree.TestStatus__c = '测试中';
       	orderDetailnewThree.Demostar__c=date.newInstance(2013,1,1);
    	orderDetailnewThree.Demoend__c=date.newInstance(2013,2,5);
    	orderDetailnewThree.AddDate__c=date.newInstance(2013,10,14);
    	orderDetailnewThree.IfNewProduct__c=false;
    	orderDetailnewThree.WhetherTheDelay__c=true;
       	list_orDetails.add(orderDetailnewThree);  

  		OrderDetails__c orderDetailnewFour = new OrderDetails__c();			//订单未超标,新样机,有延期,延期不超过1个月,当前时间>延期时间,当前时间-延期时间>30
		orderDetailnewFour.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewFour.n_OrderNo__c = ordersDelay.Id;
		orderDetailnewFour.n_ProductByOrd__c=prod.id;									//产品
    	orderDetailnewFour.n_ProCount__c=1;					 							//数量
    	orderDetailnewFour.n_PriceByord__c=400;											//成交价
    	orderDetailnewFour.TestStatus__c = '测试中';
       	orderDetailnewFour.Demostar__c=date.newInstance(2013,1,1);
    	orderDetailnewFour.Demoend__c=date.newInstance(2013,2,5);
    	orderDetailnewFour.AddDate__c=date.newInstance(2013,2,19);
    	orderDetailnewFour.IfNewProduct__c=false;
    	orderDetailnewFour.WhetherTheDelay__c=true;
       	list_orDetails.add(orderDetailnewFour);  
		
		
		OrderDetails__c orderDetailnewFive = new OrderDetails__c();			//订单未超标,新样机,有延期,延期不超过1个月,当前时间>延期时间,当前时间-延期时间<30
		orderDetailnewFive.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewFive.n_OrderNo__c = ordersDelay.Id;
		orderDetailnewFive.n_ProductByOrd__c=prod.id;								//产品
    	orderDetailnewFive.n_ProCount__c=1;					 						//数量
    	orderDetailnewFive.n_PriceByord__c=400;										//成交价
    	orderDetailnewFive.TestStatus__c = '测试中';
       	orderDetailnewFive.Demostar__c=date.newInstance(2013,5,1);
    	orderDetailnewFive.Demoend__c=date.newInstance(2013,5,5);
    	orderDetailnewFive.AddDate__c=date.newInstance(2013,5,15);
    	orderDetailnewFive.IfNewProduct__c=false;
    	orderDetailnewFive.WhetherTheDelay__c=true;
       	list_orDetails.add(orderDetailnewFive);  

		OrderDetails__c orderDetailnewSix = new OrderDetails__c();			//订单未超标,新样机,有延期,延期不超过1个月,当前时间<延期时间
		orderDetailnewSix.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewSix.n_OrderNo__c = ordersDelay.Id;
		orderDetailnewSix.n_ProductByOrd__c=prod.id;								//产品
    	orderDetailnewSix.n_ProCount__c=1;					 						//数量
    	orderDetailnewSix.n_PriceByord__c=400;										//成交价
    	orderDetailnewSix.TestStatus__c = '测试中';
       	orderDetailnewSix.Demostar__c=date.newInstance(2013,5,1);
    	orderDetailnewSix.Demoend__c=date.newInstance(2013,5,5);
    	orderDetailnewSix.AddDate__c=date.newInstance(2013,5,28);
    	orderDetailnewSix.IfNewProduct__c=false;
    	orderDetailnewSix.WhetherTheDelay__c=true;
       	list_orDetails.add(orderDetailnewSix); 		

		OrderDetails__c orderDetailnewSeven = new OrderDetails__c();			//订单未超标,新样机,无延期,当前时间>预计结束时间,当前时间-预计结束时间>30
		orderDetailnewSeven.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewSeven.n_OrderNo__c = orders.Id;
		orderDetailnewSeven.n_ProductByOrd__c=prod.id;								//产品
    	orderDetailnewSeven.n_ProCount__c=1;					 					//数量
    	orderDetailnewSeven.n_PriceByord__c=400;									//成交价
    	orderDetailnewSeven.TestStatus__c = '测试中';
       	orderDetailnewSeven.Demostar__c=date.newInstance(2013,4,1);
    	orderDetailnewSeven.Demoend__c=date.newInstance(2013,4,5);
    	orderDetailnewSeven.IfNewProduct__c=false;
    	orderDetailnewSeven.WhetherTheDelay__c=false;
       	list_orDetails.add(orderDetailnewSeven); 		

		OrderDetails__c orderDetailnewEight = new OrderDetails__c();			//订单未超标,新样机,无延期,当前时间>预计结束时间,当前时间-预计结束时间<30
		orderDetailnewEight.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewEight.n_OrderNo__c = orders.Id;
		orderDetailnewEight.n_ProductByOrd__c=prod.id;								//产品
    	orderDetailnewEight.n_ProCount__c=1;					 						//数量
    	orderDetailnewEight.n_PriceByord__c=400;										//成交价
    	orderDetailnewEight.TestStatus__c = '测试中';
       	orderDetailnewEight.Demostar__c=date.newInstance(2013,5,1);
    	orderDetailnewEight.Demoend__c=date.newInstance(2013,5,5);
    	orderDetailnewEight.IfNewProduct__c=false;
    	orderDetailnewEight.WhetherTheDelay__c=false;
       	list_orDetails.add(orderDetailnewEight);

		OrderDetails__c orderDetailnewNine = new OrderDetails__c();			//订单未超标,新样机,无延期,当前时间<预计结束时间
		orderDetailnewNine.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewNine.n_OrderNo__c = orders.Id;
		orderDetailnewNine.n_ProductByOrd__c=prod.id;								//产品
    	orderDetailnewNine.n_ProCount__c=1;					 						//数量
    	orderDetailnewNine.n_PriceByord__c=400;										//成交价
    	orderDetailnewNine.TestStatus__c = '测试中';
       	orderDetailnewNine.Demostar__c=date.newInstance(2013,5,1);
    	orderDetailnewNine.Demoend__c=date.newInstance(2013,5,5);
    	orderDetailnewNine.IfNewProduct__c=false;
    	orderDetailnewNine.WhetherTheDelay__c=false;
       	list_orDetails.add(orderDetailnewNine);
    	insert list_orDetails;
    	
		scheduleOrderDetailAutoUpdate slordAut=new scheduleOrderDetailAutoUpdate();	
 	    clsPredictActualPrice LeadBatch = new clsPredictActualPrice();
   		Database.executeBatch(LeadBatch,50);
		
   		system.Test.stopTest();    

    }
}