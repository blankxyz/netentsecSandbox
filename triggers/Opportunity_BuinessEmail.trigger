//编辑业务机会,更改字段,发送邮件
//lurrykong	销售区域 SalesRegion
//2013.3.8
trigger Opportunity_BuinessEmail on Opportunity (after update){
	
	if(trigger.isAfter&&trigger.isUpdate)
	{
		set<id> setOppid=new set<id>();
		list<Opportunity> listOpp=new list<Opportunity>();
		list<Quote> listQuote=new list<Quote>();
		
		list<Quote> listupQuote=new list<Quote>(); 
		
		for(Opportunity opp:trigger.new)
		{
			Opportunity oldOpp=trigger.oldMap.get(opp.id);
			if(oldOpp.StageName!=opp.StageName&&opp.StageName=='关单')				//前后阶段不同,变为关单	
			{
				setOppid.add(opp.id);
			}
		}
		//id,阶段
		listOpp=[select id,StageName,Name from Opportunity where id=:setOppid];
		//id,报价编号,报价Name,是否通知商务下订单,业务机会id
		listQuote=[select id,QuoteNumber,Name,Orders__c,OpportunityId,Status from Quote where OpportunityId=:setOppid ];
		system.debug('..................listQuote.......................'+listQuote);
		map<id,list<Quote>> maplistQuote=new map<id,list<Quote>>();
		//含未批准报价业务机会
		set<id> setNotAppOppid=new set<id>();
		
		if(listQuote.size()>0)
		{
			for(Quote quoteDetail :listQuote)
			{
				if(quoteDetail.Status != '已批准'){
					setNotAppOppid.add(quoteDetail.OpportunityId);
				}
			}
			for(Opportunity opp:trigger.new){
				if(setNotAppOppid.contains(opp.Id)){
					opp.addError('含未批准报价，业务机会无法关闭');	
				}
			}
			for(Quote quote:listQuote)
			{
				if(!setNotAppOppid.contains(quote.OpportunityId)){
					if(!maplistQuote.containsKey(quote.OpportunityId))
					{
						list<Quote> childlistquote=new list<Quote>();
						childlistquote.add(quote);
						maplistQuote.put(quote.OpportunityId,childlistquote);
					}
					else
					{
						list<Quote> childlistquote=maplistQuote.get(quote.OpportunityId);
						childlistquote.add(quote);
					}
				}
			}	
		}
		for(Opportunity opp:listOpp)		
		{
			if(maplistQuote.containsKey(opp.id))
			{
				list<Quote> lisquote=maplistQuote.get(opp.id);
				if(listquote.size()>0)
				{
					for(Quote quote:listquote)
					{
						quote.Orders__c=true;
						listupQuote.add(quote);
					}
				}
			}
		}
		update listupQuote;
	}
}