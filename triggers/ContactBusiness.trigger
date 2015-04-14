trigger ContactBusiness on ContactBusiness__c (after insert) {
	if(trigger.isAfter)
	{
		if(trigger.isInsert)
		{
			list<Contact> listContact=new list<Contact>();
			for(ContactBusiness__c c:trigger.new)
			{
				Contact  ci=new Contact();
				ci.LastName=c.LastName__c;
				ci.EmailState__c=c.EmailState__c;
				ci.QqNumber__c=c.QqNumber__c;
				ci.Description=c.Description__c;
				ci.Phone=c.Phone__c;
				ci.Email=c.Email__c;
				ci.AmountFans__c=c.AmountFans__c;
				ci.AccountId=c.Account__c;
				ci.mediaName__c=c.mediaName__c;
				ci.MediaAccount__c=c.MediaAccount__c;
				ci.OtherPhone=c.OtherPhone__c;
				ci.RealNameRegistration__c=c.RealNameRegistration__c;
				ci.IsMailAddress__c=c.IsMailAddress__c;
				ci.MobilePhone=c.MobilePhone__c;
				ci.Address__c=c.Address__c;
				ci.PostCard__c=c.PostCard__c;
				ci.Title=c.Title__c;
				ci.Province__c=c.Province__c;
				ci.City__c=c.City__c;
				ci.Province__c=c.Province__c;
				ci.County__c=c.County__c;
				
				listContact.add(ci);
				
			}
			insert listContact;
		}
	}
}