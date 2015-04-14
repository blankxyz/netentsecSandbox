/**
*
*
 */
@isTest(SeeAllData=true)
private class cls_ContactBusiness_test {

    static testMethod void myUnitTest() {
    	
    	Profile profile=[Select p.Name, p.Id From Profile p where Name='Chatter External User'];
    	User user=new User();											 
	    user.Phone='87413065';   
	    user.MobilePhone='15167988026';
	    user.Username='LurryKong@fccz.com17';
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
		salesregion.Name='北京办事处';
		insert salesregion; 
		
    	Account acc=new Account();
        acc.Name='五粮液123';
        acc.Fax='8088';
        acc.Description='五粮液';
        acc.Phone='053187401697';
        acc.Industry='Finance';
        acc.Identity__c='钻石';
        acc.ChannelType__c='商业渠道';
       
        acc.PrimaryIndustry__c='金融';
		acc.TwoIndustries__c='债券';
		acc.ThreeIndustries__c='银行';
		acc.SellArea__c=SalesRegion.id;
		acc.Province__c='北京';
		acc.dailishangshuxingField3__c='T1';
        insert acc;
        
        ContactBusiness__c  c=new ContactBusiness__c();
				c.LastName__c='是东方红';
				c.EmailState__c='服务';
				c.QqNumber__c='982578975';
				c.Description__c='所有西你想';
				c.Phone__c='98765432123';
				c.Email__c='982578975@qq.com';
				c.AmountFans__c=12434;
				c.Account__c=acc.id;
				c.mediaName__c='sdfsf';
				c.MediaAccount__c='sdfas';
				c.OtherPhone__c='sdfqw';
				c.RealNameRegistration__c=true;
				c.IsMailAddress__c=true;
				c.MobilePhone__c='1234567890';
				c.Address__c='sdgfs';
				c.PostCard__c='sdfgc';
				c.Title__c='dsgsdf';
				c.Province__c='sdfsf';
				c.City__c='sdfas';
				c.Province__c='sdfsa';
				c.County__c='sdfgw';
				insert c;
    }
}