@isTest(SeeAllData=true)
private class trgTest_OfYahuoTurnSeller_AmountSum 
{
	static testMethod void myUnitTest() 
    {
    	
    	list<RecordType> listrtpYaHuo= [Select r.Name, r.Id, r.Description From RecordType r where Name='压货订单'];
    	list<RecordType> listrtpQuDao=[Select r.Name, r.Id, r.Description From RecordType r where Name='渠道代理商']; 
    	
    	Profile profile=[Select p.Name, p.Id From Profile p where Name='Chatter External User'];
    	User user=new User();											 
	    user.Phone='87413065';   
	    user.MobilePhone='15167988026';
	    user.Username='LurryKong@fccz.com14';
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
        
        
       
    	Orders__c orderyahuo=new Orders__c();
        orderyahuo.Name='testyahuoorders';
        orderyahuo.RecordTypeId=listrtpYaHuo[0].id;		
        orderyahuo.Partners__c=acc.Id;
        orderyahuo.SalesRegion__c=salesregion.Id;
   		orderyahuo.customer__c=acc.Id;					
   		insert orderyahuo;
    	ProductModelSeries__c pms=new ProductModelSeries__c();	//产品型号系列
        pms.Name='NF-3000系列';
        pms.NewProductPrice__c=100;
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
        prod.n_FourLevel__c=pleFour.id;	
        prod.Family='ICG';
        insert prod;
    	ProductSN__c psnYahuo=new ProductSN__c();
    	psnYahuo.Name='lurrykong压货订单序列号';
    	psnYahuo.ProductStatus__c='压货';
		insert psnYahuo;
		
		OrderDetails__c ordetailyahuo=new OrderDetails__c();
    	ordetailyahuo.n_ProCount__c=1;					 						//数量
    	ordetailyahuo.n_PriceByord__c=400;	
    	ordetailyahuo.n_Price__c=500;								//成交价
    	ordetailyahuo.n_OrderNo__c=orderyahuo.Id;
    	ordetailyahuo.n_ProductByOrd__c=prod.id;
    	insert ordetailyahuo;
    	
    	Shipments__c ship=new Shipments__c();
    	ship.n_orders__c=orderyahuo.id;
    	ship.n_Deliverables__c=acc.id;
    	insert ship;
    	
    	ShippingDetails__c ShippingDetails=new ShippingDetails__c();
    	ShippingDetails.n_Shipmentname__c=ship.id;
    	ShippingDetails.ordersSum__c=2;
    	insert ShippingDetails;
    	
    	SendProSN__c SendProSN=new SendProSN__c();
    	
    	SendProSN.S_ShippingDetails__c=ShippingDetails.id;
    	SendProSN.S_SN__c=psnYahuo.id;
    	SendProSN.S_Order__c=orderyahuo.id;
    	insert SendProSN;
    	system.Test.startTest();
    	
    	OfYahuoTurnSeller__c ofyahuoturn=new OfYahuoTurnSeller__c();				//订单明细sn
    	ofyahuoturn.orders__c=ordetailyahuo.id;
    	ofyahuoturn.ProductCategory__c='产品';
    	ofyahuoturn.ProductStatus__c='压货';
    	ofyahuoturn.n_SN__c=psnYahuo.id;
		insert ofyahuoturn;
        system.Test.stopTest();
       
    
    }
    
    static testMethod void myUnitTest1() 
    {
    	
    	list<RecordType> listrtpYaHuo= [Select r.Name, r.Id, r.Description From RecordType r where Name='内部样机订单'];
    	list<RecordType> listrtpQuDao=[Select r.Name, r.Id, r.Description From RecordType r where Name='渠道代理商']; 
    	
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
        acc.RecordTypeId=listrtpQuDao[0].id;
        acc.PrimaryIndustry__c='金融';
		acc.TwoIndustries__c='债券';
		acc.ThreeIndustries__c='银行';
		acc.SellArea__c=SalesRegion.id;
		acc.Province__c='北京';
        insert acc;
        
          
		
		Opportunity opp = new Opportunity();
		opp.Name='业务机会test';
		opp.StageName='初步';
		opp.CloseDate=Date.today();
		opp.AccountId=acc.Id;
		opp.SalesRegion__c=salesregion.Id;
		opp.Status__c='状态test';
		opp.NeedSE__c=true;
		opp.TsEmail__c=null;
		insert opp; 
       
    	Orders__c orderyahuo=new Orders__c();
        orderyahuo.Name='testyahuoorders';
        orderyahuo.RecordTypeId=listrtpYaHuo[0].id;		
        orderyahuo.Partners__c=acc.Id;
        orderyahuo.SalesRegion__c=salesregion.Id;
   		orderyahuo.customer__c=acc.Id;	
   		orderyahuo.SalesOpportunities__c=opp.Id;
   		insert orderyahuo;
    	ProductModelSeries__c pms=new ProductModelSeries__c();	//产品型号系列
        pms.Name='NF-3000系列';
        pms.NewProductPrice__c=100;
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
        prod.n_FourLevel__c=pleFour.id;	
        prod.Family='ICG';
        insert prod;
        
    	ProductSN__c psnYahuo=new ProductSN__c();
    	psnYahuo.Name='lurrykong压货订单序列号';
    	//psnYahuo.ProductStatus__c='出售';
    	psnYahuo.ProductCategory__c='样机';
    	psnYahuo.ProductStatus__c='测试机';
    	psnYahuo.demoStatus__c='新样机';
    	psnYahuo.PrototypeStatus__c='空闲';
		insert psnYahuo;
		
		OrderDetails__c ordetailyahuo=new OrderDetails__c();
    	ordetailyahuo.n_ProCount__c=1;					 						//数量
    	ordetailyahuo.n_PriceByord__c=400;	
    	ordetailyahuo.n_Price__c=500;								//成交价
    	ordetailyahuo.n_OrderNo__c=orderyahuo.Id;
    	ordetailyahuo.TestStatus__c='测试中';
    	ordetailyahuo.Demoend__c=Date.today().addDays(1);
    	ordetailyahuo.Demostar__c=Date.today();
    	ordetailyahuo.BorrowerReceiptDate__c=Date.today();
    	ordetailyahuo.KuguanContractDate__c=Date.today().addDays(40);
    	ordetailyahuo.n_ProductByOrd__c=prod.Id;
    	ordetailyahuo.Field1__c=20;
    	ordetailyahuo.IfNewProduct__c=true;
    	insert ordetailyahuo;
    	
    	system.debug('ordetailyahuo.Demoend__c is:'+ordetailyahuo);
    	
    	Shipments__c ship=new Shipments__c();
    	ship.n_orders__c=orderyahuo.id;
    	ship.n_Deliverables__c=acc.id;
    	insert ship;
    	
    	ShippingDetails__c ShippingDetails=new ShippingDetails__c();
    	ShippingDetails.n_Shipmentname__c=ship.id;
    	ShippingDetails.ordersSum__c=2;
    	insert ShippingDetails;
    	
    	SendProSN__c SendProSN=new SendProSN__c();
    	
    	SendProSN.S_ShippingDetails__c=ShippingDetails.id;
    	SendProSN.S_SN__c=psnYahuo.id;
    	SendProSN.S_Order__c=orderyahuo.id;
    	insert SendProSN;
    	system.Test.startTest();
    	
    	OfYahuoTurnSeller__c ofyahuoturn=new OfYahuoTurnSeller__c();				//订单明细sn
    	ofyahuoturn.orders__c=ordetailyahuo.id;
    	ofyahuoturn.ProductCategory__c='产品';
    	ofyahuoturn.ProductStatus__c='压货';
    	ofyahuoturn.n_SN__c=psnYahuo.id;
		insert ofyahuoturn;
		
        system.Test.stopTest();
       
    
    }
    
    static testMethod void myUnitTest2() 
    {
    	
    	list<RecordType> listrtpYaHuo= [Select r.Name, r.Id, r.Description From RecordType r where Name='内部样机订单'];
    	list<RecordType> listrtpQuDao=[Select r.Name, r.Id, r.Description From RecordType r where Name='渠道代理商']; 
    	
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
        acc.RecordTypeId=listrtpQuDao[0].id;
        acc.PrimaryIndustry__c='金融';
		acc.TwoIndustries__c='债券';
		acc.ThreeIndustries__c='银行';
		acc.SellArea__c=SalesRegion.id;
		acc.Province__c='北京';
        insert acc;
        
        
		
		Opportunity opp = new Opportunity();
		opp.Name='业务机会test';
		opp.StageName='初步';
		opp.CloseDate=Date.today();
		opp.AccountId=acc.Id;
		opp.SalesRegion__c=salesregion.Id;
		opp.Status__c='状态test';
		opp.NeedSE__c=true;
		opp.TsEmail__c=null;
		insert opp; 
       
    	Orders__c orderyahuo=new Orders__c();
        orderyahuo.Name='testyahuoorders';
        orderyahuo.RecordTypeId=listrtpYaHuo[0].id;		
        orderyahuo.Partners__c=acc.Id;
        orderyahuo.SalesRegion__c=salesregion.Id;
   		orderyahuo.customer__c=acc.Id;	
   		orderyahuo.SalesOpportunities__c=opp.Id;
   		insert orderyahuo;
    	ProductModelSeries__c pms=new ProductModelSeries__c();	//产品型号系列
        pms.Name='NF-3000系列';
        pms.OldProductPrice__c=100;
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
        prod.n_FourLevel__c=pleFour.id;	
        prod.Family='ICG';
        insert prod;
        
    	ProductSN__c psnYahuo=new ProductSN__c();
    	psnYahuo.Name='lurrykong压货订单序列号';
    	//psnYahuo.ProductStatus__c='出售';
    	psnYahuo.ProductCategory__c='样机';
    	psnYahuo.ProductStatus__c='测试机';
    	psnYahuo.demoStatus__c='旧样机';
    	psnYahuo.PrototypeStatus__c='空闲';
		insert psnYahuo;
		
		OrderDetails__c ordetailyahuo=new OrderDetails__c();
    	ordetailyahuo.n_ProCount__c=1;					 						//数量
    	ordetailyahuo.n_PriceByord__c=400;	
    	ordetailyahuo.n_Price__c=500;								//成交价
    	ordetailyahuo.n_OrderNo__c=orderyahuo.Id;
    	ordetailyahuo.TestStatus__c='测试中';
    	ordetailyahuo.Demoend__c=Date.today().addDays(1);
    	ordetailyahuo.Demostar__c=Date.today();
    	ordetailyahuo.BorrowerReceiptDate__c=Date.today();
    	ordetailyahuo.KuguanContractDate__c=Date.today().addDays(40);
    	ordetailyahuo.n_ProductByOrd__c=prod.Id;
    	ordetailyahuo.Field1__c=20;
    	ordetailyahuo.IfNewProduct__c=false;
    	insert ordetailyahuo;
    	
    	system.debug('ordetailyahuo.Demoend__c is:'+ordetailyahuo);
    	
    	Shipments__c ship=new Shipments__c();
    	ship.n_orders__c=orderyahuo.id;
    	ship.n_Deliverables__c=acc.id;
    	insert ship;
    	
    	ShippingDetails__c ShippingDetails=new ShippingDetails__c();
    	ShippingDetails.n_Shipmentname__c=ship.id;
    	ShippingDetails.ordersSum__c=2;
    	insert ShippingDetails;
    	
    	SendProSN__c SendProSN=new SendProSN__c();
    	
    	SendProSN.S_ShippingDetails__c=ShippingDetails.id;
    	SendProSN.S_SN__c=psnYahuo.id;
    	SendProSN.S_Order__c=orderyahuo.id;
    	insert SendProSN;
    	system.Test.startTest();
    	
    	OfYahuoTurnSeller__c ofyahuoturn=new OfYahuoTurnSeller__c();				//订单明细sn
    	ofyahuoturn.orders__c=ordetailyahuo.id;
    	ofyahuoturn.ProductCategory__c='产品';
    	ofyahuoturn.ProductStatus__c='压货';
    	ofyahuoturn.n_SN__c=psnYahuo.id;
		insert ofyahuoturn;
		
        system.Test.stopTest();
       
    
    }
    
    static testMethod void myUnitTest3() 
    {
    	
    	list<RecordType> listrtpYaHuo= [Select r.Name, r.Id, r.Description From RecordType r where Name='内部样机订单'];
    	list<RecordType> listrtpQuDao=[Select r.Name, r.Id, r.Description From RecordType r where Name='渠道代理商']; 
    	
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
        acc.RecordTypeId=listrtpQuDao[0].id;
        acc.PrimaryIndustry__c='金融';
		acc.TwoIndustries__c='债券';
		acc.ThreeIndustries__c='银行';
		acc.SellArea__c=SalesRegion.id;
		acc.Province__c='北京';
        insert acc;
        
         
		
		Opportunity opp = new Opportunity();
		opp.Name='业务机会test';
		opp.StageName='初步';
		opp.CloseDate=Date.today();
		opp.AccountId=acc.Id;
		opp.SalesRegion__c=salesregion.Id;
		opp.Status__c='状态test';
		opp.NeedSE__c=true;
		opp.TsEmail__c=null;
		insert opp; 
       
    	Orders__c orderyahuo=new Orders__c();
        orderyahuo.Name='testyahuoorders';
        orderyahuo.RecordTypeId=listrtpYaHuo[0].id;		
        orderyahuo.Partners__c=acc.Id;
        orderyahuo.SalesRegion__c=salesregion.Id;
   		orderyahuo.customer__c=acc.Id;	
   		orderyahuo.SalesOpportunities__c=opp.Id;
   		insert orderyahuo;
    	ProductModelSeries__c pms=new ProductModelSeries__c();	//产品型号系列
        pms.Name='NF-3000系列';
        pms.NewProductPrice__c=100;
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
        prod.n_FourLevel__c=pleFour.id;	
        prod.Family='ICG';
        insert prod;
        
    	ProductSN__c psnYahuo=new ProductSN__c();
    	psnYahuo.Name='lurrykong压货订单序列号';
    	//psnYahuo.ProductStatus__c='出售';
    	psnYahuo.ProductCategory__c='样机';
    	psnYahuo.ProductStatus__c='测试机';
    	psnYahuo.demoStatus__c='新样机';
    	psnYahuo.PrototypeStatus__c='空闲';
		insert psnYahuo;
		
		OrderDetails__c ordetailyahuo=new OrderDetails__c();
    	ordetailyahuo.n_ProCount__c=1;					 						//数量
    	ordetailyahuo.n_PriceByord__c=400;	
    	ordetailyahuo.n_Price__c=500;								//成交价
    	ordetailyahuo.n_OrderNo__c=orderyahuo.Id;
    	ordetailyahuo.TestStatus__c='测试中';
    	ordetailyahuo.Demoend__c=Date.today().addDays(1);
    	ordetailyahuo.Demostar__c=Date.today();
    	ordetailyahuo.BorrowerReceiptDate__c=Date.today();
    	ordetailyahuo.KuguanContractDate__c=Date.today().addDays(10);
    	ordetailyahuo.n_ProductByOrd__c=prod.Id;
    	ordetailyahuo.Field1__c=20;
    	ordetailyahuo.IfNewProduct__c=true;
    	insert ordetailyahuo;
    	
    	system.debug('ordetailyahuo.Demoend__c is:'+ordetailyahuo);
    	
    	Shipments__c ship=new Shipments__c();
    	ship.n_orders__c=orderyahuo.id;
    	ship.n_Deliverables__c=acc.id;
    	insert ship;
    	
    	ShippingDetails__c ShippingDetails=new ShippingDetails__c();
    	ShippingDetails.n_Shipmentname__c=ship.id;
    	ShippingDetails.ordersSum__c=2;
    	insert ShippingDetails;
    	
    	SendProSN__c SendProSN=new SendProSN__c();
    	
    	SendProSN.S_ShippingDetails__c=ShippingDetails.id;
    	SendProSN.S_SN__c=psnYahuo.id;
    	SendProSN.S_Order__c=orderyahuo.id;
    	insert SendProSN;
    	system.Test.startTest();
    	
    	OfYahuoTurnSeller__c ofyahuoturn=new OfYahuoTurnSeller__c();				//订单明细sn
    	ofyahuoturn.orders__c=ordetailyahuo.id;
    	ofyahuoturn.ProductCategory__c='产品';
    	ofyahuoturn.ProductStatus__c='压货';
    	ofyahuoturn.n_SN__c=psnYahuo.id;
		insert ofyahuoturn;
		
        system.Test.stopTest();
       
    
    }
     static testMethod void myUnitTest4() 
    {
    	
    	list<RecordType> listrtpYaHuo= [Select r.Name, r.Id, r.Description From RecordType r where Name='内部样机订单'];
    	list<RecordType> listrtpQuDao=[Select r.Name, r.Id, r.Description From RecordType r where Name='渠道代理商']; 
    	
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
        acc.RecordTypeId=listrtpQuDao[0].id;
        acc.PrimaryIndustry__c='金融';
		acc.TwoIndustries__c='债券';
		acc.ThreeIndustries__c='银行';
		acc.SellArea__c=SalesRegion.id;
		acc.Province__c='北京';
        insert acc;
        
         
		
		Opportunity opp = new Opportunity();
		opp.Name='业务机会test';
		opp.StageName='初步';
		opp.CloseDate=Date.today();
		opp.AccountId=acc.Id;
		opp.SalesRegion__c=salesregion.Id;
		opp.Status__c='状态test';
		opp.NeedSE__c=true;
		opp.TsEmail__c=null;
		insert opp; 
       
    	Orders__c orderyahuo=new Orders__c();
        orderyahuo.Name='testyahuoorders';
        orderyahuo.RecordTypeId=listrtpYaHuo[0].id;		
        orderyahuo.Partners__c=acc.Id;
        orderyahuo.SalesRegion__c=salesregion.Id;
   		orderyahuo.customer__c=acc.Id;	
   		orderyahuo.SalesOpportunities__c=opp.Id;
   		insert orderyahuo;
    	ProductModelSeries__c pms=new ProductModelSeries__c();	//产品型号系列
        pms.Name='NF-3000系列';
        pms.OldProductPrice__c=100;
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
        prod.n_FourLevel__c=pleFour.id;	
        prod.Family='ICG';
        insert prod;
        
    	ProductSN__c psnYahuo=new ProductSN__c();
    	psnYahuo.Name='lurrykong压货订单序列号';
    	//psnYahuo.ProductStatus__c='出售';
    	psnYahuo.ProductCategory__c='样机';
    	psnYahuo.ProductStatus__c='测试机';
    	psnYahuo.demoStatus__c='旧样机';
    	psnYahuo.PrototypeStatus__c='空闲';
		insert psnYahuo;
		
		OrderDetails__c ordetailyahuo=new OrderDetails__c();
    	ordetailyahuo.n_ProCount__c=1;					 						//数量
    	ordetailyahuo.n_PriceByord__c=400;	
    	ordetailyahuo.n_Price__c=500;								//成交价
    	ordetailyahuo.n_OrderNo__c=orderyahuo.Id;
    	ordetailyahuo.TestStatus__c='测试中';
    	ordetailyahuo.Demoend__c=Date.today().addDays(1);
    	ordetailyahuo.Demostar__c=Date.today();
    	ordetailyahuo.BorrowerReceiptDate__c=Date.today();
    	ordetailyahuo.KuguanContractDate__c=Date.today().addDays(10);
    	ordetailyahuo.n_ProductByOrd__c=prod.Id;
    	ordetailyahuo.Field1__c=20;
    	ordetailyahuo.IfNewProduct__c=false;
    	insert ordetailyahuo;
    	
    	system.debug('ordetailyahuo.Demoend__c is:'+ordetailyahuo);
    	
    	Shipments__c ship=new Shipments__c();
    	ship.n_orders__c=orderyahuo.id;
    	ship.n_Deliverables__c=acc.id;
    	insert ship;
    	
    	ShippingDetails__c ShippingDetails=new ShippingDetails__c();
    	ShippingDetails.n_Shipmentname__c=ship.id;
    	ShippingDetails.ordersSum__c=2;
    	insert ShippingDetails;
    	
    	SendProSN__c SendProSN=new SendProSN__c();
    	
    	SendProSN.S_ShippingDetails__c=ShippingDetails.id;
    	SendProSN.S_SN__c=psnYahuo.id;
    	SendProSN.S_Order__c=orderyahuo.id;
    	insert SendProSN;
    	system.Test.startTest();
    	
    	OfYahuoTurnSeller__c ofyahuoturn=new OfYahuoTurnSeller__c();				//订单明细sn
    	ofyahuoturn.orders__c=ordetailyahuo.id;
    	ofyahuoturn.ProductCategory__c='产品';
    	ofyahuoturn.ProductStatus__c='压货';
    	ofyahuoturn.n_SN__c=psnYahuo.id;
		insert ofyahuoturn;
		
        system.Test.stopTest();
       
    
    }
   
}