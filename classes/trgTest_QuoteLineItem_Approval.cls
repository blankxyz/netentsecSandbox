//QuoteLineItem_Approval测试类
//lurykong
//2013.4.11.
@isTest(SeeAllData=true)
private class trgTest_QuoteLineItem_Approval {
    static testMethod void myUnitTest() {
        Pricebook2 pricebook = [select Id from Pricebook2 where isStandard=true limit 1];
    	Profile profile=[Select p.Name, p.Id From Profile p where Name='Chatter External User'];
        list<RecordType> listrtp=[Select r.Name, r.Id, r.Description From RecordType r where Name='渠道代理商'];     	    	 
    	User user=new User();											 
	    user.Phone='87413065';   
	    user.MobilePhone='15167988026';
	    user.Username='LurryKong@fccz.com29';
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
    	SalesRegion__c salesregion=new SalesRegion__c();				//销售区域
		salesregion.OfficeDirector__c=user.id;
		salesregion.Name='日本';
		insert salesregion;    	
        list<Account> listacc=new list<Account>();    
        Account accTwo=new Account();
        accTwo.Name='五粮液asdfff';
        accTwo.Fax='8088';
        accTwo.Description='五粮液';
        accTwo.Phone='053187401697';
        accTwo.Industry='Finance';
        accTwo.RecordTypeId=listrtp[0].id;
        accTwo.Identity__c='钻石';
        accTwo.ChannelType__c='商业渠道';
        accTwo.PrimaryIndustry__c='金融';
		accTwo.TwoIndustries__c='债券';
		accTwo.ThreeIndustries__c='银行';
		accTwo.SellArea__c=SalesRegion.id;
		accTwo.Province__c='北京';
		accTwo.dailishangshuxingField3__c='T1';
        listacc.add(accTwo);
        insert listacc;
        list<ProductionLevel__c> listPro=new list<ProductionLevel__c>();	//产品级别
        ProductionLevel__c pleone=new ProductionLevel__c();		//产品级别
        pleone.Name='产成品';
        pleone.n_level__c='一级';
        pleone.n_levelNO__c='B';
        listPro.add(pleone);
        ProductionLevel__c pleTwo=new ProductionLevel__c();		//产品级别
        pleTwo.Name='天晶政府';
        pleTwo.n_level__c='二级';
        pleTwo.n_levelNO__c='B';
        listPro.add(pleTwo);
        ProductionLevel__c pleThree=new ProductionLevel__c();		//产品级别
        pleThree.Name='配件';
        pleThree.n_level__c='三级';
        pleThree.n_levelNO__c='B';
        listPro.add(pleThree);
        ProductionLevel__c pleFour=new ProductionLevel__c();		//产品级别
        pleFour.Name='硬件';
        pleFour.n_level__c='四级';
        pleFour.n_levelNO__c='B';
        listPro.add(pleFour);
		insert listPro;
        ProductModelSeries__c pms=new ProductModelSeries__c();				//产品型号系列
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
		/*
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
		*/
		
		
		
		
		
		insert listpd;
		
		list<Product2> listProd=new list<Product2>();		
        Product2 prod=new Product2();						//产品
       	prod.Name='prodone';
        prod.n_Unit__c='个';									//计量单位
        prod.productmodelseries__c=pms.id;					//产品型号系列
    	prod.n_FirstLevel__c=pleone.id;						//一级产品
        prod.n_SecondLevel__c=pleTwo.id;					//二级产品
        prod.n_ThirdLevel__c=pleThree.id;					//三级产品
        prod.n_FourLevel__c=pleFour.id;						//四级产品
        prod.Family='ICG';
        listProd.add(prod);
        Product2 prodTwo=new Product2();						//产品
        prodTwo.Name='prodTwo';
        prodTwo.n_Unit__c='个';									//计量单位
        prodTwo.productmodelseries__c=pms.id;					//产品型号系列
    	prodTwo.n_FirstLevel__c=pleone.id;						//一级产品
        prodTwo.n_SecondLevel__c=pleTwo.id;						//二级产品
        prodTwo.n_ThirdLevel__c=pleThree.id;					//三级产品
        prodTwo.n_FourLevel__c=pleFour.id;						//四级产品
        prodTwo.Family='ICG';
        listProd.add(prodTwo);
        insert listProd;
        
        list<PricebookEntry> listPbe=new list<PricebookEntry>();//价格手册        
        PricebookEntry pbe=new PricebookEntry();
        pbe.IsActive=true;
        pbe.Product2Id=prod.Id;
        pbe.UnitPrice=1000;      	//产品的标准价格
        pbe.Pricebook2Id=pricebook.id;
        listPbe.add(pbe);
        PricebookEntry pbeTwo=new PricebookEntry();
        pbeTwo.IsActive=true;
        pbeTwo.Product2Id=prodTwo.Id;
        pbeTwo.UnitPrice=1000;      //产品的标准价格
        pbeTwo.Pricebook2Id=pricebook.id;
        listPbe.add(pbeTwo);
        insert listPbe;
        
        list<Opportunity> listOpp=new list<Opportunity>();      //if(quote.OppProperties__c=='商业市场'&&acc.ChannelType__c=='商业渠道'||quote.OppProperties__c=='行业市场'&&acc.ChannelType__c=='行业渠道')		//走供应商批准
        String Closetime='2005'+'-'+'10'+'-'+'5';
        Date dte=date.valueOf(Closetime);
	   	Opportunity opp=new Opportunity();    	
	    opp.OppProperties__c='商业市场';       					//商业市场
        opp.Name='五粮液商机';
        opp.Description='业务机会';
        opp.CloseDate=dte;  
        opp.AccountId=accTwo.Id;
        opp.Partners__c=accTwo.Id;
        opp.StageName='关单';
        opp.Probability=100;					//可行性
        opp.SalesRegion__c = salesregion.Id;
	    listOpp.add(opp);  
	    insert listOpp;
																												
	    list<Quote> listQuote=new list<Quote>();
	    Quote quote=new Quote();				//报价
        quote.OpportunityId=opp.Id;
        quote.Pricebook2Id=pricebook.Id;
        quote.Name='2013网康服务器报价';
        quote.Status='已批准';
        quote.Agents__c=accTwo.id;
        quote.yanhoukaipiaoliyouField3__c='延后开票';
        listQuote.add(quote);
 
	    insert listQuote;
	    
	    list<QuoteLineItem> listQuotelineitem=new list<QuoteLineItem>();
	    QuoteLineItem qut1=new QuoteLineItem();	//报价行
	 	qut1.QuoteId=quote.Id;
	    qut1.UnitPrice=80;
	    qut1.Quantity=2;
	    qut1.PricebookEntryId=pbeTwo.id;
	    listQuotelineitem.add(qut1);
	    QuoteLineItem qut2=new QuoteLineItem();	//报价行
	 	qut2.QuoteId=quote.Id;
	    qut2.UnitPrice=50;
	    qut2.Quantity=2;
	    qut2.PricebookEntryId=pbeTwo.id;
	    listQuotelineitem.add(qut2);
	    insert listQuotelineitem;
		qut1.UnitPrice=80000;
		update qut1;
        qut1.UnitPrice=200;
        update qut1;
        qut1.UnitPrice=225;
        update qut1;
    }
	static testMethod void myUnitTestTwo() {
		Pricebook2 pricebook = [select Id from Pricebook2 where isStandard=true limit 1];
    	Profile profile=[Select p.Name, p.Id From Profile p where Name='Chatter External User'];
        list<RecordType> listrtp=[Select r.Name, r.Id, r.Description From RecordType r where Name='渠道代理商'];     	    	 
    	User user=new User();											 
	    user.Phone='87413065';   
	    user.MobilePhone='15167988026';
	    user.Username='LurryKong@fccz.comsdf';
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
    	SalesRegion__c salesregion=new SalesRegion__c();				//销售区域
		salesregion.OfficeDirector__c=user.id;
		salesregion.Name='日本';
		insert salesregion;    	
        list<Account> listacc=new list<Account>();    
        Account accTwo=new Account();
        accTwo.Name='五粮液asdfff';
        accTwo.Fax='8088';
        accTwo.Description='五粮液';
        accTwo.Phone='053187401697';
        accTwo.Industry='Finance';
        accTwo.RecordTypeId=listrtp[0].id;
        accTwo.Identity__c='钻石';
        accTwo.ChannelType__c='商业渠道';
        accTwo.PrimaryIndustry__c='金融';
		accTwo.TwoIndustries__c='债券';
		accTwo.ThreeIndustries__c='银行';
		accTwo.SellArea__c=SalesRegion.id;
		accTwo.Province__c='北京';
		accTwo.dailishangshuxingField3__c='T1';
        listacc.add(accTwo);
        insert listacc;
        list<ProductionLevel__c> listPro=new list<ProductionLevel__c>();	//产品级别
        ProductionLevel__c pleone=new ProductionLevel__c();		//产品级别
        pleone.Name='产成品';
        pleone.n_level__c='一级';
        pleone.n_levelNO__c='B';
        listPro.add(pleone);
        ProductionLevel__c pleTwo=new ProductionLevel__c();		//产品级别
        pleTwo.Name='天晶政府';
        pleTwo.n_level__c='二级';
        pleTwo.n_levelNO__c='B';
        listPro.add(pleTwo);
        ProductionLevel__c pleThree=new ProductionLevel__c();		//产品级别
        pleThree.Name='配件';
        pleThree.n_level__c='三级';
        pleThree.n_levelNO__c='B';
        listPro.add(pleThree);
        ProductionLevel__c pleFour=new ProductionLevel__c();		//产品级别
        pleFour.Name='硬件';
        pleFour.n_level__c='四级';
        pleFour.n_levelNO__c='B';
        listPro.add(pleFour);
		insert listPro;
        ProductModelSeries__c pms=new ProductModelSeries__c();				//产品型号系列
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
		
		list<Product2> listProd=new list<Product2>();		
        Product2 prod=new Product2();						//产品
       	prod.Name='prodone';
        prod.n_Unit__c='个';									//计量单位
        prod.productmodelseries__c=pms.id;					//产品型号系列
    	prod.n_FirstLevel__c=pleone.id;						//一级产品
        prod.n_SecondLevel__c=pleTwo.id;					//二级产品
        prod.n_ThirdLevel__c=pleThree.id;					//三级产品
        prod.n_FourLevel__c=pleFour.id;						//四级产品
        prod.Family='ICG';
        listProd.add(prod);
        Product2 prodTwo=new Product2();						//产品
        prodTwo.Name='prodTwo';
        prodTwo.n_Unit__c='个';									//计量单位
        prodTwo.productmodelseries__c=pms.id;					//产品型号系列
    	prodTwo.n_FirstLevel__c=pleone.id;						//一级产品
        prodTwo.n_SecondLevel__c=pleTwo.id;						//二级产品
        prodTwo.n_ThirdLevel__c=pleThree.id;					//三级产品
        prodTwo.n_FourLevel__c=pleFour.id;						//四级产品
        prodTwo.Family='ICG';
        listProd.add(prodTwo);
        insert listProd;
        
        list<PricebookEntry> listPbe=new list<PricebookEntry>();//价格手册        
        PricebookEntry pbe=new PricebookEntry();
        pbe.IsActive=true;
        pbe.Product2Id=prod.Id;
        pbe.UnitPrice=1000;      	//产品的标准价格
        pbe.Pricebook2Id=pricebook.id;
        listPbe.add(pbe);
        PricebookEntry pbeTwo=new PricebookEntry();
        pbeTwo.IsActive=true;
        pbeTwo.Product2Id=prodTwo.Id;
        pbeTwo.UnitPrice=1000;      //产品的标准价格
        pbeTwo.Pricebook2Id=pricebook.id;
        listPbe.add(pbeTwo);
        insert listPbe;
        
        list<Opportunity> listOpp=new list<Opportunity>();      //if(quote.OppProperties__c=='商业市场'&&acc.ChannelType__c=='商业渠道'||quote.OppProperties__c=='行业市场'&&acc.ChannelType__c=='行业渠道')		//走供应商批准
        String Closetime='2005'+'-'+'10'+'-'+'5';
        Date dte=date.valueOf(Closetime);
	   	Opportunity opp=new Opportunity();    	
	    opp.OppProperties__c='行业市场';       					//商业市场
        opp.Name='五粮液商机';
        opp.Description='业务机会';
        opp.CloseDate=dte;  
        opp.AccountId=accTwo.Id;
        opp.Partners__c=accTwo.Id;
        opp.StageName='关单';
        opp.Probability=100;					//可行性
        opp.SalesRegion__c = salesregion.Id;
	    listOpp.add(opp);  
	    insert listOpp;
																												
	    list<Quote> listQuote=new list<Quote>();
	    Quote quote=new Quote();				//报价
        quote.OpportunityId=opp.Id;
        quote.Pricebook2Id=pricebook.Id;
        quote.Name='2013网康服务器报价';
        quote.Status='已批准';
        quote.Agents__c=accTwo.id;
        quote.yanhoukaipiaoliyouField3__c='延后开票信息';
        listQuote.add(quote);
	    insert listQuote;	    
	    QuoteLineItem qut=new QuoteLineItem();	//报价行
	 	qut.QuoteId=quote.Id;
	    qut.UnitPrice=80000;
	    qut.Quantity=2;
	    qut.PricebookEntryId=pbe.id;
		insert qut;
        qut.UnitPrice=200;
        update qut;
        qut.UnitPrice=225;
        update qut;
        qut.UnitPrice=25;
        update qut;
        delete qut;
	}
}