/**
*Dis: Trg_SNDetailsAddHis Test
*Time:2014年4月28日16:38:52
*Author:Gary Hu
**/
@isTest(SeeAllData=true)
private class Trg_SNDetailsAddHis_Test {

    static testMethod void myUnitTest() {
		RecordType rtp= [Select r.Name, r.Id, r.Description From RecordType r where Name='渠道代理商'];    		
        SalesRegion__c sc = new SalesRegion__c();   //销售区域
        sc.Name = '山东';
        insert sc;
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
		acc.dailishangshuxingField3__c='T1';
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
        oc.Name='vitovito订单1'; 
        oc.SalesOpportunities__c = opp.id; 
        insert oc; 
        Orders__c oc2 = new Orders__c();
	    oc2.Partners__c = acc.Id; 
        oc2.customer__c = acc.Id;
        oc2.Name='vitovito订单1'; 
        oc2.SalesOpportunities__c = opp.id; 
        insert oc2; 
   		OrderDetails__c oc1 = new OrderDetails__c();
    	oc1.n_OrderNo__c = oc.id;	
    	oc1.TestStatus__c='测试中'; 
	    insert oc1;
	    ProductSN__c psn = new ProductSN__c();
	    psn.Name = 'xxxxxxxxxxxxxxxx';
	    insert psn;
	    
	    ProductSNDetial__c psnD = new ProductSNDetial__c();
	    psnD.EndDate__c = Date.today().addDays(4);
	    psnD.StartDate__c = Date.today().addDays(1);
	    psnD.Remark__c='xxxx';
	    psnD.Order__c=oc.id;
	    psnD.ProductSN__c = psn.Id;
	    insert psnD;
	    psnD.EndDate__c = Date.today().addDays(2);
	    psnD.StartDate__c = Date.today().addDays(5);
	    psnD.Remark__c='xxxx';
	    psnD.Order__c=oc2.id;
	    update psnD;
	    
	    
    }
}