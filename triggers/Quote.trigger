/*
*业务机会所在部门为市场部的时候把报价上面的领导信息从客户所在区域代入
*/
trigger Quote on Quote (after insert,after update) {
	if(trigger.isAfter && trigger.isInsert)
	{
		set<string> setId = new set<string>();
		
		for(Quote q: trigger.new)
		{
			if(q.department1__c == '市场部')
			{
				setId.add(q.Id);	
			}
			
		}
		if(setId != null && setId.size() > 0)
		{
			GetDelment(setId);
		}
		
	}
	if(trigger.isAfter && trigger.isUpdate)
	{
		set<string> setId = new set<string>();
		
		for(Quote q: trigger.new)
		{
			Quote qq = trigger.oldMap.get(q.id);
			if(q.department1__c != qq.department1__c)
			{
				setId.add(q.Id);
				system.debug('setId is infor:'+setId);
			}
			
		}
		if(setId != null && setId.size() > 0)
		{
			GetDelment(setId);
		}
	}
	public void GetDelment(set<string> setId)
	{
		
		list<Quote> listQuote = new list<Quote>([
		Select q.SalesVp__c, 
		q.Opportunity.AcountcAear__c, 
		q.Opportunity.AccountId, 
		q.OpportunityId, 
		q.OfficeDirector__c, 
		q.OfficeAdm__c,
		q.Opportunity.SalesRegion__c,
		q.Id,
		q.FinancialVp__c 
		
		From Quote q
		where q.Id in: setId
		
		]);
		set<string> setDepId = new set<string>();
		for(Quote q: listQuote)
		{
			setDepId.add(q.Opportunity.AcountcAear__c);
			setDepId.add(q.Opportunity.SalesRegion__c);
		}
		if(setDepId != null && setDepId.size()>0)
		{
			list<SalesRegion__c> listSalesRegion = new list<SalesRegion__c>([
				Select s.SalesVp__c, 
				s.IsDeleted, 
				s.Id, 
				s.Name,
				s.OfficeDirector__c,
				s.FinancialVp__c 
				From SalesRegion__c s
				where s.IsDeleted = false
				and s.Id in: setDepId
				
			]);
			map<string,SalesRegion__c> mapSalesRegion = new map<string,SalesRegion__c>();
			for(SalesRegion__c s: listSalesRegion)
			{
				
				mapSalesRegion.put(s.id,s);
			}	
			
			for(Quote q: listQuote)
			{
				if(mapSalesRegion.containsKey(q.Opportunity.AcountcAear__c))
				{
					SalesRegion__c SalesRegion = mapSalesRegion.get(q.Opportunity.AcountcAear__c);
					q.OfficeDirector__c = SalesRegion.OfficeDirector__c; //q.Opportunity.AcountcAear__c
					q.SalesVp__c = SalesRegion.SalesVp__c;
					q.FinancialVp__c = SalesRegion.FinancialVp__c;
					if( mapSalesRegion.containsKey(q.Opportunity.SalesRegion__c))
					{
						q.OfficeAdm__c =  mapSalesRegion.get(q.Opportunity.SalesRegion__c).OfficeDirector__c;
					}
						
					
				}
				
			}
			update listQuote;
		}
	
	}
}