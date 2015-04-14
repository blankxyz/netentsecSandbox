//内部样机下订单明细sn创建时,自动更新订单明细的样机预计费用,样机核算费用.样机实际预计费用
//lurrykong
//2013.4.24
trigger OfYahuoTurnSeller_AmountSum on OfYahuoTurnSeller__c (after insert, after update) 
{															
	set<id> setSNid=new set<id>();													//序列号id   
	list<ProductSN__c> listProdUpdate=new list<ProductSN__c>();						//sn序列号集合
	set<id> setOrderdetailid=new set<id>();											//订单明细id	
	list<OrderDetails__c> listUpOrderdetail=new list<OrderDetails__c>();			//订单明细对象
	for(OfYahuoTurnSeller__c ofyaturnsell:trigger.new)						
	{
		if(ofyaturnsell.n_SN__c!=null)
			setSNid.add(ofyaturnsell.n_SN__c);
		if(ofyaturnsell.orders__c!=null)
			setOrderdetailid.add(ofyaturnsell.orders__c);	
	}
	//序列号id为键,序列号对象为值			id,设备类型,设备状态,客户名称,样机类型
    map<id,ProductSN__c> mapProductSN=new map<id,ProductSN__c>([select id,ProductCategory__c,ProductStatus__c,coustmer__c,demoStatus__c
    																									from ProductSN__c 
																										where id=:setSNid]);
	
	//订单明细id为键,订单明细为值										id,订单记录类型Name,换货方,客户名称,订单id,订单,产品,新样机产品新价格,旧样机产品价格	,样机预计费用,截止目前实际费用,样机核算费用,测试状态,内部样机开始时间,内部样机预计结束时间,借用人签收日期,是否延期,延期日期	,库管签收日期																											
	map<id,OrderDetails__c> mapOrderDetail=new map<id,OrderDetails__c>([Select id,n_OrderNo__r.RecordTypeName__c, n_OrderNo__r.Replacement1__c, n_OrderNo__r.customer__c, n_OrderNo__r.Id, n_OrderNo__c,
																													n_ProductByOrd__c,n_ProductByOrd__r.NewProductPrice__c,n_ProductByOrd__r.OldProductPrice__c,Field1__c,
																													Nowactual__c,demoamount__c,TestStatus__c,WhetherTheDelay__c,AddDate__c,KuguanContractDate__c,
																													Demostar__c,Demoend__c,BorrowerReceiptDate__c	 
																													from OrderDetails__c where id IN:setOrderdetailid]);
	set<id> setInsideOrder=new set<id>();							//订单id	
	list<OrderDetails__c> listOrderDetail=new list<OrderDetails__c>();
	listOrderDetail=mapOrderDetail.values();
	if(listOrderDetail.size()>0)
	{
		for(OrderDetails__c ordetail:listOrderDetail)
		{
			if(ordetail.n_OrderNo__c!=null)
				setInsideOrder.add(ordetail.n_OrderNo__c);
		}
	}	
	//订单id为键,订单为值								记录类型Name,是否超标
	map<id,Orders__c> mapOrderStatu=new map<id,Orders__c>([select id,RecordTypeName__c,IfCostOverWeight__c,SalesRegion__c,ApprovalStatus__c from Orders__c where RecordTypeName__c='内部样机订单' and id IN:setInsideOrder]);		
	DateTime dtToday = Date.today();	//当前时间	
	for(OfYahuoTurnSeller__c ofyaturnsell:trigger.new)						
	{
		OrderDetails__c ordtail;
		Orders__c faord;
		if(ofyaturnsell.orders__c!=null&&mapOrderDetail.containsKey(ofyaturnsell.orders__c))
		{
			ordtail=mapOrderDetail.get(ofyaturnsell.orders__c);system.debug('..................ordtail..................'+ordtail);
			if(ordtail!=null&&mapOrderStatu.containsKey(ordtail.n_OrderNo__c))
				faord=mapOrderStatu.get(ordtail.n_OrderNo__c);system.debug('..................faord..................'+faord);					
			if(ordtail.n_OrderNo__r.RecordTypeName__c=='内部样机订单')										//如果订单明细sn是在内部样机订单下
			{
				if(ofyaturnsell.n_SN__c!=null&&mapProductSN.containsKey(ofyaturnsell.n_SN__c))
				{
					ProductSN__c prodsn=mapProductSN.get(ofyaturnsell.n_SN__c);						
					if(prodsn.demoStatus__c=='新样机')
					{  
						if(ordtail.Demoend__c!=null&&ordtail.Demostar__c!=null)								//预计开始时间,预计结束时间	
						{												
							if(ordtail.Demoend__c>dtToday)																//当前时间小于等于预计结束时间
							{	
								integer numberDaysDue =ordtail.Demostar__c.daysBetween(ordtail.Demoend__c);				//相差的天数					
								if(numberDaysDue<=30)
								{
									ordtail.PracticalExpectPrice__c=ordtail.n_ProductByOrd__r.NewProductPrice__c;
									ordtail.Field1__c=ordtail.n_ProductByOrd__r.NewProductPrice__c;
								}
								if(numberDaysDue>30)
								{	
									Integer ii=numberDaysDue/30;
									decimal predictprice=ordtail.n_ProductByOrd__r.NewProductPrice__c*ii;	
									ordtail.PracticalExpectPrice__c=predictprice;
									ordtail.Field1__c=predictprice;
									if(numberDaysDue>ii*30){
										ordtail.PracticalExpectPrice__c=predictprice+ordtail.n_ProductByOrd__r.NewProductPrice__c;										
										ordtail.Field1__c=predictprice+ordtail.n_ProductByOrd__r.NewProductPrice__c;
									}
								}
								if(faord.IfCostOverWeight__c==true)
								{
									ordtail.PracticalExpectPrice__c=ordtail.PracticalExpectPrice__c*1.5;
									ordtail.Field1__c=ordtail.Field1__c*1.5;
								}
							}
						}
						if(ordtail.BorrowerReceiptDate__c!=null&&ordtail.KuguanContractDate__c!=null)		//借用人签收日期,库管签收日期		
						{
							integer checkDayDue=ordtail.BorrowerReceiptDate__c.daysBetween(ordtail.KuguanContractDate__c); //相差的天数
							system.debug('......................checkDayDue............................'+checkDayDue);
							if(checkDayDue<=30)
								ordtail.demoamount__c=ordtail.n_ProductByOrd__r.NewProductPrice__c;
							if(checkDayDue>30)
							{
								Integer ii=checkDayDue/30;
								decimal checkprice=ordtail.n_ProductByOrd__r.NewProductPrice__c*ii;	
								if(checkDayDue>ii*30)
									ordtail.demoamount__c=checkprice+ordtail.n_ProductByOrd__r.NewProductPrice__c;																			
							}
							system.debug('..........................ordtail.demoamount__c.............................'+ordtail.demoamount__c);
						}
					}
					if(prodsn.demoStatus__c=='旧样机')
					{
						if(ordtail.Demoend__c!=null&&ordtail.Demostar__c!=null)								//预计开始时间,预计结束时间	
						{					
							if(ordtail.Demoend__c>dtToday)																//当前时间小于等于预计结束时间
							{	
								integer numberDaysDue =ordtail.Demostar__c.daysBetween(ordtail.Demoend__c);				//相差的天数					
								if(numberDaysDue<=30)
								{
									ordtail.PracticalExpectPrice__c=ordtail.n_ProductByOrd__r.OldProductPrice__c;
									ordtail.Field1__c=ordtail.n_ProductByOrd__r.OldProductPrice__c;
								}
								if(numberDaysDue>30)
								{	
									Integer ii=numberDaysDue/30;
									decimal predictprice=ordtail.n_ProductByOrd__r.OldProductPrice__c*ii;	
									ordtail.PracticalExpectPrice__c=predictprice;
									ordtail.Field1__c=predictprice;
									if(numberDaysDue>ii*30){
										ordtail.PracticalExpectPrice__c=predictprice+ordtail.n_ProductByOrd__r.OldProductPrice__c;										
										ordtail.Field1__c=predictprice+ordtail.n_ProductByOrd__r.OldProductPrice__c;
									}
								}
								if(faord.IfCostOverWeight__c==true)
								{
									ordtail.PracticalExpectPrice__c=ordtail.PracticalExpectPrice__c*1.5;
									ordtail.Field1__c=ordtail.Field1__c*1.5;
								}
							}
						}						
						if(ordtail.BorrowerReceiptDate__c!=null&&ordtail.KuguanContractDate__c!=null)		//借用人签收日期,库管签收日期		
						{	
							integer checkDayDue=ordtail.BorrowerReceiptDate__c.daysBetween(ordtail.KuguanContractDate__c); //相差的天数
							if(checkDayDue<=30)
								ordtail.demoamount__c=ordtail.n_ProductByOrd__r.OldProductPrice__c;
							if(checkDayDue>30)
							{
								Integer ii=checkDayDue/30;
								decimal checkprice=ordtail.n_ProductByOrd__r.OldProductPrice__c*ii;	
								if(checkDayDue>ii*30)
									ordtail.demoamount__c=checkprice+ordtail.n_ProductByOrd__r.OldProductPrice__c;																			
							}
						}
					}
				}    
			}
			
		}
	
	}
	listUpOrderdetail=mapOrderDetail.values();
	if(listUpOrderdetail.size()>0)
		update listUpOrderdetail;
}