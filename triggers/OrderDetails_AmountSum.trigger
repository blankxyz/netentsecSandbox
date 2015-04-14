//新建内部样机订单明细时,计算预计费用
//编辑内部样机订单明细时,如果预计开始时间,预计结束时间,或是否为新样机发生变化时,如果订单!=已批准,更新预计费用
//编辑内部样机时，如果借用人签收日期,库管签收日期,是否为新样机发生变化时, 计算核算费用.
//lurrykong
//2013.4.24
trigger OrderDetails_AmountSum on OrderDetails__c (before insert, before update) 
{
	set<id> setProid=new set<id>();				//产品id
	set<id> setOrder=new set<id>();				//订单id	
	set<id> setOrderDetailId=new set<id>();		//订单明细id
	for(OrderDetails__c orderdetail:trigger.new)
	{
		if(orderdetail.n_OrderNo__c!=null)
			setOrder.add(orderdetail.n_OrderNo__c);
		if(orderdetail.n_ProductByOrd__c!=null)	
			setProid.add(orderdetail.n_ProductByOrd__c);
	}
	if(trigger.isUpdate&&trigger.isBefore)
	{
		for(OrderDetails__c orderdetail:trigger.new)
		{		
			setOrderDetailId.add(orderdetail.id);
			system.debug('.................orderdetail.OrddetailDiscount__c..................'+orderdetail.OrddetailDiscount__c);
		}
	}
	//产品id为键,产品为值
	map<id,Product2> mapProd=new map<id,Product2>();
	//查询订单明细的产品                                      新样机价格,旧样机价格,产品型号系列
	list<Product2> listProd=[select id,NewProductPrice__c,OldProductPrice__c,Productmodelseries__c from Product2 where id IN:setProid];
	//标准价格手册
	Pricebook2 pricebook = [select Id from Pricebook2 where isStandard=true limit 1];
	if(listProd.size()>0)
	{
		for(Product2 prod:listProd)
		{
			if(!mapProd.containsKey(prod.id))
				mapProd.put(prod.id,prod);			
		}
	}
	//全部价格手册条目pbe.IsActive=true;		产品的标准价格,产品id,价格手册id,id,是否启用
	list<PricebookEntry> listAllPbe=[Select UnitPrice,Product2Id,Pricebook2Id,Id,IsActive From PricebookEntry where Product2Id IN:setProid and IsActive=true];											
	//产品id+价格手册id为键	价格手册条目为值
	map<string,PricebookEntry> mapPidPbe=new map<string,PricebookEntry>();	
	if(listAllPbe.size()>0)
	{
		for(PricebookEntry pbe:listAllPbe)
		{
			if(!mapPidPbe.containsKey(string.valueOf(pbe.Product2Id)+string.valueOf(pbe.Pricebook2Id)))
				mapPidPbe.put(string.valueOf(pbe.Product2Id)+string.valueOf(pbe.Pricebook2Id),pbe);	
		}
	}
	//订单id为键,订单为值									id,客户,记录类型名称,换货方,退货方,销售区域
	map<id,Orders__c> mapOrder=new map<id,Orders__c>([select id,customer__c,RecordTypeName__c,Replacement1__c,Returnssquare__c,SalesRegion__c,ApprovalStatus__c,IfCostOverWeight__c from Orders__c where id IN:setOrder]);	
		
	system.debug('-------------------------mapProd-----------------------'+mapProd); 	
	system.debug('-------------------------mapOrder-----------------------'+mapOrder);	
	//销售区域,年,季度为键,费用指标的预算金额为值
	map<string,decimal> mapBudgeAmount=new map<string,decimal>();
	//按费用指标的销售区域,年,季度,分组,汇总	预算金额
	AggregateResult[] aggProCostResult=[select sum(n_BudgetAmount__c)sumYuSuan,n_SaleArea__c,n_Year__c,Quarter__c from PrototypeCosts__c
																									where Quarter__c!=null and n_SaleArea__c!=null
																									group by n_SaleArea__c,n_Year__c,Quarter__c];																		
	if(aggProCostResult.size()>0)
	{
		for(AggregateResult ar:aggProCostResult)
		{
			if(ar.get('n_SaleArea__c')!=null&&ar.get('n_Year__c')!=null&&ar.get('Quarter__c')!=null)
			{
				string str=string.valueOf(ar.get('n_SaleArea__c'))+string.valueOf(ar.get('n_Year__c'))+string.valueOf(ar.get('Quarter__c'));
				if(!mapBudgeAmount.containsKey(str))
				{
					if(ar.get('sumYuSuan')!=null)
					{
						decimal deci=decimal.valueOf(String.valueOf(ar.get('sumYuSuan')));
						mapBudgeAmount.put(str,deci);
					}
				}
			}
		}
	}	
	system.debug('....................................费用指标预算金额mapBudgeAmount.......................................'+mapBudgeAmount.values());
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
	}		
	system.debug('.......................预计实际费用mapPraExpectPrice.........................'+mapPraExpectPrice);		
	if(trigger.isInsert&&trigger.isBefore)
	{
		for(OrderDetails__c orderdetail:trigger.new)
		{
			Product2 prod;																			//订单明细上的产品		
			Orders__c orders;																		//订单
			decimal orderdecimal=0;																	//实际预计金额
			decimal prototypedecimal=0;																//费用指标金额				
			if(orderdetail.n_ProductByOrd__c!=null&&mapProd.containsKey(orderdetail.n_ProductByOrd__c))
				prod=mapProd.get(orderdetail.n_ProductByOrd__c);
			if(prod!=null)
			{system.debug('..................prod........................'+prod);
				string strprod=string.valueOf(prod.id);
				string strpbok=string.valueOf(pricebook.id);
				if(mapPidPbe.containsKey(strprod+strpbok))
				{
					PricebookEntry pbe=mapPidPbe.get(strprod+strpbok);
					if(pbe!=null)
						orderdetail.n_Price__c=pbe.UnitPrice;													//标准价默认等于产品的标准价格
					if(orderdetail.OrddetailDiscount__c!=null)													//订单明细折扣不为空
						orderdetail.n_PriceByord__c=orderdetail.n_Price__c*orderdetail.OrddetailDiscount__c/100;	//成交价=标准价*折扣
					if((orderdetail.OrddetailDiscount__c==null&&orderdetail.n_PriceByord__c!=null))				//折扣=null,成交价!=null
					{
						Decimal myDecimal=orderdetail.n_PriceByord__c/orderdetail.n_Price__c*100;				//折扣=成交价/标准价
						system.debug('......................myDecimal..........................'+myDecimal);
						orderdetail.OrddetailDiscount__c=myDecimal.divide(1,2,System.RoundingMode.HALF_EVEN);
						system.debug('......................orderdetail.OrddetailDiscount__c..........................'+orderdetail.OrddetailDiscount__c);
					}
					system.debug('.............orderdetail.n_PriceByord__c..........'+orderdetail.n_PriceByord__c);	
					system.debug('.............orderdetail.n_Price__c..........'+orderdetail.n_Price__c);	
					system.debug('.............orderdetail.OrddetailDiscount__c..........'+orderdetail.OrddetailDiscount__c);
				}				
				if(orderdetail.n_OrderNo__c!=null&&mapOrder.containsKey(orderdetail.n_OrderNo__c))
				{	orders=mapOrder.get(orderdetail.n_OrderNo__c);
	                if(orderdetail.Acount__c==null)														//客户为空
	                {
	                    if(orders.RecordTypeName__c=='销售订单'||orders.RecordTypeName__c=='压货转销售订单'||orders.RecordTypeName__c=='压货订单'||orders.RecordTypeName__c=='内部样机订单'||orders.RecordTypeName__c=='渠道样机订单'||orders.RecordTypeName__c=='内部核算订单')
	                        orderdetail.Acount__c=orders.customer__c;
	                    if(orders.RecordTypeName__c=='换货订单')                                        
	                        orderdetail.Acount__c=orders.Replacement1__c;                               //换货方   
	                    if(orders.RecordTypeName__c=='退货订单')                                        
	                        orderdetail.Acount__c=orders.Returnssquare__c;                              //退货方
	                }		
				}	
				if(orderdetail.Demoend__c!=null&&orderdetail.Demostar__c!=null&&prod.NewProductPrice__c!=null&&prod.OldProductPrice__c!=null)//产品,预计开始,预计结束不为空,新样机价格,旧样机价格不为空
				{
					/*****************根据预计开始日期得到 预计开始的年,预计开始的月,预计开始的季度*******************/	
					Date dte=orderdetail.Demostar__c;	 
					orderdetail.PredictStartYear__c=string.valueOf(dte.year());							//预计开始年份
					string strmon=string.valueOf(dte.month());system.debug('strmon.length()..............'+strmon.length());
					if(strmon.length()<2)
						strmon='0'+string.valueOf(dte.month());											//预计开始月份
					orderdetail.PredictStartMonth__c=strmon;
					if(3>=dte.month()&&dte.month()>=1)
						orderdetail.PredictStartQuarter__c='第一季度';											//预计开始季度
					if(6>=dte.month()&&dte.month()>=4)
						orderdetail.PredictStartQuarter__c='第二季度';		
					if(9>=dte.month()&&dte.month()>=7)
						orderdetail.PredictStartQuarter__c='第三季度';
					if(12>=dte.month()&&dte.month()>=10)
						orderdetail.PredictStartQuarter__c='第四季度';
					system.debug('...............prod................'+prod);
					system.debug('...............orderdetail.........'+orderdetail);
					//销售区域+预计开始的年+预计开始的季度
					string str=string.valueOf(orders.SalesRegion__c)+string.valueOf(orderdetail.PredictStartYear__c)+string.valueOf(orderdetail.PredictStartQuarter__c);
					system.debug('.................str..................'+str);
					if(mapBudgeAmount.containsKey(str))
						prototypedecimal=mapBudgeAmount.get(str);									//预计的钱
					if(mapPraExpectPrice.containsKey(str))
						orderdecimal=mapPraExpectPrice.get(str);									//实际的钱						
					system.debug('.................prototypedecimal..................'+prototypedecimal);
					system.debug('.................orderdecimal..................'+orderdecimal);
					if(orderdetail.IfNewProduct__c==true)
					{
	                    integer numberDaysDue=orderdetail.Demostar__c.daysBetween(orderdetail.Demoend__c);system.debug('...............numberDaysDue................'+numberDaysDue);
	                    system.debug('................numberDaysDue.................'+numberDaysDue);
	                    if(numberDaysDue<=30)
	                        orderdetail.Field1__c=prod.NewProductPrice__c;
	                    if(numberDaysDue>30)
	                    {
	                        Integer ii=numberDaysDue/30;
	                        decimal predictprice=prod.NewProductPrice__c*ii;    system.debug('...............predictprice..................'+predictprice);
	                        orderdetail.Field1__c=predictprice;
	                        if(numberDaysDue>ii*30)
	                            orderdetail.Field1__c=predictprice+prod.NewProductPrice__c; 
	                        
	                    }
	                    system.debug('....................orderdetail.Field1__c.........................'+orderdetail.Field1__c);
					}
					else if(orderdetail.IfNewProduct__c==false)
					{
	                    integer numberDaysDue=orderdetail.Demostar__c.daysBetween(orderdetail.Demoend__c);
	                    if(numberDaysDue<=30)
	                        orderdetail.Field1__c=prod.OldProductPrice__c;
	                    if(numberDaysDue>30)
	                    {
	                        Integer ii=numberDaysDue/30;
	                        decimal predictprice=prod.OldProductPrice__c*ii;    
	                        orderdetail.Field1__c=predictprice;
	                        if(numberDaysDue>ii*30)
	                            orderdetail.Field1__c=predictprice+prod.OldProductPrice__c; 
	                    }                  
					}system.debug('.....................orderdetail.Field1__c.......................'+orderdetail);
					if(orderdetail.Field1__c+orderdecimal>prototypedecimal)																		//判断是否超标
					{	
						orderdetail.Field1__c=orderdetail.Field1__c*1.5;
					}		
					orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c;                                                                  //实际费用(预计费用)=预计费用
				}
			}				
		}
	}
	if(trigger.isUpdate&&trigger.isBefore)
	{
		//得出所有的订单明细sn对象
		list<OfYahuoTurnSeller__c> listofturnsell=[select id,orders__c from OfYahuoTurnSeller__c where orders__c IN:setOrderDetailId];				
		//订单明细id为键,list订单明细为值
		map<id,list<OfYahuoTurnSeller__c>> mapOfyahuo=new map<id,list<OfYahuoTurnSeller__c>>();
		if(listofturnsell.size()>0)
		{
			for(OfYahuoTurnSeller__c ofyahuo:listofturnsell)
			{
				if(!mapOfyahuo.containsKey(ofyahuo.orders__c))
				{
					list<OfYahuoTurnSeller__c> listof=new list<OfYahuoTurnSeller__c>();
					listof.add(ofyahuo);
					mapOfyahuo.put(ofyahuo.orders__c,listof);
				}
				else
				{
					list<OfYahuoTurnSeller__c> listof=mapOfyahuo.get(ofyahuo.orders__c);
					listof.add(ofyahuo); 
				}
			}
		}
		for(OrderDetails__c orderdetail:trigger.new)
		{
			Product2 prod;
			Orders__c orders;
			decimal orderdecimal=0;
			decimal prototypedecimal=0;
			OrderDetails__c Oldorderdetail=trigger.oldMap.get(orderdetail.id);
			if(orderdetail.n_ProductByOrd__c!=null&&mapProd.containsKey(orderdetail.n_ProductByOrd__c))
				prod=mapProd.get(orderdetail.n_ProductByOrd__c);
				
			system.debug('..................Oldorderdetail.n_ProductByOrd__c....................'+Oldorderdetail.n_ProductByOrd__c);
			system.debug('..................orderdetail.n_ProductByOrd__c....................'+orderdetail.n_ProductByOrd__c);
			system.debug('..................Oldorderdetail.OrddetailDiscount__c....................'+Oldorderdetail.OrddetailDiscount__c);
			system.debug('..................orderdetail.OrddetailDiscount__c....................'+orderdetail.OrddetailDiscount__c);
			system.debug('..................Oldorderdetail.n_PriceByord__c....................'+Oldorderdetail.n_PriceByord__c);	
			system.debug('..................orderdetail.n_PriceByord__c....................'+orderdetail.n_PriceByord__c);
			//产品发生变化,产品折扣发生变化,成交价发生变化	,并且产品不为空
			if((Oldorderdetail.n_ProductByOrd__c!=orderdetail.n_ProductByOrd__c||orderdetail.OrddetailDiscount__c!=Oldorderdetail.OrddetailDiscount__c||orderdetail.n_PriceByord__c!=Oldorderdetail.n_PriceByord__c)&&prod!=null)//
			{
				string strprod=string.valueOf(prod.id);
				string strpbok=string.valueOf(pricebook.id);
				if(mapPidPbe.containsKey(strprod+strpbok))
				{
					PricebookEntry pbe=mapPidPbe.get(strprod+strpbok);
					if(pbe!=null)
						orderdetail.n_Price__c=pbe.UnitPrice;													//标准价默认等于产品的标准价格								
					if(orderdetail.OrddetailDiscount__c!=null)													//订单明细折扣不为空
						orderdetail.n_PriceByord__c=orderdetail.n_Price__c*orderdetail.OrddetailDiscount__c/100;	//成交价=标准价*折扣
					if((orderdetail.OrddetailDiscount__c==null&&orderdetail.n_PriceByord__c!=null))				//折扣=null,成交价!=null
					{
						Decimal myDecimal=orderdetail.n_PriceByord__c/orderdetail.n_Price__c*100;				//折扣=成交价/标准价
						system.debug('......................myDecimal..........................'+myDecimal);
						orderdetail.OrddetailDiscount__c=myDecimal.divide(1,2,System.RoundingMode.HALF_EVEN);
						system.debug('......................orderdetail.OrddetailDiscount__c..........................'+orderdetail.OrddetailDiscount__c);
					}	
					system.debug('.............orderdetail.n_PriceByord__c..........'+orderdetail.n_PriceByord__c);	
					system.debug('.............orderdetail.n_Price__c..........'+orderdetail.n_Price__c);	
					system.debug('.............orderdetail.n_PriceByord__c/orderdetail.n_Price__c..........'+orderdetail.n_PriceByord__c/orderdetail.n_Price__c);
					system.debug('.......................orderdetail.n_PriceByord__c/orderdetail.n_Price__c*100...........................'+orderdetail.n_PriceByord__c/orderdetail.n_Price__c*100);
					system.debug('.............orderdetail.OrddetailDiscount__c..........'+orderdetail.OrddetailDiscount__c);
				}	
			}	
			if(Oldorderdetail.Demostar__c!=orderdetail.Demostar__c||Oldorderdetail.Demoend__c!=orderdetail.Demoend__c||Oldorderdetail.IfNewProduct__c!=orderdetail.IfNewProduct__c)						//预计日期前后发生变化,是否为新样机前后发生变化	
			{
				if(orderdetail.n_OrderNo__c!=null&&mapOrder.containsKey(orderdetail.n_OrderNo__c))
				{
					orders=mapOrder.get(orderdetail.n_OrderNo__c);
					if(orders.ApprovalStatus__c=='草稿'||orders.ApprovalStatus__c=='已拒绝')
					{						
						if(prod!=null&&orderdetail.Demostar__c!=null&&orderdetail.Demoend__c!=null&&prod.NewProductPrice__c!=null&&prod.OldProductPrice__c!=null)
						{		
							Date dte=orderdetail.Demostar__c;	 
							orderdetail.PredictStartYear__c=string.valueOf(dte.year());							//预计开始年份
							string strmon=string.valueOf(dte.month());system.debug('strmon.length()..............'+strmon.length());
							if(strmon.length()<2)
								strmon='0'+string.valueOf(dte.month());											//预计开始月份
							orderdetail.PredictStartMonth__c=strmon;
							if(3>=dte.month()&&dte.month()>=1)
								orderdetail.PredictStartQuarter__c='第一季度';											//预计开始季度
							if(6>=dte.month()&&dte.month()>=4)
								orderdetail.PredictStartQuarter__c='第二季度';		
							if(9>=dte.month()&&dte.month()>=7)
								orderdetail.PredictStartQuarter__c='第三季度';
							if(12>=dte.month()&&dte.month()>=10)
								orderdetail.PredictStartQuarter__c='第四季度';								
							system.debug('...............prod................'+prod);
							system.debug('...............orderdetail.........'+orderdetail);	
							//销售区域+预计开始的年+预计开始的季度
							string str=string.valueOf(orders.SalesRegion__c)+string.valueOf(orderdetail.PredictStartYear__c)+string.valueOf(orderdetail.PredictStartQuarter__c);
							system.debug('............................str..............................'+str);
							if(mapBudgeAmount.containsKey(str))
								prototypedecimal=mapBudgeAmount.get(str);									//预计的钱
							if(mapPraExpectPrice.containsKey(str))
								orderdecimal=mapPraExpectPrice.get(str);									//实际的钱					
							if(orderdetail.IfNewProduct__c==true)
							{
								if(orderdetail.Demoend__c!=null&&orderdetail.Demostar__c!=null)                                                     //预计开始日期,预计结束日期   
			                    {
			                        integer numberDaysDue=orderdetail.Demostar__c.daysBetween(orderdetail.Demoend__c);
			                        if(numberDaysDue<=30)
			                            orderdetail.Field1__c=prod.NewProductPrice__c;
			                        if(numberDaysDue>30)
			                        {
			                            Integer ii=numberDaysDue/30;
			                            decimal predictprice=prod.NewProductPrice__c*ii;
			                            orderdetail.Field1__c=predictprice;    
			                            if(numberDaysDue>ii*30)
			                                orderdetail.Field1__c=predictprice+prod.NewProductPrice__c; 
			                            system.debug('.......................orderdetail.Field1__c............................'+orderdetail.Field1__c);
			                        }
			                    }
							}
							else if(orderdetail.IfNewProduct__c==false)
							{
								if(orderdetail.Demoend__c!=null&&orderdetail.Demostar__c!=null)                                                     //预计开始日期,预计结束日期   
			                    {
			                        integer numberDaysDue=orderdetail.Demostar__c.daysBetween(orderdetail.Demoend__c);
			                        if(numberDaysDue<=30)
			                            orderdetail.Field1__c=prod.OldProductPrice__c;
			                        if(numberDaysDue>30)
			                        {
			                            Integer ii=numberDaysDue/30;
			                            decimal predictprice=prod.OldProductPrice__c*ii;    
			                            orderdetail.Field1__c=predictprice;
			                            if(numberDaysDue>ii*30)
			                                orderdetail.Field1__c=predictprice+prod.OldProductPrice__c; 
			                            system.debug('.......................orderdetail.Field1__c............................'+orderdetail.Field1__c);
			                        }
			                    }
							}
							if(orderdetail.Field1__c+orderdecimal>prototypedecimal)																		//判断是否超标
							{	
								orderdetail.Field1__c=orderdetail.Field1__c*1.5;
							}		
							orderdetail.PracticalExpectPrice__c=orderdetail.Field1__c;                                                                  //实际费用(预计费用)=预计费用
							
						}
					}
				}
			}
			if(Oldorderdetail.BorrowerReceiptDate__c!=orderdetail.BorrowerReceiptDate__c||Oldorderdetail.KuguanContractDate__c!=orderdetail.KuguanContractDate__c||Oldorderdetail.IfNewProduct__c!=orderdetail.IfNewProduct__c)	//日期发生变化
			{
            	if(prod!=null&&orderdetail.BorrowerReceiptDate__c!=null&&orderdetail.KuguanContractDate__c!=null&&prod.NewProductPrice__c!=null&&prod.OldProductPrice__c!=null)				//日期不为空,价格不为空
				{			
					if(orderdetail.IfNewProduct__c==true)
					{
						integer checkDayDue=orderdetail.BorrowerReceiptDate__c.daysBetween(orderdetail.KuguanContractDate__c);  //相差的天数
			            if(checkDayDue<=30)
			                orderdetail.demoamount__c=prod.NewProductPrice__c;
			            if(checkDayDue>30)
			            {
			                Integer ii=checkDayDue/30;
			                decimal checkprice=prod.NewProductPrice__c*ii; 
			                if(checkDayDue>ii*30)
			                    orderdetail.demoamount__c=checkprice+prod.NewProductPrice__c;     
			            }  
					}
					else if(orderdetail.IfNewProduct__c==false)
					{
						integer checkDayDue=orderdetail.BorrowerReceiptDate__c.daysBetween(orderdetail.KuguanContractDate__c);  //相差的天数
			            if(checkDayDue<=30)
			                orderdetail.demoamount__c=prod.OldProductPrice__c;
			            if(checkDayDue>30)
			            {
			                Integer ii=checkDayDue/30;
			                decimal checkprice=prod.OldProductPrice__c*ii; 
			                if(checkDayDue>ii*30)
			                    orderdetail.demoamount__c=checkprice+prod.OldProductPrice__c;     
			            }
					}
				}
			}
			if(orderdetail.n_OrderNo__c!=null)																	
			{
				if(mapOrder.containsKey(orderdetail.n_OrderNo__c)&&mapOrder.get(orderdetail.n_OrderNo__c).RecordTypeName__c=='内部样机订单')
				{	
					if(Oldorderdetail.BorrowerReceiptDate__c!=orderdetail.BorrowerReceiptDate__c&&orderdetail.BorrowerReceiptDate__c!=null)			//如果借用人签收日期前后发生变化,并且不为空
					{
						list<OfYahuoTurnSeller__c> listof;
						if(mapOfyahuo.containsKey(orderdetail.id))
							listof=mapOfyahuo.get(orderdetail.id);system.debug('...............listof..................'+listof);
						if(listof!=null&&listof.size()>0)
						{	
							Date dte=orderdetail.BorrowerReceiptDate__c;
							orderdetail.n_Year__c=string.valueOf(dte.year());										//年
							string strmon=string.valueOf(dte.month());system.debug('strmon.length()..............'+strmon.length());
							if(strmon.length()<2)
								strmon='0'+string.valueOf(dte.month());
							orderdetail.n_Month__c=strmon;															
							
							system.debug('................strmon......................'+strmon);					//月	
							if(3>=dte.month()&&dte.month()>=1)
							{
								orderdetail.Quarter__c='第一季度';
							}
							else if(6>=dte.month()&&dte.month()>=4)
							{
								orderdetail.Quarter__c='第二季度';		
							}
							else if(9>=dte.month()&&dte.month()>=7)
							{
								orderdetail.Quarter__c='第三季度';
							}
							else if(12>=dte.month()&&dte.month()>=10)
							{
								orderdetail.Quarter__c='第四季度';
							}
						}
						else
						{
							orderdetail.addError('没有创建订单明细sn,借用人无法签收');
						}
					}
				}
			}
			
		}
	}
}