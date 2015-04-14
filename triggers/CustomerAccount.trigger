trigger CustomerAccount on CustomerAccount__c (After Insert) {
	if(trigger.isAfter)
	{
		if(trigger.isInsert)
		{
			list<Account> listAccount=new list<Account>();
			//list<RecordType> listRecordType=new list<RecordType>([Select r.Name, r.DeveloperName, r.Description, r.BusinessProcessId From RecordType r where r.DeveloperName='customer']);
			for(CustomerAccount__c a:trigger.new)
			{
				Account acc=new Account();
				acc.AddressNote__c=a.AddressNote__c;
				acc.AddressType__c=a.AddressType__c;
				acc.Email__c=a.Email__c;
				acc.dailishangshuxingField3__c=a.dailishangshuxingField3__c;
				acc.Phone=a.Phone__c;
				acc.TwoIndustries__c=a.TwoIndustries__c;
				acc.ThreeIndustries__c=a.ThreeIndustries__c;
				acc.RecordTypeId=a.AccountType__c;
				acc.CustomerServiceLevel__c=a.CustomerServiceLevel__c;
				acc.PrimaryIndustry__c=a.PrimaryIndustry__c;
				acc.Identity__c=a.Identity__c;
				acc.County__c=a.County__c;
				acc.ChannelType__c=a.ChannelType__c;
				if(a.IsService__c=='true')
				{
					acc.IsServiceProvider__c=true;
				}
				else
				{
					acc.IsServiceProvider__c=false;
				}
				acc.IsMailAddress__c=a.IsMailAddress__c;
				acc.SellArea__c=a.SellArea__c;
				acc.City__c=a.City__c;
				acc.Province__c=a.Province__c;
				acc.DetailedAddress__c=a.DetailedAddress__c;
				acc.Influence__c=a.Influence__c;
				acc.Name=a.Name;
				listAccount.add(acc);
			}
			insert listAccount;
		}
	}
    
}