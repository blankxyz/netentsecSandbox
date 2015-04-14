/**
*Test:InvoiceDetails_ForAutoInsert
*Author:Gary_Hu
*Time:2013年5月10日10:28:06
*/
@isTest(SeeAllData=true)
private class trgTest_InvoiceDetails_ForAutoInsert {

    static testMethod void myUnitTest() {
        Pricebook2 pricebook = [select Id from Pricebook2 where isStandard=true limit 1];
    	Profile profile=[Select p.Name, p.Id From Profile p where Name='Chatter External User'];
        list<RecordType> listrtp=[Select r.Name, r.Id, r.Description From RecordType r where Name='渠道代理商']; 
	 	list<RecordType> listrtpSales= [Select r.Name, r.Id, r.Description From RecordType r where Name='销售订单'];
    	list<RecordType> listrtpYaHuo= [Select r.Name, r.Id, r.Description From RecordType r where Name='压货订单'];
    	
    	list<Orders__c> listord=new list<Orders__c>();
    	 
    	User user=new User();											 
	    user.Phone='87413065';   
	    user.MobilePhone='15167988026';
	    user.Username='LurryKong@fccz.com13';
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
        acc.RecordTypeId=listrtp[0].id;
        acc.PrimaryIndustry__c='金融';
		acc.TwoIndustries__c='债券';
		acc.ThreeIndustries__c='银行';
		acc.SellArea__c=SalesRegion.id;
		acc.Province__c='北京';
        insert acc;

    	  
			
	    SalesTargets__c salesT = new SalesTargets__c();
	    salesT.n_customerName__c = acc.Id;
	    salesT.AQuarterOFtasks__c = 0;
	    salesT.AQuarterOFtasks2__c = 0;
	    salesT.AQuarterOFtasks3__c = 0;
	    salesT.AQuarterOFtasks4__c = 0;
	    salesT.QuarterOFtasks1__c = 0;
	    salesT.QuarterOFtasks2__c= 0;
	    salesT.QuarterOFtasks3__c =0;
	    salesT.QuarterOFtasks4__c =0;
	    salesT.n_customerName__c = acc.id;
		salesT.Year__c = '2013';
	    insert salesT;
	    
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
        quote.yanhoukaipiaoliyouField3__c='延后开票';
        insert quote;
        
        Orders__c orders=new Orders__c();
        orders.Name='testorders';
        orders.SalesOpportunities__c=opp.id;
        orders.Quote__c=quote.id;  
        orders.RecordTypeId=listrtpSales[0].id;
        orders.customer__c = acc.Id;
        orders.Partners__c = acc.Id;
   		insert orders;

   		
   		Invoice__c inv = new Invoice__c();
   		inv.Name = '00001';
   		inv.n_InvoiceDate__c = Date.valueOf('2013-03-08');
   		insert inv;
   		
   		
   		
   		InvoiceDetails__c inD = new InvoiceDetails__c(); //发票明细
		inD.n_InvoiceId__c = inv.Id;
		inD.OrderId__c =  orders.Id;
		inD.InvisSale__c = 	orders.isSale__c;
		inD.InvoiceYear__c = String.valueOf(inv.n_InvoiceDate__c.year());
		inD.InvoicesCustomers__c = acc.Id;
		try
		{
			insert inD;
		}catch(Exception e){
			
		}
		
   		
   		Orders__c ordersSeven=new Orders__c();
        ordersSeven.Name='testorders';
        ordersSeven.SalesOpportunities__c=opp.id;
        ordersSeven.Quote__c=quote.id;  
        ordersSeven.RecordTypeId=listrtpYaHuo[0].id;
        ordersSeven.customer__c = acc.Id;
   		listord.add(ordersSeven);
   		
    }
}