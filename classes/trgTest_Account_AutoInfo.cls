/**
*Test:Account_AutoInfo
*Author:Gary_Hu
*Time:2013年3月28日18:01:36
**/
@isTest(SeeAllData=true)
public with sharing class trgTest_Account_AutoInfo {
	static	testMethod void myUnitTestC(){
	    Pricebook2 pricebook = [select Id from Pricebook2 where isStandard=true limit 1];
    	Profile profile=[Select p.Name, p.Id From Profile p where Name='Chatter External User'];
        list<RecordType> listrtp=[Select r.Name, r.Id, r.Description From RecordType r where Name='渠道代理商']; 
        
        list<RecordType> listrtF=[Select r.Name, r.Id, r.Description From RecordType r where Name='最终客户']; 

    	
    	list<Orders__c> listord=new list<Orders__c>();
    	 
    	User user=new User();											 
	    user.Phone='87413065';   
	    user.MobilePhone='15167988026';
	    user.Username='LurryKong@fccz.com9';
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
        acc.SEchange__c = true;
        acc.PrimaryIndustry__c='金融';
		acc.TwoIndustries__c='债券';
		acc.ThreeIndustries__c='银行';
		acc.SellArea__c=SalesRegion.id;
		acc.Province__c='北京';
        insert acc;
        Contact   c = new Contact();
        c.FirstName = 'xx';
        c.LastName = 'xx';
        c.AccountId = acc.Id;
        c.InvoiceAddress__c = 'InvoiceAddress__c';
        c.MobilePhone = '15116216685';
        c.Phone = '073190909088';
        insert c;
        acc.LinkName__c = c.id;
        update acc;
        
        Account accf=new Account();
        accf.Name='五粮液';
        accf.Fax='8088';
        accf.Description='五粮液';
        accf.Phone='053187401697';
        accf.Industry='Finance';
        accf.RecordTypeId=listrtF[0].id;
        accf.PrimaryIndustry__c='金融';
		accf.TwoIndustries__c='债券';
		accf.ThreeIndustries__c='银行';
		accf.SellArea__c=SalesRegion.id;
		accf.Province__c='北京';
        accf.SEchange__c = true;
        try {
			insert accf;
		
		}catch (Exception e){
			
		}
        
	}
	static testMethod void myUnitTestAinfo(){
		SalesRegion__c salesregion=new SalesRegion__c();
		salesregion.Name='日本';
		insert salesregion;    
		Account accountA = new Account();
		accountA.Name='test客户重复';
		accountA.PrimaryIndustry__c='金融';
		accountA.TwoIndustries__c='债券';
		accountA.ThreeIndustries__c='银行';
		accountA.SellArea__c=SalesRegion.id;
		accountA.Province__c='北京';
		accountA.Phone='12345678';
		insert accountA;
		Account accountB = new Account();
		accountB.PrimaryIndustry__c='金融';
		accountB.TwoIndustries__c='债券';
		accountB.ThreeIndustries__c='银行';
		accountB.SellArea__c=SalesRegion.id;
		accountB.Province__c='北京';
		accountB.Name = 'test客户重复';
		accountB.Phone='12345678';
		try {
			insert accountB;
			delete accountB;
		}catch (Exception e){
			
		}
		delete accountA;
		
	}
	static	testMethod void myUnitTestF(){
	    Pricebook2 pricebook = [select Id from Pricebook2 where isStandard=true limit 1];
    	Profile profile=[Select p.Name, p.Id From Profile p where Name='Chatter External User'];
        list<RecordType> listrtp=[Select r.Name, r.Id, r.Description From RecordType r where Name='最终客户']; 

    	
    	list<Orders__c> listord=new list<Orders__c>();
    	 
    	User user=new User();											 
	    user.Phone='87413065';   
	    user.MobilePhone='15167988026';
	    user.Username='LurryKong@fccz.com10';
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
        acc.SEchange__c = true;
        acc.PrimaryIndustry__c='金融';
		acc.TwoIndustries__c='债券';
		acc.ThreeIndustries__c='银行';
		acc.SellArea__c=SalesRegion.id;
		acc.Province__c='北京';
        insert acc;
	}
	
}