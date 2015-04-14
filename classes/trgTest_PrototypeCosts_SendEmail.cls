//PrototypeCosts_SendEmail的测试类
//lurrykong
//2013.5.14
@isTest(SeeAllData=true)
private class trgTest_PrototypeCosts_SendEmail {

    static testMethod void myUnitTest() 
    {
    	Profile profile=[Select p.Name, p.Id From Profile p where Name='Chatter External User'];
    	User userOff=new User();											 
	    userOff.Phone='87413065';   
	    userOff.MobilePhone='15167988026';
	    userOff.Username='LurryKong@fccz.com26';
	    userOff.Alias='DeLi';  //匿称
	    userOff.CommunityNickname='DeLi';//绰号
	    userOff.TimeZoneSidKey='Australia/Sydney';
	    userOff.LocaleSidKey='en_AU';
	    userOff.EmailEncodingKey='ISO-8859-1';
	    userOff.ProfileId=profile.Id;
	    userOff.LanguageLocaleKey='en_US';
	    userOff.FirstName='于';
	    userOff.LastName='NN';
	    userOff.Fax='0031388';
	    userOff.Email='dlwork123@163.com';
	    insert userOff;
	    
    	User userSe=new User();											 
	    userSe.Phone='8741306335';   
	    userSe.MobilePhone='15167988026';
	    userSe.Username='LiNing@SE.com';
	    userSe.Alias='LiNing';  //匿称
	    userSe.CommunityNickname='LiNing';//绰号
	    userSe.TimeZoneSidKey='Australia/Sydney';
	    userSe.LocaleSidKey='en_AU';
	    userSe.EmailEncodingKey='ISO-8859-1';
	    userSe.ProfileId=profile.Id;
	    userSe.LanguageLocaleKey='en_US';
	    userSe.FirstName='于';
	    userSe.LastName='NN';
	    userSe.Fax='0031388';
	    userSe.Email='LiNingwork123@163.com';
	    insert userSe;
 
    	SalesRegion__c salereg=new SalesRegion__c();
    	salereg.Name='北京办事处';
    	salereg.OfficeDirector__c=userOff.Id;
    	salereg.SEPersonInCharge__c=userSe.Id;
    	insert salereg;
    	
        PrototypeCosts__c proc=new PrototypeCosts__c();
        proc.n_Year__c='2013';
        proc.n_Month__c='1';
        proc.Quarter__c='第一季度';
        proc.n_SaleArea__c=salereg.Id;
        insert proc;
        proc.IfOverWeight50__c=true;
    	update proc;

    }
    static testMethod void myUnitTestTwo() 
    {
    	Profile profile=[Select p.Name, p.Id From Profile p where Name='Chatter External User'];
    	User userOff=new User();											 
	    userOff.Phone='87413065';   
	    userOff.MobilePhone='15167988026';
	    userOff.Username='LurryKong@fccz.com';
	    userOff.Alias='DeLi';  //匿称
	    userOff.CommunityNickname='DeLi';//绰号
	    userOff.TimeZoneSidKey='Australia/Sydney';
	    userOff.LocaleSidKey='en_AU';
	    userOff.EmailEncodingKey='ISO-8859-1';
	    userOff.ProfileId=profile.Id;
	    userOff.LanguageLocaleKey='en_US';
	    userOff.FirstName='于';
	    userOff.LastName='NN';
	    userOff.Fax='0031388';
	    userOff.Email='dlwork123@163.com';
	    insert userOff;
	    
    	User userSe=new User();											 
	    userSe.Phone='8741306335';   
	    userSe.MobilePhone='15167988026';
	    userSe.Username='LiNing@SE.com';
	    userSe.Alias='LiNing';  //匿称
	    userSe.CommunityNickname='LiNing';//绰号
	    userSe.TimeZoneSidKey='Australia/Sydney';
	    userSe.LocaleSidKey='en_AU';
	    userSe.EmailEncodingKey='ISO-8859-1';
	    userSe.ProfileId=profile.Id;
	    userSe.LanguageLocaleKey='en_US';
	    userSe.FirstName='于';
	    userSe.LastName='NN';
	    userSe.Fax='0031388';
	    userSe.Email='LiNingwork123@163.com';
	    insert userSe;
 
    	SalesRegion__c salereg=new SalesRegion__c();
    	salereg.Name='北京办事处';
    	salereg.OfficeDirector__c=userOff.Id;
    	salereg.SEPersonInCharge__c=userSe.Id;
    	insert salereg;
    	
        PrototypeCosts__c proc=new PrototypeCosts__c();
        proc.n_Year__c='2013';
        proc.n_Month__c='1';
        proc.Quarter__c='第一季度';
        proc.n_SaleArea__c=salereg.Id;
        insert proc;
    	proc.IfOverWeight80__c=true;
    	update proc;
    }
    static testMethod void myUnitTestThree() 
    {
    	Profile profile=[Select p.Name, p.Id From Profile p where Name='Chatter External User'];
    	User userOff=new User();											 
	    userOff.Phone='87413065';   
	    userOff.MobilePhone='15167988026';
	    userOff.Username='LurryKong@fccz.com';
	    userOff.Alias='DeLi';  //匿称
	    userOff.CommunityNickname='DeLi';//绰号
	    userOff.TimeZoneSidKey='Australia/Sydney';
	    userOff.LocaleSidKey='en_AU';
	    userOff.EmailEncodingKey='ISO-8859-1';
	    userOff.ProfileId=profile.Id;
	    userOff.LanguageLocaleKey='en_US';
	    userOff.FirstName='于';
	    userOff.LastName='NN';
	    userOff.Fax='0031388';
	    userOff.Email='dlwork123@163.com';
	    insert userOff;
	    
    	User userSe=new User();											 
	    userSe.Phone='8741306335';   
	    userSe.MobilePhone='15167988026';
	    userSe.Username='LiNing@SE.com';
	    userSe.Alias='LiNing';  //匿称
	    userSe.CommunityNickname='LiNing';//绰号
	    userSe.TimeZoneSidKey='Australia/Sydney';
	    userSe.LocaleSidKey='en_AU';
	    userSe.EmailEncodingKey='ISO-8859-1';
	    userSe.ProfileId=profile.Id;
	    userSe.LanguageLocaleKey='en_US';
	    userSe.FirstName='于';
	    userSe.LastName='NN';
	    userSe.Fax='0031388';
	    userSe.Email='LiNingwork123@163.com';
	    insert userSe;
 
    	SalesRegion__c salereg=new SalesRegion__c();
    	salereg.Name='北京办事处';
    	salereg.OfficeDirector__c=userOff.Id;
    	salereg.SEPersonInCharge__c=userSe.Id;
    	insert salereg;
    	
        PrototypeCosts__c proc=new PrototypeCosts__c();
        proc.n_Year__c='2013';
        proc.n_Month__c='1';
        proc.Quarter__c='第一季度';
        proc.n_SaleArea__c=salereg.Id;
        insert proc;
    	proc.IfOverWeight100__c=true;
    	update proc;
    }
}