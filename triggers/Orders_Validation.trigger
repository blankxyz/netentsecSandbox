//添加Order（订单）验证		
//lurrykong
//2013.3.28				
//销售区域自动为客户上的区域
//压货订单不需要添加验证
trigger Orders_Validation on Orders__c (before insert,before update) 
{
	set<id>	setRecordType=new set<id>();							//记录类型id	
	for(Orders__c orders:trigger.new)
	{
		if(orders.RecordTypeId!=null)
			setRecordType.add(orders.RecordTypeId);
	}
	//查询所有记录类型		
	list<RecordType> listRecordType=[select Name,Id from RecordType where Id IN:setRecordType];
	//id为键记录类型Name为值
	map<id,string> mapRecordType=new map<id,string>();
	if(listRecordType.size()>0)
	{
		for(RecordType recordtype:listRecordType)
		{
			if(!mapRecordType.containsKey(recordtype.id))
				mapRecordType.put(recordtype.id,recordtype.Name);
		}
	}	
	if(trigger.isInsert||trigger.isUpdate)
	{
		if(trigger.isInsert)
		{
			set<id> setOpp=new set<id>();		//业务机会id
			set<id> setQuote=new set<id>();		//报价单id
			set<id> setOrder=new set<id>();		//订单id			
			for(Orders__c orders:trigger.new)
			{
				if(orders.RecordTypeId!=null)
					setRecordType.add(orders.RecordTypeId);
				if(orders.SalesOpportunities__c!=null)
					setOpp.add(orders.SalesOpportunities__c);	
				if(orders.Quote__c!=null)
					setQuote.add(orders.Quote__c);
				if(orders.AboutOrder__c!=null)
					setOrder.add(orders.AboutOrder__c);	
			}
			//取得所有的业务机会
			list<Opportunity> listOpp=[select id,StageName,AccountId from Opportunity where id IN:setOpp];
			//业务机会id为键,业务机会为值
			map<id,Opportunity> mapOpp=new map<id,Opportunity>();
			//业务机会id为键,客户id为值
			map<id,id> mapAcc=new map<id,id>();
			if(listOpp.size()>0)
			{
				for(Opportunity opp:listOpp)
				{
					if(!mapOpp.containsKey(opp.id))
						mapOpp.put(opp.id,opp);
					if(!mapAcc.containsKey(opp.id))
						mapAcc.put(opp.id,opp.AccountId);
				}
			}
			//取得所有的报价
			list<Quote> listQuote=[select id,Status,OpportunityId from Quote where id IN:setQuote];
			//报价id为键,报价为值
			map<id,Quote> mapQuote=new map<id,Quote>();
			//报价id为键,业务机会id为值
			map<id,id> mapQuOppid=new map<id,id>();
			if(listQuote.size()>0)
			{
				for(Quote quote:listQuote)
				{
					if(!mapQuote.containsKey(quote.id))
						mapQuote.put(quote.id,quote);
					if(!mapQuOppid.containsKey(quote.id))
						mapQuOppid.put(quote.id,quote.OpportunityId);
				}
			}
			//取得所有的order
			list<Orders__c> listOrder=[select id,customer__c from Orders__c where id in:setOrder];
			//Order id为键，Order为值
			map<id,Orders__c> mapOrder=new map<id,Orders__c>();
			if(listOrder.size()>0)
			{
				for(Orders__c orders:listOrder)
				{
					if(!mapOrder.containsKey(orders.id))
						mapOrder.put(orders.id,orders);
				}
			}	
			for(Orders__c orders:trigger.new)
			{
				if(mapRecordType.containsKey(orders.RecordTypeId))
				{	//销售订单,压货转销售订单
					if(mapRecordType.get(orders.RecordTypeId)=='销售订单'||mapRecordType.get(orders.RecordTypeId)=='压货转销售订单'||mapRecordType.get(orders.RecordTypeId)=='内部核算订单')
					{	
						if(orders.Quote__c!=null&&orders.SalesOpportunities__c!=null&&mapQuOppid.containsKey(orders.Quote__c))
						{		
							if(mapQuOppid.get(orders.Quote__c)==orders.SalesOpportunities__c)
							{	
								if(mapAcc.containsKey(orders.SalesOpportunities__c))
								{		
									if(orders.customer__c!=null&&mapAcc.get(orders.SalesOpportunities__c)==orders.customer__c)//判断客户是否为业务机会的客户
									{	
										string status;
										string stageName;
										if(mapQuote.containsKey(orders.Quote__c)&&mapOpp.containsKey(orders.SalesOpportunities__c))
										{
											status=mapQuote.get(orders.Quote__c).Status;
											stageName=mapOpp.get(orders.SalesOpportunities__c).StageName;
											
											if(status=='已批准')
											{
												if(mapRecordType.get(orders.RecordTypeId)!='销售订单')				//销售订单不需要关单验证
												{
													if(stageName=='关单')	
													{	
														if(mapRecordType.get(orders.RecordTypeId)=='内部核算订单')	//如果是内部核算订单
														{
															if(mapOrder.containsKey(orders.AboutOrder__c))
															{	system.debug('mapOrder.get(orders.AboutOrder__c).customer__c....................'+mapOrder.get(orders.AboutOrder__c).customer__c);
																if(mapOrder.get(orders.AboutOrder__c).customer__c!=orders.customer__c)
																	orders.addError('相关订单的客户和当前客户不一致');
															}
														}
													}
													else{
														orders.addError('业务机会没有赢单,所以无法下订单');
													}
												}	
											}
											else
											{
												orders.addError('报价单未审批通过,所以无法下订单');
											}
											
											 
										}
									}
									else{
										orders.addError('业务机会的客户与当前客户不一致');									
									}
								}
							}
							else{
								orders.addError('报价单上的业务机会与订单上业务机会不一致');
							}
													
						}
					}
					if(mapRecordType.get(orders.RecordTypeId)=='内部样机订单')
					{
						System.debug('-------------begin-----------------');
						if(orders.SalesOpportunities__c!=null)
						{
							if(mapAcc.containsKey(orders.SalesOpportunities__c))			
							{
								if(orders.customer__c!=null&&mapAcc.get(orders.SalesOpportunities__c)!=orders.customer__c)
								{
									System.debug('-------------begin2-----------------');
									orders.addError('业务机会客户与当前订单客户不一致');	
								}
							}	
						}
						else
						{
							System.debug('-------------begin3-----------------'); 
							orders.addError('内部样机订单必须具备业务机会,方可下订单'); 
						}
					}
				} 
	
			}
		}
		if(trigger.isUpdate)
		{			
			set<id> setOpp=new set<id>();		//业务机会id
			set<id> setQuote=new set<id>();		//报价单id
			set<id> setOrder=new set<id>();		//订单id			
			set<id> setUpOrder=new set<id>();	//需要验证的订单的id
			for(Orders__c orders:trigger.new)						
			{
				Orders__c oldorder=trigger.oldMap.get(orders.id);
				if((orders.Quote__c!=oldorder.Quote__c&&orders.Quote__c!=null)||
				   (orders.customer__c!=oldorder.customer__c&&orders.customer__c!=null)||
				   (orders.SalesOpportunities__c!=oldorder.SalesOpportunities__c&&orders.SalesOpportunities__c!=null)||				   
				   (orders.AboutOrder__c!=oldorder.AboutOrder__c&&orders.AboutOrder__c!=null))
				{
					setUpOrder.add(orders.id);
				}
			}
			if(setUpOrder.size()>0)
			{
				for(Orders__c orders:trigger.new)
				{
					if(orders.RecordTypeId!=null)
						setRecordType.add(orders.RecordTypeId);
					if(orders.SalesOpportunities__c!=null)
						setOpp.add(orders.SalesOpportunities__c);	
					if(orders.Quote__c!=null)
						setQuote.add(orders.Quote__c);
					if(orders.AboutOrder__c!=null)
						setOrder.add(orders.AboutOrder__c);	
				}
				//取得所有的业务机会
				list<Opportunity> listOpp=[select id,StageName,AccountId from Opportunity where id IN:setOpp];
				//业务机会id为键,业务机会为值
				map<id,Opportunity> mapOpp=new map<id,Opportunity>();
				//业务机会id为键,客户id为值
				map<id,id> mapAcc=new map<id,id>();
				if(listOpp.size()>0)
				{
					for(Opportunity opp:listOpp)
					{
						if(!mapOpp.containsKey(opp.id))
							mapOpp.put(opp.id,opp);
						if(!mapAcc.containsKey(opp.id))
							mapAcc.put(opp.id,opp.AccountId);
					}
				}
				//取得所有的报价
				list<Quote> listQuote=[select id,Status,OpportunityId from Quote where id IN:setQuote];
				//报价id为键,报价为值
				map<id,Quote> mapQuote=new map<id,Quote>();
				//报价id为键,业务机会id为值
				map<id,id> mapQuOppid=new map<id,id>();
				if(listQuote.size()>0)
				{
					for(Quote quote:listQuote)
					{
						if(!mapQuote.containsKey(quote.id))
							mapQuote.put(quote.id,quote);
						if(!mapQuOppid.containsKey(quote.id))
							mapQuOppid.put(quote.id,quote.OpportunityId);
					}
				}
				//取得所有的order
				list<Orders__c> listOrder=[select id,customer__c from Orders__c where id in:setOrder];
				//Order id为键，Order为值
				map<id,Orders__c> mapOrder=new map<id,Orders__c>();
				if(listOrder.size()>0)
				{
					for(Orders__c orders:listOrder)
					{
						if(!mapOrder.containsKey(orders.id))
							mapOrder.put(orders.id,orders);
					}
				}	
				for(Orders__c orders:trigger.new)
				{
					if(mapRecordType.containsKey(orders.RecordTypeId))
					{	//销售订单,压货转销售订单
						if(mapRecordType.get(orders.RecordTypeId)=='销售订单'||mapRecordType.get(orders.RecordTypeId)=='压货转销售订单'||mapRecordType.get(orders.RecordTypeId)=='内部核算订单')
						{	
							if(orders.Quote__c!=null&&orders.SalesOpportunities__c!=null&&mapQuOppid.containsKey(orders.Quote__c))
							{		
								if(mapQuOppid.get(orders.Quote__c)==orders.SalesOpportunities__c)
								{	
									if(mapAcc.containsKey(orders.SalesOpportunities__c))
									{		
										if(orders.customer__c!=null&&mapAcc.get(orders.SalesOpportunities__c)==orders.customer__c)//判断客户是否为业务机会的客户
										{	
											string status;
											string stageName;
											if(mapQuote.containsKey(orders.Quote__c)&&mapOpp.containsKey(orders.SalesOpportunities__c))
											{
												status=mapQuote.get(orders.Quote__c).Status;
												stageName=mapOpp.get(orders.SalesOpportunities__c).StageName;
												if(status=='已批准')
												{
													if(mapRecordType.get(orders.RecordTypeId)!='销售订单')
													{
														if(stageName=='关单')													//销售订单不用验证商机是否关单
														{	
															if(mapRecordType.get(orders.RecordTypeId)=='内部核算订单')			//如果是内部核算订单
															{
																if(mapOrder.containsKey(orders.AboutOrder__c))
																{	system.debug('mapOrder.get(orders.AboutOrder__c).customer__c....................'+mapOrder.get(orders.AboutOrder__c).customer__c);
																	if(mapOrder.get(orders.AboutOrder__c).customer__c!=orders.customer__c)
																		orders.addError('相关订单的客户和当前客户不一致');
																}
															}
														}
														else
														{
															orders.addError('业务机会没有赢单,所以无法下订单');
														}
													}
												}
												else
												{
													orders.addError('报价单未审批通过,所以无法下订单');
												}
											}
										}
										else{
											orders.addError('业务机会的客户与当前客户不一致');									
										}
									}
								}
								else{
									orders.addError('报价单上的业务机会与订单上业务机会不一致');
								}
														
							}
						}
						if(mapRecordType.get(orders.RecordTypeId)=='内部样机订单')
						{
							System.debug('-------------begin-----------------');
							if(orders.SalesOpportunities__c!=null)
							{
								if(mapAcc.containsKey(orders.SalesOpportunities__c))			
								{
									if(orders.customer__c!=null&&mapAcc.get(orders.SalesOpportunities__c)!=orders.customer__c)
									{
										System.debug('-------------begin2-----------------');
										orders.addError('业务机会客户与当前订单客户不一致');	
									}
								}	
							}
							else
							{
								System.debug('-------------begin3-----------------'); 
								orders.addError('内部样机订单必须具备业务机会,方可下订单'); 
							}
						}
					} 
		
				}
			}
		}
	}
	if(trigger.isInsert)
	{
		
		
		for(Orders__c orders:trigger.new)
		{
			 
			
			if(mapRecordType.get(orders.RecordTypeId)=='销售订单'){
				orders.OrderNum__c=UtilsCreateAutoNum.createAutoNum('ORD','ORDOrderNumber',Trigger.new.size());
				
			}
			
			if(mapRecordType.get(orders.RecordTypeId)=='压货订单'){
				orders.OrderNum__c=UtilsCreateAutoNum.createAutoNum('STO','STOOrderNumber',Trigger.new.size());
				
			}		
			if(mapRecordType.get(orders.RecordTypeId)=='压货转销售订单'){
				orders.OrderNum__c=UtilsCreateAutoNum.createAutoNum('TUR','TUROrderNumber',Trigger.new.size());
				
			}	
			if(mapRecordType.get(orders.RecordTypeId)=='渠道样机订单'){
				orders.OrderNum__c=UtilsCreateAutoNum.createAutoNum('TRY','TRYOrderNumber',Trigger.new.size());
				
			}						
			if(mapRecordType.get(orders.RecordTypeId)=='内部样机订单'){
				orders.OrderNum__c=UtilsCreateAutoNum.createAutoNum('SAM','SAMOrderNumber',Trigger.new.size());
				
			}		
			
			if(mapRecordType.get(orders.RecordTypeId)=='退货订单'){
				orders.OrderNum__c=UtilsCreateAutoNum.createAutoNum('REJ','REJOrderNumber',Trigger.new.size());
				
			}
			if(mapRecordType.get(orders.RecordTypeId)=='换货订单'){
				orders.OrderNum__c=UtilsCreateAutoNum.createAutoNum('EXC','EXCOrderNumber',Trigger.new.size());
				
			}						 										
			if(mapRecordType.get(orders.RecordTypeId)=='内部核算订单'){
				orders.OrderNum__c=UtilsCreateAutoNum.createAutoNum('INT','INTOrderNumber',Trigger.new.size());
				
			}	
			if(mapRecordType.get(orders.RecordTypeId)=='维修订单'){
				orders.OrderNum__c=UtilsCreateAutoNum.createAutoNum('REP','INTOrderNumber',Trigger.new.size());
				
			}			
		}
		
	
	}
}