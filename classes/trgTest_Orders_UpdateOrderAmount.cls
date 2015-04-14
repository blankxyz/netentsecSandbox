//Orders_UpdateOrderAmount触发器的测试类
//Accounting_DiscountSplitAmount触发器的测试类
//lurrykong
//2013.07.01
@isTest(SeeAlldata=true) 
private class trgTest_Orders_UpdateOrderAmount {

    static testMethod void myUnitTest() 
    {
    	Pricebook2 pricebook = [select Id from Pricebook2 where isStandard=true limit 1];
    	Profile profile=[Select p.Name, p.Id From Profile p where Name='Chatter External User'];						
    	//所有的记录类型
    	list<RecordType> listOrdRtp=[Select r.Name, r.Id, r.Description,r.DeveloperName,r.SobjectType From RecordType r]; 
		//DeveloperName+SobjectType为键,记录类型为值    	
    	map<string,RecordType> mapRtp=new map<string,RecordType>();
    	for(RecordType rt:listOrdRtp)
    	{
    		if(rt.DeveloperName!=null&&rt.SobjectType!=null)
    			mapRtp.put(string.valueOf(rt.DeveloperName)+string.valueOf(rt.SobjectType),rt);			
    	}
    	RecordType listrtpSales=mapRtp.get('salesOrders'+'Orders__c'); 											//销售订单
    	RecordType listrtp=mapRtp.get('ChannelCustomers'+'Account');											//渠道代理商 	
    	User user=new User();											 
	    user.Phone='87413065';   
	    user.MobilePhone='15167988026';
	    user.Username='LurryKong@fccz.com20130702';
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
        acc.RecordTypeId=listrtp.id;
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
	    
	    Quote quote=new Quote();
        quote.OpportunityId=opp.Id;
        quote.Pricebook2Id=pricebook.Id;
        quote.Name='报价';
        quote.Status='已批准';
        quote.yanhoukaipiaoliyouField3__c='延后开票信息';
        insert quote;
        
        //销售订单
        Orders__c orders=new Orders__c();
        orders.Name='testorders';
        orders.SalesOpportunities__c=opp.id;
        orders.Quote__c=quote.id;  
        orders.RecordTypeId=listrtpSales.id;
        orders.customer__c = acc.Id;
        orders.Partners__c=acc.Id;
   		orders.Payer__c=acc.id;
   		insert orders;
   		
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
        ProductionLevel__c pleThree=new ProductionLevel__c();	//产品级别
        pleThree.Name='配件';
        pleThree.n_level__c='三级';
        pleThree.n_levelNO__c='B';
        listprod.add(pleThree);
        ProductionLevel__c pleFour=new ProductionLevel__c();	//产品级别
        pleFour.Name='硬件';
        pleFour.n_level__c='四级';
        pleFour.n_levelNO__c='B';
        listprod.add(pleFour);
        insert listprod;
        ProductModelSeries__c pms=new ProductModelSeries__c();				//产品型号系列
		pms.OldProductPrice__c=600;
		pms.NewProductPrice__c=6000;
        pms.Name='NF-3000系列';
        insert pms;
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
 
   		OrderDetails__c orderdetail=new OrderDetails__c();			
    	orderdetail.n_OrderNo__c=orders.id;							//订单
    	orderdetail.n_ProductByOrd__c=prod.id;						//产品
    	orderdetail.n_ProCount__c=1;					 			//数量
    	orderdetail.n_PriceByord__c=500;							//成交价
		orderdetail.n_Price__c=1000;			
		orderdetail.OrddetailDiscount__c=50;
		test.startTest();
		insert orderdetail;
		list<Accounting__c> listInserAccting=new list<Accounting__c>();	//业绩核算
		Accounting__c accting=new Accounting__c();					
		accting.n_Order__c=orders.id;
		accting.n_Recipients__c=user.id;							
		accting.SplitRatio__c=30;							
		accting.n_FSplitAmount__c=200;							
		listInserAccting.add(accting);
		Accounting__c acctingTwo=new Accounting__c();					
		acctingTwo.n_Order__c=orders.id;
		acctingTwo.n_Recipients__c=user.id;														
		acctingTwo.n_FSplitAmount__c=300;
		listInserAccting.add(acctingTwo);
		Accounting__c acctingThree=new Accounting__c();					
		acctingThree.n_Order__c=orders.id;
		acctingThree.n_Recipients__c=user.id;							
		acctingThree.SplitRatio__c=20;									
		listInserAccting.add(acctingThree);
		insert listInserAccting;
		list<Accounting__c> listUpdateAccting=new list<Accounting__c>();	//业绩核算							
    	accting.SplitRatio__c=25;							
		accting.n_FSplitAmount__c=100;		
    	listUpdateAccting.add(accting);
    	acctingTwo.SplitRatio__c=null;							
		acctingTwo.n_FSplitAmount__c=500;		
    	listUpdateAccting.add(acctingTwo);
        acctingThree.SplitRatio__c=1;							
		acctingThree.n_FSplitAmount__c=null;		
    	listUpdateAccting.add(acctingThree);
    	update listUpdateAccting;
    	orderdetail.n_ProCount__c=2;
    	update orderdetail;
    	test.stopTest();    	
    }
}