/**
*Test:trgTest_Order_Payer
*Author:Vito_He
*Time:2013年4月28日16:01:21
**/
@isTest(SeeAllData=true)
private class trgTest_Order_Payer {
	
    static testMethod void myUnitTest() {
		
		SalesRegion__c sc = new SalesRegion__c();   //销售区域
        sc.Name = '山东';
        insert sc;
		RecordType rtp= [Select r.Name, r.Id, r.Description From RecordType r where Name='渠道代理商'];    		
        Account acc=new Account();
	    acc.Name='五粮液';
	    acc.Fax='8088';
	    acc.Description='五粮液';
	    acc.Phone='053187401697';
	    acc.Industry='Finance';
	    acc.RecordTypeId=rtp.id;
	    acc.PrimaryIndustry__c='金融';
		acc.TwoIndustries__c='债券';
		acc.ThreeIndustries__c='银行';
		acc.SellArea__c=sc.id;
		acc.Province__c='北京';
	    insert acc;
		
        
        
        Opportunity opp=new Opportunity(); 
	    opp.Name='玩具';
	    opp.Description='业务机会';
	    opp.CloseDate=date.today(); 
	    opp.AccountId=acc.Id;
	    opp.StageName='开拓';
	    opp.Probability=100;					//可行性
	    opp.SalesRegion__c=sc.id;
	    insert opp;
        
        Orders__c oc = new Orders__c();
        oc.Partners__c = acc.Id; 
        oc.customer__c = acc.Id;
        oc.Name='vitovito订单'; 
        oc.SalesOpportunities__c = opp.id; 
        insert oc; 
    }
}