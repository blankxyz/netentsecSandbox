/*
*客户所在部门变更后手动点击按钮，变更业务机会客户所在区域
*/

global class  Cls_OppCustomerDepartment
{

	webservice static string OrderOperate(string ordersId,string AccountId)
	{
		system.debug('传入值：'+ordersId+','+AccountId);
		map<id,Account> mapAccount = new map<id,Account>([
														Select a.SellArea__r.OperationsAssistant__c, 
														a.SellArea__r.OfficeDirector__c, 
														a.SellArea__c, 
														a.IsDeleted, 
														a.Id 
														From Account a
														where a.IsDeleted = false
														and a.Id =: AccountId
														]);
		system.debug('客户信息值：'+mapAccount);
		list<Opportunity>  listOpportunity = new  list<Opportunity>([
																	Select o.IsDeleted, 
																	o.Id, 
																	o.AcountcAear__c, 
																	o.AccountId, 
																	o.AccAearMan__c, 
																	o.AccAearCha__c 
																	From Opportunity o
																	where o.Id =: ordersId
																	and o.IsDeleted = false
																	]);		
		system.debug('业务机会信息值：'+listOpportunity);															
		if(listOpportunity != null && listOpportunity.size() > 0 )
		{
			for(Opportunity opp: listOpportunity)
			{
				if(mapAccount.containsKey(opp.AccountId))
				{
					opp.AcountcAear__c = mapAccount.get(opp.AccountId).SellArea__c;
					opp.AccAearCha__c = mapAccount.get(opp.AccountId).SellArea__r.OfficeDirector__c;
					opp.AccAearMan__c = mapAccount.get(opp.AccountId).SellArea__r.OperationsAssistant__c;
				}
				
			}
			system.debug('业务机会信息值要修改的：'+listOpportunity);	
			update listOpportunity;
		}									
		return null;
	}	
}