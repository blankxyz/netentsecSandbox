//业绩核算对象的"拆分比例"随 订单对象的"订单金额"变化而变化
//lurrykong
//2013.07.01
trigger Orders_UpdateOrderAmount on Orders__c (after update) 
{
	if(trigger.isAfter)
	{ 
		set<id> setOrd=new set<id>();
		for(Orders__c orders:trigger.new)
		{
			Orders__c oldord=trigger.oldMap.get(orders.id);
			if(oldord.OrderAmount__c!=orders.OrderAmount__c&&orders.OrderAmount__c!=null)
				setOrd.add(orders.id);							
		}
		if(setOrd.size()>0)
		{			
			//业绩核算,订单金额,订单,拆分比例,分配金额
			list<Accounting__c> listActing=[select OrderAmount__c,n_Order__c,SplitRatio__c,n_FSplitAmount__c from Accounting__c where n_Order__c IN:setOrd];
			if(listActing.size()>0)
			{
				//订单,订单金额
				map<id,Orders__c> mapOrder=new map<id,Orders__c>([select id,OrderAmount__c from Orders__c where id IN:setOrd]);
				for(Accounting__c acting:listActing)
				{					
					if(mapOrder.containsKey(acting.n_Order__c))
					{
						Orders__c ord=mapOrder.get(acting.n_Order__c);system.debug('..............ord.OrderAmount__c.................'+ord.OrderAmount__c);
						acting.SplitRatio__c=acting.n_FSplitAmount__c/ord.OrderAmount__c*100;
					}
				}
				update listActing;
			}
		}		
	}	
	
}