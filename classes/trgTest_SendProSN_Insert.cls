//SendProSN_Insert 测试类
//lurrykong
//2013.4.17
@isTest(SeeAllData=true)
private class trgTest_SendProSN_Insert {
    static testMethod void myUnitTest() 
    { 
    	Pricebook2 pricebook = [select Id from Pricebook2 where isStandard=true limit 1];   
	 	list<RecordType> listrtpSales= [Select r.Name, r.Id, r.Description,r.DeveloperName From RecordType r where DeveloperName='salesOrders'];
 		 
    	list<RecordType> listrtpHuanHuo= [Select r.Name, r.Id, r.Description,r.DeveloperName From RecordType r where DeveloperName='RecordTypeByExchange']; 
    	list<RecordType> listrtpQuDao= [Select r.Name, r.Id, r.Description,r.DeveloperName From RecordType r where DeveloperName='ChannelCustomers']; 
    	
        list<RecordType> listrtpYaHuo= [Select r.Name, r.Id, r.Description,r.DeveloperName From RecordType r where DeveloperName='YahuoOrders'];
        
    	Profile profile=[Select p.Name, p.Id From Profile p where Name='Chatter External User'];
    	User user=new User();											 
	    user.Phone='87413065';   
	    user.MobilePhone='15167988026';
	    user.Username='LurryKong@fccwsz.com';
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
        orders.RecordTypeId=listrtpSales[0].id;
        orders.customer__c = acc.Id;
        orders.SalesRegion__c=salesregion.Id;
   		listOrder.add(orders);
   		Orders__c orderhuanhuo=new Orders__c();
        orderhuanhuo.Name='testhuanhuoorders';
        orderhuanhuo.RecordTypeId=listrtpHuanHuo[0].id;		//换货订单
        orderhuanhuo.Replacement1__c = acc.Id;				//换货方
        orderhuanhuo.ReplacementReason__c='质量换货';
        orderhuanhuo.SalesRegion__c=salesregion.Id;
   		listOrder.add(orderhuanhuo);
   		
   		Orders__c orderyahuo=new Orders__c();
        orderyahuo.Name='testhuanhuoorders';
        orderyahuo.RecordTypeId=listrtpYaHuo[0].id;		
        orderyahuo.Partners__c=acc.Id;
        orderyahuo.SalesRegion__c=salesregion.Id;
   		orderyahuo.customer__c=acc.Id;					
   		listOrder.add(orderyahuo);
   		insert listOrder;
   		 
   		list<OrderDetails__c> listOrderdetail=new list<OrderDetails__c>();
    	OrderDetails__c ordetail=new OrderDetails__c();
    	ordetail.n_OrderNo__c=orders.id;
    	ordetail.n_ProductByOrd__c=prod.id;
    	ordetail.n_ProCount__c=1;
    	insert ordetail;
    	system.Test.startTest();
    	
    	list<Shipments__c> listshipment=new list<Shipments__c>();		
    		
    	Shipments__c shipment=new Shipments__c();							//发货
    	shipment.n_orders__c=orders.id;
    	shipment.n_Deliverables__c=acc.id;
    	listshipment.add(shipment);    	
		Shipments__c shipmentHuanhuo=new Shipments__c();					//发货
    	shipmentHuanhuo.n_orders__c=orderhuanhuo.id;
    	shipmentHuanhuo.n_Deliverables__c=acc.id;
    	listshipment.add(shipmentHuanhuo);    	
		Shipments__c shipmentYahuo=new Shipments__c();						//发货
    	shipmentYahuo.n_orders__c=orderyahuo.id;
    	shipmentYahuo.n_Deliverables__c=acc.id;
    	listshipment.add(shipmentYahuo);    	
		insert listshipment;

		list<ShippingDetails__c> listShippingDetail=new list<ShippingDetails__c>();
		
    	ShippingDetails__c shipdetail=new ShippingDetails__c();				//发货明细
    	shipdetail.n_Shipmentname__c=shipment.id;
    	listShippingDetail.add(shipdetail);
    	ShippingDetails__c shipdetailhuanhuo=new ShippingDetails__c();		//发货明细
    	shipdetailhuanhuo.n_Shipmentname__c=shipmentHuanhuo.id;
    	listShippingDetail.add(shipdetailhuanhuo);
    	ShippingDetails__c shipdetailyahuo=new ShippingDetails__c();				//发货明细
    	shipdetailyahuo.n_Shipmentname__c=shipmentYahuo.id;
    	listShippingDetail.add(shipdetailyahuo);
    	insert listShippingDetail;
    	
    	list<ProductSN__c> listpsn=new list<ProductSN__c>();    	
    	date mydate =Date.today();
    	ProductSN__c psn=new ProductSN__c();
    	psn.Name='lurrykong销售订单序列号';
    	psn.Licensestar__c=mydate;
    	psn.Licenseend__c=mydate;
    	psn.EmpLicense__c=mydate;
    	psn.EmpLicenseEndDate__c=mydate;
    	psn.ProductStatus__c='出售';
    	listpsn.add(psn);    	    	
    	ProductSN__c psnTwo=new ProductSN__c();
    	psnTwo.Name='lurrykong换货订单序列号';
    	psnTwo.Licensestar__c=mydate;
    	psnTwo.Licenseend__c=mydate;
    	psnTwo.EmpLicense__c=mydate;
    	psnTwo.EmpLicenseEndDate__c=mydate;
    	psnTwo.ProductStatus__c='出售';
    	listpsn.add(psnTwo);
    	ProductSN__c psnThree=new ProductSN__c();
    	psnThree.Name='lurrykong压货订单序列号';
    	psnThree.Licensestar__c=mydate;
    	psnThree.Licenseend__c=mydate;
    	psnThree.EmpLicense__c=mydate;
    	psnThree.EmpLicenseEndDate__c=mydate;
    	psnThree.ProductStatus__c='压货';
    	listpsn.add(psnThree);
    	insert listpsn;
    	 
    	//发货明细SN
    	list<SendProSN__c> listsendprosn=new list<SendProSN__c>();
        SendProSN__c sendprosn=new SendProSN__c();
        sendprosn.S_SN__c=psn.id;
        sendprosn.S_ProductCategory__c='产品';
    	sendprosn.S_ProductStatus__c='出售';
    	sendprosn.S_ShippingDetails__c=shipdetail.id;
    	listsendprosn.add(sendprosn);
    	SendProSN__c sendprosnhuan=new SendProSN__c();
        sendprosnhuan.S_SN__c=psnTwo.id;
        sendprosnhuan.S_ProductCategory__c='产品';
    	sendprosnhuan.S_ProductStatus__c='出售';
    	sendprosnhuan.S_ShippingDetails__c=shipdetailhuanhuo.id;
    	listsendprosn.add(sendprosnhuan);
    	SendProSN__c sendprosnya=new SendProSN__c();
        sendprosnya.S_SN__c=psnThree.id;
        sendprosnya.S_ProductCategory__c='产品';
    	sendprosnya.S_ProductStatus__c='压货';
    	sendprosnya.S_ShippingDetails__c=shipdetailyahuo.id;
    	listsendprosn.add(sendprosnya);
    	insert listsendprosn;
    	
    	
    	system.Test.stopTest();
    }
}