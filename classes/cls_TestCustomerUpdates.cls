/*
*RogerSun
*2013-05-23
*CustomerUpdates的测试类
*/
@isTest(SeeAllData=true)
private class cls_TestCustomerUpdates
{
	static testMethod void CustomerUpdatesTest()
	{
	
		//system.Test.startTest();
		
		 //Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
		 //Test.setMock(WebServiceMock.class,new WSDLUpdateClient.UpdateClientSoap());
	    RecordType rtp= [Select r.Name, r.Id, r.Description From RecordType r where Name='渠道代理商']; 
		Account account=new Account();
		account.TaxId_c__c='sh0001';
		account.RecordTypeId=rtp.id;
		account.Province__c='北京'; 
		account.PrimaryIndustry__c='IT';
		account.Name='北京肯德基中央一号店';
		account.Corporate_c__c='公司法人';
		account.Whether__c=true;
		insert account;
		
		Account a=new Account();
		a.TaxId_c__c='sh0002';
		a.RecordTypeId=rtp.id;
		a.Province__c='北京'; 
		a.PrimaryIndustry__c='IT';
		a.Name='北京肯德基中央二号店';
		a.Corporate_c__c='公司法人测试';
		a.Whether__c=true;
		insert a;
		list<Account> ATestAccount=[Select a.Id,a.TaxId_c__c, a.Kundtypklassificering__c, a.Province__c, a.PrimaryIndustry__c, a.Name, a.CreatedDate, a.Corporate_c__c From Account a where a.Whether__c=true and (a.IdentificationCode_c__c=null or a.IdentificationCode_c__c='')];
		WSDLUpdateClient.UpdateClientSoap tt =  new WSDLUpdateClient.UpdateClientSoap();
			list<WSDLUpdateClient.CustomArray> dd=CustomerUpdates.approOrderConvert(ATestAccount); 
			
			 WSDLUpdateClient.ArrayOfCustomArray aa=new WSDLUpdateClient.ArrayOfCustomArray();	
			 aa.CustomArray=(WSDLUpdateClient.CustomArray[])dd;
			 system.debug('获取salesforce数据库查询出满足条件值 :'+aa);
		     WSDLUpdateClient.ArrayOfString f=new WSDLUpdateClient.ArrayOfString();
		     string aswe;
		     list<string> jhg=new list<string>();
		     for(Account c:ATestAccount)
		     {
		     	string adv=null;
		     	adv='qwasds'+'+'+c.Id;
		     	if(aswe!=null && aswe!='')
		     	{
		     		aswe=adv;
		     	}
		     	else
		     	{
		     		aswe=aswe+','+adv;
		     	}
		     }
		     list<string> axs=new list<string>();
		     axs.add(aswe);
		     f.string_x=axs;
		     system.debug('获取WSDLUpdateClient中CustomersByValue方法返回值赋值给f :'+f);
		      tt.timeout_x=120000;
		      if(f.string_x.size()>0)
		      {
		      	 CustomerUpdates.Operator(f);	
		      }
		
 	    CustomerUpdates LeadBatch = new CustomerUpdates();
   		Database.executeBatch(LeadBatch,50);
	 	string schLead=DateTime.now().second()+' '+DateTime.now().minute()+' '+DateTime.now().hour()+' * * ?';
		
   		//system.Test.stopTest();
	}
}