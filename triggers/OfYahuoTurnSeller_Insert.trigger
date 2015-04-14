//新增 订单明细SN对象（OfYahuoTurnSeller__c）,自动更新序列号(订单,客户),订单明细sn的相关历史订单,历史成交价,自动更新订单明细是否为新样机
//lurrykong
//2013.4.16
trigger OfYahuoTurnSeller_Insert on OfYahuoTurnSeller__c (before insert,before update) 
{
    if(trigger.isInsert||trigger.isUpdate)
    {
  		set<id> setSNid=new set<id>();																		//序列号id
    	list<ProductSN__c> listProdUpdate=new list<ProductSN__c>();											//sn序列号		
    	set<id> setOrderid=new set<id>();																	//订单id
    	set<id> setOrderdetailid=new set<id>();																//订单明细id		
    	set<id> setShipDetailid=new set<id>();																//发货明细id
    	list<SendProSN__c> listUpSendProSN=new list<SendProSN__c>();										//要更新的发货明细sn
    	list<OrderDetails__c> listUpOrderDetail=new list<OrderDetails__c>();								//需要更新的订单明细
    	for(OfYahuoTurnSeller__c ofyaturnsell:trigger.new)
        {
            if(ofyaturnsell.n_SN__c!=null)
            	setSNid.add(ofyaturnsell.n_SN__c);
            if(ofyaturnsell.orders__c!=null)
                setOrderdetailid.add(ofyaturnsell.orders__c);
        }
        //序列号id为键,序列号对象为值			id,License开始日,License结束日,硬件License开始日,硬件License结束日,设备类型,设备状态,新样机开始计算日期,内部样机订单,样机状态,样机类型,退货订单,换货订单,客户所在部门
        map<id,ProductSN__c> mapProductSN=new map<id,ProductSN__c>([select id,Licensestar__c,Licenseend__c,EmpLicense__c,EmpLicenseEndDate__c,ProductCategory__c,ProductStatus__c,demonewdaty__c,InsideOrder__c,PrototypeStatus__c,demoStatus__c,ReturnOrder__c,ReplaceMentOrder__c,AccountSaleArea__c
                                                                   															 								from ProductSN__c 
																																							where id=:setSNid]);
                                                                    
		//序列号id为键,最新的发货明细SN对象为值
        map<id,SendProSN__c> mapSendProSN=new map<id,SendProSN__c>();																																						 
		//发货明细SN对象					id,创建日期,订单,序列号,License开始日期,License到期日期,硬件License开始日,硬件License到期日,设备状态,设备类别,发货明细
        list<SendProSN__c> listSendProSN=[select id,CreatedDate,S_Order__c,S_SN__c,S_Licensestar__c,S_Licenseend__c,S_HardLicenstar__c,S_HardLicenseend__c,S_ProductStatus__c,S_ProductCategory__c,S_ShippingDetails__c 
                                          																													from SendProSN__c 
                                          																													where S_SN__c=:setSNid]; 		                                  																																						      																																		
        if(listSendProSN.size()>0)																													
        {
        	for(SendProSN__c sendprosn:listSendProSN)
            {
            	if(sendprosn.S_ShippingDetails__c!=null)					//发货明细
            		setShipDetailid.add(sendprosn.S_ShippingDetails__c);
                if(sendprosn.S_SN__c!=null)
                {
                 	if(!mapSendProSN.containsKey(sendprosn.S_SN__c)) 	   
                    {
                    	mapSendProSN.put(sendprosn.S_SN__c,sendprosn);
                    }
                    else
                    {
                        SendProSN__c oldsendprosn=mapSendProSN.get(sendprosn.S_SN__c);			
                    	if(oldsendprosn.CreatedDate<sendprosn.CreatedDate)				//创建日期小于当前发货明细SN的创建日期				
                    	{                    		
                         	mapSendProSN.remove(sendprosn.S_SN__c);
                            mapSendProSN.put(sendprosn.S_SN__c,sendprosn);				//添加时间最晚的发货明细SN	
                    	}																												        
                    }
                }    
            }
        }          
        //发货明细id为键,发货明细为值													//发货明细										订单,订单记录类型,发货	
        map<id,ShippingDetails__c> mapShippingDetail=new map<id,ShippingDetails__c>([Select id,n_Shipmentname__r.n_orders__c,n_Shipmentname__r.OrderRecordName__c,n_Shipmentname__c From ShippingDetails__c where id IN:setShipDetailid]);
        

     	//订单明细id为键,订单明细为值。。 产品
        list<OrderDetails__c> listOrderDetail=[select id,n_OrderNo__c,n_OrderNo__r.Replacement1__c,BorrowerReceiptDate__c,n_OrderNo__r.customer__c,n_OrderNo__r.RecordTypeName__c,n_OrderNo__r.Returnssquare__c,IfNewProduct__c,n_ProductByOrd__c 
        																																		from OrderDetails__c 
        																																		where id IN:setOrderdetailid];
     	//订单明细id为键,订单明细为值。。 产品
     	map<id,OrderDetails__c> mapOrderdetail=new map<id,OrderDetails__c>();
     	set<id> setAccId=new set<id>();			//客户id
     	if(listOrderDetail.size()>0)
     	{
     		for(OrderDetails__c ordetail:listOrderDetail)
     		{
     			if(!mapOrderdetail.containsKey(ordetail.id))
     				mapOrderdetail.put(ordetail.id,ordetail);
     			if(ordetail.n_OrderNo__r.customer__c!=null)	 
     				setAccId.add(ordetail.n_OrderNo__r.customer__c);
     		}
     	}
     	//客户id为键,客户为值
        map<id,Account> mapAcc=new map<id,Account>([select id,SellArea__c from Account where id IN:setAccId]);
        
     	list<ShippingDetails__c> listShipDetail=new list<ShippingDetails__c>();
     	listShipDetail=mapShippingDetail.values();
     	if(listShipDetail.size()>0)
     	{
     		for(ShippingDetails__c shdetail:listShipDetail)
     		{
     			if(shdetail.n_Shipmentname__r.n_orders__c!=null)
     			{
     				setOrderid.add(shdetail.n_Shipmentname__r.n_orders__c);
     			}
     		}
     	}
     	map<string,OrderDetails__c> mapOrdetail=new map<string,OrderDetails__c>();	//订单id,产品id为键, 订单明细为值		     	
     	//订单,产品,成交价						        																																	                  
        list<OrderDetails__c> listPriceOrder=[select id,n_OrderNo__c,n_ProductByOrd__c,n_PriceByord__c from OrderDetails__c where n_OrderNo__c IN :setOrderid];
        for(OrderDetails__c ordetail:listPriceOrder)
        {
        	if(ordetail.n_OrderNo__c!=null&&ordetail.n_ProductByOrd__c!=null)
        	{
        		string str=string.valueOf(ordetail.n_OrderNo__c)+string.valueOf(ordetail.n_ProductByOrd__c);
        		mapOrdetail.put(str,ordetail);
        	}
        }        
        for(OfYahuoTurnSeller__c ofyaturnsell:trigger.new)																																		
        {
            if(ofyaturnsell.n_SN__c!=null)
            {
            	if(mapProductSN.containsKey(ofyaturnsell.n_SN__c))    
                {
                 	ProductSN__c prodsn=mapProductSN.get(ofyaturnsell.n_SN__c);
                    if(prodsn.ProductStatus__c=='出售'||prodsn.ProductStatus__c=='压货'||prodsn.ProductStatus__c=='测试机')
                    {																			
						if(ofyaturnsell.orders__c!=null&&mapOrderdetail.containsKey(ofyaturnsell.orders__c))											//订单明细不为空
						{
							OrderDetails__c ordetail=mapOrderdetail.get(ofyaturnsell.orders__c);
                            if(mapAcc.containsKey(ordetail.n_OrderNo__r.customer__c)){
                            	Account acc=mapAcc.get(ordetail.n_OrderNo__r.customer__c);
                            	prodsn.AccountSaleArea__c=acc.SellArea__c;
                            }							 
							system.debug('....................ordetail.........................'+ordetail);
							system.debug('..............................ordetail.n_OrderNo__r.RecordTypeName__c....................................'+ordetail.n_OrderNo__r.RecordTypeName__c);
							if(ordetail.n_OrderNo__r.RecordTypeName__c=='销售订单'||ordetail.n_OrderNo__r.RecordTypeName__c=='渠道样机订单'||ordetail.n_OrderNo__r.RecordTypeName__c=='内部核算订单')
							{	
								if(prodsn.ProductStatus__c!='出售')
									ofyaturnsell.addError('序列号的设备状态不正确,无法创建销售订单明细sn');																						
								if(ofyaturnsell.Account__c==null)
									ofyaturnsell.Account__c=ordetail.n_OrderNo__r.customer__c;
								prodsn.coustmer__c=ordetail.n_OrderNo__r.customer__c;				//客户名称									
								prodsn.SelaOrder__c=ordetail.n_OrderNo__c;							//销售订单								
								prodsn.OversTockOrder__c=null;										//压货订单清空
								prodsn.OverStockSaleOrder__c=null;									//压货转销售订单清空			
								prodsn.InsideOrder__c=null;											//内部样机订单清空
							}
							if(ordetail.n_OrderNo__r.RecordTypeName__c=='内部样机订单')
							{
								if(prodsn.PrototypeStatus__c!='空闲')						//内部样机订单下的订单明细sn的序列号不为空闲,或不为测试机			
									ofyaturnsell.addError('序列号的样机状态不为空闲,无法创建内部样机订单明细sn');
								if(prodsn.ProductStatus__c!='测试机')	
									ofyaturnsell.addError('序列号的设备状态不正确,无法创建内部样机订单明细sn');
								if(prodsn.ProductCategory__c!='样机')								
									ofyaturnsell.addError('序列号的设备类型不正确,无法创建内部样机订单明细sn');										
								if(ordetail.BorrowerReceiptDate__c!=null&&prodsn.demoStatus__c=='新样机')												//借用人签收日期不为空,并且为新样机
									prodsn.demonewdaty__c=ordetail.BorrowerReceiptDate__c;																//借用人签收日期								
								if(ofyaturnsell.Account__c==null)
									ofyaturnsell.Account__c=ordetail.n_OrderNo__r.customer__c;		
								if(prodsn.demoStatus__c!=null)										//序列号的样机类型不为空
								{
									if(prodsn.demoStatus__c=='旧样机')
										ordetail.IfNewProduct__c=false;
									if(prodsn.demoStatus__c=='新样机')
										ordetail.IfNewProduct__c=true;
								}
								prodsn.coustmer__c=ordetail.n_OrderNo__r.customer__c;				//客户名称									
								prodsn.InsideOrder__c=ordetail.n_OrderNo__c;						//内部样机订单								
								prodsn.OversTockOrder__c=null;										//压货订单清空
								prodsn.OverStockSaleOrder__c=null;									//压货转销售订单清空
								prodsn.SelaOrder__c=null;											//销售订单清空					
							}
							if(ordetail.n_OrderNo__r.RecordTypeName__c=='换货订单'||ordetail.n_OrderNo__r.RecordTypeName__c=='退货订单')					
							{
								if(prodsn.ProductStatus__c!='出售')
									ofyaturnsell.addError('序列号的设备状态不正确,无法创建订单明细sn');																																						
								prodsn.coustmer__c=null;											//客户名称
								prodsn.SelaOrder__c=null;											//销售订单		
								prodsn.OversTockOrder__c=null;										//压货订单清空
								prodsn.OverStockSaleOrder__c=null;									//压货转销售订单清空
								prodsn.InsideOrder__c=null;											//内部样机订单清空				 								
								if(ordetail.n_OrderNo__r.RecordTypeName__c=='换货订单'){
									if(prodsn.ProductStatus__c!='出售')
									ofyaturnsell.addError('序列号的设备状态不正确,无法创建换货订单明细sn');
									prodsn.ReplaceMentOrder__c=ordetail.n_OrderNo__c;
									if(ofyaturnsell.Account__c==null)
										ofyaturnsell.Account__c=ordetail.n_OrderNo__r.Replacement1__c;
								}	
								if(ordetail.n_OrderNo__r.RecordTypeName__c=='退货订单'){
									if(prodsn.ProductStatus__c!='出售')
									ofyaturnsell.addError('序列号的设备状态不正确,无法创建退货订单明细sn');
									prodsn.ReturnOrder__c=ordetail.n_OrderNo__c;								
									if(ofyaturnsell.Account__c==null)
										ofyaturnsell.Account__c=ordetail.n_OrderNo__r.Returnssquare__c;									
								}								
								SendProSN__c sendprosn=mapSendProSN.get(ofyaturnsell.n_SN__c);		//取得发货明细sn
								if(sendprosn.S_ShippingDetails__c!=null&&mapShippingDetail.containsKey(sendprosn.S_ShippingDetails__c))
								{
									ShippingDetails__c ship=mapShippingDetail.get(sendprosn.S_ShippingDetails__c);
									if(ship.n_Shipmentname__r.OrderRecordName__c=='压货订单')
									{
										sendprosn.S_ProductStatus__c=ofyaturnsell.ProductStatus__c;
										listUpSendProSN.add(sendprosn);
									}
								}
							}
							if(ordetail.n_OrderNo__r.RecordTypeName__c=='压货订单')
							{
								prodsn.coustmer__c=ordetail.n_OrderNo__r.customer__c;				//客户名称
								prodsn.OversTockOrder__c=ordetail.n_OrderNo__c;						//压货订单
								prodsn.SelaOrder__c=null;											//销售订单
								prodsn.OverStockSaleOrder__c=null;									//压货转销售订单清空
								if(ofyaturnsell.Account__c==null)
									ofyaturnsell.Account__c=ordetail.n_OrderNo__r.customer__c;								
							}	
							if(ordetail.n_OrderNo__r.RecordTypeName__c=='压货转销售订单')
							{
								if(prodsn.ProductStatus__c!='压货')
									ofyaturnsell.addError('序列号的设备状态不正确,无法创建压货转销售订单明细sn');																														
								prodsn.coustmer__c=ordetail.n_OrderNo__r.customer__c;				//客户名称
								prodsn.OverStockSaleOrder__c=ordetail.n_OrderNo__c;					//压货转销售订单
								prodsn.SelaOrder__c=null;											//销售订单
								prodsn.OversTockOrder__c=null;										//压货订单
								if(ofyaturnsell.Account__c==null)
									ofyaturnsell.Account__c=ordetail.n_OrderNo__r.customer__c;
								SendProSN__c sendprosn=mapSendProSN.get(ofyaturnsell.n_SN__c);		//取得发货明细sn
								if(sendprosn!=null&&sendprosn.S_ShippingDetails__c!=null&&mapShippingDetail.containsKey(sendprosn.S_ShippingDetails__c))
								{
									ShippingDetails__c ship=mapShippingDetail.get(sendprosn.S_ShippingDetails__c);
									if(ship.n_Shipmentname__r.OrderRecordName__c=='压货订单')
									{
										sendprosn.S_ProductStatus__c='出售';
										listUpSendProSN.add(sendprosn);
									}
								}
							}
							listUpOrderDetail.add(ordetail);
							if(ordetail.n_OrderNo__r.RecordTypeName__c!='内部样机订单')
							{
								prodsn.ProductCategory__c=ofyaturnsell.ProductCategory__c;					//设备类型
								prodsn.ProductStatus__c=ofyaturnsell.ProductStatus__c;						//设备状态
		                        prodsn.Licensestar__c=ofyaturnsell.Licensestar__c;							//License开始日
								prodsn.Licenseend__c=ofyaturnsell.Licenseend__c;							//License到期日
								prodsn.EmpLicense__c=ofyaturnsell.Licensestar1__c;							//硬件License开始日
								prodsn.EmpLicenseEndDate__c=ofyaturnsell.Licenseend2__c;					//硬件License结束日
							}
							listProdUpdate.add(prodsn);
							
							if(mapSendProSN.containsKey(ofyaturnsell.n_SN__c))
							{
								SendProSN__c sendprosn=mapSendProSN.get(ofyaturnsell.n_SN__c);					//取得最新的发货明细sn
								if(sendprosn.S_ShippingDetails__c!=null)
								{
									if(mapShippingDetail.containsKey(sendprosn.S_ShippingDetails__c))
									{
										ShippingDetails__c shipdetail=mapShippingDetail.get(sendprosn.S_ShippingDetails__c);
										ofyaturnsell.n_Order1__c=shipdetail.n_Shipmentname__r.n_orders__c;		//相关历史订单
										system.debug('....................ordetail.........................'+ordetail);
										
										if(shipdetail.n_Shipmentname__r.n_orders__c!=null&&ordetail.n_ProductByOrd__c!=null)
										{	
											string str=string.valueOf(shipdetail.n_Shipmentname__r.n_orders__c)+string.valueOf(ordetail.n_ProductByOrd__c);
											if(str!=null&&mapOrdetail.containsKey(str))
											{
												OrderDetails__c ordet=mapOrdetail.get(str);system.debug('...............ordet.................'+ordet);
												ofyaturnsell.n_HistoryPrice__c=ordet.n_PriceByord__c;
												system.debug('.........ofyaturnsell.n_HistoryPrice__c...........'+ofyaturnsell.n_HistoryPrice__c);
											}
										}								
									}
								}
							}	
						}
									
                    }
                    else
                    {
                        ofyaturnsell.addError('此序列号的设备状态不正确,无法创建订单明细sn');
                    }
                    
                }    
            }
        }
    	system.debug('........................listUpOrderDetail............................'+listUpOrderDetail);
    	system.debug('........................listProdUpdate............................'+listProdUpdate);
    	if(listProdUpdate.size()>0)
		update listProdUpdate;
		if(listUpSendProSN.size()>0)
		update listUpSendProSN;
		if(listUpOrderDetail.size()>0)
		update listUpOrderDetail;
    }  	
    
}