//内部样机订单明细实际费用(预计费用)的计算
//lurrykong
//2013年4月26日
global class clsPredictActualPrice implements Database.Batchable<SObject>, Database.Stateful
{
	DateTime nowToday = Date.today();	//当前时间
	global Database.queryLocator start(Database.BatchableContext ctx)
	{	
		//内部样机下的所有订单明细									id,订单记录类型Name,费用是否超标,换货方,客户名称,订单id,订单,产品,新样机产品新价格,旧样机产品价格	,样机预计费用,截止目前实际费用,样机核算费用,测试状态,内部样机开始时间,内部样机预计结束时间,借用人签收日期,是否延期,延期日期	,库管签收日期,是否为新样机,实际费用(预计费用),订单的审批状态,订单销售区域,年,月
    	return Database.getQueryLocator([Select id,n_OrderNo__r.RecordTypeName__c,n_OrderNo__r.IfCostOverWeight__c,n_OrderNo__r.Replacement1__c, n_OrderNo__r.customer__c, n_OrderNo__r.Id, n_OrderNo__c,
																												n_ProductByOrd__c,n_ProductByOrd__r.NewProductPrice__c,n_ProductByOrd__r.OldProductPrice__c,Field1__c,
																												Nowactual__c,demoamount__c,TestStatus__c,WhetherTheDelay__c,AddDate__c,KuguanContractDate__c,
																												Demostar__c,Demoend__c,BorrowerReceiptDate__c,IfNewProduct__c,PracticalExpectPrice__c,n_OrderNo__r.ApprovalStatus__c,
																												n_OrderNo__r.SalesRegion__c,n_Year__c,n_Month__c	 
																		 										from OrderDetails__c 
																		 										where n_OrderNo__r.RecordTypeName__c='内部样机订单'and TestStatus__c='测试中' and (n_OrderNo__r.ApprovalStatus__c='已审批' or n_OrderNo__r.ApprovalStatus__c='延期已审批')]);																																						
	}			//更新实际(预计)金额 			     		 
	global void execute(Database.BatchableContext ctx, List<Sobject> scope)
	{
		set<id> setOrd=new set<id>();
		for(Sobject sc:scope)
		{
			OrderDetails__c orderdetail=(OrderDetails__c)sc;
			if(orderdetail.n_OrderNo__c!=null)
				setOrd.add(orderdetail.n_OrderNo__c);
		}
		//订单id为键,订单为值									id,客户,记录类型名称,换货方,退货方,销售区域,审批状态
		map<id,Orders__c> mapOrder=new map<id,Orders__c>([select id,customer__c,RecordTypeName__c,Replacement1__c,Returnssquare__c,SalesRegion__c,ApprovalStatus__c,IfCostOverWeight__c from Orders__c where id IN:setOrd]);	
		DateTime dtToday = Date.today();	//当前时间
		list<OrderDetails__c> listOrderdetail=new list<OrderDetails__c>();
		system.debug('...............................scope.....................................'+scope.size());
		system.debug('...............................scope.....................................'+scope);
		for(Sobject sc:scope)  
		{
			Orders__c orde=new Orders__c();
			OrderDetails__c orderdetail=(OrderDetails__c)sc;
			system.debug('...........................orderdetail.........................'+orderdetail);
			if(mapOrder.containsKey(orderdetail.n_OrderNo__c))
				orde=mapOrder.get(orderdetail.n_OrderNo__c);
			if(orderdetail!=null&&orderdetail.Demostar__c!=null&&orderdetail.Demoend__c!=null&&orderdetail.Field1__c!=null)					//如果订单明细不为空,预计开始时间,预计结束时间不为空20130726
			{	
				if(Date.today()>orderdetail.Demoend__c)																						//结束日期不为空,如果当前日期大于预计结束日期
				{
					system.debug('.................................orderdetail.Field1__c....................................'+orderdetail.Field1__c);
					integer numberDaysDue =orderdetail.Demoend__c.daysBetween(Date.today());										
					system.debug('.................................numberDaysDue............................................'+numberDaysDue);
					if(orderdetail.n_OrderNo__r.IfCostOverWeight__c==false)																	//没有超标
					{
						if(orderdetail.IfNewProduct__c==true)																				//新样机							
						{
							if(orderdetail.WhetherTheDelay__c==true&&orde!=null&&orde.ApprovalStatus__c=='延期已审批')																		//有延期
							{
								integer DelayDaysDue=orderdetail.Demoend__c.daysBetween(orderdetail.AddDate__c);							//延期的天数			
								if(DelayDaysDue>=30)																						//延期超过30天
								{system.debug('..................DelayDaysDue延期的天数.................'+DelayDaysDue);
									if(orderdetail.AddDate__c.daysBetween(Date.today())>0)													//当前时间超过延期时间																			
									{
										integer ii=DelayDaysDue/30;																	
										decimal predictprice=orderdetail.n_ProductByOrd__r.NewProductPrice__c*ii;		
										if(DelayDaysDue>ii*30)																				//延期
										{
											decimal DelayPay=predictprice+orderdetail.n_ProductByOrd__r.NewProductPrice__c;					//延期的费用	
											system.debug('..................DelayPay延期的费用.........................'+DelayPay);			
											integer increDelay=orderdetail.AddDate__c.daysBetween(Date.today());							//超过延期的时间
											system.debug('.........................increDelay超过延期的时间..........................'+increDelay);
											if(increDelay<=30)
											{	system.debug('..................................DelayPay.....................................'+DelayPay);
												orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+orderdetail.n_ProductByOrd__r.NewProductPrice__c+DelayPay;
												system.debug('..................................orderdetail.PracticalExpectPrice__c............................'+orderdetail.PracticalExpectPrice__c);
											}
											if(increDelay>30)																				//当前时间-延期的时间>30
											{
												integer icin=increDelay/30;
												decimal IncrePay=icin*orderdetail.n_ProductByOrd__r.NewProductPrice__c;												
												system.debug('.....................IncrePay......................'+IncrePay);
												if(increDelay>icin*30){
													orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+DelayPay+IncrePay+orderdetail.n_ProductByOrd__r.NewProductPrice__c;			
													system.debug('...........................orderdetail.PracticalExpectPrice__c............................'+orderdetail.PracticalExpectPrice__c);
												}else{
													orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+DelayPay+IncrePay;
												}
												
											}																			
										}
										else			
										{
											decimal DelayPay=predictprice;																	//延期的费用													
											integer increDelay=orderdetail.AddDate__c.daysBetween(Date.today());							//超过延期的时间
											if(increDelay<=30)
											{	system.debug('..................................DelayPay.....................................'+DelayPay);
												orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+orderdetail.n_ProductByOrd__r.NewProductPrice__c+DelayPay;
												system.debug('..................................orderdetail.PracticalExpectPrice__c............................'+orderdetail.PracticalExpectPrice__c);
											}
											if(increDelay>30)																				//当前时间-延期的时间>30
											{
												integer icin=increDelay/30;
												decimal IncrePay=icin*orderdetail.n_ProductByOrd__r.NewProductPrice__c;												
												if(increDelay>icin*30){
													orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+DelayPay+IncrePay+orderdetail.n_ProductByOrd__r.NewProductPrice__c;			
												}else{
													orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+DelayPay+IncrePay;
												}												
											}
										}									
									}
									else																													//当前时间未超过延期时间
									{
										integer ii=DelayDaysDue/30;																											
										decimal predictprice=orderdetail.n_ProductByOrd__r.NewProductPrice__c*ii;																
										if(DelayDaysDue>ii*30){
											 orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+predictprice+orderdetail.n_ProductByOrd__r.NewProductPrice__c;				//延期的费用	
										}else{
											 orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+predictprice;																//延期的费用
										}
									}								
								}
								else																														//延期不超过30天	
								{
									if(orderdetail.AddDate__c.daysBetween(Date.today())>0)																	//超过延期时间
									{
										integer increDelay=orderdetail.AddDate__c.daysBetween(Date.today());												//超过延期的时间
										if(increDelay<=30)
										{
											orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+orderdetail.n_ProductByOrd__r.NewProductPrice__c;		//多加一个月的费用
										}
										if(increDelay>30)																									//超过延期时间一个月	
										{
											integer icin=increDelay/30;
											decimal IncrePay=icin*orderdetail.n_ProductByOrd__r.NewProductPrice__c;
											if(increDelay>icin*30){
												orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+IncrePay+orderdetail.n_ProductByOrd__r.NewProductPrice__c;			
											}else{
												orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+IncrePay;
											}
										}
									}	
									else																													//未超过延期时间
									{
										orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c;															//实际费用(预计费用)=预计费用	
									}	
								}
							}
							else																															//没有延期申请
							{	system.debug('.......................orderdetail.Demoend__c.daysBetween(Date.today()..........................');
								if(orderdetail.Demoend__c.daysBetween(Date.today())>0)																		//当前时间超过预计结束时间
								{
									integer incredemod=orderdetail.Demoend__c.daysBetween(Date.today());													//超过的时间
									if(incredemod<=30)
									{
										orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+orderdetail.n_ProductByOrd__r.NewProductPrice__c;
										system.debug('.......................orderdetail.PracticalExpectPrice__c........................'+orderdetail.PracticalExpectPrice__c);
									}
									if(incredemod>30)
									{
										integer icin=incredemod/30;
										decimal IncrePay=icin*orderdetail.n_ProductByOrd__r.NewProductPrice__c;										
										if(incredemod>icin*30){
											orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+IncrePay+orderdetail.n_ProductByOrd__r.NewProductPrice__c;			
										}else{
											orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+IncrePay;
										}
										system.debug('.......................orderdetail.PracticalExpectPrice__c........................'+orderdetail.PracticalExpectPrice__c);
										system.debug('.......................orderdetail.Field1__c........................'+orderdetail.Field1__c);
										
									}
								}			
								else																														//当前时间不超过预计结束时间
								{
									orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c;
									system.debug('.......................orderdetail.PracticalExpectPrice__c........................'+orderdetail.PracticalExpectPrice__c);
								}
							}
						}
						else																												//旧样机		
						{
							if(orderdetail.WhetherTheDelay__c==true&&orde!=null&&orde.ApprovalStatus__c=='延期已审批')																		//有延期
							{
								integer DelayDaysDue=orderdetail.Demoend__c.daysBetween(orderdetail.AddDate__c);							//延期的天数			
								if(DelayDaysDue>=30)																						//延期超过30天
								{
									if(orderdetail.AddDate__c.daysBetween(Date.today())>0)													//当前时间超过延期时间																			
									{
										integer ii=DelayDaysDue/30;																	
										decimal predictprice=orderdetail.n_ProductByOrd__r.OldProductPrice__c*ii;		
										if(DelayDaysDue>ii*30)																				//延期
										{
											decimal DelayPay=predictprice+orderdetail.n_ProductByOrd__r.OldProductPrice__c;					//延期的费用	
												
											integer increDelay=orderdetail.AddDate__c.daysBetween(Date.today());							//超过延期的时间
											if(increDelay<=30)
											{	system.debug('..................................DelayPay.....................................'+DelayPay);
												orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+orderdetail.n_ProductByOrd__r.OldProductPrice__c+DelayPay;
												system.debug('..................................orderdetail.PracticalExpectPrice__c............................'+orderdetail.PracticalExpectPrice__c);
											}
											if(increDelay>30)																				//当前时间-延期的时间>30
											{
												integer icin=increDelay/30;
												decimal IncrePay=icin*orderdetail.n_ProductByOrd__r.OldProductPrice__c;												
												if(increDelay>icin*30){
													orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+DelayPay+IncrePay+orderdetail.n_ProductByOrd__r.OldProductPrice__c;			
												}else{
													orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+DelayPay+IncrePay;
												}
												
											}																			
										}
										else			
										{
											decimal DelayPay=predictprice;																	//延期的费用													
											integer increDelay=orderdetail.AddDate__c.daysBetween(Date.today());							//超过延期的时间
											if(increDelay<=30)
											{	system.debug('..................................DelayPay.....................................'+DelayPay);
												orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+orderdetail.n_ProductByOrd__r.OldProductPrice__c+DelayPay;
												system.debug('..................................orderdetail.PracticalExpectPrice__c............................'+orderdetail.PracticalExpectPrice__c);
											}
											if(increDelay>30)																				//当前时间-延期的时间>30
											{
												integer icin=increDelay/30;
												decimal IncrePay=icin*orderdetail.n_ProductByOrd__r.OldProductPrice__c;												
												if(increDelay>icin*30){
													orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+DelayPay+IncrePay+orderdetail.n_ProductByOrd__r.OldProductPrice__c;			
												}else{
													orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+DelayPay+IncrePay;
												}												
											}
										}									
									}
									else																													//当前时间未超过延期时间
									{
										integer ii=DelayDaysDue/30;																											
										decimal predictprice=orderdetail.n_ProductByOrd__r.OldProductPrice__c*ii;																
										if(DelayDaysDue>ii*30){
											 orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+predictprice+orderdetail.n_ProductByOrd__r.OldProductPrice__c;				//延期的费用	
										}else{
											 orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+predictprice;																//延期的费用
										}
									}								
								}
								else																														//延期不超过30天	
								{
									if(orderdetail.AddDate__c.daysBetween(Date.today())>0)																	//超过延期时间
									{
										integer increDelay=orderdetail.AddDate__c.daysBetween(Date.today());												//超过延期的时间
										if(increDelay<=30)
										{
											orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+orderdetail.n_ProductByOrd__r.OldProductPrice__c;		//多加一个月的费用
										}
										if(increDelay>30)																									//超过延期时间一个月	
										{
											integer icin=increDelay/30;
											decimal IncrePay=icin*orderdetail.n_ProductByOrd__r.OldProductPrice__c;
											if(increDelay>icin*30){
												orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+IncrePay+orderdetail.n_ProductByOrd__r.OldProductPrice__c;			
											}else{
												orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+IncrePay;
											}
										}
									}	
									else																													//未超过延期时间
									{
										orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c;															//实际费用(预计费用)=预计费用	
									}	
								}
							}
							else																															//没有延期申请
							{
								if(orderdetail.Demoend__c.daysBetween(Date.today())>0)																		//当前时间超过预计结束时间
								{
									integer incredemod=orderdetail.Demoend__c.daysBetween(Date.today());													//超过的时间
									if(incredemod<=30&&orderdetail.Field1__c!=null)
									{
										orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+orderdetail.n_ProductByOrd__r.OldProductPrice__c;
									}
									if(incredemod>30)
									{
										integer icin=incredemod/30;
										decimal IncrePay=icin*orderdetail.n_ProductByOrd__r.OldProductPrice__c;										
										if(incredemod>icin*30){
											orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+IncrePay+orderdetail.n_ProductByOrd__r.OldProductPrice__c;			
										}else{
											orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+IncrePay;
										}
									}
								}			
								else																														//当前时间不超过预计结束时间
								{
									orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c;
								}
							}
						}
						
					}
					else																													//超标后的金额按1.5倍来算(实际预计费用,预计费用)
					{
						if(orderdetail.IfNewProduct__c==true)																				//新样机							
						{
							if(orderdetail.WhetherTheDelay__c==true&&orde!=null&&orde.ApprovalStatus__c=='延期已审批')																		//有延期
							{
								integer DelayDaysDue=orderdetail.Demoend__c.daysBetween(orderdetail.AddDate__c);							//延期的天数			
								if(DelayDaysDue>=30)																						//延期超过30天
								{
									if(orderdetail.AddDate__c.daysBetween(Date.today())>0)													//当前时间超过延期时间																			
									{
										integer ii=DelayDaysDue/30;																	
										decimal predictprice=orderdetail.n_ProductByOrd__r.NewProductPrice__c*ii*1.5;		
										if(DelayDaysDue>ii*30)																				//延期
										{
											decimal DelayPay=predictprice+orderdetail.n_ProductByOrd__r.NewProductPrice__c*1.5;					//延期的费用	
												
											integer increDelay=orderdetail.AddDate__c.daysBetween(Date.today());							//超过延期的时间
											if(increDelay<=30)
											{	system.debug('..................................DelayPay.....................................'+DelayPay);
												orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+orderdetail.n_ProductByOrd__r.NewProductPrice__c*1.5+DelayPay;
												system.debug('..................................orderdetail.PracticalExpectPrice__c............................'+orderdetail.PracticalExpectPrice__c);
											}
											if(increDelay>30)																				//当前时间-延期的时间>30
											{
												integer icin=increDelay/30;
												decimal IncrePay=icin*orderdetail.n_ProductByOrd__r.NewProductPrice__c*1.5;												
												if(increDelay>icin*30){
													orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+DelayPay+IncrePay+orderdetail.n_ProductByOrd__r.NewProductPrice__c*1.5;			
												}else{
													orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+DelayPay+IncrePay;
												}
												
											}																			
										}
										else			
										{
											decimal DelayPay=predictprice;																	//延期的费用													
											integer increDelay=orderdetail.AddDate__c.daysBetween(Date.today());							//超过延期的时间
											if(increDelay<=30)
											{	system.debug('..................................DelayPay.....................................'+DelayPay);
												orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+orderdetail.n_ProductByOrd__r.NewProductPrice__c*1.5+DelayPay;
												system.debug('..................................orderdetail.PracticalExpectPrice__c............................'+orderdetail.PracticalExpectPrice__c);
											}
											if(increDelay>30)																				//当前时间-延期的时间>30
											{
												integer icin=increDelay/30;
												decimal IncrePay=icin*orderdetail.n_ProductByOrd__r.NewProductPrice__c*1.5;												
												if(increDelay>icin*30){
													orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+DelayPay+IncrePay+orderdetail.n_ProductByOrd__r.NewProductPrice__c*1.5;			
												}else{
													orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+DelayPay+IncrePay;
												}												
											}
										}									
									}
									else																													//当前时间未超过延期时间
									{
										integer ii=DelayDaysDue/30;																											
										decimal predictprice=orderdetail.n_ProductByOrd__r.NewProductPrice__c*ii*1.5;																
										if(DelayDaysDue>ii*30){
											 orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+predictprice+orderdetail.n_ProductByOrd__r.NewProductPrice__c*1.5;				//延期的费用	
										}else{
											 orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+predictprice;																//延期的费用
										}
									}								
								}
								else																														//延期不超过30天	
								{
									if(orderdetail.AddDate__c.daysBetween(Date.today())>0)																	//超过延期时间
									{
										integer increDelay=orderdetail.AddDate__c.daysBetween(Date.today());												//超过延期的时间
										if(increDelay<=30)
										{
											orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+orderdetail.n_ProductByOrd__r.NewProductPrice__c*1.5;		//多加一个月的费用
										}
										if(increDelay>30)																									//超过延期时间一个月	
										{
											integer icin=increDelay/30;
											decimal IncrePay=icin*orderdetail.n_ProductByOrd__r.NewProductPrice__c*1.5;
											if(increDelay>icin*30){
												orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+IncrePay+orderdetail.n_ProductByOrd__r.NewProductPrice__c*1.5;			
											}else{
												orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+IncrePay;
											}
										}
									}	
									else																													//未超过延期时间
									{
										orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c;															//实际费用(预计费用)=预计费用	
									}	
								}
							}
							else																															//没有延期申请
							{
								if(orderdetail.Demoend__c.daysBetween(Date.today())>0)																		//当前时间超过预计结束时间
								{
									integer incredemod=orderdetail.Demoend__c.daysBetween(Date.today());													//超过的时间
									if(incredemod<=30)
									{
										orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+orderdetail.n_ProductByOrd__r.NewProductPrice__c*1.5;
										system.debug('................orderdetail.PracticalExpectPrice__c...................'+orderdetail.PracticalExpectPrice__c);
									}
									if(incredemod>30)
									{
										integer icin=incredemod/30;
										decimal IncrePay=icin*orderdetail.n_ProductByOrd__r.NewProductPrice__c*1.5;										
										if(incredemod>icin*30){
											orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+IncrePay+orderdetail.n_ProductByOrd__r.NewProductPrice__c*1.5;			
										}else{
											orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+IncrePay;
										}
										system.debug('................orderdetail.PracticalExpectPrice__c...................'+orderdetail.PracticalExpectPrice__c);
									}
								}			
								else																														//当前时间不超过预计结束时间
								{
									orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c;
									system.debug('................orderdetail.PracticalExpectPrice__c...................'+orderdetail.PracticalExpectPrice__c);
								}
							}
						}
						else																												//旧样机		
						{
							if(orderdetail.WhetherTheDelay__c==true&&orde!=null&&orde.ApprovalStatus__c=='延期已审批')																		//有延期
							{
								integer DelayDaysDue=orderdetail.Demoend__c.daysBetween(orderdetail.AddDate__c);							//延期的天数			
								if(DelayDaysDue>=30)																						//延期超过30天
								{
									if(orderdetail.AddDate__c.daysBetween(Date.today())>0)													//当前时间超过延期时间																			
									{
										integer ii=DelayDaysDue/30;																	
										decimal predictprice=orderdetail.n_ProductByOrd__r.OldProductPrice__c*ii*1.5;		
										if(DelayDaysDue>ii*30)																				//延期
										{
											decimal DelayPay=predictprice+orderdetail.n_ProductByOrd__r.OldProductPrice__c*1.5;					//延期的费用	
												
											integer increDelay=orderdetail.AddDate__c.daysBetween(Date.today());							//超过延期的时间
											if(increDelay<=30)
											{	system.debug('..................................DelayPay.....................................'+DelayPay);
												orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+orderdetail.n_ProductByOrd__r.OldProductPrice__c*1.5+DelayPay;
												system.debug('..................................orderdetail.PracticalExpectPrice__c............................'+orderdetail.PracticalExpectPrice__c);
											}
											if(increDelay>30)																				//当前时间-延期的时间>30
											{
												integer icin=increDelay/30;
												decimal IncrePay=icin*orderdetail.n_ProductByOrd__r.OldProductPrice__c*1.5;												
												if(increDelay>icin*30){
													orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+DelayPay+IncrePay+orderdetail.n_ProductByOrd__r.OldProductPrice__c*1.5;			
												}else{
													orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+DelayPay+IncrePay;
												}
												
											}																			
										}
										else			
										{
											decimal DelayPay=predictprice;																	//延期的费用													
											integer increDelay=orderdetail.AddDate__c.daysBetween(Date.today());							//超过延期的时间
											if(increDelay<=30)
											{	system.debug('..................................DelayPay.....................................'+DelayPay);
												orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+orderdetail.n_ProductByOrd__r.OldProductPrice__c*1.5+DelayPay;
												system.debug('..................................orderdetail.PracticalExpectPrice__c............................'+orderdetail.PracticalExpectPrice__c);
											}
											if(increDelay>30)																				//当前时间-延期的时间>30
											{
												integer icin=increDelay/30;
												decimal IncrePay=icin*orderdetail.n_ProductByOrd__r.OldProductPrice__c*1.5;												
												if(increDelay>icin*30){
													orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+DelayPay+IncrePay+orderdetail.n_ProductByOrd__r.OldProductPrice__c*1.5;			
												}else{
													orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+DelayPay+IncrePay;
												}												
											}
										}									
									}
									else																													//当前时间未超过延期时间
									{
										integer ii=DelayDaysDue/30;																											
										decimal predictprice=orderdetail.n_ProductByOrd__r.OldProductPrice__c*ii*1.5;																
										if(DelayDaysDue>ii*30){
											 orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+predictprice+orderdetail.n_ProductByOrd__r.OldProductPrice__c*1.5;				//延期的费用	
										}else{
											 orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+predictprice;																//延期的费用
										}
									}								
								}
								else																														//延期不超过30天	
								{
									if(orderdetail.AddDate__c.daysBetween(Date.today())>0)																	//超过延期时间
									{
										integer increDelay=orderdetail.AddDate__c.daysBetween(Date.today());												//超过延期的时间
										if(increDelay<=30)
										{
											orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+orderdetail.n_ProductByOrd__r.OldProductPrice__c*1.5;		//多加一个月的费用
										}
										if(increDelay>30)																									//超过延期时间一个月	
										{
											integer icin=increDelay/30;
											decimal IncrePay=icin*orderdetail.n_ProductByOrd__r.OldProductPrice__c*1.5;
											if(increDelay>icin*30){
												orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+IncrePay+orderdetail.n_ProductByOrd__r.OldProductPrice__c*1.5;			
											}else{
												orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+IncrePay;
											}
										}
									}	
									else																													//未超过延期时间
									{
										orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c;															//实际费用(预计费用)=预计费用	
									}	
								}
							}
							else																															//没有延期申请
							{
								if(orderdetail.Demoend__c.daysBetween(Date.today())>0)																		//当前时间超过预计结束时间
								{
									integer incredemod=orderdetail.Demoend__c.daysBetween(Date.today());													//超过的时间
									if(incredemod<=30)
									{
										orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+orderdetail.n_ProductByOrd__r.OldProductPrice__c*1.5;
									}
									if(incredemod>30)
									{
										integer icin=incredemod/30;
										decimal IncrePay=icin*orderdetail.n_ProductByOrd__r.OldProductPrice__c*1.5;										
										if(incredemod>icin*30){
											orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+IncrePay+orderdetail.n_ProductByOrd__r.OldProductPrice__c*1.5;			
										}else{
											orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+IncrePay;
										}
									}
								}			
								else																				//当前时间不超过预计结束时间
								{
									orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c;
								}
							}
						}

					}
				}
				else																									//当前时间小于预计结束时间
				{
					//预计费用(实际费用)==预计费用
					orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c;
				}				
			}
			listOrderdetail.add(orderdetail);
		}
		
		system.debug('.................................listOrderdetail..................................'+listOrderdetail);
		
		update listOrderdetail;		
		/*
			****************************
			更新完订单明细后,自动更新费用指标的实际金额,可用金额
			****************************
		*/								
		/*
		list<PrototypeCosts__c> listUppro=new list<PrototypeCosts__c>();
		//订单id为键,订单为值								季度类型Name,是否超标
		map<id,Orders__c> mapOrder=new map<id,Orders__c>([select id,RecordTypeName__c,IfCostOverWeight__c,SalesRegion__c from Orders__c where RecordTypeName__c='内部样机订单']);	
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
					system.debug('....................str.........................'+str);
					if(!mapProtype.containsKey(str))
						mapProtype.put(str,proc); 
				}
			}
		}
		system.debug('............................mapProtype.....................................'+mapProtype.values());				
		//查询订单明细							汇总实际费用(预计费用),销售区域,年,月					条件:内部样机订单,==测试中,借用人签收日期！=null																							
		AggregateResult[] aggOrderDetailResult=[select sum(PracticalExpectPrice__c)sumFeiYong,n_OrderNo__r.SalesRegion__c,n_Year__c,n_Month__c from OrderDetails__c
																										where n_OrderNo__r.RecordTypeName__c='内部样机订单' and TestStatus__c='测试中' and n_OrderNo__r.ApprovalStatus__c='已审批' and BorrowerReceiptDate__c!=null
																										group by n_OrderNo__r.SalesRegion__c,n_Year__c,n_Month__c];	                                		
	 	//销售区域,年,季度为键,订单明细的实际(预计金额)为值 
	 	map<string,decimal> mapPraExpectPrice=new map<string,decimal>();
	 	for(AggregateResult ar:aggOrderDetailResult)
	 	{
			string str=string.valueOf(ar.get('SalesRegion__c'))+string.valueOf(ar.get('n_Year__c'))+string.valueOf(ar.get('n_Month__c'));	
	 		system.debug('........................str...............................'+str);
	 		if(!mapPraExpectPrice.containsKey(str))
	 		{
	 				decimal deci=decimal.valueOf(String.valueOf(ar.get('sumFeiYong')));
	 				mapPraExpectPrice.put(str,deci);
	 		}
	 	}
	 	system.debug('............................mapPraExpectPrice.....................................'+mapPraExpectPrice.values());
 		for(Sobject sc:scope)
		{
			OrderDetails__c orderdetail=(OrderDetails__c)sc;
	 		system.debug('........................orderdetail...........................................'+orderdetail);
	 		if(orderdetail.BorrowerReceiptDate__c!=null&&orderdetail.n_OrderNo__c!=null&&mapOrder.containsKey(orderdetail.n_OrderNo__c))						//借用人签收日期,订单不为空
	 		{	 			
	 			Orders__c ord=mapOrder.get(orderdetail.n_OrderNo__c);system.debug('..........................ord.........................'+ord);
	 			if(ord.SalesRegion__c!=null&&orderdetail.n_Year__c!=null&&orderdetail.n_Month__c!=null)
	 			{
	 				string str=string.valueOf(ord.SalesRegion__c)+string.valueOf(orderdetail.n_Year__c)+string.valueOf(orderdetail.n_Month__c);
	 				system.debug('............................str................................'+str);
	 				if(mapProtype.containsKey(str)&&mapPraExpectPrice.containsKey(str))
	 				{
	 					decimal deci=mapPraExpectPrice.get(str);
						PrototypeCosts__c pt=mapProtype.get(str);
						pt.n_FactAmount__c=deci;											//实际金额
						pt.ReAmount__c=pt.n_BudgetAmount__c-deci;							
						listUppro.add(pt);	
	 				}	
	 			} 		
	 		}
		}
		system.debug('..........................listUppro............................'+listUppro);
		update listUppro;
		*/
	}
	global void finish(Database.BatchableContext ctx)
	{
		       	
	}
}