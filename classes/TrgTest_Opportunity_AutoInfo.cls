/*
*功能：测试触发器Opportunity_AutoInfo
*作者：Alisa
*时间：2013年5月16日
*/
@isTest(SeeAlldata=true)
public class TrgTest_Opportunity_AutoInfo {
	static testMethod void myUnitTest(){
		Profile profile=[Select p.Name, p.Id From Profile p where Name='标准用户'];
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
		opp2.Status__c = '报备审批中';
		update opp2;
		
		
		
		try{
			insert opp1;
		}catch(Exception e){
			
		}
		
		
		opp.TsEmail__c=acc.CustomerEngineer__r.Email;
		opp.StageName='丢单';
		opp.Reason__c=null;
		
		try{
			update opp;
			
		}catch(Exception e){
			
		}
	}
}