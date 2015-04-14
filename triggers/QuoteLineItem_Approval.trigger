//报价单折扣
//lurrykong
//2013.4.10
trigger QuoteLineItem_Approval on QuoteLineItem (after delete, after insert, after update) 
{
	//报价id
	set<id> setQuoteId=new set<id>();
	if(trigger.isInsert)
	{	
		for(QuoteLineItem qli:trigger.new)
		{
			if(qli.QuoteId!=null)
				setQuoteId.add(qli.QuoteId);
		}
	}
	if(trigger.isUpdate)
	{
		for(QuoteLineItem qli:trigger.new)
		{
			QuoteLineItem oldqli=trigger.oldMap.get(qli.id);
			if(qli.UnitPrice!=oldqli.UnitPrice)						//销售价格发生变化	
			{	if(qli.QuoteId!=null)
					setQuoteId.add(qli.QuoteId);
			}
		}
	}
	if(trigger.isDelete)
	{	
		for(QuoteLineItem qli:trigger.old)
		{
			if(qli.QuoteId!=null)
				setQuoteId.add(qli.QuoteId);
		}
	}		
	if(setQuoteId.size()>0)
	{
		DataFormat df=new DataFormat();		
		//报价id为键,错误为值
		map<id,string> mapQuoteError=new map<id,string>(); 
		system.debug('...............df.setService.....................'+df.setService);
		system.debug('...............df.setEquipMent.....................'+df.setEquipMent);
		system.debug('...............df.setPart.....................'+df.setPart);
		//折扣角色,产品系列为键,折扣对象为值。
		map<string,ProdcutionDiscount__c> mapSaleProdiscount=new map<string,ProdcutionDiscount__c>();
		//折扣角色,产品系列,渠道类型,产品型号系列Name为键,折扣对象为值
		map<string,ProdcutionDiscount__c> mapAgenProdiscount=new map<string,ProdcutionDiscount__c>();
		//查询产品折扣对象	id,产品,折扣角色,产品级别,产品系列,产品型号系列Name,渠道类型,折扣
		list<ProdcutionDiscount__c> listProdiscount=[select id,Product__c,n_DiscountRole__c,n_ProductionLevel__c,n_ProductionLine__c,Family__c,Family__r.Name,ChannelType__c,n_Discount__c  from ProdcutionDiscount__c];
		if(listProdiscount.size()>0)
		{  
			for(ProdcutionDiscount__c prodis:listProdiscount)
			{
				if(prodis.n_DiscountRole__c=='销售人员'||prodis.n_DiscountRole__c=='办事处主任'||prodis.n_DiscountRole__c=='行业总监'||prodis.n_DiscountRole__c=='销售VP'||prodis.n_DiscountRole__c=='财务VP')
					mapSaleProdiscount.put(string.valueOf(prodis.n_DiscountRole__c)+string.valueOf(prodis.n_ProductionLine__c),prodis);
				else{
					mapAgenProdiscount.put(string.valueOf(prodis.n_DiscountRole__c)+string.valueOf(prodis.n_ProductionLine__c)+string.valueOf(prodis.ChannelType__c)+string.valueOf(prodis.Family__r.Name),prodis);
				}			
			}
		}
		system.debug('...........................setQuoteId.............................'+setQuoteId);  
		//查询报价行 id,产品,报价,销售价格,定价,数量,Discount,产品系列,产品型号系列 
		list<QuoteLineItem> listQuoteLineItem=[select id,PricebookEntry.Product2Id,QuoteId,UnitPrice,ListPrice,Quantity,n_Discount__c,Family__c,productmodelseries__c from QuoteLineItem
																					where QuoteId IN: setQuoteId];
		system.debug('..............listQuoteLineItem...................'+listQuoteLineItem);	
		//报价id为键,list报价行为值	
		map<id,list<QuoteLineItem>> maplistQuoteLinItem=new map<id,list<QuoteLineItem>>();
		if(listQuoteLineItem.size()>0)
		{
			for(QuoteLineItem qli:listQuoteLineItem)
			{
				if(!maplistQuoteLinItem.containsKey(qli.QuoteId))
				{
					list<QuoteLineItem> listquolinitem=new list<QuoteLineItem>();
					listquolinitem.add(qli);
					maplistQuoteLinItem.put(qli.QuoteId,listquolinitem);
				}
				else
				{
					list<QuoteLineItem> listquolinitem=maplistQuoteLinItem.get(qli.QuoteId);
					listquolinitem.add(qli);
				}
			}
		}
		system.debug('.....................maplistQuoteLinItem..........................'+maplistQuoteLinItem.values());
		//查询id,商机属性,审批级别,代理商,报价行折扣,是否需要办公室主任审批,是否需要销售vp审批,是否需要财务vp审批,业务机会,业务机会的销售区域,无产品折扣是否需要审批,客户id
		list<Quote> listQuote=[select id,OppProperties__c,ApprovalLevel__c,Agents__c,QuoteLineItemDiscount__c,OfficeAdmApproval__c,FinancialVpApproval__c,SalesVpApproval__c,OpportunityId,
																														Opportunity.SalesRegion__c,Opportunity.RecordTypeId,NoProductDisApp__c,Opportunity.AccountId 
																														from Quote 
																														where id IN:setQuoteId];	
		//报价的业务机会的销售区域的id
		set<id> setSaleid=new set<id>();
		//报价的业务机会的客户的id
		set<id> setAccId=new set<id>();
		//报价的代理商的id
		set<id> setAgen=new set<id>();
		if(listQuote.size()>0)
		{
			for(Quote quote:listQuote)
			{			
				if(quote.Opportunity.AccountId!=null)
					setAccId.add(quote.Opportunity.AccountId);		
				if(quote.Agents__c!=null) 
					setAgen.add(quote.Agents__c);
			}
		}	
		//代理商Name为键,代理商为值      代理商的签约等级,代理商的类型
		map<string,Account> mapAcc=new map<string,Account>();
		//查询所有的渠道客户,渠道类型,签约等级,销售区域,销售区域的办公室主任
		list<Account> listAcc=[select id,Name,RecordType.Name,RecordTypeId,ChannelType__c,Identity__c,SellArea__c,SellArea__r.OfficeDirector__c from Account where (id IN:setAccId or id IN:setAgen)];
		for(Account acc:listAcc)
		{
			if(!mapAcc.containsKey(acc.id))								  			
				mapAcc.put(string.valueOf(acc.id),acc);
		}        
		//销售区域id为键,销售区域为值												id,办公室主任,Name
		map<id,SalesRegion__c> mapSaleregion=new map<id,SalesRegion__c>([select id,OfficeDirector__c,Name from SalesRegion__c]);
		map<id,RecordType> mapRecordType=new map<id,RecordType>([select id,Name,Description,DeveloperName,SobjectType from RecordType]);																				
		if(listQuote.size()>0)
		{
			QuoteLineItem quotelineitem;
			SalesRegion__c saleregion;
			ProdcutionDiscount__c OfficeAdm; //办事处主任
			ProdcutionDiscount__c FinancialVp;//财务vp
			ProdcutionDiscount__c SalesVp;	 //销售vp
			RecordType rt;					 //记录类型
			Account acc;
			map<id,QuoteLineItem> mapServiceqli=new map<id,QuoteLineItem>();//服务
			map<id,QuoteLineItem> mapEquipMentqli=new map<id,QuoteLineItem>();//设备
			map<id,QuoteLineItem> mapPartqli=new map<id,QuoteLineItem>();//配件
			for(Quote quote:listQuote)
			{
				if(maplistQuoteLinItem.containsKey(quote.id))
				{
					list<QuoteLineItem> listquolinitem=maplistQuoteLinItem.get(quote.id);system.debug('........................listquolinitem.........................'+listquolinitem);
					if(listquolinitem.size()>0&&listquolinitem!=null)
					{
						for(QuoteLineItem qli:listquolinitem)
						{
							if(df.setService.contains(qli.Family__c))//服务产品
							{
								if(!mapServiceqli.containsKey(qli.QuoteId))
									mapServiceqli.put(qli.QuoteId,qli);
								else{
									QuoteLineItem oldserqli=mapServiceqli.get(qli.QuoteId);
									if(oldserqli.n_Discount__c>qli.n_Discount__c){
										mapServiceqli.put(qli.QuoteId,qli);
									}
								}
							}
							if(df.setEquipMent.contains(qli.Family__c))//设备产品
							{
								if(!mapEquipMentqli.containsKey(qli.QuoteId))
									mapEquipMentqli.put(qli.QuoteId,qli);
								else{
									QuoteLineItem oldserqli=mapEquipMentqli.get(qli.QuoteId);
									if(oldserqli.n_Discount__c>qli.n_Discount__c){
										mapEquipMentqli.put(qli.QuoteId,qli);
									}
								}
							}
							if(df.setPart.contains(qli.Family__c))//配件
							{
								if(!mapPartqli.containsKey(qli.QuoteId))
									mapPartqli.put(qli.QuoteId,qli);
								else{
									QuoteLineItem oldserqli=mapPartqli.get(qli.QuoteId);
									if(oldserqli.n_Discount__c>qli.n_Discount__c){
										mapPartqli.put(qli.QuoteId,qli);
									}
								}
							}
						}
						system.debug('.............mapServiceqli...............'+mapServiceqli);system.debug('..............mapServiceqli.keySet()...............'+mapServiceqli.keySet());
						system.debug('.............mapEquipMentqli...............'+mapEquipMentqli);system.debug('..............mapEquipMentqli.keySet()...............'+mapEquipMentqli.keySet());
						system.debug('.............mapPartqli...............'+mapPartqli);system.debug('..............mapPartqli.keySet()...............'+mapPartqli.keySet());
						if(mapServiceqli.size()>0&&mapEquipMentqli.size()==0&&mapPartqli.size()==0)//服务产品
						{																
							quotelineitem=mapServiceqli.values()[0];
						}
						if(mapPartqli.size()>0&&mapServiceqli.size()==0&&mapEquipMentqli.size()==0)//配件
						{
							quotelineitem=mapPartqli.values()[0];
						}
						if(mapEquipMentqli.size()>0&&mapPartqli.size()==0&&mapServiceqli.size()==0)//设备
						{
							quotelineitem=mapEquipMentqli.values()[0];
						}
						if(mapServiceqli.size()>0&&mapEquipMentqli.size()>0&&mapPartqli.size()==0)//服务产品+设备
						{
							quotelineitem=mapEquipMentqli.values()[0];	
						}
						if(mapServiceqli.size()>0&&mapPartqli.size()>0&&mapEquipMentqli.size()==0)//服务产品+配件
						{
							quotelineitem=mapServiceqli.values()[0];
						}
						if(mapEquipMentqli.size()>0&&mapPartqli.size()>0&&mapServiceqli.size()==0)//设备+配件
						{	 
							quotelineitem=mapEquipMentqli.values()[0];
						}
						if(mapEquipMentqli.size()>0&&mapPartqli.size()>0&&mapServiceqli.size()>0)//设备+配件+服务产品
						{
							quotelineitem=mapEquipMentqli.values()[0];
						}system.debug('..................quotelineitem.....................'+quotelineitem);
						//报价的业务机会的销售区域不为空,	
						if(quote.Opportunity.SalesRegion__c!=null&&mapSaleregion.containsKey(quote.Opportunity.SalesRegion__c)&&
							mapRecordType.containsKey(quote.Opportunity.RecordTypeId)&&
							quote.Opportunity.AccountId!=null&&mapAcc.containsKey(quote.Opportunity.AccountId))					//报价的业务机会的销售区域不为空,并且mapSaleregion包含			
						{	
							saleregion=mapSaleregion.get(quote.Opportunity.SalesRegion__c);
							system.debug('.........................saleregion........................'+saleregion);
							if(saleregion.Name=='客户服务部(inside)'||saleregion.Name=='客户服务部')								//如果业务机会的销售区域='客户服务部(inside)'或'客户服务部'					
							{
								Account Oppacc=mapAcc.get(quote.Opportunity.AccountId);											//取得客户的销售区域id							
								if(Oppacc!=null&&Oppacc.SellArea__c!=null)															//区域=销售机会客户的区域
									saleregion=mapSaleregion.get(Oppacc.SellArea__c);																													
							}
							rt=mapRecordType.get(quote.Opportunity.RecordTypeId);
							if(rt.DeveloperName=='OPP')
							{system.debug('..............rt.DeveloperName................'+rt.DeveloperName);
							system.debug('saleregion'+);
								if(saleregion!=null&&saleregion.OfficeDirector__c!=null){			//如果是销售商机
									quote.OfficeAdm__c=saleregion.OfficeDirector__c;	system.debug('................quote.OfficeAdm__c.................'+quote.OfficeAdm__c);	
								}else{
									//quotelineitem.addError('');
									string strerror='销售机会的所属部门信息不完整';
									mapQuoteError.put(quotelineitem.QuoteId,strerror);
									break;
								}
							}
						}	
						if(quotelineitem!=null)
						{							
							if(mapSaleProdiscount.containsKey('办事处主任'+string.valueOf(quotelineitem.Family__c)))
								OfficeAdm=mapSaleProdiscount.get('办事处主任'+string.valueOf(quotelineitem.Family__c));			
							if(mapSaleProdiscount.containsKey('销售VP'+string.valueOf(quotelineitem.Family__c)))
								SalesVp=mapSaleProdiscount.get('销售VP'+string.valueOf(quotelineitem.Family__c));
							if(mapSaleProdiscount.containsKey('财务VP'+string.valueOf(quotelineitem.Family__c)))						
								FinancialVp=mapSaleProdiscount.get('财务VP'+string.valueOf(quotelineitem.Family__c));			
							if(mapAcc.containsKey(quote.Agents__c))
								acc=mapAcc.get(string.valueOf(quote.Agents__c));
							system.debug('.....................acc...................................'+acc);
							system.debug('.....................OfficeAdm...................................'+OfficeAdm);
							system.debug('.....................SalesVp...................................'+SalesVp);
							quote.QuoteLineItemDiscount__c=quotelineitem.n_Discount__c;
							if(acc!=null&&OfficeAdm!=null&&SalesVp!=null&&rt.DeveloperName=='OPP')										//如果供应商存在
							{
								system.debug('acc.ChannelType__c......................'+acc.ChannelType__c);
								system.debug('quote.OppProperties__c..................'+quote.OppProperties__c);
								//取得报价上的客户
								if(quote.OppProperties__c=='商业市场'&&acc.ChannelType__c=='商业渠道'||quote.OppProperties__c=='行业市场'&&acc.ChannelType__c=='行业渠道')		//走供应商批准
								{	
									ProdcutionDiscount__c agentprodis;
									system.debug('quotelineitemwwwww'+quotelineitem);
									if(quote.NoProductDisApp__c==false)
									{
										//供应商签约等级,产品系列,渠道类型,产品型号系列
										if(mapAgenProdiscount.containsKey(string.valueOf(acc.Identity__c)+string.valueOf(quotelineitem.Family__c)+string.valueOf(acc.ChannelType__c)+string.valueOf(quotelineitem.productmodelseries__c)))
										{	
											agentprodis=mapAgenProdiscount.get(string.valueOf(acc.Identity__c)+string.valueOf(quotelineitem.Family__c)+string.valueOf(acc.ChannelType__c)+string.valueOf(quotelineitem.productmodelseries__c));
											system.debug('quotelineitem.n_Discount__c'+quotelineitem.n_Discount__c);
											system.debug('agentprodis.n_Discount__c'+agentprodis.n_Discount__c);
											system.debug('SalesVp.n_Discount__c'+SalesVp.n_Discount__c);
											system.debug('OfficeAdm.n_Discount__c'+OfficeAdm.n_Discount__c);
											if((quotelineitem.n_Discount__c/100)>=(agentprodis.n_Discount__c)/100)			//折扣大于代理商	
											{
												quote.SalesVpApproval__c=false;
												quote.FinancialVpApproval__c=false;
												quote.OfficeAdmApproval__c=false;
												quote.ApprovalLevel__c='无需审批';
				                                quote.QuoteLineItemDiscount__c=quotelineitem.n_Discount__c;
												system.debug('不用审批');
											}					
											else if((quotelineitem.n_Discount__c/100)<(SalesVp.n_Discount__c)/100)			//折扣小于销售vp
											{
												//3级审批
												quote.SalesVpApproval__c=true;
												quote.FinancialVpApproval__c=true;
												quote.OfficeAdmApproval__c=true;
												quote.ApprovalLevel__c='三级审批';								
				                                quote.QuoteLineItemDiscount__c=quotelineitem.n_Discount__c;
												system.debug('三级审批');
											}	
											else if((quotelineitem.n_Discount__c/100)>=SalesVp.n_Discount__c/100&&(quotelineitem.n_Discount__c/100)<OfficeAdm.n_Discount__c/100)		//折扣大于销售vp,小于办公室主任	
											{
												//2级审批
												system.debug('.............................2级审批');
												quote.SalesVpApproval__c=true;
												quote.FinancialVpApproval__c=false;
												quote.OfficeAdmApproval__c=true;
												quote.ApprovalLevel__c='二级审批';
				                                quote.QuoteLineItemDiscount__c=quotelineitem.n_Discount__c;
												
											}
											else if((quotelineitem.n_Discount__c/100)>=OfficeAdm.n_Discount__c/100&&(quotelineitem.n_Discount__c/100)<agentprodis.n_Discount__c/100)  //小于办公室主任,大于销售的折扣
											{
												//一级审批
												system.debug('.............................1级审批');
												quote.SalesVpApproval__c=false;
												quote.FinancialVpApproval__c=false;
												quote.OfficeAdmApproval__c=true;
												quote.ApprovalLevel__c='一级审批';
				                                quote.QuoteLineItemDiscount__c=quotelineitem.n_Discount__c;
											}		
										}
										else
										{
											//quotelineitem.addError('产品信息不完整或产品折扣表中无此产品的所属型号系列,若确定提交审批,请需勾选报价上"无产品折扣是否需要审批"字段,审批流程按照3级审批流程进行');
											string strerror='产品信息不完整或产品折扣表中无此产品的所属型号系列,若确定提交审批,请需勾选报价上"无产品折扣是否需要审批"字段,审批流程按照3级审批流程进行';
											mapQuoteError.put(quotelineitem.QuoteId,strerror);
										}
									}
								}
								else															  																										//走销售审批
								{
									ProdcutionDiscount__c saleprodis;	//销售人员	
									if(quote.NoProductDisApp__c==false)
									{	
										if(mapSaleProdiscount.containsKey('销售人员'+string.valueOf(quotelineitem.Family__c)))
										{	
											saleprodis=mapSaleProdiscount.get('销售人员'+string.valueOf(quotelineitem.Family__c));
											if((quotelineitem.n_Discount__c/100)>=(saleprodis.n_Discount__c)/100)		//如果折扣大于销售人员折扣,不用审批
											{
												quote.SalesVpApproval__c=false;
												quote.FinancialVpApproval__c=false;
												quote.OfficeAdmApproval__c=false;
												quote.ApprovalLevel__c='无需审批';
				                                quote.QuoteLineItemDiscount__c=quotelineitem.n_Discount__c;
												system.debug('不用审批');
												system.debug(string.valueOf(quote.SalesVpApproval__c)+string.valueOf(quote.FinancialVpApproval__c)+string.valueOf(quote.OfficeAdmApproval__c));
											}
											else if((quotelineitem.n_Discount__c/100)<(SalesVp.n_Discount__c)/100)		//小于销售vp
											{
												system.debug('SalesVp.n_Discount__c'+SalesVp.n_Discount__c);
												//3级审批
												quote.SalesVpApproval__c=true;
												quote.FinancialVpApproval__c=true;
												quote.OfficeAdmApproval__c=true;
												quote.ApprovalLevel__c='三级审批';								
				                                quote.QuoteLineItemDiscount__c=quotelineitem.n_Discount__c;
												system.debug('三级审批');
												system.debug(string.valueOf(quote.SalesVpApproval__c)+string.valueOf(quote.FinancialVpApproval__c)+string.valueOf(quote.OfficeAdmApproval__c));
											}
											else if((quotelineitem.n_Discount__c/100)>=SalesVp.n_Discount__c/100&&(quotelineitem.n_Discount__c/100)<OfficeAdm.n_Discount__c/100)		//小于销售vp,大于办公室主任	
											{
												//2级审批
												system.debug('.............................2级审批');
												quote.SalesVpApproval__c=true;
												quote.FinancialVpApproval__c=false;
												quote.OfficeAdmApproval__c=true;
												quote.ApprovalLevel__c='二级审批';
				                                quote.QuoteLineItemDiscount__c=quotelineitem.n_Discount__c;
												system.debug(string.valueOf(quote.SalesVpApproval__c)+string.valueOf(quote.FinancialVpApproval__c)+string.valueOf(quote.OfficeAdmApproval__c));
											}
											else if((quotelineitem.n_Discount__c/100)>=OfficeAdm.n_Discount__c/100&&(quotelineitem.n_Discount__c/100)<saleprodis.n_Discount__c/100)  //大于办公室主任,小于销售的折扣
											{
												//一级审批
												system.debug('.............................1级审批');
												quote.SalesVpApproval__c=false;
												quote.FinancialVpApproval__c=false;
												quote.OfficeAdmApproval__c=true;
												quote.ApprovalLevel__c='一级审批';
				                                quote.QuoteLineItemDiscount__c=quotelineitem.n_Discount__c;
												system.debug(string.valueOf(quote.SalesVpApproval__c)+string.valueOf(quote.FinancialVpApproval__c)+string.valueOf(quote.OfficeAdmApproval__c));
											}
										}
										else
										{
											//quotelineitem.addError('产品信息不完整或产品折扣表中无此产品的所属型号系列,若确定提交审批,请需勾选报价上"无产品折扣是否需要审批"字段,审批流程按照3级审批流程进行');
											string strerror='产品信息不完整或产品折扣表中无此产品的所属型号系列,若确定提交审批,请需勾选报价上"无产品折扣是否需要审批"字段,审批流程按照3级审批流程进行';
											mapQuoteError.put(quotelineitem.QuoteId,strerror);
										}  
									}
								}
							}
						}
					}
				}	
			}
			system.debug('..................mapQuoteError.......................'+mapQuoteError.values());
			if(trigger.isInsert||trigger.isUpdate)
			{
				for(QuoteLineItem qli:trigger.new)
				{
					if(mapQuoteError.containsKey(qli.QuoteId))
						qli.addError(mapQuoteError.get(qli.QuoteId));
				}
			}
			if(trigger.isDelete)
			{
				for(QuoteLineItem qli:trigger.old)
				{
					if(mapQuoteError.containsKey(qli.QuoteId))
						qli.addError(mapQuoteError.get(qli.QuoteId));				
				}
			}	
		}
		update listQuote;		system.debug('..........listQuote..............'+listQuote);
	}
}