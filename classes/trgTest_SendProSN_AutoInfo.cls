/**
*Test:trgTest_Order_Payer
*Author:Vito_He
*Time:2013年5月16日 09:08:21
**/
@isTest(SeeAllData=true)
private class trgTest_SendProSN_AutoInfo {

    static testMethod void myUnitTest() {
		
		Pricebook2 pricebook = [select Id from Pricebook2 where isStandard=true limit 1];
		list<RecordType> listrtpQuDao=[Select r.Name, r.Id, r.Description From RecordType r where DeveloperName='ChannelCustomers']; 
		list<RecordType> listrtpSales= [Select r.Name, r.Id, r.Description From RecordType r where DeveloperName='ChannelPrototypeOrders' and SobjectType='Orders__c'];
		list<RecordType> listSale= [Select r.Name, r.Id, r.Description From RecordType r where DeveloperName='YahuoOrders' and SobjectType='Orders__c'];
		list<SendProSN__c> prosList = new list<SendProSN__c>();
		
		Profile profile=[Select p.Name, p.Id From Profile p where Name='Chatter External User'];
    	User user=new User();											 
	    user.Phone='87413065';   
	    user.MobilePhone='15167988026';
	    user.Username='LurryKong@ggfccz.com';
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
		
		Quote quote=new Quote();				//报价
        quote.OpportunityId=opp.Id;
        quote.Pricebook2Id=pricebook.Id;
        quote.Name='2013网康服务器报价';
        quote.Status='已批准';
        quote.yanhoukaipiaoliyouField3__c='延后开票';
        insert quote;
		
		Orders__c orders=new Orders__c();
        orders.Name='testorders';
        orders.SalesOpportunities__c=opp.id;
        orders.Quote__c=quote.id;  
        orders.RecordTypeId=listrtpSales[0].id;
        orders.customer__c = acc.Id;
        orders.Partners__c = acc.Id; 
        orders.ApprovalStatus__c = '已审批'; 
   		insert orders;
   		
   		
   		
   		Orders__c orders3=new Orders__c();
        orders3.Name='rrr';
        orders3.SalesOpportunities__c=opp.id;
        orders3.Quote__c=quote.id;  
        orders3.RecordTypeId=listSale[0].id; 
        orders3.customer__c = acc.Id;
        orders3.Partners__c = acc.Id; 
        orders3.ApprovalStatus__c = '已审批'; 
   		insert orders3;
   		
 
   		
   		Shipments__c shipment=new Shipments__c();					//发货
    	shipment.n_orders__c=orders.id;
    	shipment.n_Deliverables__c=acc.id;
    	insert shipment;
    	
    	
   		
   		ShippingDetails__c shipdetail=new ShippingDetails__c();		//发货明细
    	shipdetail.n_Shipmentname__c=shipment.id;
    	insert shipdetail;
    	
    	ProductSN__c psnYahuo=new ProductSN__c();
    	psnYahuo.Name='lurrykong压货订单序列号';
		insert psnYahuo;
    	
    	
    	
    	SendProSN__c spro = new SendProSN__c();
		spro.S_Order__c = orders.id;
		spro.S_ShippingDetails__c = shipdetail.id; 
		spro.S_Client__c = acc.id;
		spro.S_SN__c = psnYahuo.id;
		prosList.add(spro);
		
		
		
    	
    	Orders__c orders2=new Orders__c();
        orders2.Name='ee';
        orders2.SalesOpportunities__c=opp.id; 
        orders2.Quote__c=quote.id;  
        orders2.RecordTypeId=listSale[0].id;
        orders2.customer__c = acc.Id;
        orders2.ApprovalStatus__c = '已审批';
        orders2.Partners__c = acc.Id;  
   		insert orders2;
   		
   		Shipments__c shipment2=new Shipments__c();					    //发货
    	shipment2.n_orders__c=orders2.id;
    	shipment2.n_Deliverables__c=acc.id;
    	insert shipment2; 
    	
    	Shipments__c shipment3=new Shipments__c();					    //发货
    	shipment3.n_orders__c=orders3.id;
    	shipment3.n_Deliverables__c=acc.id;
    	insert shipment3;  
    	
    	ShippingDetails__c shipdetail3=new ShippingDetails__c();		//发货明细
    	shipdetail3.n_Shipmentname__c=shipment3.id;
    	insert shipdetail3;
    	
    	ShippingDetails__c shipdetail2=new ShippingDetails__c();		//发货明细
    	shipdetail2.n_Shipmentname__c=shipment2.id;
    	insert shipdetail2;
    	
    	test.startTest();   
   		
		SendProSN__c spro2 = new SendProSN__c();
		spro2.S_Order__c = orders2.id;
		spro2.S_ShippingDetails__c = shipdetail2.id; 
		spro2.S_Client__c = acc.id;
		spro2.S_ProductStatus__c = '出售';
		prosList.add(spro2);
		
		SendProSN__c spro3 = new SendProSN__c();
		spro3.S_Order__c = orders3.id;
		spro3.S_ShippingDetails__c = shipdetail3.id; 
		spro3.S_Client__c = acc.id; 
		spro3.S_ProductStatus__c = '压货';
		
		prosList.add(spro3);
		
		insert prosList; 
		delete spro3;
		delete spro2; 
		delete spro;
		test.stopTest(); 
    }
}