/**
*Test:OrderDetails_AutoUpdatePracticalExpectPrice
*Author:Vito_He
*Time:2013年5月16日16:43:21
*lurrykong
**/
@isTest(SeeAllData=true)
private class trgTest_OrderDetails_PracticalPrice { 
  
    static testMethod void myUnitTest() 	/****************************订单没超标新样机***************************/
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
	    user.Username='LurryKong@fccz.com18';
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
        quote.yanhoukaipiaoliyouField3__c='延后开票信息';
        //quote.Status='已批准';
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
        //orders.Quote__c=quote.id;  
        orders.RecordTypeId=listrtpInside.id;
        orders.customer__c = acc.Id;
        orders.Partners__c = acc.Id;
        orders.SalesRegion__c=salesregion.Id;
        orders.ApprovalStatus__c='已审批';
        orders.IfCostOverWeight__c=false;
        orders.WhetherTheDelay__c=true;
		listOrder.add(orders);
		insert listOrder;

		DateTime dtToday = Date.today();
		//订单明细
		DateTime nowToday = Date.today();
		date startDate = date.newInstance(2013,1,1);
		date dueDate = date.newInstance(2013,3,24);		
		
		date dueDateAddDatemaxMonth=date.newInstance(2013,5,15);
		date dueDateAddDateminMonth=date.newInstance(2013,4,25);
				
		list<OrderDetails__c> list_orDetails = new list<OrderDetails__c>();		
		list<OrderDetails__c> list_upDetails=new list<OrderDetails__c>();
		list<ProductSN__c> listProductSN=new list<ProductSN__c>(); 
		list<OfYahuoTurnSeller__c> listOfYahuoTurnSeller=new list<OfYahuoTurnSeller__c>();
		
		OrderDetails__c orderDetailnew = new OrderDetails__c();				//订单未超标,新样机,有延期,延期超过1个月,当前时间>延期时间,当前时间-延期时间>30
		orderDetailnew.RecordTypeId = listrtpDetailsType.id;
		orderDetailnew.n_OrderNo__c = orders.Id;
		orderDetailnew.n_ProductByOrd__c=prod.id;									
    	orderDetailnew.n_ProCount__c=1;					 						
    	orderDetailnew.n_PriceByord__c=400;										
    	orderDetailnew.TestStatus__c = '测试中';
       	orderDetailnew.Demostar__c=date.newInstance(2013,1,1);
    	orderDetailnew.Demoend__c=date.newInstance(2013,2,5);
    	orderDetailnew.AddDate__c=date.newInstance(2013,4,6);
    	orderDetailnew.IfNewProduct__c=true;
    	orderDetailnew.WhetherTheDelay__c=true;
    	orderDetailnew.BorrowerReceiptDate__c=date.newInstance(2013,1,5);
       	list_orDetails.add(orderDetailnew);  
       	
       	ProductSN__c psnInside1=new ProductSN__c();
    	psnInside1.Name='lurrykong压货订单序列号';
    	psnInside1.ProductCategory__c='样机';
    	psnInside1.ProductStatus__c='测试机';
    	psnInside1.demoStatus__c='新样机';
    	psnInside1.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInside1);
       	


   		OrderDetails__c orderDetailnewTwo = new OrderDetails__c();			//订单未超标,新样机,有延期,延期超过1个月,当前时间>延期时间,当前时间-延期时间<30
		orderDetailnewTwo.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewTwo.n_OrderNo__c = orders.Id;
		orderDetailnewTwo.n_ProductByOrd__c=prod.id;									//产品
    	orderDetailnewTwo.n_ProCount__c=1;					 						//数量
    	orderDetailnewTwo.n_PriceByord__c=400;										//成交价
    	orderDetailnewTwo.TestStatus__c = '测试中';
       	orderDetailnewTwo.Demostar__c=date.newInstance(2013,1,1);
    	orderDetailnewTwo.Demoend__c=date.newInstance(2013,2,5);
    	orderDetailnewTwo.AddDate__c=date.newInstance(2013,5,14);
    	orderDetailnewTwo.IfNewProduct__c=true;
    	orderDetailnewTwo.WhetherTheDelay__c=true;
    	orderDetailnewTwo.BorrowerReceiptDate__c=date.newInstance(2013,1,5);
       	list_orDetails.add(orderDetailnewTwo);  

       	ProductSN__c psnInside2=new ProductSN__c();
    	psnInside2.Name='lurrykong压货订单序列号';
    	psnInside2.ProductCategory__c='样机';
    	psnInside2.ProductStatus__c='测试机';
    	psnInside2.demoStatus__c='新样机';
    	psnInside2.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInside2);


  		OrderDetails__c orderDetailnewThree = new OrderDetails__c();		//订单未超标,新样机,有延期,延期超过1个月,当前时间<延期时间
		orderDetailnewThree.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewThree.n_OrderNo__c = orders.Id;
		orderDetailnewThree.n_ProductByOrd__c=prod.id;									//产品
    	orderDetailnewThree.n_ProCount__c=1;					 						//数量
    	orderDetailnewThree.n_PriceByord__c=400;										//成交价
    	orderDetailnewThree.TestStatus__c = '测试中';
       	orderDetailnewThree.Demostar__c=date.newInstance(2013,1,1);
    	orderDetailnewThree.Demoend__c=date.newInstance(2013,2,5);
    	orderDetailnewThree.AddDate__c=date.newInstance(2013,10,14);
    	orderDetailnewThree.IfNewProduct__c=true;
    	orderDetailnewThree.WhetherTheDelay__c=true;
    	orderDetailnewThree.BorrowerReceiptDate__c=date.newInstance(2013,1,5);
       	list_orDetails.add(orderDetailnewThree);  

       	ProductSN__c psnInside3=new ProductSN__c();
    	psnInside3.Name='lurrykong压货订单序列号';
    	psnInside3.ProductCategory__c='样机';
    	psnInside3.ProductStatus__c='测试机';
    	psnInside3.demoStatus__c='新样机';
    	psnInside3.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInside3);

  		OrderDetails__c orderDetailnewFour = new OrderDetails__c();			//订单未超标,新样机,有延期,延期不超过1个月,当前时间>延期时间,当前时间-延期时间>30
		orderDetailnewFour.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewFour.n_OrderNo__c = orders.Id;
		orderDetailnewFour.n_ProductByOrd__c=prod.id;									//产品
    	orderDetailnewFour.n_ProCount__c=1;					 							//数量
    	orderDetailnewFour.n_PriceByord__c=400;											//成交价
    	orderDetailnewFour.TestStatus__c = '测试中';
       	orderDetailnewFour.Demostar__c=date.newInstance(2013,1,1);
    	orderDetailnewFour.Demoend__c=date.newInstance(2013,2,5);
    	orderDetailnewFour.AddDate__c=date.newInstance(2013,2,19);
    	orderDetailnewFour.IfNewProduct__c=true;
    	orderDetailnewFour.WhetherTheDelay__c=true;
    	orderDetailnewFour.BorrowerReceiptDate__c=date.newInstance(2013,1,5);
       	list_orDetails.add(orderDetailnewFour);  
		
		ProductSN__c psnInside4=new ProductSN__c();
    	psnInside4.Name='lurrykong压货订单序列号';
    	psnInside4.ProductCategory__c='样机';
    	psnInside4.ProductStatus__c='测试机';
    	psnInside4.demoStatus__c='新样机';
    	psnInside4.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInside4);
		
		OrderDetails__c orderDetailnewFive = new OrderDetails__c();			//订单未超标,新样机,有延期,延期不超过1个月,当前时间>延期时间,当前时间-延期时间<30
		orderDetailnewFive.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewFive.n_OrderNo__c = orders.Id;
		orderDetailnewFive.n_ProductByOrd__c=prod.id;								//产品
    	orderDetailnewFive.n_ProCount__c=1;					 						//数量
    	orderDetailnewFive.n_PriceByord__c=400;										//成交价
    	orderDetailnewFive.TestStatus__c = '测试中';
       	orderDetailnewFive.Demostar__c=date.newInstance(2013,5,1);
    	orderDetailnewFive.Demoend__c=date.newInstance(2013,5,5);
    	orderDetailnewFive.AddDate__c=date.newInstance(2013,5,15);
    	orderDetailnewFive.IfNewProduct__c=true;
    	orderDetailnewFive.WhetherTheDelay__c=true;
    	orderDetailnewFive.BorrowerReceiptDate__c=date.newInstance(2013,5,4);
       	list_orDetails.add(orderDetailnewFive);  

		ProductSN__c psnInside5=new ProductSN__c();
    	psnInside5.Name='lurrykong压货订单序列号';
    	psnInside5.ProductCategory__c='样机';
    	psnInside5.ProductStatus__c='测试机';
    	psnInside5.demoStatus__c='新样机';
    	psnInside5.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInside5);


		OrderDetails__c orderDetailnewSix = new OrderDetails__c();			//订单未超标,新样机,有延期,延期不超过1个月,当前时间<延期时间
		orderDetailnewSix.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewSix.n_OrderNo__c = orders.Id;
		orderDetailnewSix.n_ProductByOrd__c=prod.id;								//产品
    	orderDetailnewSix.n_ProCount__c=1;					 						//数量
    	orderDetailnewSix.n_PriceByord__c=400;										//成交价
    	orderDetailnewSix.TestStatus__c = '测试中';
       	orderDetailnewSix.Demostar__c=date.newInstance(2013,5,1);
    	orderDetailnewSix.Demoend__c=date.newInstance(2013,5,5);
    	orderDetailnewSix.AddDate__c=date.newInstance(2013,5,28);
    	orderDetailnewSix.IfNewProduct__c=true;
    	orderDetailnewSix.WhetherTheDelay__c=true;
    	orderDetailnewSix.BorrowerReceiptDate__c=date.newInstance(2013,5,4);
       	list_orDetails.add(orderDetailnewSix); 		

		ProductSN__c psnInside6=new ProductSN__c();
    	psnInside6.Name='lurrykong压货订单序列号';
    	psnInside6.ProductCategory__c='样机';
    	psnInside6.ProductStatus__c='测试机';
    	psnInside6.demoStatus__c='新样机';
    	psnInside6.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInside6);


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
    	orderDetailnewSeven.BorrowerReceiptDate__c=date.newInstance(2013,4,4);
       	list_orDetails.add(orderDetailnewSeven); 		

		ProductSN__c psnInside7=new ProductSN__c();
    	psnInside7.Name='lurrykong压货订单序列号';
    	psnInside7.ProductCategory__c='样机';
    	psnInside7.ProductStatus__c='测试机';
    	psnInside7.demoStatus__c='新样机';
    	psnInside7.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInside7);

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
    	orderDetailnewEight.BorrowerReceiptDate__c=date.newInstance(2013,5,4);
       	list_orDetails.add(orderDetailnewEight);

		ProductSN__c psnInside8=new ProductSN__c();
    	psnInside8.Name='lurrykong压货订单序列号';
    	psnInside8.ProductCategory__c='样机';
    	psnInside8.ProductStatus__c='测试机';
    	psnInside8.demoStatus__c='新样机';
    	psnInside8.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInside8);


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
    	orderDetailnewNine.BorrowerReceiptDate__c=date.newInstance(2013,5,4);
       	list_orDetails.add(orderDetailnewNine);
    	
    	ProductSN__c psnInside9=new ProductSN__c();
    	psnInside9.Name='lurrykong压货订单序列号';
    	psnInside9.ProductCategory__c='样机';
    	psnInside9.ProductStatus__c='测试机';
    	psnInside9.demoStatus__c='新样机';
    	psnInside9.PrototypeStatus__c='空闲'; 
    	listProductSN.add(psnInside9);

		
		insert list_orDetails;	
			
		insert listProductSN;
		system.debug('.....................listProductSN........................................'+listProductSN);
		
		OfYahuoTurnSeller__c ofyahuoturn1=new OfYahuoTurnSeller__c();				//订单明细sn
		ofyahuoturn1.orders__c=orderDetailnew.id;
		ofyahuoturn1.ProductCategory__c='样机';
		ofyahuoturn1.ProductStatus__c='测试机';
		ofyahuoturn1.n_SN__c=psnInside1.id;
		listOfYahuoTurnSeller.add(ofyahuoturn1);
		OfYahuoTurnSeller__c ofyahuoturn2=new OfYahuoTurnSeller__c();				//订单明细sn
		ofyahuoturn2.orders__c=orderDetailnewTwo.id;
		ofyahuoturn2.ProductCategory__c='样机';
		ofyahuoturn2.ProductStatus__c='测试机';
		ofyahuoturn2.n_SN__c=psnInside2.id;
		listOfYahuoTurnSeller.add(ofyahuoturn2);
		OfYahuoTurnSeller__c ofyahuoturn3=new OfYahuoTurnSeller__c();				//订单明细sn
		ofyahuoturn3.orders__c=orderDetailnewThree.id;
		ofyahuoturn3.ProductCategory__c='样机';
		ofyahuoturn3.ProductStatus__c='测试机';
		ofyahuoturn3.n_SN__c=psnInside3.id;
		listOfYahuoTurnSeller.add(ofyahuoturn3);
		OfYahuoTurnSeller__c ofyahuoturn4=new OfYahuoTurnSeller__c();				//订单明细sn
		ofyahuoturn4.orders__c=orderDetailnewFour.id;
		ofyahuoturn4.ProductCategory__c='样机';
		ofyahuoturn4.ProductStatus__c='测试机';
		ofyahuoturn4.n_SN__c=psnInside4.id;
		listOfYahuoTurnSeller.add(ofyahuoturn4);
		OfYahuoTurnSeller__c ofyahuoturn5=new OfYahuoTurnSeller__c();				//订单明细sn
		ofyahuoturn5.orders__c=orderDetailnewFive.id;
		ofyahuoturn5.ProductCategory__c='样机';
		ofyahuoturn5.ProductStatus__c='测试机';
		ofyahuoturn5.n_SN__c=psnInside5.id;
		listOfYahuoTurnSeller.add(ofyahuoturn5);
		OfYahuoTurnSeller__c ofyahuoturn6=new OfYahuoTurnSeller__c();				//订单明细sn
		ofyahuoturn6.orders__c=orderDetailnewSix.id;
		ofyahuoturn6.ProductCategory__c='样机';
		ofyahuoturn6.ProductStatus__c='测试机';
		ofyahuoturn6.n_SN__c=psnInside6.id;
		listOfYahuoTurnSeller.add(ofyahuoturn6);
		OfYahuoTurnSeller__c ofyahuoturn7=new OfYahuoTurnSeller__c();				//订单明细sn
		ofyahuoturn7.orders__c=orderDetailnewSeven.id;
		ofyahuoturn7.ProductCategory__c='样机';
		ofyahuoturn7.ProductStatus__c='测试机';
		ofyahuoturn7.n_SN__c=psnInside7.id;
		listOfYahuoTurnSeller.add(ofyahuoturn7);
		OfYahuoTurnSeller__c ofyahuoturn8=new OfYahuoTurnSeller__c();				//订单明细sn
		ofyahuoturn8.orders__c=orderDetailnewEight.id;
		ofyahuoturn8.ProductCategory__c='样机';
		ofyahuoturn8.ProductStatus__c='测试机';
		ofyahuoturn8.n_SN__c=psnInside8.id;
		listOfYahuoTurnSeller.add(ofyahuoturn8);
		OfYahuoTurnSeller__c ofyahuoturn9=new OfYahuoTurnSeller__c();				//订单明细sn
		ofyahuoturn9.orders__c=orderDetailnewNine.id;
		ofyahuoturn9.ProductCategory__c='样机';
		ofyahuoturn9.ProductStatus__c='测试机';
		ofyahuoturn9.n_SN__c=psnInside9.id;
		listOfYahuoTurnSeller.add(ofyahuoturn9);
		
	
		insert listOfYahuoTurnSeller;
		system.debug('.....................listOfYahuoTurnSeller........................................'+listOfYahuoTurnSeller);
		orderDetailnew.BorrowerReceiptDate__c=date.newInstance(2013,1,2);
		list_upDetails.add(orderDetailnew);
		orderDetailnewTwo.BorrowerReceiptDate__c=date.newInstance(2013,1,3);
		list_upDetails.add(orderDetailnewTwo);
		
		orderDetailnewThree.BorrowerReceiptDate__c=date.newInstance(2013,1,22);
		list_upDetails.add(orderDetailnewThree);
		orderDetailnewFour.BorrowerReceiptDate__c=date.newInstance(2013,1,22);
		list_upDetails.add(orderDetailnewFour);
		orderDetailnewFive.BorrowerReceiptDate__c=date.newInstance(2013,5,3);
		list_upDetails.add(orderDetailnewFive);
		orderDetailnewSix.BorrowerReceiptDate__c=date.newInstance(2013,5,3);
		list_upDetails.add(orderDetailnewSix);
		orderDetailnewSeven.BorrowerReceiptDate__c=date.newInstance(2013,4,3);
		list_upDetails.add(orderDetailnewSeven);
		orderDetailnewEight.BorrowerReceiptDate__c=date.newInstance(2013,5,3);
		list_upDetails.add(orderDetailnewEight);
		orderDetailnewNine.BorrowerReceiptDate__c=date.newInstance(2013,5,3);
		list_upDetails.add(orderDetailnewNine);
		
		system.Test.startTest(); 
		update list_upDetails;
   		system.Test.stopTest();    
    
    }
    static testMethod void myUnitTestTwo() 														/****************************订单没超标 旧样机***************************/	
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
	    user.Username='LurryKong@fccz.com';
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
        orders.RecordTypeId=listrtpInside.id;
        orders.customer__c = acc.Id;
        orders.Partners__c = acc.Id;
        orders.SalesRegion__c=salesregion.Id;
        orders.ApprovalStatus__c='已审批';
        orders.IfCostOverWeight__c=false;
        orders.WhetherTheDelay__c=true;
		listOrder.add(orders);
		insert listOrder;
		DateTime dtToday = Date.today();
		
		//订单明细
		DateTime nowToday = Date.today();
		date startDate = date.newInstance(2013,1,1);
		date dueDate = date.newInstance(2013,3,24);		
		
		date dueDateAddDatemaxMonth=date.newInstance(2013,5,15);
		date dueDateAddDateminMonth=date.newInstance(2013,4,25);
				
		list<OrderDetails__c> list_orDetails = new list<OrderDetails__c>();		
		list<OrderDetails__c> list_upDetails=new list<OrderDetails__c>();
		list<ProductSN__c> listProductSN=new list<ProductSN__c>(); 
		list<OfYahuoTurnSeller__c> listOfYahuoTurnSeller=new list<OfYahuoTurnSeller__c>();
		
		OrderDetails__c orderDetailnew = new OrderDetails__c();				//订单未超标,新样机,有延期,延期超过1个月,当前时间>延期时间,当前时间-延期时间>30
		orderDetailnew.RecordTypeId = listrtpDetailsType.id;
		orderDetailnew.n_OrderNo__c = orders.Id;
		orderDetailnew.n_ProductByOrd__c=prod.id;									
    	orderDetailnew.n_ProCount__c=1;					 						
    	orderDetailnew.n_PriceByord__c=400;										
    	orderDetailnew.TestStatus__c = '测试中';
       	orderDetailnew.Demostar__c=date.newInstance(2013,1,1);
    	orderDetailnew.Demoend__c=date.newInstance(2013,2,5);
    	orderDetailnew.AddDate__c=date.newInstance(2013,4,6);
    	orderDetailnew.BorrowerReceiptDate__c=null;
    	orderDetailnew.IfNewProduct__c=false;
    	orderDetailnew.WhetherTheDelay__c=true;
       	list_orDetails.add(orderDetailnew);  

		ProductSN__c psnInside1=new ProductSN__c();
    	psnInside1.Name='lurrykong压货订单序列号';
    	psnInside1.ProductCategory__c='样机';
    	psnInside1.ProductStatus__c='测试机';
    	psnInside1.demoStatus__c='旧样机';
    	psnInside1.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInside1);
 
   		OrderDetails__c orderDetailnewTwo = new OrderDetails__c();			//订单未超标,新样机,有延期,延期超过1个月,当前时间>延期时间,当前时间-延期时间<30
		orderDetailnewTwo.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewTwo.n_OrderNo__c = orders.Id;
		orderDetailnewTwo.n_ProductByOrd__c=prod.id;									//产品
    	orderDetailnewTwo.n_ProCount__c=1;					 						//数量
    	orderDetailnewTwo.n_PriceByord__c=400;										//成交价
    	orderDetailnewTwo.TestStatus__c = '测试中';
       	orderDetailnewTwo.Demostar__c=date.newInstance(2013,1,1);
    	orderDetailnewTwo.Demoend__c=date.newInstance(2013,2,5);
    	orderDetailnewTwo.AddDate__c=date.newInstance(2013,5,14);
    	orderDetailnewTwo.IfNewProduct__c=false;
    	orderDetailnewTwo.WhetherTheDelay__c=true;
    	orderDetailnewTwo.BorrowerReceiptDate__c=null;
       	list_orDetails.add(orderDetailnewTwo);  

		ProductSN__c psnInside2=new ProductSN__c();
    	psnInside2.Name='lurrykong压货订单序列号';
    	psnInside2.ProductCategory__c='样机';
    	psnInside2.ProductStatus__c='测试机';
    	psnInside2.demoStatus__c='旧样机';
    	psnInside2.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInside2);

  		OrderDetails__c orderDetailnewThree = new OrderDetails__c();		//订单未超标,新样机,有延期,延期超过1个月,当前时间<延期时间
		orderDetailnewThree.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewThree.n_OrderNo__c = orders.Id;
		orderDetailnewThree.n_ProductByOrd__c=prod.id;									//产品
    	orderDetailnewThree.n_ProCount__c=1;					 						//数量
    	orderDetailnewThree.n_PriceByord__c=400;										//成交价
    	orderDetailnewThree.TestStatus__c = '测试中';
       	orderDetailnewThree.Demostar__c=date.newInstance(2013,1,1);
    	orderDetailnewThree.Demoend__c=date.newInstance(2013,2,5);
    	orderDetailnewThree.AddDate__c=date.newInstance(2013,10,14);
    	orderDetailnewThree.IfNewProduct__c=false;
    	orderDetailnewThree.WhetherTheDelay__c=true;
    	orderDetailnewThree.BorrowerReceiptDate__c=null;
       	list_orDetails.add(orderDetailnewThree);  

		ProductSN__c psnInside3=new ProductSN__c();
    	psnInside3.Name='lurrykong压货订单序列号';
    	psnInside3.ProductCategory__c='样机';
    	psnInside3.ProductStatus__c='测试机';
    	psnInside3.demoStatus__c='旧样机';
    	psnInside3.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInside3);

  		OrderDetails__c orderDetailnewFour = new OrderDetails__c();			//订单未超标,新样机,有延期,延期不超过1个月,当前时间>延期时间,当前时间-延期时间>30
		orderDetailnewFour.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewFour.n_OrderNo__c = orders.Id;
		orderDetailnewFour.n_ProductByOrd__c=prod.id;									//产品
    	orderDetailnewFour.n_ProCount__c=1;					 							//数量
    	orderDetailnewFour.n_PriceByord__c=400;											//成交价
    	orderDetailnewFour.TestStatus__c = '测试中';
       	orderDetailnewFour.Demostar__c=date.newInstance(2013,1,1);
    	orderDetailnewFour.Demoend__c=date.newInstance(2013,2,5);
    	orderDetailnewFour.AddDate__c=date.newInstance(2013,2,19);
    	orderDetailnewFour.IfNewProduct__c=false;
    	orderDetailnewFour.WhetherTheDelay__c=true;
    	orderDetailnewFour.BorrowerReceiptDate__c=null;
       	list_orDetails.add(orderDetailnewFour);  
		
		ProductSN__c psnInside4=new ProductSN__c();
    	psnInside4.Name='lurrykong压货订单序列号';
    	psnInside4.ProductCategory__c='样机';
    	psnInside4.ProductStatus__c='测试机';
    	psnInside4.demoStatus__c='旧样机';
    	psnInside4.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInside4);
		
		OrderDetails__c orderDetailnewFive = new OrderDetails__c();			//订单未超标,新样机,有延期,延期不超过1个月,当前时间>延期时间,当前时间-延期时间<30
		orderDetailnewFive.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewFive.n_OrderNo__c = orders.Id;
		orderDetailnewFive.n_ProductByOrd__c=prod.id;								//产品
    	orderDetailnewFive.n_ProCount__c=1;					 						//数量
    	orderDetailnewFive.n_PriceByord__c=400;										//成交价
    	orderDetailnewFive.TestStatus__c = '测试中';
       	orderDetailnewFive.Demostar__c=date.newInstance(2013,5,1);
    	orderDetailnewFive.Demoend__c=date.newInstance(2013,5,5);
    	orderDetailnewFive.AddDate__c=date.newInstance(2013,5,15);
    	orderDetailnewFive.IfNewProduct__c=false;
    	orderDetailnewFive.WhetherTheDelay__c=true;
    	orderDetailnewFive.BorrowerReceiptDate__c=null;
       	list_orDetails.add(orderDetailnewFive);  

		ProductSN__c psnInside5=new ProductSN__c();
    	psnInside5.Name='lurrykong压货订单序列号';
    	psnInside5.ProductCategory__c='样机';
    	psnInside5.ProductStatus__c='测试机';
    	psnInside5.demoStatus__c='旧样机';
    	psnInside5.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInside5);


		OrderDetails__c orderDetailnewSix = new OrderDetails__c();			//订单未超标,新样机,有延期,延期不超过1个月,当前时间<延期时间
		orderDetailnewSix.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewSix.n_OrderNo__c = orders.Id;
		orderDetailnewSix.n_ProductByOrd__c=prod.id;								//产品
    	orderDetailnewSix.n_ProCount__c=1;					 						//数量
    	orderDetailnewSix.n_PriceByord__c=400;										//成交价
    	orderDetailnewSix.TestStatus__c = '测试中';
       	orderDetailnewSix.Demostar__c=date.newInstance(2013,5,1);
    	orderDetailnewSix.Demoend__c=date.newInstance(2013,5,5);
    	orderDetailnewSix.AddDate__c=date.newInstance(2013,5,28);
    	orderDetailnewSix.IfNewProduct__c=false;
    	orderDetailnewSix.WhetherTheDelay__c=true;
    	orderDetailnewSix.BorrowerReceiptDate__c=null;
       	list_orDetails.add(orderDetailnewSix); 		

		ProductSN__c psnInside6=new ProductSN__c();
    	psnInside6.Name='lurrykong压货订单序列号';
    	psnInside6.ProductCategory__c='样机';
    	psnInside6.ProductStatus__c='测试机';
    	psnInside6.demoStatus__c='旧样机';
    	psnInside6.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInside6);

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
    	orderDetailnewSeven.BorrowerReceiptDate__c=null;
       	list_orDetails.add(orderDetailnewSeven); 		

		ProductSN__c psnInside7=new ProductSN__c();
    	psnInside7.Name='lurrykong压货订单序列号';
    	psnInside7.ProductCategory__c='样机';
    	psnInside7.ProductStatus__c='测试机';
    	psnInside7.demoStatus__c='旧样机';
    	psnInside7.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInside7);


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
    	orderDetailnewEight.BorrowerReceiptDate__c=null;
       	list_orDetails.add(orderDetailnewEight);

		ProductSN__c psnInside8=new ProductSN__c();
    	psnInside8.Name='lurrykong压货订单序列号';
    	psnInside8.ProductCategory__c='样机';
    	psnInside8.ProductStatus__c='测试机';
    	psnInside8.demoStatus__c='旧样机';
    	psnInside8.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInside8);

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
    	orderDetailnewNine.BorrowerReceiptDate__c=null;
       	list_orDetails.add(orderDetailnewNine);
       	insert list_orDetails;
       	ProductSN__c psnInside9=new ProductSN__c();
    	psnInside9.Name='lurrykong压货订单序列号';
    	psnInside9.ProductCategory__c='样机';
    	psnInside9.ProductStatus__c='测试机';
    	psnInside9.demoStatus__c='旧样机';
    	psnInside9.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInside9);	     	 
		insert listProductSN;
		
		OfYahuoTurnSeller__c ofyahuoturn1=new OfYahuoTurnSeller__c();				//订单明细sn
    	ofyahuoturn1.orders__c=orderDetailnew.id;
    	ofyahuoturn1.ProductCategory__c='样机';
    	ofyahuoturn1.ProductStatus__c='测试机';
    	ofyahuoturn1.n_SN__c=psnInside1.id;
    	listOfYahuoTurnSeller.add(ofyahuoturn1);
       	OfYahuoTurnSeller__c ofyahuoturn2=new OfYahuoTurnSeller__c();				//订单明细sn
    	ofyahuoturn2.orders__c=orderDetailnewTwo.id;
    	ofyahuoturn2.ProductCategory__c='样机';
    	ofyahuoturn2.ProductStatus__c='测试机';
    	ofyahuoturn2.n_SN__c=psnInside2.id;
    	listOfYahuoTurnSeller.add(ofyahuoturn2);
       	OfYahuoTurnSeller__c ofyahuoturn3=new OfYahuoTurnSeller__c();				//订单明细sn
    	ofyahuoturn3.orders__c=orderDetailnewThree.id;
    	ofyahuoturn3.ProductCategory__c='样机';
    	ofyahuoturn3.ProductStatus__c='测试机';
    	ofyahuoturn3.n_SN__c=psnInside3.id;
    	listOfYahuoTurnSeller.add(ofyahuoturn3);
       	OfYahuoTurnSeller__c ofyahuoturn4=new OfYahuoTurnSeller__c();				//订单明细sn
    	ofyahuoturn4.orders__c=orderDetailnewFour.id;
    	ofyahuoturn4.ProductCategory__c='样机';
    	ofyahuoturn4.ProductStatus__c='测试机';
    	ofyahuoturn4.n_SN__c=psnInside4.id;
    	listOfYahuoTurnSeller.add(ofyahuoturn4);
       	OfYahuoTurnSeller__c ofyahuoturn5=new OfYahuoTurnSeller__c();				//订单明细sn
    	ofyahuoturn5.orders__c=orderDetailnewFive.id;
    	ofyahuoturn5.ProductCategory__c='样机';
    	ofyahuoturn5.ProductStatus__c='测试机';
    	ofyahuoturn5.n_SN__c=psnInside5.id;
    	listOfYahuoTurnSeller.add(ofyahuoturn5);
       	OfYahuoTurnSeller__c ofyahuoturn6=new OfYahuoTurnSeller__c();				//订单明细sn
    	ofyahuoturn6.orders__c=orderDetailnewSix.id;
    	ofyahuoturn6.ProductCategory__c='样机';
    	ofyahuoturn6.ProductStatus__c='测试机';
    	ofyahuoturn6.n_SN__c=psnInside6.id;
    	listOfYahuoTurnSeller.add(ofyahuoturn6);
       	OfYahuoTurnSeller__c ofyahuoturn7=new OfYahuoTurnSeller__c();				//订单明细sn
    	ofyahuoturn7.orders__c=orderDetailnewSeven.id;
    	ofyahuoturn7.ProductCategory__c='样机';
    	ofyahuoturn7.ProductStatus__c='测试机';
    	ofyahuoturn7.n_SN__c=psnInside7.id;
    	listOfYahuoTurnSeller.add(ofyahuoturn7);
       	OfYahuoTurnSeller__c ofyahuoturn8=new OfYahuoTurnSeller__c();				//订单明细sn
    	ofyahuoturn8.orders__c=orderDetailnewEight.id;
    	ofyahuoturn8.ProductCategory__c='样机';
    	ofyahuoturn8.ProductStatus__c='测试机';
    	ofyahuoturn8.n_SN__c=psnInside8.id;
    	listOfYahuoTurnSeller.add(ofyahuoturn8);
       	OfYahuoTurnSeller__c ofyahuoturn9=new OfYahuoTurnSeller__c();				//订单明细sn
    	ofyahuoturn9.orders__c=orderDetailnewNine.id;
    	ofyahuoturn9.ProductCategory__c='样机';
    	ofyahuoturn9.ProductStatus__c='测试机';
    	ofyahuoturn9.n_SN__c=psnInside9.id;
    	listOfYahuoTurnSeller.add(ofyahuoturn9);
		insert listOfYahuoTurnSeller;
		
		orderDetailnew.BorrowerReceiptDate__c=date.newInstance(2013,1,22);
		list_upDetails.add(orderDetailnew);
		orderDetailnewTwo.BorrowerReceiptDate__c=date.newInstance(2013,1,22);
		list_upDetails.add(orderDetailnewTwo);
		orderDetailnewThree.BorrowerReceiptDate__c=date.newInstance(2013,1,22);
		list_upDetails.add(orderDetailnewThree);
		orderDetailnewFour.BorrowerReceiptDate__c=date.newInstance(2013,1,22);
		list_upDetails.add(orderDetailnewFour);
		orderDetailnewFive.BorrowerReceiptDate__c=date.newInstance(2013,5,3);
		list_upDetails.add(orderDetailnewFive);
		orderDetailnewSix.BorrowerReceiptDate__c=date.newInstance(2013,5,3);
		list_upDetails.add(orderDetailnewSix);
		orderDetailnewSeven.BorrowerReceiptDate__c=date.newInstance(2013,4,3);
		list_upDetails.add(orderDetailnewSeven);
		orderDetailnewEight.BorrowerReceiptDate__c=date.newInstance(2013,5,3);
		list_upDetails.add(orderDetailnewEight);
   		orderDetailnewNine.BorrowerReceiptDate__c=date.newInstance(2013,5,3);
		list_upDetails.add(orderDetailnewNine);
		
		system.Test.startTest();
		update list_upDetails; 
   		system.Test.stopTest();    
    	
    }
    static testMethod void myUnitTestThree() 												/****************************订单超标新样机***************************/
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
	    user.Username='LurryKong@fccz.com';
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
        orders.RecordTypeId=listrtpInside.id;
        orders.customer__c = acc.Id;
        orders.Partners__c = acc.Id;
        orders.SalesRegion__c=salesregion.Id;
        orders.ApprovalStatus__c='已审批';
        orders.IfCostOverWeight__c=true;
        orders.WhetherTheDelay__c=true;
		listOrder.add(orders);
		insert listOrder;

		DateTime dtToday = Date.today();
		
		//订单明细
		DateTime nowToday = Date.today();
		date startDate = date.newInstance(2013,1,1);
		date dueDate = date.newInstance(2013,3,24);		
		
		date dueDateAddDatemaxMonth=date.newInstance(2013,5,15);
		date dueDateAddDateminMonth=date.newInstance(2013,4,25);
						
		list<OrderDetails__c> list_orDetails = new list<OrderDetails__c>();		
		list<OrderDetails__c> list_upDetails=new list<OrderDetails__c>();
		list<ProductSN__c> listProductSN=new list<ProductSN__c>(); 
		list<OfYahuoTurnSeller__c> listOfYahuoTurnSeller=new list<OfYahuoTurnSeller__c>();
				
		OrderDetails__c orderDetailnew = new OrderDetails__c();				//订单未超标,新样机,有延期,延期超过1个月,当前时间>延期时间,当前时间-延期时间>30
		orderDetailnew.RecordTypeId = listrtpDetailsType.id;
		orderDetailnew.n_OrderNo__c = orders.Id;
		orderDetailnew.n_ProductByOrd__c=prod.id;									
    	orderDetailnew.n_ProCount__c=1;					 						
    	orderDetailnew.n_PriceByord__c=400;										
    	orderDetailnew.TestStatus__c = '测试中';
       	orderDetailnew.Demostar__c=date.newInstance(2013,1,1);
    	orderDetailnew.Demoend__c=date.newInstance(2013,2,5);
    	orderDetailnew.AddDate__c=date.newInstance(2013,4,6);
    	orderDetailnew.IfNewProduct__c=true;
    	orderDetailnew.WhetherTheDelay__c=true;
    	orderDetailnew.BorrowerReceiptDate__c=null;
       	list_orDetails.add(orderDetailnew);  

       	ProductSN__c psnInsidenew=new ProductSN__c();
    	psnInsidenew.Name='lurrykong压货订单序列号';
    	psnInsidenew.ProductCategory__c='样机';
    	psnInsidenew.ProductStatus__c='测试机';
    	psnInsidenew.demoStatus__c='新样机';
    	psnInsidenew.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInsidenew);

   		OrderDetails__c orderDetailnewTwo = new OrderDetails__c();			//订单未超标,新样机,有延期,延期超过1个月,当前时间>延期时间,当前时间-延期时间<30
		orderDetailnewTwo.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewTwo.n_OrderNo__c = orders.Id;
		orderDetailnewTwo.n_ProductByOrd__c=prod.id;									//产品
    	orderDetailnewTwo.n_ProCount__c=1;					 						//数量
    	orderDetailnewTwo.n_PriceByord__c=400;										//成交价
    	orderDetailnewTwo.TestStatus__c = '测试中';
       	orderDetailnewTwo.Demostar__c=date.newInstance(2013,1,1);
    	orderDetailnewTwo.Demoend__c=date.newInstance(2013,2,5);
    	orderDetailnewTwo.AddDate__c=date.newInstance(2013,5,14);
    	orderDetailnewTwo.IfNewProduct__c=true;
    	orderDetailnewTwo.WhetherTheDelay__c=true;
    	orderDetailnewTwo.BorrowerReceiptDate__c=null;
       	list_orDetails.add(orderDetailnewTwo);  

       	ProductSN__c psnInside2=new ProductSN__c();
    	psnInside2.Name='lurrykong压货订单序列号';
    	psnInside2.ProductCategory__c='样机';
    	psnInside2.ProductStatus__c='测试机';
    	psnInside2.demoStatus__c='新样机';
    	psnInside2.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInside2);

  		OrderDetails__c orderDetailnewThree = new OrderDetails__c();		//订单未超标,新样机,有延期,延期超过1个月,当前时间<延期时间
		orderDetailnewThree.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewThree.n_OrderNo__c = orders.Id;
		orderDetailnewThree.n_ProductByOrd__c=prod.id;									//产品
    	orderDetailnewThree.n_ProCount__c=1;					 						//数量
    	orderDetailnewThree.n_PriceByord__c=400;										//成交价
    	orderDetailnewThree.TestStatus__c = '测试中';
       	orderDetailnewThree.Demostar__c=date.newInstance(2013,1,1);
    	orderDetailnewThree.Demoend__c=date.newInstance(2013,2,5);
    	orderDetailnewThree.AddDate__c=date.newInstance(2013,10,14);
    	orderDetailnewThree.IfNewProduct__c=true;
    	orderDetailnewThree.WhetherTheDelay__c=true;
    	orderDetailnewThree.BorrowerReceiptDate__c=null;
       	list_orDetails.add(orderDetailnewThree);  

       	ProductSN__c psnInside3=new ProductSN__c();
    	psnInside3.Name='lurrykong压货订单序列号';
    	psnInside3.ProductCategory__c='样机';
    	psnInside3.ProductStatus__c='测试机';
    	psnInside3.demoStatus__c='新样机';
    	psnInside3.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInside3);
    	


  		OrderDetails__c orderDetailnewFour = new OrderDetails__c();			//订单未超标,新样机,有延期,延期不超过1个月,当前时间>延期时间,当前时间-延期时间>30
		orderDetailnewFour.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewFour.n_OrderNo__c = orders.Id;
		orderDetailnewFour.n_ProductByOrd__c=prod.id;									//产品
    	orderDetailnewFour.n_ProCount__c=1;					 							//数量
    	orderDetailnewFour.n_PriceByord__c=400;											//成交价
    	orderDetailnewFour.TestStatus__c = '测试中';
       	orderDetailnewFour.Demostar__c=date.newInstance(2013,1,1);
    	orderDetailnewFour.Demoend__c=date.newInstance(2013,2,5);
    	orderDetailnewFour.AddDate__c=date.newInstance(2013,2,19);
    	orderDetailnewFour.IfNewProduct__c=true;
    	orderDetailnewFour.WhetherTheDelay__c=true;
    	orderDetailnewFour.BorrowerReceiptDate__c=null;
       	list_orDetails.add(orderDetailnewFour);  
		
		ProductSN__c psnInside4=new ProductSN__c();
    	psnInside4.Name='lurrykong压货订单序列号';
    	psnInside4.ProductCategory__c='样机';
    	psnInside4.ProductStatus__c='测试机';
    	psnInside4.demoStatus__c='新样机';
    	psnInside4.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInside4);
    	 
		OrderDetails__c orderDetailnewFive = new OrderDetails__c();			//订单未超标,新样机,有延期,延期不超过1个月,当前时间>延期时间,当前时间-延期时间<30
		orderDetailnewFive.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewFive.n_OrderNo__c = orders.Id;
		orderDetailnewFive.n_ProductByOrd__c=prod.id;								//产品
    	orderDetailnewFive.n_ProCount__c=1;					 						//数量
    	orderDetailnewFive.n_PriceByord__c=400;										//成交价
    	orderDetailnewFive.TestStatus__c = '测试中';
       	orderDetailnewFive.Demostar__c=date.newInstance(2013,5,1);
    	orderDetailnewFive.Demoend__c=date.newInstance(2013,5,5);
    	orderDetailnewFive.AddDate__c=date.newInstance(2013,5,15);
    	orderDetailnewFive.IfNewProduct__c=true;
    	orderDetailnewFive.WhetherTheDelay__c=true;
    	orderDetailnewFive.BorrowerReceiptDate__c=null;
       	list_orDetails.add(orderDetailnewFive);  
       	
       	ProductSN__c psnInside5=new ProductSN__c();
    	psnInside5.Name='lurrykong压货订单序列号';
    	psnInside5.ProductCategory__c='样机';
    	psnInside5.ProductStatus__c='测试机';
    	psnInside5.demoStatus__c='新样机';
    	psnInside5.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInside5);

		OrderDetails__c orderDetailnewSix = new OrderDetails__c();			//订单未超标,新样机,有延期,延期不超过1个月,当前时间<延期时间
		orderDetailnewSix.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewSix.n_OrderNo__c = orders.Id;
		orderDetailnewSix.n_ProductByOrd__c=prod.id;								//产品
    	orderDetailnewSix.n_ProCount__c=1;					 						//数量
    	orderDetailnewSix.n_PriceByord__c=400;										//成交价
    	orderDetailnewSix.TestStatus__c = '测试中';
       	orderDetailnewSix.Demostar__c=date.newInstance(2013,5,1);
    	orderDetailnewSix.Demoend__c=date.newInstance(2013,5,5);
    	orderDetailnewSix.AddDate__c=date.newInstance(2013,5,28);
    	orderDetailnewSix.IfNewProduct__c=true;
    	orderDetailnewSix.WhetherTheDelay__c=true;
    	orderDetailnewSix.BorrowerReceiptDate__c=null;
       	list_orDetails.add(orderDetailnewSix); 		

       	ProductSN__c psnInside6=new ProductSN__c();
    	psnInside6.Name='lurrykong压货订单序列号';
    	psnInside6.ProductCategory__c='样机';
    	psnInside6.ProductStatus__c='测试机';
    	psnInside6.demoStatus__c='新样机';
    	psnInside6.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInside6);

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
    	orderDetailnewSeven.BorrowerReceiptDate__c=null;
       	list_orDetails.add(orderDetailnewSeven); 		

       	ProductSN__c psnInside7=new ProductSN__c();
    	psnInside7.Name='lurrykong压货订单序列号';
    	psnInside7.ProductCategory__c='样机';
    	psnInside7.ProductStatus__c='测试机';
    	psnInside7.demoStatus__c='新样机';
    	psnInside7.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInside7);


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
    	orderDetailnewEight.BorrowerReceiptDate__c=null;
       	list_orDetails.add(orderDetailnewEight);

       	ProductSN__c psnInside8=new ProductSN__c();
    	psnInside8.Name='lurrykong压货订单序列号';
    	psnInside8.ProductCategory__c='样机';
    	psnInside8.ProductStatus__c='测试机';
    	psnInside8.demoStatus__c='新样机';
    	psnInside8.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInside8);


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
    	orderDetailnewNine.BorrowerReceiptDate__c=null;
       	list_orDetails.add(orderDetailnewNine);
    	insert list_orDetails;
    	
    	ProductSN__c psnInside9=new ProductSN__c();
    	psnInside9.Name='lurrykong压货订单序列号';
    	psnInside9.ProductCategory__c='样机';
    	psnInside9.ProductStatus__c='测试机';
    	psnInside9.demoStatus__c='新样机';
    	psnInside9.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInside9);
    	insert listProductSN;
    	
    	OfYahuoTurnSeller__c ofyahuoturn1=new OfYahuoTurnSeller__c();				//订单明细sn
    	ofyahuoturn1.orders__c=orderDetailnew.id;
    	ofyahuoturn1.ProductCategory__c='样机';
    	ofyahuoturn1.ProductStatus__c='测试机';
    	ofyahuoturn1.n_SN__c=psnInsidenew.id;
    	listOfYahuoTurnSeller.add(ofyahuoturn1);
       	OfYahuoTurnSeller__c ofyahuoturn2=new OfYahuoTurnSeller__c();				//订单明细sn
    	ofyahuoturn2.orders__c=orderDetailnewTwo.id;
    	ofyahuoturn2.ProductCategory__c='样机';
    	ofyahuoturn2.ProductStatus__c='测试机';
    	ofyahuoturn2.n_SN__c=psnInside2.id;
    	listOfYahuoTurnSeller.add(ofyahuoturn2);
       	OfYahuoTurnSeller__c ofyahuoturn3=new OfYahuoTurnSeller__c();				//订单明细sn
    	ofyahuoturn3.orders__c=orderDetailnewThree.id;
    	ofyahuoturn3.ProductCategory__c='样机';
    	ofyahuoturn3.ProductStatus__c='测试机';
    	ofyahuoturn3.n_SN__c=psnInside3.id;
    	listOfYahuoTurnSeller.add(ofyahuoturn3);
       	OfYahuoTurnSeller__c ofyahuoturn4=new OfYahuoTurnSeller__c();				//订单明细sn
    	ofyahuoturn4.orders__c=orderDetailnewFour.id;
    	ofyahuoturn4.ProductCategory__c='样机';
    	ofyahuoturn4.ProductStatus__c='测试机';
    	ofyahuoturn4.n_SN__c=psnInside4.id;
    	listOfYahuoTurnSeller.add(ofyahuoturn4);	
		OfYahuoTurnSeller__c ofyahuoturn5=new OfYahuoTurnSeller__c();				//订单明细sn
    	ofyahuoturn5.orders__c=orderDetailnewFive.id;
    	ofyahuoturn5.ProductCategory__c='样机';
    	ofyahuoturn5.ProductStatus__c='测试机';
    	ofyahuoturn5.n_SN__c=psnInside5.id;
    	listOfYahuoTurnSeller.add(ofyahuoturn5);    	
       	OfYahuoTurnSeller__c ofyahuoturn6=new OfYahuoTurnSeller__c();				//订单明细sn
    	ofyahuoturn6.orders__c=orderDetailnewSix.id;
    	ofyahuoturn6.ProductCategory__c='样机';
    	ofyahuoturn6.ProductStatus__c='测试机';
    	ofyahuoturn6.n_SN__c=psnInside6.id;
    	listOfYahuoTurnSeller.add(ofyahuoturn6);    	
       	OfYahuoTurnSeller__c ofyahuoturn7=new OfYahuoTurnSeller__c();				//订单明细sn
    	ofyahuoturn7.orders__c=orderDetailnewSeven.id;
    	ofyahuoturn7.ProductCategory__c='样机';
    	ofyahuoturn7.ProductStatus__c='测试机';
    	ofyahuoturn7.n_SN__c=psnInside7.id;
    	listOfYahuoTurnSeller.add(ofyahuoturn7);    	
       	OfYahuoTurnSeller__c ofyahuoturn8=new OfYahuoTurnSeller__c();				//订单明细sn
    	ofyahuoturn8.orders__c=orderDetailnewEight.id;
    	ofyahuoturn8.ProductCategory__c='样机';
    	ofyahuoturn8.ProductStatus__c='测试机';
    	ofyahuoturn8.n_SN__c=psnInside8.id;
    	listOfYahuoTurnSeller.add(ofyahuoturn8);    	
       	OfYahuoTurnSeller__c ofyahuoturn9=new OfYahuoTurnSeller__c();				//订单明细sn
    	ofyahuoturn9.orders__c=orderDetailnewNine.id;
    	ofyahuoturn9.ProductCategory__c='样机';
    	ofyahuoturn9.ProductStatus__c='测试机';
    	ofyahuoturn9.n_SN__c=psnInside9.id;
    	listOfYahuoTurnSeller.add(ofyahuoturn9);    	    	
    	insert listOfYahuoTurnSeller;
    	    	
    	orderDetailnew.BorrowerReceiptDate__c=date.newInstance(2013,1,22);
		list_upDetails.add(orderDetailnew);
		orderDetailnewTwo.BorrowerReceiptDate__c=date.newInstance(2013,1,22);
		list_upDetails.add(orderDetailnewTwo);
		orderDetailnewThree.BorrowerReceiptDate__c=date.newInstance(2013,1,22);
		list_upDetails.add(orderDetailnewThree);
		orderDetailnewFour.BorrowerReceiptDate__c=date.newInstance(2013,1,22);
		list_upDetails.add(orderDetailnewFour);
		orderDetailnewFive.BorrowerReceiptDate__c=date.newInstance(2013,5,2);
		list_upDetails.add(orderDetailnewFive);
		orderDetailnewSix.BorrowerReceiptDate__c=date.newInstance(2013,5,2);
		list_upDetails.add(orderDetailnewSix);
		orderDetailnewSeven.BorrowerReceiptDate__c=date.newInstance(2013,4,2);
		list_upDetails.add(orderDetailnewSeven);
		orderDetailnewEight.BorrowerReceiptDate__c=date.newInstance(2013,5,3);
		list_upDetails.add(orderDetailnewEight);
    	orderDetailnewNine.BorrowerReceiptDate__c=date.newInstance(2013,5,3);
		list_upDetails.add(orderDetailnewNine);
		system.Test.startTest(); 
		update list_upDetails;
   		system.Test.stopTest();    
   		
    }
    static testMethod void myUnitTestFour() 																/****************************订单超标旧样机***************************/
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
	    user.Username='LurryKong@fccz.com';
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
        orders.RecordTypeId=listrtpInside.id;
        orders.customer__c = acc.Id;
        orders.Partners__c = acc.Id;
        orders.SalesRegion__c=salesregion.Id;
        orders.ApprovalStatus__c='已审批';
        orders.IfCostOverWeight__c=true;
        orders.WhetherTheDelay__c=true;
		listOrder.add(orders);
		insert listOrder;

		DateTime dtToday = Date.today();
		
		//订单明细
		DateTime nowToday = Date.today();
		date startDate = date.newInstance(2013,1,1);
		date dueDate = date.newInstance(2013,3,24);		
		
		date dueDateAddDatemaxMonth=date.newInstance(2013,5,15);
		date dueDateAddDateminMonth=date.newInstance(2013,4,25);
				
		list<OrderDetails__c> list_orDetails = new list<OrderDetails__c>();		
		list<OrderDetails__c> list_orUpDetails = new list<OrderDetails__c>();
		list<ProductSN__c> listProductSN=new list<ProductSN__c>();
		list<OfYahuoTurnSeller__c> listOfYahuoTurnSeller=new list<OfYahuoTurnSeller__c>();
		OrderDetails__c orderDetailnew = new OrderDetails__c();				//订单未超标,新样机,有延期,延期超过1个月,当前时间>延期时间,当前时间-延期时间>30
		orderDetailnew.RecordTypeId = listrtpDetailsType.id;
		orderDetailnew.n_OrderNo__c = orders.Id;
		orderDetailnew.n_ProductByOrd__c=prod.id;									
    	orderDetailnew.n_ProCount__c=1;					 						
    	orderDetailnew.n_PriceByord__c=400;										
    	orderDetailnew.TestStatus__c = '测试中';
       	orderDetailnew.Demostar__c=date.newInstance(2013,1,1);
    	orderDetailnew.Demoend__c=date.newInstance(2013,2,5);
    	orderDetailnew.AddDate__c=date.newInstance(2013,4,6);
    	orderDetailnew.IfNewProduct__c=false;
    	orderDetailnew.WhetherTheDelay__c=true;
    	orderDetailnew.BorrowerReceiptDate__c=null;
       	list_orDetails.add(orderDetailnew);  

		ProductSN__c psnInsidenew=new ProductSN__c();
    	psnInsidenew.Name='lurrykong压货订单序列号';
    	psnInsidenew.ProductCategory__c='样机';
    	psnInsidenew.ProductStatus__c='测试机';
    	psnInsidenew.demoStatus__c='旧样机';
    	psnInsidenew.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInsidenew);
    	
   		OrderDetails__c orderDetailnewTwo = new OrderDetails__c();			//订单未超标,新样机,有延期,延期超过1个月,当前时间>延期时间,当前时间-延期时间<30
		orderDetailnewTwo.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewTwo.n_OrderNo__c = orders.Id;
		orderDetailnewTwo.n_ProductByOrd__c=prod.id;									//产品
    	orderDetailnewTwo.n_ProCount__c=1;					 						//数量
    	orderDetailnewTwo.n_PriceByord__c=400;										//成交价
    	orderDetailnewTwo.TestStatus__c = '测试中';
       	orderDetailnewTwo.Demostar__c=date.newInstance(2013,1,1);
    	orderDetailnewTwo.Demoend__c=date.newInstance(2013,2,5);
    	orderDetailnewTwo.AddDate__c=date.newInstance(2013,5,14);
    	orderDetailnewTwo.IfNewProduct__c=false;
    	orderDetailnewTwo.WhetherTheDelay__c=true;
        orderDetailnewTwo.BorrowerReceiptDate__c=null;
       	list_orDetails.add(orderDetailnewTwo);  

		ProductSN__c psnInside2=new ProductSN__c();
    	psnInside2.Name='lurrykong压货订单序列号';
    	psnInside2.ProductCategory__c='样机';
    	psnInside2.ProductStatus__c='测试机';
    	psnInside2.demoStatus__c='旧样机';
    	psnInside2.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInside2);
  
  		OrderDetails__c orderDetailnewThree = new OrderDetails__c();		//订单未超标,新样机,有延期,延期超过1个月,当前时间<延期时间
		orderDetailnewThree.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewThree.n_OrderNo__c = orders.Id;
		orderDetailnewThree.n_ProductByOrd__c=prod.id;									//产品
    	orderDetailnewThree.n_ProCount__c=1;					 						//数量
    	orderDetailnewThree.n_PriceByord__c=400;										//成交价
    	orderDetailnewThree.TestStatus__c = '测试中';
       	orderDetailnewThree.Demostar__c=date.newInstance(2013,1,1);
    	orderDetailnewThree.Demoend__c=date.newInstance(2013,2,5);
    	orderDetailnewThree.AddDate__c=date.newInstance(2013,10,14);
    	orderDetailnewThree.IfNewProduct__c=false;
    	orderDetailnewThree.WhetherTheDelay__c=true;
    	orderDetailnewThree.BorrowerReceiptDate__c=null;
       	list_orDetails.add(orderDetailnewThree);  

		ProductSN__c psnInside3=new ProductSN__c();
    	psnInside3.Name='lurrykong压货订单序列号';
    	psnInside3.ProductCategory__c='样机';
    	psnInside3.ProductStatus__c='测试机';
    	psnInside3.demoStatus__c='旧样机';
    	psnInside3.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInside3);

  		OrderDetails__c orderDetailnewFour = new OrderDetails__c();			//订单未超标,新样机,有延期,延期不超过1个月,当前时间>延期时间,当前时间-延期时间>30
		orderDetailnewFour.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewFour.n_OrderNo__c = orders.Id;
		orderDetailnewFour.n_ProductByOrd__c=prod.id;									//产品
    	orderDetailnewFour.n_ProCount__c=1;					 							//数量
    	orderDetailnewFour.n_PriceByord__c=400;											//成交价
    	orderDetailnewFour.TestStatus__c = '测试中';
       	orderDetailnewFour.Demostar__c=date.newInstance(2013,1,1);
    	orderDetailnewFour.Demoend__c=date.newInstance(2013,2,5);
    	orderDetailnewFour.AddDate__c=date.newInstance(2013,2,19);
    	orderDetailnewFour.IfNewProduct__c=false;
    	orderDetailnewFour.WhetherTheDelay__c=true;
    	orderDetailnewFour.BorrowerReceiptDate__c=null;
       	list_orDetails.add(orderDetailnewFour);  

		ProductSN__c psnInside4=new ProductSN__c();
    	psnInside4.Name='lurrykong压货订单序列号';
    	psnInside4.ProductCategory__c='样机';
    	psnInside4.ProductStatus__c='测试机';
    	psnInside4.demoStatus__c='旧样机';
    	psnInside4.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInside4); 
 
		OrderDetails__c orderDetailnewFive = new OrderDetails__c();			//订单未超标,新样机,有延期,延期不超过1个月,当前时间>延期时间,当前时间-延期时间<30
		orderDetailnewFive.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewFive.n_OrderNo__c = orders.Id;
		orderDetailnewFive.n_ProductByOrd__c=prod.id;								//产品
    	orderDetailnewFive.n_ProCount__c=1;					 						//数量
    	orderDetailnewFive.n_PriceByord__c=400;										//成交价
    	orderDetailnewFive.TestStatus__c = '测试中';
       	orderDetailnewFive.Demostar__c=date.newInstance(2013,5,1);
    	orderDetailnewFive.Demoend__c=date.newInstance(2013,5,5);
    	orderDetailnewFive.AddDate__c=date.newInstance(2013,5,15);
    	orderDetailnewFive.IfNewProduct__c=false;
    	orderDetailnewFive.WhetherTheDelay__c=true;
    	orderDetailnewFive.BorrowerReceiptDate__c=null;
       	list_orDetails.add(orderDetailnewFive);  

		ProductSN__c psnInside5=new ProductSN__c();
    	psnInside5.Name='lurrykong压货订单序列号';
    	psnInside5.ProductCategory__c='样机';
    	psnInside5.ProductStatus__c='测试机';
    	psnInside5.demoStatus__c='旧样机';
    	psnInside5.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInside5);
    	
		OrderDetails__c orderDetailnewSix = new OrderDetails__c();			//订单未超标,新样机,有延期,延期不超过1个月,当前时间<延期时间
		orderDetailnewSix.RecordTypeId = listrtpDetailsType.id;
		orderDetailnewSix.n_OrderNo__c = orders.Id;
		orderDetailnewSix.n_ProductByOrd__c=prod.id;								//产品
    	orderDetailnewSix.n_ProCount__c=1;					 						//数量
    	orderDetailnewSix.n_PriceByord__c=400;										//成交价
    	orderDetailnewSix.TestStatus__c = '测试中';
       	orderDetailnewSix.Demostar__c=date.newInstance(2013,5,1);
    	orderDetailnewSix.Demoend__c=date.newInstance(2013,5,5);
    	orderDetailnewSix.AddDate__c=date.newInstance(2013,5,28);
    	orderDetailnewSix.IfNewProduct__c=false;
    	orderDetailnewSix.WhetherTheDelay__c=true;
    	orderDetailnewSix.BorrowerReceiptDate__c=null;
       	list_orDetails.add(orderDetailnewSix); 		

		ProductSN__c psnInside6=new ProductSN__c();
    	psnInside6.Name='lurrykong压货订单序列号';
    	psnInside6.ProductCategory__c='样机';
    	psnInside6.ProductStatus__c='测试机';
    	psnInside6.demoStatus__c='旧样机';
    	psnInside6.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInside6);
    	
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
    	orderDetailnewSeven.BorrowerReceiptDate__c=null;
       	list_orDetails.add(orderDetailnewSeven); 		

		ProductSN__c psnInside7=new ProductSN__c();
    	psnInside7.Name='lurrykong压货订单序列号';
    	psnInside7.ProductCategory__c='样机';
    	psnInside7.ProductStatus__c='测试机';
    	psnInside7.demoStatus__c='旧样机';
    	psnInside7.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInside7);
    	
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
    	orderDetailnewEight.BorrowerReceiptDate__c=null;
       	list_orDetails.add(orderDetailnewEight);

		ProductSN__c psnInside8=new ProductSN__c();
    	psnInside8.Name='lurrykong压货订单序列号';
    	psnInside8.ProductCategory__c='样机';
    	psnInside8.ProductStatus__c='测试机';
    	psnInside8.demoStatus__c='旧样机';
    	psnInside8.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInside8);
    	
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
    	orderDetailnewNine.BorrowerReceiptDate__c=null;
       	list_orDetails.add(orderDetailnewNine);
    	insert list_orDetails;
    	
    	ProductSN__c psnInside9=new ProductSN__c();
    	psnInside9.Name='lurrykong压货订单序列号';
    	psnInside9.ProductCategory__c='样机';
    	psnInside9.ProductStatus__c='测试机';
    	psnInside9.demoStatus__c='旧样机';
    	psnInside9.PrototypeStatus__c='空闲';
    	listProductSN.add(psnInside9);

    	insert listProductSN;

		OfYahuoTurnSeller__c ofyahuoturnnew=new OfYahuoTurnSeller__c();				//订单明细sn
    	ofyahuoturnnew.orders__c=orderDetailnew.id;
    	ofyahuoturnnew.ProductCategory__c='样机';
    	ofyahuoturnnew.ProductStatus__c='测试机';
    	ofyahuoturnnew.n_SN__c=psnInsidenew.id;
    	listOfYahuoTurnSeller.add(ofyahuoturnnew);    	
       	OfYahuoTurnSeller__c ofyahuoturn2=new OfYahuoTurnSeller__c();				//订单明细sn
    	ofyahuoturn2.orders__c=orderDetailnewTwo.id;
    	ofyahuoturn2.ProductCategory__c='样机';
    	ofyahuoturn2.ProductStatus__c='测试机';
    	ofyahuoturn2.n_SN__c=psnInside2.id;
    	listOfYahuoTurnSeller.add(ofyahuoturn2);   
       	OfYahuoTurnSeller__c ofyahuoturn3=new OfYahuoTurnSeller__c();				//订单明细sn
    	ofyahuoturn3.orders__c=orderDetailnewThree.id;
    	ofyahuoturn3.ProductCategory__c='样机';
    	ofyahuoturn3.ProductStatus__c='测试机';
    	ofyahuoturn3.n_SN__c=psnInside3.id;
    	listOfYahuoTurnSeller.add(ofyahuoturn3);    
       	OfYahuoTurnSeller__c ofyahuoturn4=new OfYahuoTurnSeller__c();				//订单明细sn
    	ofyahuoturn4.orders__c=orderDetailnewFour.id;
    	ofyahuoturn4.ProductCategory__c='样机';
    	ofyahuoturn4.ProductStatus__c='测试机';
    	ofyahuoturn4.n_SN__c=psnInside4.id;
    	listOfYahuoTurnSeller.add(ofyahuoturn4);
       	OfYahuoTurnSeller__c ofyahuoturn5=new OfYahuoTurnSeller__c();				//订单明细sn
    	ofyahuoturn5.orders__c=orderDetailnewFive.id;
    	ofyahuoturn5.ProductCategory__c='样机';
    	ofyahuoturn5.ProductStatus__c='测试机';
    	ofyahuoturn5.n_SN__c=psnInside5.id;
    	listOfYahuoTurnSeller.add(ofyahuoturn5); 
       	OfYahuoTurnSeller__c ofyahuoturn6=new OfYahuoTurnSeller__c();				//订单明细sn
    	ofyahuoturn6.orders__c=orderDetailnewSix.id;
    	ofyahuoturn6.ProductCategory__c='样机';
    	ofyahuoturn6.ProductStatus__c='测试机';
    	ofyahuoturn6.n_SN__c=psnInside6.id;
    	listOfYahuoTurnSeller.add(ofyahuoturn6);  
       	OfYahuoTurnSeller__c ofyahuoturn7=new OfYahuoTurnSeller__c();				//订单明细sn
    	ofyahuoturn7.orders__c=orderDetailnewSeven.id;
    	ofyahuoturn7.ProductCategory__c='样机';
    	ofyahuoturn7.ProductStatus__c='测试机';
    	ofyahuoturn7.n_SN__c=psnInside7.id;
    	listOfYahuoTurnSeller.add(ofyahuoturn7);  
       	OfYahuoTurnSeller__c ofyahuoturn8=new OfYahuoTurnSeller__c();				//订单明细sn
    	ofyahuoturn8.orders__c=orderDetailnewEight.id;
    	ofyahuoturn8.ProductCategory__c='样机';
    	ofyahuoturn8.ProductStatus__c='测试机';
    	ofyahuoturn8.n_SN__c=psnInside8.id;
    	listOfYahuoTurnSeller.add(ofyahuoturn8);  
       	OfYahuoTurnSeller__c ofyahuoturn9=new OfYahuoTurnSeller__c();				//订单明细sn
    	ofyahuoturn9.orders__c=orderDetailnewNine.id;
    	ofyahuoturn9.ProductCategory__c='样机';
    	ofyahuoturn9.ProductStatus__c='测试机';    
    	ofyahuoturn9.n_SN__c=psnInside9.id;
    	listOfYahuoTurnSeller.add(ofyahuoturn9);
    	insert listOfYahuoTurnSeller;
    	orderDetailnew.BorrowerReceiptDate__c=date.newInstance(2013,1,12);
		list_orUpDetails.add(orderDetailnew);
		orderDetailnewTwo.BorrowerReceiptDate__c=date.newInstance(2013,1,12);
		list_orUpDetails.add(orderDetailnewTwo);
		orderDetailnewThree.BorrowerReceiptDate__c=date.newInstance(2013,1,12);
		list_orUpDetails.add(orderDetailnewThree);
		orderDetailnewFour.BorrowerReceiptDate__c=date.newInstance(2013,1,12);
		list_orUpDetails.add(orderDetailnewFour);		
		orderDetailnewFive.BorrowerReceiptDate__c=date.newInstance(2013,5,2);
		list_orUpDetails.add(orderDetailnewFive);		
		orderDetailnewSix.BorrowerReceiptDate__c=date.newInstance(2013,5,2);
		list_orUpDetails.add(orderDetailnewSix);	
		orderDetailnewSeven.BorrowerReceiptDate__c=date.newInstance(2013,4,2);
		list_orUpDetails.add(orderDetailnewSeven);		
		orderDetailnewEight.BorrowerReceiptDate__c=date.newInstance(2013,5,2);
		list_orUpDetails.add(orderDetailnewEight);	
		orderDetailnewNine.BorrowerReceiptDate__c=date.newInstance(2013,5,2);
		list_orUpDetails.add(orderDetailnewNine);
		system.Test.startTest();   
		update list_orUpDetails;
   		system.Test.stopTest();    

    }
}