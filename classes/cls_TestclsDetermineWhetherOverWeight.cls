//clsDetermineWhetherOverWeight的测试类
//lurrykong
//2013.5.17
@isTest(SeeAllData=true)
private class cls_TestclsDetermineWhetherOverWeight {
    static testMethod void myUnitTest() 
    {
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
    	RecordType listrtpQuDao=maprtp.get('渠道代理商'); /*ar.get('SalesRegion__c'))+string.valueOf(ar.get('n_Year__c'))+string.valueOf(ar.get('Quarter__c'));*/
    	RecordType listrtpInside=maprtp.get('内部样机订单');
    	Profile profile=[Select p.Name, p.Id From Profile p where Name='Chatter External User'];
    	User user=new User();											 
	    user.Phone='87413065';   
	    user.MobilePhone='15167988026';
	    user.Username='LurryKong@fccz.com1';
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
        acc.dailishangshuxingField3__c = 'T1';
        insert acc;
        
        SalesRegion__c salesregion=new SalesRegion__c();
		salesregion.OfficeDirector__c=user.id;
		salesregion.SEPersonInCharge__c=user.id;
		salesregion.Name='北京办事处wwwww';
		insert salesregion;   
		
        list<PrototypeCosts__c> listproto=new list<PrototypeCosts__c>();
        PrototypeCosts__c pc=new PrototypeCosts__c();					//费用指标对象
        pc.Name='北京办事处样机费用指标';
        pc.n_SaleArea__c=salesregion.id; 
        pc.n_Year__c='2013';
        pc.n_Month__c='01';
        pc.Quarter__c='第一季度';
        pc.n_BudgetAmount__c=5000;
        listproto.add(pc);
		PrototypeCosts__c pcTwo=new PrototypeCosts__c();				//费用指标对象
        pcTwo.Name='北京办事处样机费用指标';
        pcTwo.n_SaleArea__c=salesregion.id;
        pcTwo.n_Year__c='2013';
        pcTwo.Quarter__c='第二季度';
        pcTwo.n_BudgetAmount__c=5000;
		listproto.add(pcTwo);       
		PrototypeCosts__c pcThree=new PrototypeCosts__c();				//费用指标对象
        pcThree.Name='北京办事处样机费用指标';
        pcThree.n_SaleArea__c=salesregion.id;
        pcThree.n_Year__c='2013';
        pcThree.Quarter__c='第三季度';
        pcThree.n_BudgetAmount__c=5000;
		listproto.add(pcThree);
		insert listproto;
																															
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
		pms.NewProductPrice__c=1000;
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
		Orders__c orderinsideApp=new Orders__c();			//新样机订单
        orderinsideApp.Name='内部样机测试审批通过';
        orderinsideApp.RecordTypeId=listrtpInside.id;		
        orderinsideApp.SalesOpportunities__c=opp.Id; 
        orderinsideApp.SalesRegion__c=salesregion.Id;
        orderinsideApp.customer__c=acc.Id;		
   		orderinsideApp.ApprovalStatus__c='已审批';
		listOrd.add(orderinsideApp); 
		insert listOrd;
		
		date startDate = date.newInstance(2013, 1, 1);
		date dueDate = date.newInstance(2013, 2, 24); 		 
		date borrowDate = date.newInstance(2013,1,4);  
		date borrowDateTwo = date.newInstance(2013,2,4);  
		list<OrderDetails__c> listordetail=new list<OrderDetails__c>();	
		OrderDetails__c orderdetailApp=new OrderDetails__c();
    	orderdetailApp.n_OrderNo__c=orderinsideApp.id;								//订单
    	orderdetailApp.n_ProductByOrd__c=prod.id;								//产品
    	orderdetailApp.n_ProCount__c=1;					 						//数量
    	orderdetailApp.n_PriceByord__c=4500;	
    	orderdetailApp.TestStatus__c='测试中';    	
    	orderdetailApp.IfNewProduct__c=true;
    	orderdetailApp.Demostar__c=startDate;
    	orderdetailApp.Demoend__c=dueDate;
    	orderdetailApp.BorrowerReceiptDate__c=borrowDate;	
    	orderdetailApp.n_Year__c = '2013';
    	orderdetailApp.Quarter__c = '第一季度'; 
    						
		listordetail.add(orderdetailApp);
		OrderDetails__c orderdetailAppTwo=new OrderDetails__c();
    	orderdetailAppTwo.n_OrderNo__c=orderinsideApp.id;								//订单
    	orderdetailAppTwo.n_ProductByOrd__c=prod.id;								//产品
    	orderdetailAppTwo.n_ProCount__c=1;					 						//数量
    	orderdetailAppTwo.n_PriceByord__c=2600;	
    	orderdetailAppTwo.TestStatus__c='测试中';     	
    	orderdetailAppTwo.IfNewProduct__c=true;
    	orderdetailAppTwo.Demostar__c=startDate;
    	orderdetailAppTwo.Demoend__c=dueDate;
    	orderdetailAppTwo.BorrowerReceiptDate__c=borrowDateTwo;						//n_Year__c,Quarter__c
    	orderdetailAppTwo.n_Year__c ='2013';
    	orderdetailAppTwo.Quarter__c = '第一季度';
		listordetail.add(orderdetailAppTwo);
		system.Test.startTest();
		insert listordetail;
		OrderDetails__c orderdetailApp3=new OrderDetails__c(); 
    	orderdetailApp3.n_OrderNo__c=orderinsideApp.id;								//订单
    	orderdetailApp3.n_ProductByOrd__c=prod.id;								//产品
    	orderdetailApp3.n_ProCount__c=1;	
    	orderdetailAppTwo.n_PriceByord__c=1000;				 						//数量
    	orderdetailApp3.PracticalExpectPrice__c = 2000;										//成交价
    	orderdetailApp3.TestStatus__c='测试中';    	
    	orderdetailApp3.IfNewProduct__c=true;
    	orderdetailApp3.Demostar__c=startDate;
    	orderdetailApp3.Demoend__c=dueDate;
    	orderdetailApp3.BorrowerReceiptDate__c=borrowDateTwo;						//n_Year__c,Quarter__c
    	orderdetailApp3.n_Year__c ='2013';
    	orderdetailApp3.Quarter__c = '第二季度';
    	insert orderdetailApp3;
    	
    	
    	system.debug('----------------yangjifeiyong--------------'+orderdetailApp3.PracticalExpectPrice__c);
    	
    	
		/*
		list<OrderDetails__c> listOrderdetail=new list<OrderDetails__c>();
		OrderDetails__c ordetail2=new OrderDetails__c();
    	ordetail2.n_OrderNo__c=orderdetailApp.id;
    	ordetail2.n_ProCount__c=1;
    	ordetail2.PracticalExpectPrice__c = 5000;
    	ordetail2.TestStatus__c = '测试中';
    	listOrderdetail.add(ordetail2);
    	OrderDetails__c ordetail3=new OrderDetails__c();
    	ordetail3.n_OrderNo__c=orderdetailApp.id; 
    	ordetail3.n_ProCount__c=1;
    	ordetail3.PracticalExpectPrice__c = 5000;
    	ordetail3.TestStatus__c = '测试中';
    	listOrderdetail.add(ordetail3);
		*/
		
		    
		/*
		scheduleLeadAutoCheck slead= new scheduleLeadAutoCheck();	
 	    clsOrderDetailsAutoForNowactual LeadBatch = new clsOrderDetailsAutoForNowactual();
   		Database.executeBatch(LeadBatch,50);
	 	string schLead=DateTime.now().second()+' '+DateTime.now().minute()+' '+DateTime.now().hour()+' * * ?';
	 	*/
	 	scheduleWhetherOverWeight schWeOverWeight=new scheduleWhetherOverWeight();
	 	clsDetermineWhetherOverWeight clsWeOverWeight=new clsDetermineWhetherOverWeight();
    	Database.executeBatch(clsWeOverWeight,50);
    	system.Test.stopTest();    
    }    
}