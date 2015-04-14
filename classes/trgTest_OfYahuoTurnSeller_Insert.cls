//OfYahuoTurnSeller_Insert的测试类
//lurrykong
//2013.4.16 
@isTest(SeeAllData=true)
private class trgTest_OfYahuoTurnSeller_Insert {

    static testMethod void myUnitTest() 
    {
    	
		list<RecordType> listrtpYaHuo= [Select r.Name, r.Id, r.Description,r.DeveloperName,r.SobjectType From RecordType r where  DeveloperName='YahuoOrders' and SobjectType='Orders__c'];
    	
    	list<RecordType> listrtpQuDao= [Select r.Name, r.Id, r.Description,r.DeveloperName,r.SobjectType From RecordType r where  DeveloperName='ChannelCustomers' and SobjectType='Account']; 
    	
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
        
         
       
    	Orders__c orderyahuo=new Orders__c();
        orderyahuo.Name='testyahuoorders';
        orderyahuo.RecordTypeId=listrtpYaHuo[0].id;		
        orderyahuo.Partners__c=acc.Id;
        orderyahuo.SalesRegion__c=salesregion.Id;
   		orderyahuo.customer__c=acc.Id;					
   		insert orderyahuo;
    	
    	ProductSN__c psnYahuo=new ProductSN__c();
    	psnYahuo.Name='lurrykong压货订单序列号';
    	psnYahuo.ProductStatus__c='压货';
		insert psnYahuo;
		
		OrderDetails__c ordetailyahuo=new OrderDetails__c();
    	ordetailyahuo.n_ProCount__c=1;					 						//数量
    	ordetailyahuo.n_PriceByord__c=400;	
    	ordetailyahuo.n_Price__c=500;								//成交价
    	ordetailyahuo.n_OrderNo__c=orderyahuo.Id;
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
		list<RecordType> listrtpYaHuo= [Select r.Name, r.Id, r.Description,r.DeveloperName,r.SobjectType From RecordType r where  DeveloperName='salesOrders' and SobjectType='Orders__c'];
    	
    	list<RecordType> listrtpQuDao= [Select r.Name, r.Id, r.Description,r.DeveloperName,r.SobjectType From RecordType r where  DeveloperName='ChannelCustomers' and SobjectType='Account']; 

    	List<Orders__c> listOrder=new List<Orders__c>();
    	List<OrderDetails__c> listOrderDetails=new List<OrderDetails__c>();
    	List<Shipments__c> listShip=new List<Shipments__c>();
    	List<ShippingDetails__c> listShippingDetails=new List<ShippingDetails__c>();
    	List<ProductSN__c> listProductSN=new List<ProductSN__c>();
    	
    	List<OfYahuoTurnSeller__c> listOfYahuoTurnSeller=new List<OfYahuoTurnSeller__c>();
    	List<SendProSN__c> listSendProSN=new List<SendProSN__c>();
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
   		listOrder.add(orderyahuo);
   				
   		insert listOrder;
    	
    	ProductSN__c psnYahuo=new ProductSN__c();
    	psnYahuo.Name='lurrykong压货订单序列号';
    	psnYahuo.ProductStatus__c='出售';
    	listProductSN.add(psnYahuo);
    	
		insert listProductSN;
		
		OrderDetails__c ordetailyahuo=new OrderDetails__c();
    	ordetailyahuo.n_ProCount__c=1;					 						//数量
    	ordetailyahuo.n_PriceByord__c=400;	
    	ordetailyahuo.n_Price__c=500;								//成交价
    	ordetailyahuo.n_OrderNo__c=orderyahuo.Id;
    	listOrderDetails.add(ordetailyahuo);
    	
    	insert listOrderDetails;
    	    	
    	Shipments__c ship=new Shipments__c();
    	ship.n_orders__c=orderyahuo.id;
    	ship.n_Deliverables__c=acc.id;
    	listShip.add(ship);
    
    	insert listShip;
    	
    	ShippingDetails__c ShippingDetails=new ShippingDetails__c();
    	ShippingDetails.n_Shipmentname__c=ship.id;
    	ShippingDetails.ordersSum__c=2;
    	listShippingDetails.add(ShippingDetails);
    	
    	insert listShippingDetails;
    	
    	SendProSN__c SendProSN=new SendProSN__c();
    	
    	SendProSN.S_ShippingDetails__c=ShippingDetails.id;
    	SendProSN.S_SN__c=psnYahuo.id;
    	SendProSN.S_Order__c=orderyahuo.id;
    	listSendProSN.add(SendProSN);
    	SendProSN__c SendProSN1=new SendProSN__c();
    	
    	
    	insert listSendProSN;
    	system.Test.startTest();
    	
    	OfYahuoTurnSeller__c ofyahuoturn=new OfYahuoTurnSeller__c();				//订单明细sn
    	ofyahuoturn.orders__c=ordetailyahuo.id;
    	ofyahuoturn.ProductCategory__c='产品';
    	ofyahuoturn.ProductStatus__c='压货';
    	ofyahuoturn.n_SN__c=psnYahuo.id;
    	listOfYahuoTurnSeller.add(ofyahuoturn);
    
		insert listOfYahuoTurnSeller;
        system.Test.stopTest();
       
    }
    
    static testMethod void myUnitTest2() 
    {
    	list<RecordType> listrtpYaHuo= [Select r.Name, r.Id, r.Description,r.DeveloperName,r.SobjectType From RecordType r where  DeveloperName='InternalPrototypeOrders' and SobjectType='Orders__c'];
    	list<RecordType> listrtpQuDao= [Select r.Name, r.Id, r.Description,r.DeveloperName,r.SobjectType From RecordType r where  DeveloperName='ChannelCustomers' and SobjectType='Account']; 
    	List<Orders__c> listOrder=new List<Orders__c>();
    	List<OrderDetails__c> listOrderDetails=new List<OrderDetails__c>();
    	List<Shipments__c> listShip=new List<Shipments__c>();
    	List<ShippingDetails__c> listShippingDetails=new List<ShippingDetails__c>();
    	List<ProductSN__c> listProductSN=new List<ProductSN__c>();
    	
    	List<OfYahuoTurnSeller__c> listOfYahuoTurnSeller=new List<OfYahuoTurnSeller__c>();
    	List<SendProSN__c> listSendProSN=new List<SendProSN__c>();
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
   		listOrder.add(orderyahuo);
   				
   		insert listOrder;
    	
    	ProductSN__c psnYahuo=new ProductSN__c();
    	psnYahuo.Name='lurrykong压货订单序列号';
    	//psnYahuo.ProductStatus__c='出售';
    	psnYahuo.ProductCategory__c='样机';
    	psnYahuo.ProductStatus__c='测试机';
    	psnYahuo.demoStatus__c='新样机';
    	psnYahuo.PrototypeStatus__c='空闲';
    	listProductSN.add(psnYahuo);
    	
		insert listProductSN;
		
		OrderDetails__c ordetailyahuo=new OrderDetails__c();
    	ordetailyahuo.n_ProCount__c=1;					 						//数量
    	ordetailyahuo.n_PriceByord__c=400;	
    	ordetailyahuo.n_Price__c=500;								//成交价
    	ordetailyahuo.n_OrderNo__c=orderyahuo.Id;
    	listOrderDetails.add(ordetailyahuo);
    	
    	insert listOrderDetails;
    	    	
    	Shipments__c ship=new Shipments__c();
    	ship.n_orders__c=orderyahuo.id;
    	ship.n_Deliverables__c=acc.id;
    	listShip.add(ship);
    
    	insert listShip;
    	
    	ShippingDetails__c ShippingDetails=new ShippingDetails__c();
    	ShippingDetails.n_Shipmentname__c=ship.id;
    	ShippingDetails.ordersSum__c=2;
    	listShippingDetails.add(ShippingDetails);
    	
    	insert listShippingDetails;
    	
    	SendProSN__c SendProSN=new SendProSN__c();
    	
    	SendProSN.S_ShippingDetails__c=ShippingDetails.id;
    	SendProSN.S_SN__c=psnYahuo.id;
    	SendProSN.S_Order__c=orderyahuo.id;
    	listSendProSN.add(SendProSN);
    	SendProSN__c SendProSN1=new SendProSN__c();
    	
    	
    	insert listSendProSN;
    	system.Test.startTest();
    	
    	OfYahuoTurnSeller__c ofyahuoturn=new OfYahuoTurnSeller__c();				//订单明细sn
    	ofyahuoturn.orders__c=ordetailyahuo.id;
    	ofyahuoturn.ProductCategory__c='产品';
    	ofyahuoturn.ProductStatus__c='压货';
    	ofyahuoturn.n_SN__c=psnYahuo.id;
    	listOfYahuoTurnSeller.add(ofyahuoturn);
    
		insert listOfYahuoTurnSeller;
        system.Test.stopTest();
       
    }
    
    static testMethod void myUnitTest3() 
    {
    	list<RecordType> listrtpYaHuo= [Select r.Name, r.Id, r.Description,r.DeveloperName,r.SobjectType From RecordType r where  DeveloperName='RecordTypeByExchange' and SobjectType='Orders__c'];
    	list<RecordType> listrtpQuDao= [Select r.Name, r.Id, r.Description,r.DeveloperName,r.SobjectType From RecordType r where  DeveloperName='ChannelCustomers' and SobjectType='Account']; 
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
        
          
       
    	Orders__c orderyahuo=new Orders__c();
        orderyahuo.Name='testyahuoorders';
        orderyahuo.RecordTypeId=listrtpYaHuo[0].id;		
        orderyahuo.Partners__c=acc.Id;
        orderyahuo.SalesRegion__c=salesregion.Id;
   		orderyahuo.customer__c=acc.Id;					
   		insert orderyahuo;
    	
    	ProductSN__c psnYahuo=new ProductSN__c();
    	psnYahuo.Name='lurrykong压货订单序列号';
    	//psnYahuo.ProductStatus__c='压货';
    	psnYahuo.ProductCategory__c='产品';
    	psnYahuo.ProductStatus__c='出售';
		insert psnYahuo;
		
		OrderDetails__c ordetailyahuo=new OrderDetails__c();
    	ordetailyahuo.n_ProCount__c=1;					 						//数量
    	ordetailyahuo.n_PriceByord__c=400;	
    	ordetailyahuo.n_Price__c=500;								//成交价
    	ordetailyahuo.n_OrderNo__c=orderyahuo.Id;
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
    
    static testMethod void myUnitTest4() 
    {
    	list<RecordType> listrtpYaHuo= [Select r.Name, r.Id, r.Description,r.DeveloperName,r.SobjectType From RecordType r where  DeveloperName='YahuoOrdersSales' and SobjectType='Orders__c'];
    	list<RecordType> listrtpQuDao= [Select r.Name, r.Id, r.Description,r.DeveloperName,r.SobjectType From RecordType r where  DeveloperName='ChannelCustomers' and SobjectType='Account'];  
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
        
         
       
    	Orders__c orderyahuo=new Orders__c();
        orderyahuo.Name='testyahuoorders';
        orderyahuo.RecordTypeId=listrtpYaHuo[0].id;		
        orderyahuo.Partners__c=acc.Id;
        orderyahuo.SalesRegion__c=salesregion.Id;
   		orderyahuo.customer__c=acc.Id;					
   		insert orderyahuo;
    	
    	ProductSN__c psnYahuo=new ProductSN__c();
    	psnYahuo.Name='lurrykong压货订单序列号';
    	psnYahuo.ProductStatus__c='压货';
    	psnYahuo.ProductCategory__c='产品';
    	//psnYahuo.ProductStatus__c='出售';
		insert psnYahuo;
		
		OrderDetails__c ordetailyahuo=new OrderDetails__c();
    	ordetailyahuo.n_ProCount__c=1;					 						//数量
    	ordetailyahuo.n_PriceByord__c=400;	
    	ordetailyahuo.n_Price__c=500;								//成交价
    	ordetailyahuo.n_OrderNo__c=orderyahuo.Id;
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
   
   
}