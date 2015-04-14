/*
*发货明细SN信息
*RogerSun
*2014-06-03
*
*/
trigger SendProSN on SendProSN__c (after insert, after update) {
	system.debug('-----------come in SendProSN--------------');
	set<string> setOrderId=new set<string>();   //订单
	set<string> setShippingDetailsId=new set<string>();  //发货明细
	set<string> setAccountId=new set<string>();	//客户
	set<string> setProductSNId=new set<string>();	//序列号信息
	set<string> setDepartmentId=new set<string>();	//部门信息
	set<string> setSendProSN=new set<string>();   //发货明细SN信息
	map<string,Account> mapAccount=new map<string,Account>(); //客户
	map<string,ShippingDetails__c> mapShippingDetails=new map<string,ShippingDetails__c>(); //发货明细
	map<string,Orders__c> mapOrder=new map<string,Orders__c>(); //订单
	map<string,ProductSN__c> mapProductSN=new map<string,ProductSN__c>(); //序列号信息
	map<string,SalesRegion__c> mapSalesRegion=new map<string,	SalesRegion__c>();  //部门信息
	if(trigger.isAfter)
	{
		if(trigger.isInsert)
		{
			for(SendProSN__c s:trigger.new)
			{
				if(s.Department__c!=null)
				{
					setDepartmentId.add(s.Department__c);
				}
				if(s.ShippingDetails__c!=null)
				{
					setShippingDetailsId.add(s.ShippingDetails__c);
				}
				if(s.Account__c!=null)
				{
					setAccountId.add(s.Account__c);
				}
				if(s.SerialNumber__c!=null)
				{
					setProductSNId.add(s.SerialNumber__c);
				}
				if(s.Order__c!=null)
				{
					setOrderId.add(s.Order__c);
				}
				if(s.Department__c!=null || s.ShippingDetails__c!=null || s.Account__c!=null || s.SerialNumber__c!=null || s.Order__c!=null)
				{
					setSendProSN.add(s.id);
				}
			}
		}
		else if(trigger.isUpdate)
		{
			for(SendProSN__c s:trigger.new)
			{
				SendProSN__c oldMap=trigger.oldMap.get(s.id);
				if(s.Department__c!=oldMap.Department__c)
				{
					setDepartmentId.add(s.Department__c);
				}
				if(s.ShippingDetails__c!=oldMap.ShippingDetails__c)
				{
					setShippingDetailsId.add(s.ShippingDetails__c);
				}
				if(s.Account__c!=oldMap.Account__c)
				{
					setAccountId.add(s.Account__c);
				}
				if(s.SerialNumber__c!=oldMap.SerialNumber__c)
				{
					setProductSNId.add(s.SerialNumber__c);
				}
				if(s.Order__c!=oldMap.Order__c)
				{
					setOrderId.add(s.Order__c);
				}
				if(s.Department__c!=oldMap.Department__c || s.ShippingDetails__c!=oldMap.ShippingDetails__c || s.Account__c!=oldMap.Account__c || s.SerialNumber__c!=oldMap.SerialNumber__c || s.Order__c!=oldMap.Order__c)
				{
					setSendProSN.add(s.id);
				}
			}
		}
		if(setAccountId!=null && setAccountId.size()>0)
		{
			list<Account> listAccount=new list<Account>([select id,IdentificationCode_c__c,name from Account where IdentificationCode_c__c in:setAccountId]);
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
		if(setOrderId!=null && setOrderId.size()>0)
		{
			list<Orders__c> listOrder=new list<Orders__c>([select id,name,OrderNum__c,RecordTypeName__c,CourierNumber__c,CourierCompany__c from Orders__c where OrderNum__c in:setOrderId]);
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
					if(!mapShippingDetails.containsKey(a.ShipDetails__c))
					{
						mapShippingDetails.put(a.ShipDetails__c,a);
					}
					
				}
				
			}
		}
		//根据部门名称获取部门id
		if(setDepartmentId!=null && setDepartmentId.size()>0)
		{
			list<SalesRegion__c> listSalesRegion=new list<SalesRegion__c>([select id,name from SalesRegion__c where name in:setDepartmentId]);
			if(listSalesRegion!=null && listSalesRegion.size()>0)
			{
				for(SalesRegion__c a:listSalesRegion)
				{
					if(!mapSalesRegion.containsKey(a.Name))
					{
						mapSalesRegion.put(a.Name,a);
					}
					
				}
				
			}
		}
		//根据序列号名称获取序列号id
		if(setProductSNId!=null && setProductSNId.size()>0)
		{
			list<ProductSN__c> listProductSN=new list<ProductSN__c>([select id,name from ProductSN__c where name in:setProductSNId]);
			if(listProductSN!=null && listProductSN.size()>0)
			{
				for(ProductSN__c a:listProductSN)
				{
					if(!mapProductSN.containsKey(a.Name))
					{
						mapProductSN.put(a.Name,a);
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
		if(setSendProSN!=null && setSendProSN.size()>0)
		{
			list<SendProSN__c> listSendProSN=new list<SendProSN__c>([select id,Department__c,Order__c,ShippingDetails__c,	Account__c,SerialNumber__c,	S_Order__c,S_ShippingDetails__c,S_Client__c,S_ProductCategory__c,S_ProductStatus__c,S_area__c,S_SN__c from SendProSN__c where id in:setSendProSN ]);
			for(SendProSN__c s:listSendProSN)
			{
				if(mapAccount.containsKey(s.Account__c))
				{
					s.S_Client__c=mapAccount.get(s.Account__c).id;
				}
				if(mapOrder.containsKey(s.Order__c))
				{
					s.S_Order__c=mapOrder.get(s.Order__c).id;
					if(DeviceTypeCategory.containsKey(mapOrder.get(s.Order__c).RecordTypeName__c))
					{
						s.S_ProductCategory__c=DeviceTypeCategory.get(mapOrder.get(s.Order__c).RecordTypeName__c).ProductCategory__c;   //设备类别
	                    s.S_ProductStatus__c=DeviceTypeCategory.get(mapOrder.get(s.Order__c).RecordTypeName__c).ProductStatus__c;     //设备状态
						
					}
					
				}
				if(mapShippingDetails.containsKey(s.ShippingDetails__c))
				{
					s.S_ShippingDetails__c=mapShippingDetails.get(s.ShippingDetails__c).id;
				}
				if(mapSalesRegion.containsKey(s.Department__c))
				{
					s.S_area__c=mapSalesRegion.get(s.Department__c).id;
				}
				if(mapProductSN.containsKey(s.SerialNumber__c))
				{
					s.S_SN__c=mapProductSN.get(s.SerialNumber__c).id;
				}
			}
			update listSendProSN;
		}
		
		
	}
	system.debug('------------come in SendProSN end----------');
}