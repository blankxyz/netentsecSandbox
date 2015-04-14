//订单明细的		借用人签收日期变化之前   自动更新   预计费用(实际费用)
//lurrykong
//2013.5
trigger OrderDetails_AutoUpdatePracticalExpectPrice on OrderDetails__c (before update) 
{
	set<id> setOrderDetailselect=new set<id>();								//订单明细id		
	list<PrototypeCosts__c> listUppro=new list<PrototypeCosts__c>();		//需要更新的费用指标
	set<id> setInsideOrder=new set<id>();									//内部样机订单id
	set<id> setProid=new set<id>();                          				//产品id
	for(OrderDetails__c orderd:trigger.new)
	{
		OrderDetails__c oldorderd=trigger.oldMap.get(orderd.id);
		system.debug('AAAAAAAAAAAAAAAAAAAAAAAAAAAAA..'+oldorderd.BorrowerReceiptDate__c);
		system.debug('AAAAAAAAAAAAAAAAAAAAAAAAAAAAA..'+oldorderd.BorrowerReceiptDate__c);
		if(orderd.BorrowerReceiptDate__c!=oldorderd.BorrowerReceiptDate__c&&orderd.BorrowerReceiptDate__c!=null)
		{
			setInsideOrder.add(orderd.n_OrderNo__c);
			setOrderDetailselect.add(orderd.id);
			if(orderd.n_ProductByOrd__c!=null)			
			{
				setProid.add(orderd.n_ProductByOrd__c);	
			}
		}		
	}
	if(setOrderDetailselect.size()>0)
	{
		//产品id为键,产品为值          新样机产品价格,旧样机产品价格
	  	map<id,Product2> mapProd=new map<id,Product2>([select id,NewProductPrice__c,OldProductPrice__c from Product2 where id IN:setProid]);
		//订单id为键,订单为值								记录类型Name,是否超标
		map<id,Orders__c> mapOrderStatu=new map<id,Orders__c>([select id,RecordTypeName__c,IfCostOverWeight__c,SalesRegion__c,ApprovalStatus__c from Orders__c where RecordTypeName__c='内部样机订单' and id IN:setInsideOrder]);		
			
	
			DateTime dtToday = Date.today();	//当前时间
			list<OrderDetails__c> listOrderdetail=new list<OrderDetails__c>();
			for(OrderDetails__c orderdetail:trigger.new)
			{
				Orders__c faord=new Orders__c();																									//订单对象				
				Product2 prod=new Product2();
				OrderDetails__c oldOrderDetail=trigger.oldMap.get(orderdetail.id);																	//取得旧的对象
				if(orderdetail.n_OrderNo__c!=null&&mapOrderStatu.containsKey(orderdetail.n_OrderNo__c))
					faord=mapOrderStatu.get(orderdetail.n_OrderNo__c);
				if(orderdetail.n_ProductByOrd__c!=null&&mapProd.containsKey(orderdetail.n_ProductByOrd__c))
					prod=mapProd.get(orderdetail.n_ProductByOrd__c);
				if(oldOrderDetail.BorrowerReceiptDate__c!=orderdetail.BorrowerReceiptDate__c&&orderdetail.BorrowerReceiptDate__c!=null)
				{					
					if(orderdetail!=null&&orderdetail.Demostar__c!=null&&orderdetail.Demoend__c!=null&&faord.ApprovalStatus__c=='已审批')												//如果订单明细不为空,预计开始时间,预计结束时间不为空
					{	
						if(Date.today()>orderdetail.Demoend__c)																						//结束日期不为空,如果当前日期大于预计结束日期
						{
							integer numberDaysDue =orderdetail.Demoend__c.daysBetween(Date.today());																
							if(faord.IfCostOverWeight__c==false)																				//没有超标
							{
								if(orderdetail.IfNewProduct__c==true)																				//新样机							
								{
									if(orderdetail.WhetherTheDelay__c==true)																		//有延期
									{
										integer DelayDaysDue=orderdetail.Demoend__c.daysBetween(orderdetail.AddDate__c);							//延期的天数			
										if(DelayDaysDue>=30)																						//延期超过30天
										{
											if(orderdetail.AddDate__c.daysBetween(Date.today())>0)													//当前时间超过延期时间																			
											{
												integer ii=DelayDaysDue/30;																	
												decimal predictprice=prod.NewProductPrice__c*ii;		
												if(DelayDaysDue>ii*30)																				//延期
												{
													decimal DelayPay=predictprice+prod.NewProductPrice__c;											//延期的费用														
													integer increDelay=orderdetail.AddDate__c.daysBetween(Date.today());							//超过延期的时间
													if(increDelay<=30)
													{	system.debug('..................................DelayPay.....................................'+DelayPay);
														orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+prod.NewProductPrice__c+DelayPay;
														system.debug('..................................orderdetail.PracticalExpectPrice__c............................'+orderdetail.PracticalExpectPrice__c);
													}
													if(increDelay>30)																				//当前时间-延期的时间>30
													{
														integer icin=increDelay/30;
														decimal IncrePay=icin*prod.NewProductPrice__c;												
														if(increDelay>icin*30){
															orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+DelayPay+IncrePay+prod.NewProductPrice__c;			
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
														orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+prod.NewProductPrice__c+DelayPay;
														system.debug('..................................orderdetail.PracticalExpectPrice__c............................'+orderdetail.PracticalExpectPrice__c);
													}
													if(increDelay>30)																				//当前时间-延期的时间>30
													{
														integer icin=increDelay/30;
														decimal IncrePay=icin*prod.NewProductPrice__c;												
														if(increDelay>icin*30){
															orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+DelayPay+IncrePay+prod.NewProductPrice__c;			
														}else{
															orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+DelayPay+IncrePay;
														}												
													}
												}									
											}
											else																													//当前时间未超过延期时间
											{
												integer ii=DelayDaysDue/30;																											
												decimal predictprice=prod.NewProductPrice__c*ii;																
												if(DelayDaysDue>ii*30){
													 orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+predictprice+prod.NewProductPrice__c;				//延期的费用	
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
													orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+prod.NewProductPrice__c;		//多加一个月的费用
												}
												if(increDelay>30)																									//超过延期时间一个月	
												{
													integer icin=increDelay/30;
													decimal IncrePay=icin*prod.NewProductPrice__c;
													if(increDelay>icin*30){
														orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+IncrePay+prod.NewProductPrice__c;			
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
												orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+prod.NewProductPrice__c;
											}
											if(incredemod>30)
											{
												integer icin=incredemod/30;
												decimal IncrePay=icin*prod.NewProductPrice__c;										
												if(incredemod>icin*30){
													orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+IncrePay+prod.NewProductPrice__c;			
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
								else																												//旧样机		
								{
									if(orderdetail.WhetherTheDelay__c==true)																		//有延期
									{
										integer DelayDaysDue=orderdetail.Demoend__c.daysBetween(orderdetail.AddDate__c);							//延期的天数			
										if(DelayDaysDue>=30)																						//延期超过30天
										{
											if(orderdetail.AddDate__c.daysBetween(Date.today())>0)													//当前时间超过延期时间																			
											{
												integer ii=DelayDaysDue/30;																	
												decimal predictprice=prod.OldProductPrice__c*ii;		
												if(DelayDaysDue>ii*30)																				//延期
												{
													decimal DelayPay=predictprice+prod.OldProductPrice__c;					//延期的费用	
														
													integer increDelay=orderdetail.AddDate__c.daysBetween(Date.today());							//超过延期的时间
													if(increDelay<=30)
													{	system.debug('..................................DelayPay.....................................'+DelayPay);
														orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+prod.OldProductPrice__c+DelayPay;
														system.debug('..................................orderdetail.PracticalExpectPrice__c............................'+orderdetail.PracticalExpectPrice__c);
													}
													if(increDelay>30)																				//当前时间-延期的时间>30
													{
														integer icin=increDelay/30;
														decimal IncrePay=icin*prod.OldProductPrice__c;												
														if(increDelay>icin*30){
															orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+DelayPay+IncrePay+prod.OldProductPrice__c;			
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
														orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+prod.OldProductPrice__c+DelayPay;
														system.debug('..................................orderdetail.PracticalExpectPrice__c............................'+orderdetail.PracticalExpectPrice__c);
													}
													if(increDelay>30)																				//当前时间-延期的时间>30
													{
														integer icin=increDelay/30;
														decimal IncrePay=icin*prod.OldProductPrice__c;												
														if(increDelay>icin*30){
															orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+DelayPay+IncrePay+prod.OldProductPrice__c;			
														}else{
															orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+DelayPay+IncrePay;
														}												
													}
												}									
											}
											else																													//当前时间未超过延期时间
											{
												integer ii=DelayDaysDue/30;																											
												decimal predictprice=prod.OldProductPrice__c*ii;																
												if(DelayDaysDue>ii*30){
													 orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+predictprice+prod.OldProductPrice__c;				//延期的费用	
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
													orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+prod.OldProductPrice__c;		//多加一个月的费用
												}
												if(increDelay>30)																									//超过延期时间一个月	
												{
													integer icin=increDelay/30;
													decimal IncrePay=icin*prod.OldProductPrice__c;
													if(increDelay>icin*30){
														orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+IncrePay+prod.OldProductPrice__c;			
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
												orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+prod.OldProductPrice__c;
											}
											if(incredemod>30)
											{
												integer icin=incredemod/30;
												decimal IncrePay=icin*prod.OldProductPrice__c;										
												if(incredemod>icin*30){
													orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+IncrePay+prod.OldProductPrice__c;			
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
									if(orderdetail.WhetherTheDelay__c==true)																		//有延期
									{
										integer DelayDaysDue=orderdetail.Demoend__c.daysBetween(orderdetail.AddDate__c);							//延期的天数			
										if(DelayDaysDue>=30)																						//延期超过30天
										{
											if(orderdetail.AddDate__c.daysBetween(Date.today())>0)													//当前时间超过延期时间																			
											{
												integer ii=DelayDaysDue/30;																	
												decimal predictprice=prod.NewProductPrice__c*ii*1.5;		
												if(DelayDaysDue>ii*30)																				//延期
												{
													decimal DelayPay=predictprice+prod.NewProductPrice__c*1.5;					//延期的费用	
														
													integer increDelay=orderdetail.AddDate__c.daysBetween(Date.today());							//超过延期的时间
													if(increDelay<=30)
													{	system.debug('..................................DelayPay.....................................'+DelayPay);
														orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+prod.NewProductPrice__c*1.5+DelayPay;
														system.debug('..................................orderdetail.PracticalExpectPrice__c............................'+orderdetail.PracticalExpectPrice__c);
													}
													if(increDelay>30)																				//当前时间-延期的时间>30
													{
														integer icin=increDelay/30;
														decimal IncrePay=icin*prod.NewProductPrice__c*1.5;												
														if(increDelay>icin*30){
															orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+DelayPay+IncrePay+prod.NewProductPrice__c*1.5;			
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
														orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+prod.NewProductPrice__c*1.5+DelayPay;
														system.debug('..................................orderdetail.PracticalExpectPrice__c............................'+orderdetail.PracticalExpectPrice__c);
													}
													if(increDelay>30)																				//当前时间-延期的时间>30
													{
														integer icin=increDelay/30;
														decimal IncrePay=icin*prod.NewProductPrice__c*1.5;												
														if(increDelay>icin*30){
															orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+DelayPay+IncrePay+prod.NewProductPrice__c*1.5;			
														}else{
															orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+DelayPay+IncrePay;
														}												
													}
												}									
											}
											else																													//当前时间未超过延期时间
											{
												integer ii=DelayDaysDue/30;																											
												decimal predictprice=prod.NewProductPrice__c*ii*1.5;																
												if(DelayDaysDue>ii*30){
													 orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+predictprice+prod.NewProductPrice__c*1.5;				//延期的费用	
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
													orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+prod.NewProductPrice__c*1.5;		//多加一个月的费用
												}
												if(increDelay>30)																									//超过延期时间一个月	
												{
													integer icin=increDelay/30;
													decimal IncrePay=icin*prod.NewProductPrice__c*1.5;
													if(increDelay>icin*30){
														orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+IncrePay+prod.NewProductPrice__c*1.5;			
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
												orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+prod.NewProductPrice__c*1.5;
											}
											if(incredemod>30)
											{
												integer icin=incredemod/30;
												decimal IncrePay=icin*prod.NewProductPrice__c*1.5;										
												if(incredemod>icin*30){
													orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+IncrePay+prod.NewProductPrice__c*1.5;			
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
								else																												//旧样机		
								{
									if(orderdetail.WhetherTheDelay__c==true)																		//有延期
									{
										integer DelayDaysDue=orderdetail.Demoend__c.daysBetween(orderdetail.AddDate__c);							//延期的天数			
										if(DelayDaysDue>=30)																						//延期超过30天
										{
											if(orderdetail.AddDate__c.daysBetween(Date.today())>0)													//当前时间超过延期时间																			
											{
												integer ii=DelayDaysDue/30;																	
												decimal predictprice=prod.OldProductPrice__c*ii*1.5;		
												if(DelayDaysDue>ii*30)																				//延期
												{
													decimal DelayPay=predictprice+prod.OldProductPrice__c*1.5;					//延期的费用	
														
													integer increDelay=orderdetail.AddDate__c.daysBetween(Date.today());							//超过延期的时间
													if(increDelay<=30)
													{	system.debug('..................................DelayPay.....................................'+DelayPay);
														orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+prod.OldProductPrice__c*1.5+DelayPay;
														system.debug('..................................orderdetail.PracticalExpectPrice__c............................'+orderdetail.PracticalExpectPrice__c);
													}
													if(increDelay>30)																				//当前时间-延期的时间>30
													{
														integer icin=increDelay/30;
														decimal IncrePay=icin*prod.OldProductPrice__c*1.5;												
														if(increDelay>icin*30){
															orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+DelayPay+IncrePay+prod.OldProductPrice__c*1.5;			
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
														orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+prod.OldProductPrice__c*1.5+DelayPay;
														system.debug('..................................orderdetail.PracticalExpectPrice__c............................'+orderdetail.PracticalExpectPrice__c);
													}
													if(increDelay>30)																				//当前时间-延期的时间>30
													{
														integer icin=increDelay/30;
														decimal IncrePay=icin*prod.OldProductPrice__c*1.5;												
														if(increDelay>icin*30){
															orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+DelayPay+IncrePay+prod.OldProductPrice__c*1.5;			
														}else{
															orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+DelayPay+IncrePay;
														}												
													}
												}									
											}
											else																													//当前时间未超过延期时间
											{
												integer ii=DelayDaysDue/30;																											
												decimal predictprice=prod.OldProductPrice__c*ii*1.5;																
												if(DelayDaysDue>ii*30){
													 orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+predictprice+prod.OldProductPrice__c*1.5;				//延期的费用	
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
													orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+prod.OldProductPrice__c*1.5;		//多加一个月的费用
												}
												if(increDelay>30)																									//超过延期时间一个月	
												{
													integer icin=increDelay/30;
													decimal IncrePay=icin*prod.OldProductPrice__c*1.5;
													if(increDelay>icin*30){
														orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+IncrePay+prod.OldProductPrice__c*1.5;			
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
												system.debug('......................orderdetail.Field1__c........................'+orderdetail.Field1__c);
												system.debug('...........prod.OldProductPrice__c........'+prod.OldProductPrice__c);
												orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+prod.OldProductPrice__c*1.5;
											}
											if(incredemod>30)
											{
												integer icin=incredemod/30;
												decimal IncrePay=icin*prod.OldProductPrice__c*1.5;										
												if(incredemod>icin*30){
													orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c+IncrePay+prod.OldProductPrice__c*1.5;			
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
				}
			}
	}
}