//订单明细借用人签收日期编辑时,自动更新费用指标的可用金额
//更新实际预计金额
//lurrykong   
//2013.5.3
trigger OrderDetails_PrototypeCostAmountSum on OrderDetails__c (after delete, after update) 
{
	set<id> setOrderdtail=new set<id>();									//订单明细id
	list<PrototypeCosts__c> listUppro=new list<PrototypeCosts__c>();
	set<id> setOrder=new set<id>();											//订单id
	set<id> setProid=new set<id>();                          				//产品id
	map<string,OrderDetails__c> mapOrdetail=new map<string,OrderDetails__c>();	//销售区域+年+月  为键,订单明细为值
	if(trigger.isUpdate)
	{
		for(OrderDetails__c orderdetail:trigger.new)
		{
			setOrderdtail.add(orderdetail.id);
			OrderDetails__c oldorderd=trigger.oldMap.get(orderdetail.id);
			if(orderdetail.BorrowerReceiptDate__c!=oldorderd.BorrowerReceiptDate__c&&orderdetail.BorrowerReceiptDate__c!=null)
				setOrder.add(orderdetail.n_OrderNo__c);
			if(orderdetail.n_ProductByOrd__c!=null)			
				setProid.add(orderdetail.n_ProductByOrd__c);
		}
	}
	if(trigger.isDelete)
	{
		for(OrderDetails__c orderdetail:trigger.old)
		{
			setOrderdtail.add(orderdetail.id);
			setOrder.add(orderdetail.n_OrderNo__c);
		}
	}
	//查询样机费用管理					id,销售区域,年,月,季度,实际金额,预算金额,可用金额
	list<PrototypeCosts__c> listProtype=[select id,n_SaleArea__c,n_Year__c,n_Month__c,n_FactAmount__c,n_BudgetAmount__c,ReAmount__c from PrototypeCosts__c];
	//销售区域,年,月为键,样机费用管理为值
	map<string,PrototypeCosts__c> mapProtype=new map<string,PrototypeCosts__c>();
	if(listProtype.size()>0)
	{
		for(PrototypeCosts__c proc:listProtype)
		{
			if(proc.n_SaleArea__c!=null&&proc.n_Year__c!=null&&proc.n_Month__c!=null)
			{
				string str=string.valueOf(proc.n_SaleArea__c)+string.valueOf(proc.n_Year__c)+string.valueOf(proc.n_Month__c);//销售区域+年+月
				if(!mapProtype.containsKey(str))
					mapProtype.put(str,proc); 
			}
		}
	}
	
	system.debug('--------------------mapProtype----------------------'+mapProtype); 
	
	//订单id为键,订单为值								记录类型Name,是否超标
	map<id,Orders__c> mapOrder=new map<id,Orders__c>([select id,RecordTypeName__c,IfCostOverWeight__c,SalesRegion__c from Orders__c where RecordTypeName__c='内部样机订单']);		
	
	//查询订单明细							汇总实际费用(预计费用),销售区域,年,月					条件:内部样机订单,！=测试完毕,借用人签收日期！=null																							
	AggregateResult[] aggOrderDetailResult=[select sum(PracticalExpectPrice__c)sumFeiYong,n_OrderNo__r.SalesRegion__c,n_Year__c,n_Month__c from OrderDetails__c
																									where n_OrderNo__r.RecordTypeName__c='内部样机订单' and TestStatus__c='测试中' and BorrowerReceiptDate__c!=null
																									group by n_OrderNo__r.SalesRegion__c,n_Year__c,n_Month__c];	                                		
 	//销售区域,年,季度为键,订单明细的实际(预计金额)为值 
 	map<string,decimal> mapPraExpectPrice=new map<string,decimal>();
 	for(AggregateResult ar:aggOrderDetailResult)
 	{
 		if(ar.get('SalesRegion__c')!=null&&ar.get('n_Year__c')!=null&&ar.get('n_Month__c')!=null)
 		{
			string str=string.valueOf(ar.get('SalesRegion__c'))+string.valueOf(ar.get('n_Year__c'))+string.valueOf(ar.get('n_Month__c'));	
	 		if(!mapPraExpectPrice.containsKey(str))
	 		{
	 			if(ar.get('sumFeiYong')!=null)
	 			{
	 				decimal deci=decimal.valueOf(String.valueOf(ar.get('sumFeiYong')));
	 				mapPraExpectPrice.put(str,deci);
	 			}
	 		}
 		}
 	}
 	system.debug('...................................mapProtype.keySET...........................................'+mapProtype.keySet());
 	system.debug('...................................mapPraExpectPrice.keySET....................................'+mapPraExpectPrice.keySet());
	system.debug('..................mapProtype.values().........................'+mapProtype.values());
	if(trigger.isUpdate)
	{
		for(OrderDetails__c orderd:trigger.new)
		{		
			OrderDetails__c oldorderd=trigger.oldMap.get(orderd.id);
			if(orderd.BorrowerReceiptDate__c!=oldorderd.BorrowerReceiptDate__c&&orderd.BorrowerReceiptDate__c!=null||orderd.PracticalExpectPrice__c!=oldorderd.PracticalExpectPrice__c&&orderd.PracticalExpectPrice__c!=null)
			{					
				if(orderd.n_OrderNo__c!=null&&mapOrder.containsKey(orderd.n_OrderNo__c))
				{
					Orders__c ord=mapOrder.get(orderd.n_OrderNo__c);
					if(ord.SalesRegion__c!=null&&orderd.n_Year__c!=null&&orderd.n_Month__c!=null)
					{
						string str=string.valueOf(ord.SalesRegion__c)+string.valueOf(orderd.n_Year__c)+string.valueOf(orderd.n_Month__c);					
						system.debug('..................................mapProtype.containsKey(str)...........................................'+mapProtype.containsKey(str));
						system.debug('----------------------------------mapPraExpectPrice.containsKey(str)---------------------------------'+mapPraExpectPrice.containsKey(str));
						if(mapProtype.containsKey(str)&&mapPraExpectPrice.containsKey(str))
						{
							decimal deci=mapPraExpectPrice.get(str);
							PrototypeCosts__c pt=mapProtype.get(str);
							if(deci!=null&&pt!=null)
							{
								pt.n_FactAmount__c=deci;														//实际金额
								pt.ReAmount__c=pt.n_BudgetAmount__c-deci;										//可用金额=预计金额-以用金额					
								//listUppro.add(pt);
							}
						}
					}
				}
			}			
		}
	}
	if(trigger.isDelete)	
	{
		for(OrderDetails__c orderd:trigger.old)
		{	system.debug('................orderd.trigger.old....................'+trigger.old);
			OrderDetails__c oldorderd=trigger.oldMap.get(orderd.id);
			if(orderd.n_OrderNo__c!=null&&mapOrder.containsKey(orderd.n_OrderNo__c))
			{
				Orders__c ord=mapOrder.get(orderd.n_OrderNo__c);
				if(ord.SalesRegion__c!=null&&orderd.n_Year__c!=null&&orderd.n_Month__c!=null)
				{
					string str=string.valueOf(ord.SalesRegion__c)+string.valueOf(orderd.n_Year__c)+string.valueOf(orderd.n_Month__c);					
					system.debug('..................................22222mapProtype.containsKey(str)...........................................'+mapProtype.containsKey(str));
					system.debug('----------------------------------22222mapPraExpectPrice.containsKey(str)---------------------------------'+mapPraExpectPrice.containsKey(str));
					if(mapProtype.containsKey(str)&&mapPraExpectPrice.containsKey(str))
					{
						decimal deci=mapPraExpectPrice.get(str);
						PrototypeCosts__c pt=mapProtype.get(str);
						if(deci!=null&&pt!=null)
						{	
							pt.n_FactAmount__c=deci;											//实际金额
							pt.ReAmount__c=pt.n_BudgetAmount__c-deci;							
							//listUppro.add(pt);
						}
					}
				}
			}
		}
	}
	system.debug('..................mapProtype.values().........................'+mapProtype.values());
	if(mapProtype.values().size()>0)
		update mapProtype.values();

}