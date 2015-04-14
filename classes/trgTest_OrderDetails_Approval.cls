//OrderDetails_Approval的测试类
//lurrykong
//2013.5.16
@isTest(SeeAllData=true)
private class trgTest_OrderDetails_Approval {		

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
    	RecordType listrtpQuDao=maprtp.get('渠道代理商'); 
    	RecordType listrtpyahuo=maprtp.get('压货订单');
    	Profile profile=[Select p.Name, p.Id From Profile p where Name='Chatter External User'];
    	User user=new User();											 
	    user.Phone='87413065';   
	    user.MobilePhone='15167988026';
	    user.Username='LurryKong@fccz.com17';
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
        acc.Identity__c='钻石';
        acc.ChannelType__c='商业渠道';
        acc.RecordTypeId=listrtpQuDao.id;
        acc.PrimaryIndustry__c='金融';
		acc.TwoIndustries__c='债券';
		acc.ThreeIndustries__c='银行';
		acc.SellArea__c=SalesRegion.id;
		acc.Province__c='北京';
		acc.dailishangshuxingField3__c='T1';
        insert acc;
        Account accTwo=new Account();
        accTwo.Name='五粮液曾经代理商';
        accTwo.Fax='8088';
        accTwo.Description='五粮液';
        accTwo.Phone='053187401688';
        accTwo.Industry='Finance';
        accTwo.Identity__c='钻石';
        accTwo.ChannelType__c='曾经代理商';
        accTwo.RecordTypeId=listrtpQuDao.id;
        accTwo.PrimaryIndustry__c='金融';
		accTwo.TwoIndustries__c='债券';
		accTwo.ThreeIndustries__c='银行';
		accTwo.SellArea__c=SalesRegion.id;
		accTwo.Province__c='北京';
		accTwo.dailishangshuxingField3__c='T1';
        insert accTwo;        
          
        ProductModelSeries__c pms=new ProductModelSeries__c();				//产品型号系列
		pms.OldProductPrice__c=600;
		pms.NewProductPrice__c=6000;
        pms.Name='NF-3000系列';
        insert pms;
        list<ProdcutionDiscount__c> listpd=new list<ProdcutionDiscount__c>();
		ProdcutionDiscount__c pdisOffer=new ProdcutionDiscount__c();		//产品折扣表
		pdisOffer.n_DiscountRole__c='办事处主任';
		pdisOffer.n_Discount__c=decimal.valueOf(22);
		pdisOffer.n_ProductionLine__c='ICG';
		listpd.add(pdisOffer);
		ProdcutionDiscount__c pdisSaleVp=new ProdcutionDiscount__c();		//产品折扣表
		pdisSaleVp.n_DiscountRole__c='销售VP';
		pdisSaleVp.n_Discount__c=decimal.valueOf(19);
		pdisSaleVp.n_ProductionLine__c='ICG';
		listpd.add(pdisSaleVp);		
		ProdcutionDiscount__c pdisCaiWuVp=new ProdcutionDiscount__c();		//产品折扣表
		pdisCaiWuVp.n_DiscountRole__c='财务VP';
		pdisCaiWuVp.n_ProductionLine__c='ICG';
		listpd.add(pdisCaiWuVp);
		ProdcutionDiscount__c pdisSale=new ProdcutionDiscount__c();			//产品折扣表
		pdisSale.n_DiscountRole__c='销售人员';
		pdisSale.n_Discount__c=decimal.valueOf(30);
		pdisSale.n_ProductionLine__c='ICG';
		listpd.add(pdisSale);
		ProdcutionDiscount__c pdisHangSale=new ProdcutionDiscount__c();		//产品折扣表
		pdisHangSale.n_DiscountRole__c='行业总监';
		pdisHangSale.n_Discount__c=decimal.valueOf(30);
		pdisHangSale.n_ProductionLine__c='ICG';
		listpd.add(pdisHangSale);
		ProdcutionDiscount__c pdisDaili=new ProdcutionDiscount__c();		//产品折扣表
		pdisDaili.n_DiscountRole__c='钻石';
		pdisDaili.n_Discount__c=decimal.valueOf(30);
		pdisDaili.n_ProductionLine__c='ICG';
		pdisDaili.ChannelType__c='行业渠道';				
		pdisDaili.Family__c=pms.id;
		listpd.add(pdisDaili);
		ProdcutionDiscount__c pdisDailiTwo=new ProdcutionDiscount__c();		//产品折扣表
		pdisDailiTwo.n_DiscountRole__c='钻石';
		pdisDailiTwo.n_Discount__c=decimal.valueOf(30);
		pdisDailiTwo.n_ProductionLine__c='ICG';
		pdisDailiTwo.ChannelType__c='商业渠道';				
		pdisDailiTwo.Family__c=pms.id;
		listpd.add(pdisDailiTwo);
		insert listpd;
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
	   	Orders__c orderyahuo=new Orders__c();						
        orderyahuo.Name='压货订单测试';
        orderyahuo.RecordTypeId=listrtpyahuo.id;		
        orderyahuo.SalesOpportunities__c=opp.Id; 
        orderyahuo.SalesRegion__c=salesregion.Id;
        orderyahuo.customer__c=acc.Id;		
        orderyahuo.Partners__c=acc.Id;
        orderyahuo.Payer__c=acc.Id;
   		orderyahuo.ApprovalStatus__c='草稿';
		listOrd.add(orderyahuo);		
	   	Orders__c orderyahuoTwo=new Orders__c();						
        orderyahuoTwo.Name='压货订单测试Two';
        orderyahuoTwo.RecordTypeId=listrtpyahuo.id;		
        orderyahuoTwo.SalesOpportunities__c=opp.Id; 
        orderyahuoTwo.SalesRegion__c=salesregion.Id;
        orderyahuoTwo.customer__c=acc.Id;		
        orderyahuoTwo.Partners__c=acc.Id;
        orderyahuoTwo.Payer__c=acc.Id;
   		orderyahuoTwo.ApprovalStatus__c='草稿';
		listOrd.add(orderyahuoTwo);
		Orders__c orderyahuoThree=new Orders__c();
	   	orderyahuoThree.Name='压货订单测试Three';
	   	orderyahuoThree.RecordTypeId=listrtpyahuo.id;
	   	orderyahuoThree.SalesOpportunities__c=opp.Id;
	   	orderyahuoThree.SalesRegion__c=salesregion.Id;
	   	orderyahuoThree.customer__c=acc.Id;
	   	orderyahuoThree.Partners__c=acc.Id;
	   	orderyahuoThree.Payer__c=acc.Id;
   		orderyahuoThree.ApprovalStatus__c='草稿';
		listOrd.add(orderyahuoThree);
			   	
	   	Orders__c orderyahuoFour=new Orders__c();						
        orderyahuoFour.Name='压货订单测试Four';
        orderyahuoFour.RecordTypeId=listrtpyahuo.id;		
        orderyahuoFour.SalesOpportunities__c=opp.Id; 
        orderyahuoFour.SalesRegion__c=salesregion.Id;
        orderyahuoFour.customer__c=acc.Id;		
        orderyahuoFour.Partners__c=acc.Id;
        orderyahuoFour.Payer__c=acc.Id;
   		orderyahuoFour.ApprovalStatus__c='草稿';
		listOrd.add(orderyahuoFour);

	   	Orders__c orderyahuoFive=new Orders__c();						
        orderyahuoFive.Name='压货订单测试Five';
        orderyahuoFive.RecordTypeId=listrtpyahuo.id;		
        orderyahuoFive.SalesOpportunities__c=opp.Id; 
        orderyahuoFive.SalesRegion__c=salesregion.Id;
        orderyahuoFive.customer__c=acc.Id;		
        orderyahuoFive.Partners__c=accTwo.Id;
        orderyahuoFive.Payer__c=acc.Id;
   		orderyahuoFive.ApprovalStatus__c='草稿';
		listOrd.add(orderyahuoFive);
		
		Orders__c orderyahuoSix=new Orders__c();						
        orderyahuoSix.Name='压货订单测试Six';
        orderyahuoSix.RecordTypeId=listrtpyahuo.id;		
        orderyahuoSix.SalesOpportunities__c=opp.Id; 
        orderyahuoSix.SalesRegion__c=salesregion.Id;
        orderyahuoSix.customer__c=acc.Id;		
        orderyahuoSix.Partners__c=accTwo.Id;
        orderyahuoSix.Payer__c=acc.Id;
   		orderyahuoSix.ApprovalStatus__c='草稿';
		listOrd.add(orderyahuoSix);
		
		Orders__c orderyahuoSeven=new Orders__c();						
        orderyahuoSeven.Name='压货订单测试Five';
        orderyahuoSeven.RecordTypeId=listrtpyahuo.id;		
        orderyahuoSeven.SalesOpportunities__c=opp.Id; 
        orderyahuoSeven.SalesRegion__c=salesregion.Id;
        orderyahuoSeven.customer__c=acc.Id;		
        orderyahuoSeven.Partners__c=accTwo.Id;
         orderyahuoSeven.Payer__c=acc.Id;
   		orderyahuoSeven.ApprovalStatus__c='草稿';
		listOrd.add(orderyahuoSeven);
		
		system.Test.startTest();  
		insert listOrd;						 
		list<OrderDetails__c> listordetail=new list<OrderDetails__c>();
		OrderDetails__c orderdetailYahuo=new OrderDetails__c();
    	orderdetailYahuo.n_OrderNo__c=orderyahuo.id;							//订单
    	orderdetailYahuo.n_ProductByOrd__c=prod.id;								//产品
    	orderdetailYahuo.n_ProCount__c=1;					 					//数量
    	orderdetailYahuo.n_PriceByord__c=400;									//成交价
		orderdetailYahuo.n_Price__c=1000;
		orderdetailYahuo.OrddetailDiscount__c=40;
		listordetail.add(orderdetailYahuo);
		
		
		OrderDetails__c orderdetailYahuoTwo=new OrderDetails__c();				//4级审批
    	orderdetailYahuoTwo.n_OrderNo__c=orderyahuo.id;							//订单
    	orderdetailYahuoTwo.n_ProductByOrd__c=prod.id;							//产品
    	orderdetailYahuoTwo.n_ProCount__c=1;					 				//数量
    	orderdetailYahuoTwo.n_PriceByord__c=5;									//成交价
		orderdetailYahuoTwo.n_Price__c=1000;
		orderdetailYahuoTwo.OrddetailDiscount__c=0.5;
		listordetail.add(orderdetailYahuoTwo);	
		OrderDetails__c orderdetailYahuoThree=new OrderDetails__c();			//3级审批
    	orderdetailYahuoThree.n_OrderNo__c=orderyahuoTwo.id;					//订单
    	orderdetailYahuoThree.n_ProductByOrd__c=prod.id;						//产品
    	orderdetailYahuoThree.n_ProCount__c=1;					 				//数量
    	orderdetailYahuoThree.n_PriceByord__c=500;								//成交价
		orderdetailYahuoThree.n_Price__c=1000;			
		orderdetailYahuoThree.OrddetailDiscount__c=50;							
		listordetail.add(orderdetailYahuoThree);	

		OrderDetails__c orderdetailYahuoFour=new OrderDetails__c();				//2级审批
    	orderdetailYahuoFour.n_OrderNo__c=orderyahuoThree.id;					//订单
    	orderdetailYahuoFour.n_ProductByOrd__c=prod.id;							//产品
    	orderdetailYahuoFour.n_ProCount__c=1;					 				//数量
    	orderdetailYahuoFour.n_PriceByord__c=210;								//成交价
		orderdetailYahuoFour.n_Price__c=1000;
		orderdetailYahuoFour.OrddetailDiscount__c=21;
		listordetail.add(orderdetailYahuoFour);
        
				
		OrderDetails__c orderdetailYahuoFive=new OrderDetails__c();				
    	orderdetailYahuoFive.n_OrderNo__c=orderyahuoFour.id;					
    	orderdetailYahuoFive.n_ProductByOrd__c=prod.id;							
    	orderdetailYahuoFive.n_ProCount__c=1;					 				
    	orderdetailYahuoFive.n_PriceByord__c=250;								
		orderdetailYahuoFive.n_Price__c=1000;
		orderdetailYahuoFive.OrddetailDiscount__c=25;
		listordetail.add(orderdetailYahuoFive);
		//渠道类型不是行业销售和商业销售 
		OrderDetails__c orderdetailYahuoSix=new OrderDetails__c();
		orderdetailYahuoSix.n_OrderNo__c=orderyahuoFive.id;					
    	orderdetailYahuoSix.n_ProductByOrd__c=prod.id;							
    	orderdetailYahuoSix.n_ProCount__c=1;					 				
    	orderdetailYahuoSix.n_PriceByord__c=250;								
		orderdetailYahuoSix.n_Price__c=1000;
		orderdetailYahuoSix.OrddetailDiscount__c=25;
		listordetail.add(orderdetailYahuoSix);
		OrderDetails__c orderdetailYahuoSeven=new OrderDetails__c();
		orderdetailYahuoSeven.n_OrderNo__c=orderyahuoSix.id;					
    	orderdetailYahuoSeven.n_ProductByOrd__c=prod.id;							
    	orderdetailYahuoSeven.n_ProCount__c=1;					 				
    	orderdetailYahuoSeven.n_PriceByord__c=500;								
		orderdetailYahuoSeven.n_Price__c=1000;
		orderdetailYahuoSeven.OrddetailDiscount__c=50;
		listordetail.add(orderdetailYahuoSeven);
		OrderDetails__c orderdetailYahuoEight=new OrderDetails__c();
		orderdetailYahuoEight.n_OrderNo__c=orderyahuoSeven.id;					
    	orderdetailYahuoEight.n_ProductByOrd__c=prod.id;							
    	orderdetailYahuoEight.n_ProCount__c=1;					 				
    	orderdetailYahuoEight.n_PriceByord__c=210;								
		orderdetailYahuoEight.n_Price__c=1000;
		orderdetailYahuoEight.OrddetailDiscount__c=21;
		listordetail.add(orderdetailYahuoEight);
		
    	insert listordetail;
    	delete  orderdetailYahuoFour;
    	system.Test.stopTest();    
        
    }
    static testMethod void myUnitTestTwo()
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
    	RecordType listrtpQuDao=maprtp.get('渠道代理商'); 
    	RecordType listrtpyahuo=maprtp.get('压货订单');
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
        acc.Identity__c='钻石';
        acc.ChannelType__c='商业渠道';
        acc.RecordTypeId=listrtpQuDao.id;
        acc.PrimaryIndustry__c='金融';
		acc.TwoIndustries__c='债券';
		acc.ThreeIndustries__c='银行';
		acc.SellArea__c=SalesRegion.id;
		acc.Province__c='北京';
		acc.dailishangshuxingField3__c='T1';
        insert acc;
		Account accTwo=new Account();
        accTwo.Name='五粮液曾经代理商测试';
        accTwo.Fax='8088';
        accTwo.Description='五粮液';
        accTwo.Phone='053187413065';
        accTwo.Industry='Finance';
        accTwo.Identity__c='钻石';
        accTwo.ChannelType__c='曾经代理商';
        accTwo.RecordTypeId=listrtpQuDao.id;
        accTwo.PrimaryIndustry__c='金融';
		accTwo.TwoIndustries__c='债券';
		accTwo.ThreeIndustries__c='银行';
		accTwo.SellArea__c=SalesRegion.id;
		accTwo.Province__c='北京';
		accTwo.dailishangshuxingField3__c='T1';
        insert accTwo;        
                 
        ProductModelSeries__c pms=new ProductModelSeries__c();	//产品型号系列
		pms.OldProductPrice__c=600;
		pms.NewProductPrice__c=6000;
        pms.Name='NF-3000系列';
        insert pms;        
        list<ProdcutionDiscount__c> listpd=new list<ProdcutionDiscount__c>();
		ProdcutionDiscount__c pdisOffer=new ProdcutionDiscount__c();		//产品折扣表
		pdisOffer.n_DiscountRole__c='办事处主任';
		pdisOffer.n_Discount__c=decimal.valueOf(22);
		pdisOffer.n_ProductionLine__c='ICG';
		listpd.add(pdisOffer);
		ProdcutionDiscount__c pdisSaleVp=new ProdcutionDiscount__c();		//产品折扣表
		pdisSaleVp.n_DiscountRole__c='销售VP';
		pdisSaleVp.n_Discount__c=decimal.valueOf(19);
		pdisSaleVp.n_ProductionLine__c='ICG';
		listpd.add(pdisSaleVp);		
		ProdcutionDiscount__c pdisCaiWuVp=new ProdcutionDiscount__c();		//产品折扣表
		pdisCaiWuVp.n_DiscountRole__c='财务VP';
		pdisCaiWuVp.n_ProductionLine__c='ICG';
		listpd.add(pdisCaiWuVp);
		ProdcutionDiscount__c pdisSale=new ProdcutionDiscount__c();			//产品折扣表
		pdisSale.n_DiscountRole__c='销售人员';
		pdisSale.n_Discount__c=decimal.valueOf(30);
		pdisSale.n_ProductionLine__c='ICG';
		listpd.add(pdisSale);
		ProdcutionDiscount__c pdisDaili=new ProdcutionDiscount__c();		//产品折扣表
		pdisDaili.n_DiscountRole__c='钻石';
		pdisDaili.n_Discount__c=decimal.valueOf(30);
		pdisDaili.n_ProductionLine__c='ICG';
		pdisDaili.ChannelType__c='行业渠道';				
		pdisDaili.Family__c=pms.id;
		listpd.add(pdisDaili);
		ProdcutionDiscount__c pdisDailiTwo=new ProdcutionDiscount__c();		//产品折扣表
		pdisDailiTwo.n_DiscountRole__c='钻石';
		pdisDailiTwo.n_Discount__c=decimal.valueOf(30);
		pdisDailiTwo.n_ProductionLine__c='ICG';
		pdisDailiTwo.ChannelType__c='商业渠道';				
		pdisDailiTwo.Family__c=pms.id;
		listpd.add(pdisDailiTwo);
		insert listpd;        
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
	   	Orders__c orderyahuo=new Orders__c();						
        orderyahuo.Name='压货订单测试';
        orderyahuo.RecordTypeId=listrtpyahuo.id;		
        orderyahuo.SalesOpportunities__c=opp.Id; 
        orderyahuo.SalesRegion__c=salesregion.Id;
        orderyahuo.customer__c=acc.Id;		
        orderyahuo.Partners__c=acc.Id;
         orderyahuo.Payer__c=acc.Id;
   		orderyahuo.ApprovalStatus__c='草稿';
		listOrd.add(orderyahuo);		
	   	Orders__c orderyahuoTwo=new Orders__c();						
        orderyahuoTwo.Name='压货订单测试Two';
        orderyahuoTwo.RecordTypeId=listrtpyahuo.id;		
        orderyahuoTwo.SalesOpportunities__c=opp.Id; 
        orderyahuoTwo.SalesRegion__c=salesregion.Id;
        orderyahuoTwo.customer__c=acc.Id;		
        orderyahuoTwo.Partners__c=acc.Id;
         orderyahuoTwo.Payer__c=acc.Id;
   		orderyahuoTwo.ApprovalStatus__c='草稿';
		listOrd.add(orderyahuoTwo);
	   	Orders__c orderyahuoThree=new Orders__c();						
        orderyahuoThree.Name='压货订单测试Three';
        orderyahuoThree.RecordTypeId=listrtpyahuo.id;		
        orderyahuoThree.SalesOpportunities__c=opp.Id; 
        orderyahuoThree.SalesRegion__c=salesregion.Id;
        orderyahuoThree.customer__c=acc.Id;		
        orderyahuoThree.Partners__c=acc.Id;
        orderyahuoThree.Payer__c=acc.Id;
   		orderyahuoThree.ApprovalStatus__c='草稿';
		listOrd.add(orderyahuoThree);
	   	Orders__c orderyahuoFour=new Orders__c();						
        orderyahuoFour.Name='压货订单测试Four';
        orderyahuoFour.RecordTypeId=listrtpyahuo.id;		
        orderyahuoFour.SalesOpportunities__c=opp.Id; 
        orderyahuoFour.SalesRegion__c=salesregion.Id;
        orderyahuoFour.customer__c=acc.Id;		
        orderyahuoFour.Partners__c=acc.Id;
         orderyahuoFour.Payer__c=acc.Id;
   		orderyahuoFour.ApprovalStatus__c='草稿';
		listOrd.add(orderyahuoFour);
		
		Orders__c orderyahuoFive=new Orders__c();						
        orderyahuoFive.Name='压货订单测试Five';
        orderyahuoFive.RecordTypeId=listrtpyahuo.id;		
        orderyahuoFive.SalesOpportunities__c=opp.Id; 
        orderyahuoFive.SalesRegion__c=salesregion.Id;
        orderyahuoFive.customer__c=acc.Id;		
        orderyahuoFive.Partners__c=accTwo.Id;
        orderyahuoFive.Payer__c=acc.Id;
   		orderyahuoFive.ApprovalStatus__c='草稿';
		listOrd.add(orderyahuoFive);
		
		Orders__c orderyahuoSix=new Orders__c();						
        orderyahuoSix.Name='压货订单测试Six';
        orderyahuoSix.RecordTypeId=listrtpyahuo.id;		
        orderyahuoSix.SalesOpportunities__c=opp.Id; 
        orderyahuoSix.SalesRegion__c=salesregion.Id;
        orderyahuoSix.customer__c=acc.Id;		
        orderyahuoSix.Partners__c=accTwo.Id;
        orderyahuoSix.Payer__c=acc.Id;
   		orderyahuoSix.ApprovalStatus__c='草稿';
		listOrd.add(orderyahuoSix);
		
		Orders__c orderyahuoSeven=new Orders__c();						
        orderyahuoSeven.Name='压货订单测试Five';
        orderyahuoSeven.RecordTypeId=listrtpyahuo.id;		
        orderyahuoSeven.SalesOpportunities__c=opp.Id; 
        orderyahuoSeven.SalesRegion__c=salesregion.Id;
        orderyahuoSeven.customer__c=acc.Id;		
        orderyahuoSeven.Partners__c=accTwo.Id;
         orderyahuoSeven.Payer__c=acc.Id;
   		orderyahuoSeven.ApprovalStatus__c='草稿';
		listOrd.add(orderyahuoSeven);
 
		system.Test.startTest();
		system.debug('----------------information is come in--------------------');  
		insert listOrd;						 
		list<OrderDetails__c> listordetail=new list<OrderDetails__c>();
		OrderDetails__c orderdetailYahuo=new OrderDetails__c();
    	orderdetailYahuo.n_OrderNo__c=orderyahuo.id;							//订单
    	orderdetailYahuo.n_ProductByOrd__c=prod.id;								//产品
    	orderdetailYahuo.n_ProCount__c=1;					 					//数量
    	orderdetailYahuo.n_PriceByord__c=400;									//成交价
		orderdetailYahuo.n_Price__c=1000;
		orderdetailYahuo.OrddetailDiscount__c=40;
		listordetail.add(orderdetailYahuo);
		OrderDetails__c orderdetailYahuoTwo=new OrderDetails__c();				//4级审批
    	orderdetailYahuoTwo.n_OrderNo__c=orderyahuo.id;							//订单
    	orderdetailYahuoTwo.n_ProductByOrd__c=prod.id;							//产品
    	orderdetailYahuoTwo.n_ProCount__c=1;					 				//数量
    	orderdetailYahuoTwo.n_PriceByord__c=5;									//成交价
		orderdetailYahuoTwo.n_Price__c=1000;
		orderdetailYahuoTwo.OrddetailDiscount__c=0.5;
		listordetail.add(orderdetailYahuoTwo);			
		OrderDetails__c orderdetailYahuoThree=new OrderDetails__c();			//3级审批
    	orderdetailYahuoThree.n_OrderNo__c=orderyahuoTwo.id;					//订单
    	orderdetailYahuoThree.n_ProductByOrd__c=prod.id;						//产品
    	orderdetailYahuoThree.n_ProCount__c=1;					 				//数量
    	orderdetailYahuoThree.n_PriceByord__c=210;								//成交价
		orderdetailYahuoThree.n_Price__c=1000;
		orderdetailYahuoThree.OrddetailDiscount__c=21;										
		listordetail.add(orderdetailYahuoThree);			
		OrderDetails__c orderdetailYahuoFour=new OrderDetails__c();				//1级审批
    	orderdetailYahuoFour.n_OrderNo__c=orderyahuoThree.id;							//订单
    	orderdetailYahuoFour.n_ProductByOrd__c=prod.id;							//产品
    	orderdetailYahuoFour.n_ProCount__c=1;					 				//数量
    	orderdetailYahuoFour.n_PriceByord__c=500;									//成交价
		orderdetailYahuoFour.n_Price__c=1000;
		orderdetailYahuoFour.OrddetailDiscount__c=50;	
		listordetail.add(orderdetailYahuoFour);		
		OrderDetails__c orderdetailYahuoFive=new OrderDetails__c();				//2级审批
    	orderdetailYahuoFive.n_OrderNo__c=orderyahuoFour.id;					//订单
    	orderdetailYahuoFive.n_ProductByOrd__c=prod.id;							//产品
    	orderdetailYahuoFive.n_ProCount__c=1;					 				//数量
    	orderdetailYahuoFive.n_PriceByord__c=250;								//成交价
		orderdetailYahuoFive.n_Price__c=1000;
		orderdetailYahuoFive.OrddetailDiscount__c=25;
		listordetail.add(orderdetailYahuoFive);
		
				/**渠道类型不是行业销售和商业销售**/ 
		OrderDetails__c orderdetailYahuoSix=new OrderDetails__c();
		orderdetailYahuoSix.n_OrderNo__c=orderyahuoFive.id;					
    	orderdetailYahuoSix.n_ProductByOrd__c=prod.id;							
    	orderdetailYahuoSix.n_ProCount__c=1;					 				
    	orderdetailYahuoSix.n_PriceByord__c=250;								
		orderdetailYahuoSix.n_Price__c=1000;
		orderdetailYahuoSix.OrddetailDiscount__c=25;
		listordetail.add(orderdetailYahuoSix);
		OrderDetails__c orderdetailYahuoSeven=new OrderDetails__c();
		orderdetailYahuoSeven.n_OrderNo__c=orderyahuoSix.id;					
    	orderdetailYahuoSeven.n_ProductByOrd__c=prod.id;							
    	orderdetailYahuoSeven.n_ProCount__c=1;					 				
    	orderdetailYahuoSeven.n_PriceByord__c=500;								
		orderdetailYahuoSeven.n_Price__c=1000;
		orderdetailYahuoSeven.OrddetailDiscount__c=50;
		listordetail.add(orderdetailYahuoSeven);
		OrderDetails__c orderdetailYahuoEight=new OrderDetails__c();
		orderdetailYahuoEight.n_OrderNo__c=orderyahuoSeven.id;					
    	orderdetailYahuoEight.n_ProductByOrd__c=prod.id;							
    	orderdetailYahuoEight.n_ProCount__c=1;					 				
    	orderdetailYahuoEight.n_PriceByord__c=210;								
		orderdetailYahuoEight.n_Price__c=1000;
		orderdetailYahuoEight.OrddetailDiscount__c=21;
		listordetail.add(orderdetailYahuoEight);
		
    	insert listordetail;    	
    	list<OrderDetails__c> listUpOrdetail=new list<OrderDetails__c>();    	
    	orderdetailYahuo.n_PriceByord__c=399;			
    	orderdetailYahuoTwo.n_PriceByord__c=6;
    	orderdetailYahuoThree.n_PriceByord__c=211;
    	orderdetailYahuoFour.n_PriceByord__c=501;
    	orderdetailYahuoFive.n_PriceByord__c=251;
    	orderdetailYahuoSix.n_PriceByord__c=251;
    	orderdetailYahuoSeven.n_PriceByord__c=501;
    	orderdetailYahuoEight.n_PriceByord__c=211;
    	listUpOrdetail.add(orderdetailYahuo);
    	listUpOrdetail.add(orderdetailYahuoTwo);
    	listUpOrdetail.add(orderdetailYahuoThree);
    	listUpOrdetail.add(orderdetailYahuoFour);
    	listUpOrdetail.add(orderdetailYahuoFive);
    	listUpOrdetail.add(orderdetailYahuoSix);
    	listUpOrdetail.add(orderdetailYahuoSeven);
    	listUpOrdetail.add(orderdetailYahuoEight);
    	system.debug('----------------information is come in center--------------------');  
    	//update listUpOrdetail;
    	system.debug('----------------information is come in end--------------------');  
    	system.Test.stopTest();    
    } 
}