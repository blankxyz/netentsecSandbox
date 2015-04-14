/*发票同步信息
*rogersun

*/
trigger Invoice on Invoice__c (before insert, before update) {
	set<string> setAccount=new set<string>();
	map<string,Account> mapAccount=new map<string,Account>();
	set<string> setInvoice=new set<string>();
	if(trigger.isBefore)
	{
		if(trigger.isInsert)
		{
			for(Invoice__c i:trigger.new)
			{
				if(i.Customer__c!=null)
				{
					setAccount.add(i.Customer__c);
					setInvoice.add(i.id);
				}
			}
		}
		else if(trigger.isUpdate)
		{
			for(Invoice__c i:trigger.new)
			{
				Invoice__c oldMap=trigger.oldMap.get(i.id);
				if(i.Customer__c!=oldMap.Customer__c)
				{
					setAccount.add(i.Customer__c);
					setInvoice.add(i.id);
				}
			}
			
		}
		if(setAccount!=null && setAccount.size()>0)
		{
			list<Account> listAccount=new list<Account>([select id,IdentificationCode_c__c,name from Account where IdentificationCode_c__c in:setAccount]);
			if(listAccount!=null && listAccount.size()>0)
			{
				for(Account a:listAccount)
				{
					if(!mapAccount.containsKey(a.IdentificationCode_c__c))
					{
						mapAccount.put(a.IdentificationCode_c__c,a);
					}
					
				}
				
			}
		}
		if(setInvoice!=null && setInvoice.size()>0)
		{
			list<Invoice__c> listInvoice=new list<Invoice__c>([select id,name,Customer__c from Invoice__c where id in:setInvoice]);
			for(Invoice__c i:listInvoice)
			{
				if(mapAccount.containsKey(i.Customer__c))
				{
					i.n_Customer__c=mapAccount.get(i.Customer__c).id;
				}
			}
			update listInvoice;
		}
		
	}
}