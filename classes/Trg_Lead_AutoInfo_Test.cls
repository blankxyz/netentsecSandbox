/**
*Dis: Trg_Lead_AutoInfo_Test
*Author:Gary_Hu
*Time:2014年3月14日14:49:58
*/
@isTest
private class Trg_Lead_AutoInfo_Test {

    static testMethod void myUnitTest() {
    	RecordType rType = [select Id from RecordType where DeveloperName = 'Autonomous'];
    	Profile profile=[Select p.Name, p.Id From Profile p where Name='标准用户'];
    	User u = [select Id from User where id =: UserInfo.getUserId()];
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
	    insert user;
    	
		// 任务和活动为空
    	Lead lead = new Lead();
    	lead.LastName = 'test渠道代理商';
    	lead.Company = 'testCompany';
    	lead.RecordTypeId = rType.Id;
    	lead.OwnerId = u.id;
    	lead.IsConverted = false;
    	insert lead;
    	
    	
    	
    	lead.OwnerId = user.Id;
    	update lead;
    	
    	
    }
}