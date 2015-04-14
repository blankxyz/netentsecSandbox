//订单明细创建或修改,删除,如果订单没有审批通过,自动判断此订单是否超标
//lurrykong
//2013.5.3
trigger OrderDetails_PrototypeCost on OrderDetails__c (before delete,after insert,after update) 
{
	set<id> setInsideOrder=new set<id>();				//内部样机订单
	set<id> setOrderDetailId=new set<id>();				//订单明细id
	if(trigger.isInsert)
	{	
		for(OrderDetails__c orderdetail:trigger.new)
		{
			if(orderdetail.OrderRecordTypeName__c=='InternalPrototypeOrders')
			{
				setInsideOrder.add(orderdetail.n_OrderNo__c);	 
				setOrderDetailId.add(orderdetail.id);  
			}
			system.debug(orderdetail.OrderRecordTypeName__c+'....................OrderRecordTypeName__c......................');
		}
	}
	if(trigger.isUpdate)
	{
		for(OrderDetails__c orderdetail:trigger.new)
		{
			if(orderdetail.OrderRecordTypeName__c=='InternalPrototypeOrders')
			{
				setInsideOrder.add(orderdetail.n_OrderNo__c);	 
				setOrderDetailId.add(orderdetail.id);  
			}	
		}
	}
	if(trigger.isDelete)
	{
		for(OrderDetails__c orderdetail:trigger.old) 
		{
			if(orderdetail.OrderRecordTypeName__c=='InternalPrototypeOrders')
			{
				setInsideOrder.add(orderdetail.n_OrderNo__c);	 
				setOrderDetailId.add(orderdetail.id);  
			}				
		}
	}
	if(setOrderDetailId.size()>0&&setInsideOrder.size()>0)
	{
		//订单id为键,订单为值								记录类型Name,是否超标,审批状态											条件：内部样机订单
		map<id,Orders__c> mapOrder=new map<id,Orders__c>([select id,RecordTypeName__c,IfCostOverWeight__c,ApprovalStatus__c,SalesRegion__c from Orders__c where id IN:setInsideOrder and RecordTypeName__c='内部样机订单']);
		if(trigger.isAfter&&trigger.isUpdate||trigger.isAfter&&trigger.isInsert||trigger.isBefore&&trigger.isDelete)			//删除,修改,添加之后
		{ 
			if(mapOrder.size()>0)
			{
				//需要更新的订单。。。
				list<Orders__c> listUpOrder=new list<Orders__c>();
				//销售区域,年,季度为键,费用指标的预算金额为值
				map<string,decimal> mapBudgeAmount=new map<string,decimal>();
				//按费用指标的销售区域,年,季度,分组,汇总	预算金额
				AggregateResult[] aggProCostResult=[select sum(n_BudgetAmount__c)sumYuSuan,n_SaleArea__c,n_Year__c,Quarter__c from PrototypeCosts__c
																												where Quarter__c!=null and n_SaleArea__c!=null
																												group by n_SaleArea__c,n_Year__c,Quarter__c];																		
				system.debug('-------------------aggProCostResult---------------------'+aggProCostResult);
				if(aggProCostResult.size()>0)
				{
					for(AggregateResult ar:aggProCostResult)
					{
						if(ar.get('n_SaleArea__c')!=null&&ar.get('n_Year__c')!=null&&ar.get('Quarter__c')!=null)
						{
							string str=string.valueOf(ar.get('n_SaleArea__c'))+string.valueOf(ar.get('n_Year__c'))+string.valueOf(ar.get('Quarter__c'));
							if(!mapBudgeAmount.containsKey(str))
							{
								decimal deci=decimal.valueOf(String.valueOf(ar.get('sumYuSuan')));
								mapBudgeAmount.put(str,deci);
							}   
						}
					}
				}
				system.debug('....................................mapBudgeAmount.......................................'+mapBudgeAmount.values());
			 	//查询订单明细							汇总实际费用(预计费用),销售区域,预计开始年,预计开始季度					条件:内部样机订单,！=测试完毕,借用人签收日期！=null																							
				AggregateResult[] aggOrderDetailResult=[select sum(PracticalExpectPrice__c)sumFeiYong,n_OrderNo__r.SalesRegion__c,PredictStartYear__c,PredictStartQuarter__c from OrderDetails__c
																											where n_OrderNo__r.RecordTypeName__c='内部样机订单' and TestStatus__c='测试中' and n_OrderNo__r.ApprovalStatus__c='已审批'
																											group by n_OrderNo__r.SalesRegion__c,PredictStartYear__c,PredictStartQuarter__c];	                                		
			 	system.debug('...................................aggOrderDetailResult.............................'+aggOrderDetailResult);	 	
			 	//销售区域,预计开始年,预计开始季度为键,订单明细的实际(预计金额)为值 
			 	map<string,decimal> mapPraExpectPrice=new map<string,decimal>();
				if(aggOrderDetailResult.size()>0)
				{
				 	for(AggregateResult ar:aggOrderDetailResult)
				 	{
				 		if(ar.get('SalesRegion__c')!=null&&ar.get('PredictStartYear__c')!=null&&ar.get('PredictStartQuarter__c')!=null)
				 		{
							string str=string.valueOf(ar.get('SalesRegion__c'))+string.valueOf(ar.get('PredictStartYear__c'))+string.valueOf(ar.get('PredictStartQuarter__c'));	
					 		if(!mapPraExpectPrice.containsKey(str))
					 		{
					 			if(ar.get('sumFeiYong')!=null)
					 			{
						 			decimal deci=decimal.valueOf(String.valueOf(ar.get('sumFeiYong')));
						 			if(deci!=null)
						 			mapPraExpectPrice.put(str,deci);
					 			}
					 		}
				 		}	
				 	}
				}		system.debug('.......................mapPraExpectPrice.........................'+mapPraExpectPrice);	
				if(trigger.isAfter&&trigger.isInsert)
				{
					for(OrderDetails__c orderdetail:trigger.new)
					{
						system.debug('........................orderdetail.n_OrderNo__c......................'+orderdetail.n_OrderNo__c);
						system.debug('........................orderdetail.PredictStartYear__c......................'+orderdetail.PredictStartYear__c);
						system.debug('........................orderdetail.PredictStartQuarter__c......................'+orderdetail.PredictStartQuarter__c);
						//订单id,预计开始年,预计开始季度不为空
						if(orderdetail.n_OrderNo__c!=null&&orderdetail.PredictStartYear__c!=null&&orderdetail.PredictStartQuarter__c!=null&&mapOrder.containsKey(orderdetail.n_OrderNo__c))			//订单不为空
						{
							Orders__c ord=mapOrder.get(orderdetail.n_OrderNo__c);
							system.debug('------------ord--------------'+ord); 
							if(ord.ApprovalStatus__c!='已审批') 
							{
								//销售区域+预计开始的年+预计开始的季度 
								string str=string.valueOf(ord.SalesRegion__c)+string.valueOf(orderdetail.PredictStartYear__c)+string.valueOf(orderdetail.PredictStartQuarter__c);
								system.debug('str..........................................'+str);
								decimal orderdecimal=0;
								decimal prototypedecimal=0;
								if(mapBudgeAmount.containsKey(str))
									 prototypedecimal=mapBudgeAmount.get(str);	 								//预计的钱
								if(mapPraExpectPrice.containsKey(str))
									 orderdecimal=mapPraExpectPrice.get(str);									//实际的钱
									
								orderdecimal+=orderdetail.Field1__c;												//加预计金额
								system.debug('...............orderdecimal.....................'+orderdecimal);
								system.debug('...............prototypedecimal.................'+prototypedecimal);
								if(orderdecimal>prototypedecimal)
								{
									ord.IfCostOverWeight__c=true;
								}						
							}
						}			
					}
				}	
				if(trigger.isBefore&&trigger.isDelete)
				{			
					system.debug('...................aaaaaaaaaaaa....................');
					for(OrderDetails__c orderdetail:trigger.old)
					{
						if(orderdetail.n_OrderNo__c!=null&&orderdetail.PredictStartYear__c!=null&&orderdetail.PredictStartQuarter__c!=null&&mapOrder.containsKey(orderdetail.n_OrderNo__c))			//订单不为空
						{
							Orders__c ord=mapOrder.get(orderdetail.n_OrderNo__c);
							system.debug('......................ord........................'+ord);
							system.debug('..................orderdetail.........................'+orderdetail);
							if(ord.RecordTypeName__c=='内部样机订单'&&ord.ApprovalStatus__c!='已审批')
							{
								//销售区域+年+季度
								string str=string.valueOf(ord.SalesRegion__c)+string.valueOf(orderdetail.PredictStartYear__c)+string.valueOf(orderdetail.PredictStartQuarter__c);
								system.debug('str..........................................'+str);
								decimal orderdecimal=0;																	//实际的钱
								decimal prototypedecimal=0;																//预计的钱
								if(mapBudgeAmount.containsKey(str))
									 prototypedecimal=mapBudgeAmount.get(str);									//预计的钱
								if(mapPraExpectPrice.containsKey(str))
									 orderdecimal=mapPraExpectPrice.get(str);									//实际的钱
		
									system.debug('...............orderdecimal.....................'+orderdecimal);
									system.debug('...............prototypedecimal.................'+prototypedecimal);
									if(orderdecimal>prototypedecimal)
									{
										ord.IfCostOverWeight__c=true;
									}
									else
									{								
										ord.IfCostOverWeight__c=false;						
									}
								
							}
						}			
					}
				}
				if(trigger.isAfter&&trigger.isUpdate)
				{
					for(OrderDetails__c orderdetail:trigger.new)
					{
						Orders__c ord=mapOrder.get(orderdetail.n_OrderNo__c);
						OrderDetails__c oldorder=trigger.oldMap.get(orderdetail.id);
						system.debug('........................orderdetail.n_OrderNo__c......................'+orderdetail.n_OrderNo__c);
						system.debug('........................orderdetail.PredictStartYear__c......................'+orderdetail.PredictStartYear__c);
						system.debug('........................orderdetail.PredictStartQuarter__c......................'+orderdetail.PredictStartQuarter__c);
						if(oldorder.Demostar__c!=orderdetail.Demostar__c||oldorder.Demoend__c!=orderdetail.Demoend__c||oldorder.IfNewProduct__c!=orderdetail.IfNewProduct__c)							//预计开始时间或预计结束时间发生变化时
						{
							//订单id,预计开始年,预计开始季度不为空
							if(orderdetail.n_OrderNo__c!=null&&orderdetail.PredictStartYear__c!=null&&orderdetail.PredictStartQuarter__c!=null&&mapOrder.containsKey(orderdetail.n_OrderNo__c))			//订单不为空
							{							
								if(ord.RecordTypeName__c=='内部样机订单'&&ord.ApprovalStatus__c!='已审批'&&orderdetail.Demostar__c!=null&&orderdetail.Demoend__c!=null)
								{
									//销售区域+预计开始的年+预计开始的季度	 
									string str=string.valueOf(ord.SalesRegion__c)+string.valueOf(orderdetail.PredictStartYear__c)+string.valueOf(orderdetail.PredictStartQuarter__c);
									system.debug('str..........................................'+str);
									system.debug('.............mapBudgeAmount..................'+mapBudgeAmount.keySet());
									system.debug('.............mapPraExpectPrice...............'+mapPraExpectPrice.keySet());
									decimal orderdecimal=0;																	//实际的钱
									decimal prototypedecimal=0;																//预计的钱
									if(mapBudgeAmount.containsKey(str))
										 prototypedecimal=mapBudgeAmount.get(str);									//预计的钱
									if(mapPraExpectPrice.containsKey(str))
										 orderdecimal=mapPraExpectPrice.get(str);									//实际的钱
		
										orderdecimal+=orderdetail.Field1__c;												//加预计金额
										system.debug('...............orderdecimal.....................'+orderdecimal);
										system.debug('...............prototypedecimal.................'+prototypedecimal);
										if(orderdecimal>prototypedecimal)
										{
											ord.IfCostOverWeight__c=true;
										}
										else
										{
											ord.IfCostOverWeight__c=false;
										}
								}
							}
						}
					}
				}
				system.debug('........................listUpOrder................................'+listUpOrder);
				list<Orders__c> listorder=mapOrder.values();
				if(listorder.size()>0)
					update listorder;
			}
		}	
	}
}