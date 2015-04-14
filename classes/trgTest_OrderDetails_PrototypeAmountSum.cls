/**
*Test:OrderDetails_PrototypeCostAmountSum
*Author:Vito_He
*Time:2013年5月13日09:43:21
**/
@isTest(SeeAllData=true)
private class trgTest_OrderDetails_PrototypeAmountSum {

    static testMethod void myUnitTest() {
    	
        Pricebook2 pricebook = [select Id from Pricebook2 where isStandard=true limit 1];   
    	list<RecordType> listrtp= [Select r.Name, r.Id, r.Description From RecordType r ];
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
    	
    	Profile profile=[Select p.Name, p.Id From Profile p where Name='Chatter External User'];
    	User user=new User();											 
	    user.Phone='87413065';   
	    user.MobilePhone='15167988026';
	    user.Username='LurryKong@fccz.com19';
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
        
        SalesRegion__c salesregion=new SalesRegion__c();
		salesregion.OfficeDirector__c=user.id;
		salesregion.OperationsAssistant__c = user.id;
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
        
        Product2 product=new Product2();						//产品
       	product.Name='prodone';
        product.n_Unit__c='个';									//计量单位
        insert product;
        
	    Orders__c orders=new Orders__c();
        orders.Name='testorders';
        orders.SalesOpportunities__c=opp.id;
        orders.RecordTypeId=listrtpInside.id;
        orders.customer__c = acc.Id;
        orders.SalesRegion__c=salesregion.Id;
        insert orders;
       
   		
   		 
   		list<OrderDetails__c> listOrderdetail=new list<OrderDetails__c>();
    	OrderDetails__c ordetail=new OrderDetails__c();
    	ordetail.n_OrderNo__c=orders.id;
    	ordetail.n_ProCount__c=1;
    	ordetail.PracticalExpectPrice__c = 5000; 
    	ordetail.n_ProductByOrd__c = product.id;
    	listOrderdetail.add(ordetail); 
    	
    	OrderDetails__c ordetail2=new OrderDetails__c();
    	ordetail2.n_OrderNo__c=orders.id;
    	ordetail2.n_ProCount__c=1;
    	ordetail2.n_ProductByOrd__c = product.id;
    	ordetail2.PracticalExpectPrice__c = 5000;
    	listOrderdetail.add(ordetail2);
    	
    	OrderDetails__c ordetail3=new OrderDetails__c();
    	ordetail3.n_OrderNo__c=orders.id;
    	ordetail3.n_ProCount__c=1;
    	ordetail3.PracticalExpectPrice__c = 5000;
    	ordetail3.n_ProductByOrd__c = product.id;
    	listOrderdetail.add(ordetail3);
    	insert listOrderdetail;
    	
    	
    	//订单明细sn
    	list<OfYahuoTurnSeller__c> sns = new list<OfYahuoTurnSeller__c>();
    	OfYahuoTurnSeller__c osn1 = new OfYahuoTurnSeller__c();
    	osn1.orders__c = ordetail.id;
    	sns.add(osn1);
    	OfYahuoTurnSeller__c osn2 = new OfYahuoTurnSeller__c();
    	osn2.orders__c = ordetail2.id; 
    	sns.add(osn2);
    	OfYahuoTurnSeller__c osn3 = new OfYahuoTurnSeller__c();
    	osn3.orders__c = ordetail3.id;
    	sns.add(osn3);  
    	insert sns;
    	
    	//样机费用指标
    	test.startTest(); 
    	list<PrototypeCosts__c> proList = new list<PrototypeCosts__c>();
    	PrototypeCosts__c pro1 = new PrototypeCosts__c();
    	pro1.n_SaleArea__c = salesregion.id;
    	pro1.n_BudgetAmount__c = 5000;
    	pro1.n_Year__c = '2013';
    	pro1.n_Month__c = '1';
    	pro1.Quarter__c = '第一季度'; 
    	proList.add(pro1);
    	
    	PrototypeCosts__c pro2 = new PrototypeCosts__c();                   //15000
    	pro2.n_SaleArea__c = salesregion.id;
    	pro2.n_BudgetAmount__c = 5000;
    	pro2.n_Year__c = '2013';
    	pro2.n_Month__c = '2';
    	pro2.Quarter__c = '第一季度';
    	proList.add(pro2);  
    	
    	PrototypeCosts__c pro3 = new PrototypeCosts__c();
    	pro3.n_SaleArea__c = salesregion.id;
    	pro3.n_BudgetAmount__c = 5000;
    	pro3.n_Year__c = '2013';
    	pro3.n_Month__c = '3'; 
    	pro3.Quarter__c = '第一季度';
    	proList.add(pro3);
    	insert proList;
    	
       
    	  
    	list<OrderDetails__c> updetail=new list<OrderDetails__c>();
    	ordetail.BorrowerReceiptDate__c=date.valueOf('2012-2-2');
    	updetail.add(ordetail);
    	ordetail2.BorrowerReceiptDate__c=date.valueOf('2012-2-2');
    	updetail.add(ordetail2);
    	ordetail3.BorrowerReceiptDate__c=date.valueOf('2012-2-2'); 
    	updetail.add(ordetail3); 
    	update updetail;
    	
    	delete updetail; 
    	test.stopTest();
    }
}