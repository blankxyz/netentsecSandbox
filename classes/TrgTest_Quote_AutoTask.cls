/**
*Quote_AutoTask Test
*Author:Gary Hu
*Time:2014年5月28日16:52:07
**/
@isTest(SeeAlldata=true)
private class TrgTest_Quote_AutoTask {

    static testMethod void myUnitTest() {
		Profile profile=[Select p.Name, p.Id From Profile p where Name='标准用户'];
		Pricebook2 pricebook = [select Id from Pricebook2 where isStandard=true limit 1];
    	User user=new User();											 
	    user.Phone='87413065';   
	    user.MobilePhone='15167988026';
	    user.Username='LurryKong@fccz.com933';
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
	    user.IsActive = true;
	    user.EventToRemind__c = true;
	    user.SpecialRemind__c = true;
	    insert user;
		
		SalesRegion__c sr=new SalesRegion__c();
		sr.Name='销售区域test';
		sr.OfficeDirector__c=UserInfo.getUserId();
		sr.OperationsAssistant__c=UserInfo.getUserId();
		insert sr;
		
		Account acc=new Account();
		acc.Name='客户test';
		acc.PrimaryIndustry__c='金融';
		acc.TwoIndustries__c='债券';
		acc.ThreeIndustries__c='银行';
		acc.SellArea__c=sr.id;
		acc.Province__c='北京';
		acc.Phone='456987524';
		acc.PrimaryIndustry__c='金融';
		acc.TwoIndustries__c='债券';
		acc.ThreeIndustries__c='银行';
		acc.SellArea__c=sr.id;
		acc.Province__c='北京';
		insert acc;
		
		
		
		Opportunity opp = new Opportunity();
		opp.Name='业务机会test';
		opp.StageName='初步';
		opp.CloseDate=Date.today();
		opp.AccountId=acc.Id;
		opp.SalesRegion__c=sr.Id;
		opp.Status__c='状态test';
		opp.NeedSE__c=true;
		opp.TsEmail__c=null;
		insert opp;
		
		Opportunity opp1 = new Opportunity();
		opp1.Name='业务机会test1';
		opp1.StageName='初步1';
		opp1.CloseDate=Date.today();
		opp1.Status__c='test报备状态';
		
		
		Employee__c d = new Employee__c();
		d.n_EmployeeAear__c = sr.Id;
		d.n_EmployeeName__c = user.Id;
		d.n_salesDeputy__c = user.Id;
		insert d;
		
		Opportunity opp2 = new Opportunity();
		opp2.Name='业务机会test';
		opp2.StageName='初步';
		opp2.CloseDate=Date.today();
		opp2.AccountId=acc.Id;
		opp2.SalesRegion__c=sr.Id;
		opp2.Status__c='状态test';
		opp2.NeedSE__c=true;
		opp2.TsEmail__c=null; 
		opp2.OwnerId = user.Id;
		insert opp2;

		Quote quote=new Quote();
        quote.OpportunityId=opp2.Id;
        quote.Pricebook2Id=pricebook.Id;
        quote.Name='报价';
        quote.Status='草稿';
        quote.Orders__c=false;
        quote.yanhoukaipiaoliyouField3__c='延后开票';
        insert quote;  
		quote.Status = '审批中';
		update quote;
		
				
		
		
		
		
    }
}