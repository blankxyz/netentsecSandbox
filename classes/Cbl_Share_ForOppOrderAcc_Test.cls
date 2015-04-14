/**
*Dis:Test Cbl_Share_ForOppOrderAcc
*Time:2015年3月16日16:02:28
*Author:Gary Hu
**/
@isTest(SeeAllData=true) 
public class Cbl_Share_ForOppOrderAcc_Test {
	 static testMethod void myUnitTest()
	 {
	 	Pricebook2 pricebook = [select Id from Pricebook2 where isStandard=true limit 1];   
    	list<RecordType> listrtpQuDao=[Select r.Name, r.Id, r.Description From RecordType r where DeveloperName='ChannelCustomers']; 
	 	list<RecordType> listrtptuiHuo= [Select r.Name, r.Id, r.Description From RecordType r where DeveloperName='RecordTypeByReturn'];
	 	list<RecordType> listrtquDaoY = [Select r.Name, r.Id, r.Description From RecordType r where DeveloperName='ChannelPrototypeOrders'];
	 	list<RecordType> listrtpxs= [Select r.Name, r.Id, r.Description From RecordType r where DeveloperName='salesOrders'];	
	 	list<RecordType> listrtswfp= [Select r.Name, r.Id, r.Description From RecordType r where DeveloperName='Taxbill' and SobjectType='bill_date__c'];	
	 	list<RecordType> listUnOrd= [Select r.Name, r.Id, r.Description,r.DeveloperName,r.SobjectType From RecordType r where DeveloperName='QXDD' and SobjectType='Orders__c'];			//取消订单 	
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
	    User user2=new User();											 
	    user2.Phone='87413065';   
	    user2.MobilePhone='15167988026';  
	    user2.Username='LurryKong@fccz.com16';
	    user2.Alias='DeLi';  //匿称
	    user2.CommunityNickname='xx';//绰号 
	    user2.TimeZoneSidKey='Australia/Sydney'; 
	    user2.LocaleSidKey='en_AU';
	    user2.EmailEncodingKey='ISO-8859-1';
	    user2.ProfileId=profile.Id;
	    user2.LanguageLocaleKey='en_US';
	    user2.FirstName='于';
	    user2.LastName='NN';
	    user2.Fax='0031388';
	    user2.Email='dlwork123@163.com';
	    insert user2;
	    
	    User user3=new User();											 
	    user3.Phone='87413065';   
	    user3.MobilePhone='15167988026';  
	    user3.Username='LurryKong@fccz.com17';
	    user3.Alias='DeLi';  //匿称
	    user3.CommunityNickname='888';//绰号 
	    user3.TimeZoneSidKey='Australia/Sydney'; 
	    user3.LocaleSidKey='en_AU';
	    user3.EmailEncodingKey='ISO-8859-1';
	    user3.ProfileId=profile.Id;
	    user3.LanguageLocaleKey='en_US';
	    user3.FirstName='于';
	    user3.LastName='NN';
	    user3.Fax='0031388';
	    user3.Email='dlwork123@163.com';
	    insert user3;
	    User user4=new User();											 
	    user4.Phone='87413065';   
	    user4.MobilePhone='15167988026';  
	    user4.Username='LurryKong@fccz.com66';
	    user4.Alias='DeLi';  //匿称
	    user4.CommunityNickname='cc';//绰号 
	    user4.TimeZoneSidKey='Australia/Sydney'; 
	    user4.LocaleSidKey='en_AU';
	    user4.EmailEncodingKey='ISO-8859-1';
	    user4.ProfileId=profile.Id;
	    user4.LanguageLocaleKey='en_US';
	    user4.FirstName='于';
	    user4.LastName='NN';
	    user4.Fax='0031388';
	    user4.Email='dlwork123@163.com';
	    insert user4;
	    
	    SalesRegion__c salesregion=new SalesRegion__c();
		salesregion.OfficeDirector__c=user.id;
		salesregion.Name='日本';
		
		insert salesregion;  
		
	    SalesRegion__c salesregion2=new SalesRegion__c();
		salesregion2.OfficeDirector__c=user2.id;
		salesregion2.Name='日本';
		insert salesregion2;  
        
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
        prod.MSHT__c='ICG';
        insert prod;

	    Orders__c orders=new Orders__c();
        orders.Name='testorders';
        orders.SalesOpportunities__c=opp.id;
        orders.Quote__c=quote.id;  
        orders.RecordTypeId=listrtptuiHuo[0].id;
        orders.customer__c = acc.Id;
        orders.SalesRegion__c=salesregion.Id;
        orders.Payer__c = acc.Id;
        orders.ReturnPayAccount__c = acc.id; 
        orders.ApprovalStatus__c ='已审批';
        orders.Partners__c = acc.id;
        //orders.FDJE__c = 200;
        orders.duiyingOSR__c = user2.Id;
        orders.dingdansuozaiquyu__c = salesregion.id;
   		insert orders;
   		
   		system.Test.startTest();
   		orders.duiyingOSR__c = user3.id;
   		orders.dingdansuozaiquyu__c = salesregion2.id;
   		update orders;
   		acc.SellArea__c = salesregion2.id;
   		update acc;
   		salesregion2.OfficeDirector__c = user4.Id;
   		salesregion.OfficeDirector__c = user3.Id;
   		
   		update salesregion2;
   		update salesregion;
   		
   		system.Test.stopTest();
   		
	 }
}