/*
*RogerSun
*982578975@qq.com
*序列号同步信息
*/
trigger ProductSN on ProductSN__c (after insert, after update) {
	set<string> setOrderId=new set<string>();   //订单
	set<string> setShippingDetailsId=new set<string>();  //发货明细
	set<string> setAccountId=new set<string>();	//客户
	set<string> setProductSNId=new set<string>();	//序列号信息
	map<string,Account> mapAccount=new map<string,Account>(); //客户
	map<string,ShippingDetails__c> mapShippingDetails=new map<string,ShippingDetails__c>(); //发货明细
	map<string,Orders__c> mapOrder=new map<string,Orders__c>(); //订单
	list<ProductSNDetial__c> listProductSNDetial=new list<ProductSNDetial__c>();  //创建序列号明细信息
	if(trigger.isAfter)
	{
		if(trigger.isInsert)
		{
			for(ProductSN__c p:trigger.new)
			{
				if(p.Account__c!=null)
				{
					setAccountId.add(p.Account__c);   //客户
				}
				if(p.Order__c!=null)
				{
					setOrderId.add(p.Order__c);    //订单
				}
				if(p.ShippingDetails__c!=null)
				{
					setShippingDetailsId.add(p.ShippingDetails__c);   //发货明细
				}
				if(p.Account__c!=null || p.Order__c!=null || p.ShippingDetails__c!=null)
				{
					setProductSNId.add(p.id);   //序列号
				}
			}
		}
		else if(trigger.isUpdate)
		{
			for(ProductSN__c p:trigger.new)
			{
				ProductSN__c oldMap=trigger.oldMap.get(p.id);
				if(p.Account__c!=oldMap.Account__c)
				{
					setAccountId.add(p.Account__c);   //客户
				}
				if(p.Order__c!=oldMap.Order__c)
				{
					setOrderId.add(p.Order__c);    //订单
				}
				if(p.ShippingDetails__c!=oldMap.ShippingDetails__c)
				{
					setShippingDetailsId.add(p.ShippingDetails__c);   //发货明细
				}
				if(p.Account__c!=oldMap.Account__c || p.Order__c!=oldMap.Order__c || p.ShippingDetails__c!=oldMap.ShippingDetails__c)
				{
					setProductSNId.add(p.id);   //序列号
				}
			}
		}
		//根据客户识别编码获取客户id信息
		if(setAccountId!=null && setAccountId.size()>0)
		{
			list<Account> listAccount=new list<Account>([select id,SellArea__c,IdentificationCode_c__c,name,Kundtypklassificering__c from Account where IdentificationCode_c__c in:setAccountId]);
			if(listAccount!=null && listAccount.size()>0)
			{
				for(Account a:listAccount)
				{
					if(!mapAccount.containsKey(a.IdentificationCode_c__c))
					{
						mapAccount.put(a.IdentificationCode_c__c,a);
					}
					
				}
				
			}
			
		}
		// 根据订单编号获取订单id信息
		if(setOrderId!=null && setOrderId.size()>0)
		{
			list<Orders__c> listOrder=new list<Orders__c>([select id,name,RecordTypeName__c,OrderNum__c,CourierNumber__c,CourierCompany__c from Orders__c where OrderNum__c in:setOrderId]);
			if(listOrder!=null && listOrder.size()>0)
			{
				for(Orders__c a:listOrder)
				{
					if(!mapOrder.containsKey(a.OrderNum__c))
					{
						mapOrder.put(a.OrderNum__c,a);
					}
					
				}
				
			}
			
		}
		//根据发货明细中u8记录id获取发货明细id
		if(setShippingDetailsId!=null && setShippingDetailsId.size()>0)
		{
			list<ShippingDetails__c> listShippingDetails=new list<ShippingDetails__c>([select id,name,n_Products__c,ShipDetails__c from ShippingDetails__c where ShipDetails__c in:setShippingDetailsId]);
			if(listShippingDetails!=null && listShippingDetails.size()>0)
			{
				for(ShippingDetails__c a:listShippingDetails)
				{
					if(!mapOrder.containsKey(a.ShipDetails__c))
					{
						mapShippingDetails.put(a.ShipDetails__c,a);
					}
					
				}
				
			}
		}
		  map<string,ProductSN__c> DeviceTypeCategory =new map<string,ProductSN__c>();
           ProductSN__c q=new ProductSN__c();
           q.ProductCategory__c='样机';   //设备类别
           q.ProductStatus__c='测试机';     //设备状态
           DeviceTypeCategory.put('内部样机订单',q);
           
           ProductSN__c q1=new ProductSN__c();
           q1.ProductCategory__c='产品';   //设备类别
           q1.ProductStatus__c='出售';     //设备状态
           DeviceTypeCategory.put('销售订单',q1);
           
           ProductSN__c q2=new ProductSN__c();
           q2.ProductCategory__c='产品';   //设备类别
           q2.ProductStatus__c='出售';     //设备状态
           DeviceTypeCategory.put('换货订单',q2);
           
           ProductSN__c q3=new ProductSN__c();
           q3.ProductCategory__c='产品';   //设备类别
           q3.ProductStatus__c='压货';     //设备状态
           DeviceTypeCategory.put('压货订单',q3);
           
           ProductSN__c q4=new ProductSN__c();
           q4.ProductCategory__c='产品';   //设备类别
           q4.ProductStatus__c='出售';     //设备状态
           DeviceTypeCategory.put('渠道样机订单',q4);
        if(setProductSNId !=null && setProductSNId.size()>0)
        {
        	list<ProductSN__c> listProductSN=new list<ProductSN__c>([select id,name,Order__c,ShippingDetails__c,	Account__c,n_Production__c,dailishangmingcheng__c,shipmentdetile__c,ReplaceMentOrder__c,coustmer__c,AccountSaleArea__c,InsideOrder__c,ChannelOrder__c,ProductCategory__c,ProductStatus__c,ReturnOrder__c,SelaOrder__c,OversTockOrder__c,OverStockSaleOrder__c,demoStatus__c,PrototypeStatus__c from ProductSN__c where id in:setProductSNId]);
			for(ProductSN__c p:listProductSN)
			{
				if(mapOrder.containsKey(p.Order__c))
				{
					if(mapOrder.get(p.Order__c).RecordTypeName__c=='换货订单')
					{
						p.ReplaceMentOrder__c=mapOrder.get(p.Order__c).id;
					}
					else if(mapOrder.get(p.Order__c).RecordTypeName__c=='内部样机订单')
					{
						p.InsideOrder__c=mapOrder.get(p.Order__c).id;
					}
					else if(mapOrder.get(p.Order__c).RecordTypeName__c=='渠道样机订单')
					{
						p.ChannelOrder__c=mapOrder.get(p.Order__c).id;
					}
					else if(mapOrder.get(p.Order__c).RecordTypeName__c=='退货订单')
					{
						p.ReturnOrder__c=mapOrder.get(p.Order__c).id;
					}
					else if(mapOrder.get(p.Order__c).RecordTypeName__c=='销售订单')
					{
						p.SelaOrder__c=mapOrder.get(p.Order__c).id;
					}
					else if(mapOrder.get(p.Order__c).RecordTypeName__c=='压货订单')
					{
						p.OversTockOrder__c=mapOrder.get(p.Order__c).id;
					}
					else if(mapOrder.get(p.Order__c).RecordTypeName__c=='压货转销售订单')
					{
						p.OverStockSaleOrder__c=mapOrder.get(p.Order__c).id;
					}
					if(DeviceTypeCategory.containsKey(mapOrder.get(p.Order__c).RecordTypeName__c))
					{
						p.ProductCategory__c=DeviceTypeCategory.get(mapOrder.get(p.Order__c).RecordTypeName__c).ProductCategory__c;   //设备类别
	                    p.ProductStatus__c=DeviceTypeCategory.get(mapOrder.get(p.Order__c).RecordTypeName__c).ProductStatus__c;     //设备状态
						 if(mapOrder.get(p.Order__c).RecordTypeName__c=='内部样机订单')
	                    {
	                         p.PrototypeStatus__c='空闲';
	                    }
					}
				}
				if(mapAccount.containsKey(p.Account__c))
				{
					if(mapAccount.get(p.Account__c).Kundtypklassificering__c=='最终客户')
					{
						p.coustmer__c=mapAccount.get(p.Account__c).id;
						p.AccountSaleArea__c=mapAccount.get(p.Account__c).SellArea__c;
						
					}
					else if(mapAccount.get(p.Account__c).Kundtypklassificering__c=='渠道代理商')
					{
						p.dailishangmingcheng__c=mapAccount.get(p.Account__c).id;
					}
				}
				if(mapShippingDetails.containsKey(p.ShippingDetails__c))
				{
					p.shipmentdetile__c=mapShippingDetails.get(p.ShippingDetails__c).id;
					p.n_Production__c=mapShippingDetails.get(p.ShippingDetails__c).n_Products__c;
				}
				
				
			}
			update listProductSN;
			
        }     
		
	}
	
}