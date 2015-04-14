//业绩核算对象 折扣比例和分配金额同时存在时。折扣比例=分配金额/订单金额
//业绩核算对象 折扣比例存在分配金额不存在时。分配金额=订单金额*折扣比例
//业绩核算对象 分配金额存在折扣比例不存在时。折扣比例=分配金额/订单明细
//lurrykong
//2013.07.01
trigger Accounting_DiscountSplitAmount on Accounting__c (before insert, before update) 
{
	if(trigger.isInsert)
	{
		for(Accounting__c accting:trigger.new)
		{
			if(accting.n_FSplitAmount__c!=null&&accting.SplitRatio__c!=null)
				accting.SplitRatio__c=accting.n_FSplitAmount__c/accting.OrderAmount__c*100;
			else if(accting.n_FSplitAmount__c!=null&&accting.SplitRatio__c==null)
				accting.SplitRatio__c=accting.n_FSplitAmount__c/accting.OrderAmount__c*100;
			else if(accting.SplitRatio__c!=null&&accting.n_FSplitAmount__c==null)
				accting.n_FSplitAmount__c=accting.OrderAmount__c*accting.SplitRatio__c/100;
		}
	}
	if(trigger.isUpdate)
	{
		for(Accounting__c accting:trigger.new)
		{
			Accounting__c oldaccting=trigger.oldMap.get(accting.id);
			if(accting.n_FSplitAmount__c!=oldaccting.n_FSplitAmount__c||accting.OrderAmount__c!=oldaccting.OrderAmount__c||accting.SplitRatio__c!=oldaccting.SplitRatio__c)
			{
				if(accting.n_FSplitAmount__c!=null&&accting.SplitRatio__c!=null)
					accting.SplitRatio__c=accting.n_FSplitAmount__c/accting.OrderAmount__c*100;
				else if(accting.n_FSplitAmount__c!=null&&accting.SplitRatio__c==null)
					accting.SplitRatio__c=accting.n_FSplitAmount__c/accting.OrderAmount__c*100;
				else if(accting.SplitRatio__c!=null&&accting.n_FSplitAmount__c==null)
					accting.n_FSplitAmount__c=accting.OrderAmount__c*accting.SplitRatio__c/100;
			}
		}
	}
	
}