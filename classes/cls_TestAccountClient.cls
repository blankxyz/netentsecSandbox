//AccountClient的测试类
//vito he
//2013.6.14
@isTest(SeeAllData=true)
private class cls_TestAccountClient { 

	     static testMethod void myUnitTest() {
	     	 SalesRegion__c SalesRegion=new SalesRegion__c();
	        SalesRegion.Name='华北云计算事业部';
	        insert SalesRegion;
        
	     	list<Account> acclist = new list<Account>();
	        Account acc=new Account();
	        acc.Name='五粮液dd';
	        acc.Fax='8088';
	        acc.Description='五粮液ddd';
	        acc.Phone='053187401697';
	        acc.Industry='Finance'; 
	        acc.Whether__c=true; 
	        acc.Statues__c='未同步';
	        acc.IdentificationCode_c__c='08000701';
			acc.PrimaryIndustry__c='金融';
			acc.TwoIndustries__c='债券';
			acc.ThreeIndustries__c='银行';
			acc.SellArea__c=SalesRegion.id;
			acc.Province__c='北京';
	        acclist.add(acc);
	        Account acc2=new Account();
	        acc2.Name='五粮液fff';
	        acc2.Fax='80883';
	        acc2.Description='五粮液dddf';
	        acc2.Phone='053187401693';
	        acc2.Industry='Finances'; 
	        acc2.Whether__c=true; 
	        acc2.Statues__c='未同步';
	        acc2.IdentificationCode_c__c='08000702';
	        acc2.PrimaryIndustry__c='金融';
			acc2.TwoIndustries__c='债券';
			acc2.ThreeIndustries__c='银行';
			acc2.SellArea__c=SalesRegion.id;
			acc2.Province__c='北京';
	        acclist.add(acc2);
	        insert acclist; 
	        
	        list<Contact> listCon = new list<Contact>();
	        
	        Contact c1 = new Contact();
		    c1.AccountID = acc.id; 
		    c1.FirstName = 'test1';
		    c1.LastName = 'Contact';
		    listCon.add(c1);
		    Contact c2 = new Contact(); 
		    c2.AccountID = acc.id; 
		    c2.FirstName = 'test2';
		    c2.LastName = 'Contact';
		    listCon.add(c2);
		    Contact c3 = new Contact();
		    c3.AccountID = acc.id; 
		    c3.FirstName = 'test3';
		    c3.LastName = 'Contact';
		    listCon.add(c3);
	        insert listCon; 
			
	        list<string> idetif = new list<string>();
	        idetif.add('已同步+08000701');
	        idetif.add('已同步+08000702');

	        Test.setMock(WebServiceMock.class, new WebserviceMockImplCrmAccount());
			WsdlCrmAccount.ArrayOfString f = new WsdlCrmAccount.ArrayOfString();
	        f.string_x = idetif;  
	        AccountClient.updateStatuesData(f);
	        AccountClient.OrderAccountClient();
	      
	        AccountClient.AccountClientOperaton(acclist); 
	        AccountClient.contactClientOperaton(listCon);
	    }
}