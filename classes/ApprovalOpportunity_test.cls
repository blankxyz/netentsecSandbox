/*
跨区报备的业务机会三天后自动审批通过

rogerSun 
982578975@qq.com
*/
@isTest(SeeAlldata=true)
private class ApprovalOpportunity_test 
{
    static testMethod void myUnitTest() 
    {
        SalesRegion__c SalesRegion=new SalesRegion__c();
        SalesRegion.Name='华北云计算事业部';
        insert SalesRegion;
		
		list<SalesRegion__c> listSalesRegion=new list<SalesRegion__c>([Select s.Id From SalesRegion__c s where s.Name in('上海办事处','北京办事处')]);
		system.debug('listSalesRegion is infor:'+listSalesRegion);
		Account acc=new Account();
		acc.Phone='25652855';
		acc.PrimaryIndustry__c='金融';
		acc.TwoIndustries__c='债券';
		acc.ThreeIndustries__c='银行';
		//acc.SellArea__c=SalesRegion.id;
		acc.Province__c='北京';
		acc.Name='客户test';
		acc.SellArea__c=listSalesRegion[0].Id;
		
		insert acc;
		system.debug('acc is infor:'+acc);
		//o.OppProperty__c='跨区报备'  and o.InterregionalApproval__c=true and o.Status__c='报备审批中'
		Opportunity opp = new Opportunity();
		opp.Name='业务机会test12';
		opp.StageName='初步';
		opp.CloseDate=Date.today();
		opp.AccountId=acc.Id;
		opp.SalesRegion__c=listSalesRegion[1].Id;
		opp.Status__c='状态test';
		opp.NeedSE__c=true;
		opp.TsEmail__c=null;
		opp.OppProperty__c='跨区报备';
		opp.InterregionalApproval__c=true;
		opp.Status__c='报备审批中';
		opp.ApprovalDate__c=datetime.valueOfGmt(string.valueOf(datetime.now())).addDays(-5);
		insert opp;
		
		ApprovalOpportunity LeadBatch = new ApprovalOpportunity();
   		Database.executeBatch(LeadBatch,50);
	 	string schLead=DateTime.now().second()+' '+DateTime.now().minute()+' '+DateTime.now().hour()+' * * ?';
    }
}