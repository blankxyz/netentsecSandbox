//OrderDetails_AmountSum的测试类
//lurrykong
//2013.5.15
@isTest(SeeAllData=true)
private class trgTest_OrderDetails_AmountSum {

    static testMethod void myUnitTest() 
    {    	
    	list<RecordType> listrtp=[Select Name, Id, Description,DeveloperName,SobjectType From RecordType];
    	//developerName,记录类型为值
    	map<string,RecordType> maprtp=new map<string,RecordType>();
    	if(listrtp.size()>0)
    	{
    		for(RecordType rt:listrtp)
    		{
    			if(rt.DeveloperName!=null&&rt.SobjectType!=null)
    			{
    				string str=string.valueOf(rt.DeveloperName);
    				if(!maprtp.containsKey(str))
    				{
    					maprtp.put(str,rt);
    				}
    			}
    		}
    	}
    	RecordType listrtpQuDao=maprtp.get('ChannelCustomers'); 
    	RecordType listrtpHuanHuo=maprtp.get('RecordTypeByExchange');
    	RecordType listrtpInside=maprtp.get('InternalPrototypeOrders');
    	RecordType listrtpReturn=maprtp.get('RecordTypeByReturn');
    	
    	Profile profile=[Select p.Name, p.Id From Profile p where Name='Chatter External User'];
    	User user=new User();											 
	    user.Phone='87413065';   
	    user.MobilePhone='15167988026';
	    user.Username='LurryKong@fccz.com16';
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
		salesregion.Name='北京办事处';
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
		acc.dailishangshuxingField3__c='T1';
		acc.Province__c='北京';
        insert acc;
        
         
        
        PrototypeCosts__c pc=new PrototypeCosts__c();				//费用指标对象
        pc.Name='北京办事处样机费用指标';
        pc.n_SaleArea__c=salesregion.id;
        pc.n_Year__c='2013';
        pc.n_Month__c='01';
        pc.Quarter__c='第一季度';
        pc.n_BudgetAmount__c=5000;
        insert pc;
    	String Closetime='2005'+'-'+'10'+'-'+'5';
        Date dte=date.valueOf(Closetime);
	   	Opportunity opp=new Opportunity();    	
	    opp.OppProperties__c='商业市场';       
        opp.Name='五粮液商机';
        opp.Description='业务机会';
        opp.CloseDate=dte;  
        opp.AccountId=acc.Id;					//客户名
        opp.StageName='关单';
        opp.Probability=100;					//可行性
        opp.Partners__c=acc.Id;					//渠道代理商
        opp.SalesRegion__c = salesregion.Id;	//销售区域
	    insert opp;
        
        		
				    
		ProductModelSeries__c pms=new ProductModelSeries__c();	//产品型号系列
		pms.OldProductPrice__c=600;
		pms.NewProductPrice__c=6000;
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
        insert listprod;
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
     
        list<Orders__c> listOrd=new list<Orders__c>();       
		Orders__c orderinsideApp=new Orders__c();						//新样机订单
        orderinsideApp.Name='内部样机测试审批通过';
        orderinsideApp.RecordTypeId=listrtpInside.id;		
        orderinsideApp.SalesOpportunities__c=opp.Id; 
        orderinsideApp.SalesRegion__c=salesregion.Id;
        orderinsideApp.customer__c=acc.Id;		
   		orderinsideApp.ApprovalStatus__c='已审批';
		listOrd.add(orderinsideApp);
    	Orders__c orderinsidenew=new Orders__c();						//新样机订单
        orderinsidenew.Name='内部样机测试';
        orderinsidenew.RecordTypeId=listrtpInside.id;		
        orderinsidenew.SalesOpportunities__c=opp.Id; 
        orderinsidenew.SalesRegion__c=salesregion.Id;
        orderinsidenew.customer__c=acc.Id;		
   		orderinsidenew.ApprovalStatus__c='草稿';
   		listOrd.add(orderinsidenew);

	   	Orders__c orderinsideold=new Orders__c();						//旧样机订单
        orderinsideold.Name='内部样机测试';
        orderinsideold.RecordTypeId=listrtpInside.id;		
        orderinsideold.SalesOpportunities__c=opp.Id; 
        orderinsideold.SalesRegion__c=salesregion.Id;
        orderinsideold.customer__c=acc.Id;		
   		orderinsideold.ApprovalStatus__c='草稿';
		listOrd.add(orderinsideold);
		
	   	Orders__c orderinsideHuan=new Orders__c();						//换货订单
        orderinsideHuan.Name='换货订单测试';
        orderinsideHuan.RecordTypeId=listrtpHuanHuo.id;		
        orderinsideHuan.SalesOpportunities__c=opp.Id; 
        orderinsideHuan.SalesRegion__c=salesregion.Id;
        orderinsideHuan.Replacement1__c=acc.Id;		
		listOrd.add(orderinsideHuan);
		
		Orders__c orderinsideReturn=new Orders__c();					//退货订单
        orderinsideReturn.Name='退订单测试';
        orderinsideReturn.RecordTypeId=listrtpReturn.id;		
        orderinsideReturn.SalesOpportunities__c=opp.Id; 
        orderinsideReturn.SalesRegion__c=salesregion.Id;
        orderinsideReturn.Returnssquare__c=acc.Id;		
		listOrd.add(orderinsideReturn);
		insert listOrd;
			
		date startDate = date.newInstance(2013, 1, 1);
		date dueDate = date.newInstance(2014, 6, 24);		
		
		date startDateTwo = date.newInstance(2013, 5, 1);
		date startDateThree = date.newInstance(2013, 8, 1);																	
		date startDateFour = date.newInstance(2013, 11, 1);	
		OrderDetails__c orderdetailApp=new OrderDetails__c();
    	orderdetailApp.n_OrderNo__c=orderinsideApp.id;								//订单
    	orderdetailApp.n_ProductByOrd__c=prod.id;								//产品
    	orderdetailApp.n_ProCount__c=1;					 						//数量
    	orderdetailApp.n_PriceByord__c=400;										//成交价
    	orderdetailApp.TestStatus__c='测试中';    	
    	orderdetailApp.IfNewProduct__c=true;
    	orderdetailApp.Demostar__c=startDate;
    	orderdetailApp.Demoend__c=dueDate;
		insert orderdetailApp;
																							
		list<OrderDetails__c> listordetail=new list<OrderDetails__c>();
		
    	OrderDetails__c ordetailinsidenew=new OrderDetails__c();
    	ordetailinsidenew.n_OrderNo__c=orderinsidenew.id;								//订单
    	ordetailinsidenew.n_ProductByOrd__c=prod.id;								//产品
    	ordetailinsidenew.n_ProCount__c=1;					 						//数量
    	ordetailinsidenew.n_PriceByord__c=400;										//成交价
    	ordetailinsidenew.TestStatus__c='测试中';    	
    	ordetailinsidenew.IfNewProduct__c=true;
    	ordetailinsidenew.Demostar__c=startDate;
    	ordetailinsidenew.Demoend__c=dueDate;
    	listordetail.add(ordetailinsidenew);

    	OrderDetails__c ordetailinsidenewTwo=new OrderDetails__c();
    	ordetailinsidenewTwo.n_OrderNo__c=orderinsidenew.id;								//订单
    	ordetailinsidenewTwo.n_ProductByOrd__c=prod.id;								//产品
    	ordetailinsidenewTwo.n_ProCount__c=1;					 						//数量
    	ordetailinsidenewTwo.n_PriceByord__c=400;										//成交价
    	ordetailinsidenewTwo.TestStatus__c='测试中';    	
    	ordetailinsidenewTwo.IfNewProduct__c=true;
    	ordetailinsidenewTwo.Demostar__c=startDate;
    	ordetailinsidenewTwo.Demoend__c=dueDate;
    	listordetail.add(ordetailinsidenewTwo);

    	OrderDetails__c ordetailinsideold=new OrderDetails__c();
    	ordetailinsideold.n_OrderNo__c=orderinsideold.id;								//订单
    	ordetailinsideold.n_ProductByOrd__c=prod.id;								//产品
    	ordetailinsideold.n_ProCount__c=1;					 						//数量
    	ordetailinsideold.n_PriceByord__c=400;										//成交价
    	ordetailinsideold.TestStatus__c='测试中';    	
    	ordetailinsideold.IfNewProduct__c=false;
    	ordetailinsideold.Demostar__c=startDateTwo;
    	ordetailinsideold.Demoend__c=dueDate;
    	listordetail.add(ordetailinsideold);
    	
    	OrderDetails__c ordetailinsideoldthree=new OrderDetails__c();
    	ordetailinsideoldthree.n_OrderNo__c=orderinsideold.id;								//订单
    	ordetailinsideoldthree.n_ProductByOrd__c=prod.id;								//产品
    	ordetailinsideoldthree.n_ProCount__c=1;					 						//数量
    	ordetailinsideoldthree.n_PriceByord__c=400;										//成交价
    	ordetailinsideoldthree.TestStatus__c='测试中';    	
    	ordetailinsideoldthree.IfNewProduct__c=false;
    	ordetailinsideoldthree.Demostar__c=startDateThree;
    	ordetailinsideoldthree.Demoend__c=dueDate;
    	listordetail.add(ordetailinsideoldthree);
    	
    	OrderDetails__c ordetailinsideoldfour=new OrderDetails__c();
    	ordetailinsideoldfour.n_OrderNo__c=orderinsideold.id;								//订单
    	ordetailinsideoldfour.n_ProductByOrd__c=prod.id;								//产品
    	ordetailinsideoldfour.n_ProCount__c=1;					 						//数量
    	ordetailinsideoldfour.n_PriceByord__c=400;										//成交价
    	ordetailinsideoldfour.TestStatus__c='测试中';    	
    	ordetailinsideoldfour.IfNewProduct__c=false;
    	ordetailinsideoldfour.Demostar__c=startDateFour;
    	ordetailinsideoldfour.Demoend__c=dueDate;
    	listordetail.add(ordetailinsideoldfour);
 
    	OrderDetails__c ordetailinsideHuan=new OrderDetails__c();
    	ordetailinsideHuan.n_OrderNo__c=orderinsideHuan.id;							//换货订单订单明细	
    	ordetailinsideHuan.n_ProductByOrd__c=prod.id;								//产品
    	ordetailinsideHuan.n_ProCount__c=1;					 						//数量
    	ordetailinsideHuan.n_PriceByord__c=400;										//成交价 	
    	listordetail.add(ordetailinsideHuan);
    	
    	OrderDetails__c ordetailinsideReturn=new OrderDetails__c();
    	ordetailinsideReturn.n_OrderNo__c=orderinsideReturn.id;						//退订单订单明细	
    	ordetailinsideReturn.n_ProductByOrd__c=prod.id;								//产品
    	ordetailinsideReturn.n_ProCount__c=1;					 					//数量
    	ordetailinsideReturn.n_PriceByord__c=400;									//成交价 	
    	listordetail.add(ordetailinsideReturn);
  
		system.Test.startTest();    
    	insert listordetail;    	
    	system.Test.stopTest();    
    }
    static testMethod void myUnitTestTwo()
    {
    	list<RecordType> listrtp=[Select Name, Id, Description,DeveloperName,SobjectType From RecordType];
    	//developerName,记录类型为值
    	map<string,RecordType> maprtp=new map<string,RecordType>();
    	if(listrtp.size()>0)
    	{
    		for(RecordType rt:listrtp)
    		{
    			if(rt.DeveloperName!=null&&rt.SobjectType!=null)
    			{
    				string str=string.valueOf(rt.DeveloperName);
    				if(!maprtp.containsKey(str))
    				{
    					maprtp.put(str,rt);
    				}
    			}
    		}
    	}
    	RecordType listrtpQuDao=maprtp.get('ChannelCustomers'); 
    	RecordType listrtpHuanHuo=maprtp.get('RecordTypeByExchange');
    	RecordType listrtpInside=maprtp.get('InternalPrototypeOrders');
    	RecordType listrtpReturn=maprtp.get('RecordTypeByReturn');

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
		salesregion.Name='北京办事处';
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
		acc.dailishangshuxingField3__c='T1';
        insert acc;
        
        
				    
		ProductModelSeries__c pms=new ProductModelSeries__c();	//产品型号系列
		pms.OldProductPrice__c=600;
		pms.NewProductPrice__c=6000;
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
		
    	String Closetime='2005'+'-'+'10'+'-'+'5';
        Date dte=date.valueOf(Closetime);
	   	Opportunity opp=new Opportunity();    	
	    opp.OppProperties__c='商业市场';       
        opp.Name='五粮液商机';
        opp.Description='业务机会';
        opp.CloseDate=dte;  
        opp.AccountId=acc.Id;					//客户名
        opp.StageName='关单';
        opp.Probability=100;					//可行性
        opp.Partners__c=acc.Id;					//渠道代理商
        opp.SalesRegion__c = salesregion.Id;	//销售区域
	    insert opp;
        
        list<Orders__c> listOrd=new list<Orders__c>();       
    	Orders__c orderinsidenew=new Orders__c();						//新样机订单
        orderinsidenew.Name='内部样机测试';
        orderinsidenew.RecordTypeId=listrtpInside.id;		
        orderinsidenew.SalesOpportunities__c=opp.Id; 
        orderinsidenew.SalesRegion__c=salesregion.Id;
        orderinsidenew.customer__c=acc.Id;		
   		orderinsidenew.ApprovalStatus__c='草稿';
   		listOrd.add(orderinsidenew);

	   	Orders__c orderinsideold=new Orders__c();						//旧样机订单
        orderinsideold.Name='内部样机测试';
        orderinsideold.RecordTypeId=listrtpInside.id;		
        orderinsideold.SalesOpportunities__c=opp.Id; 
        orderinsideold.SalesRegion__c=salesregion.Id;
        orderinsideold.customer__c=acc.Id;		
   		orderinsideold.ApprovalStatus__c='草稿';
		listOrd.add(orderinsideold);
        insert listOrd;
        
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
			
		date startDate = date.newInstance(2013, 1, 1);
		date dueDate = date.newInstance(2013, 6, 24);		
		date startDateTwo = date.newInstance(2013, 5, 1);
		date startDateThree = date.newInstance(2013, 8, 1);																	
		date startDateFour = date.newInstance(2013, 11, 1);	 
    	
		list<OrderDetails__c> listordetail=new list<OrderDetails__c>();
    	OrderDetails__c ordetailinsidenew=new OrderDetails__c();
    	ordetailinsidenew.n_OrderNo__c=orderinsidenew.id;								//订单
    	ordetailinsidenew.n_ProductByOrd__c=prod.id;								//产品
    	ordetailinsidenew.n_ProCount__c=1;					 						//数量
    	ordetailinsidenew.n_PriceByord__c=400;										//成交价
    	ordetailinsidenew.TestStatus__c='测试中';    	
    	ordetailinsidenew.IfNewProduct__c=true;
    	ordetailinsidenew.Demostar__c=startDate;
    	ordetailinsidenew.Demoend__c=dueDate;
    	listordetail.add(ordetailinsidenew);    	
    	OrderDetails__c ordetailinsideold=new OrderDetails__c();
    	ordetailinsideold.n_OrderNo__c=orderinsideold.id;								//订单
    	ordetailinsideold.n_ProductByOrd__c=prod.id;								//产品
    	ordetailinsideold.n_ProCount__c=1;					 						//数量
    	ordetailinsideold.n_PriceByord__c=400;										//成交价
    	ordetailinsideold.TestStatus__c='测试中';    	
    	ordetailinsideold.IfNewProduct__c=false;
    	ordetailinsideold.Demostar__c=startDateTwo;
    	ordetailinsideold.Demoend__c=dueDate;
    	listordetail.add(ordetailinsideold);
    	insert listordetail;
    	system.Test.startTest();    
    	list<OfYahuoTurnSeller__c> listofyahuo=new list<OfYahuoTurnSeller__c>();
    	OfYahuoTurnSeller__c ofyahuo=new OfYahuoTurnSeller__c();
    	ofyahuo.orders__c=ordetailinsidenew.id;
    	listofyahuo.add(ofyahuo);
    	OfYahuoTurnSeller__c ofyahuoTwo=new OfYahuoTurnSeller__c();
    	ofyahuoTwo.orders__c=ordetailinsidenew.id;
    	listofyahuo.add(ofyahuoTwo);
    	insert listofyahuo;
    	list<OrderDetails__c> listupordetail=new list<OrderDetails__c>();
    	date updueDate = date.newInstance(2013, 6, 25);		
    	ordetailinsidenew.Demoend__c=updueDate;
    	ordetailinsidenew.BorrowerReceiptDate__c=date.valueOf('2013-4-4');
    	ordetailinsideold.Demoend__c=updueDate;
    	ordetailinsidenew.BorrowerReceiptDate__c=date.valueOf('2013-2-4');
    	listupordetail.add(ordetailinsidenew);
    	listupordetail.add(ordetailinsideold);
    	update listupordetail;
    	system.Test.stopTest();
    	
    }
    
}