trigger InvoiceDetails on InvoiceDetails__c (before insert, before update) 
{
	set<string> setOrderId=new set<string>();
	set<string> setProduct2Id=new set<string>();
	set<string> setInvoice=new set<string>();
	map<string,Orders__c> mapOrders=new map<string,Orders__c>();
	map<string,Product2> mapProduct2=new map<string,Product2>();
	map<string,Invoice__c> mapInvoice=new map<string,Invoice__c>();
	if(trigger.isBefore)
	{
		if(trigger.isInsert)
		{
			for(InvoiceDetails__c c:trigger.new)
			{
				setOrderId.add(c.OrderData__c);
				setProduct2Id.add(c.ProductName__c);
				setInvoice.add(c.InvoiceData__c);
			}
		}
		else if(trigger.isUpdate)
		{
			for(InvoiceDetails__c c:trigger.new)
			{
				
				if(c.OrderData__c!=trigger.oldMap.get(c.id).OrderData__c || c.ProductName__c!=trigger.oldMap.get(c.id).ProductName__c || c.InvoiceData__c!=trigger.oldMap.get(c.id).InvoiceData__c)
				{
					setOrderId.add(c.OrderData__c);
					setProduct2Id.add(c.ProductName__c);
					setInvoice.add(c.InvoiceData__c);
				}
			}
		}
		if(setOrderId!=null && setOrderId.size()>0)
	{
		list<Orders__c> listOrders=new list<Orders__c>([select id,OrderNum__c from Orders__c where OrderNum__c in:setOrderId]);
		if(listOrders!=null && listOrders.size()>0)
		{
			for(Orders__c o:listOrders)
			{
				mapOrders.put(o.OrderNum__c,o);
			}
		}
		
	}
	
	if(setProduct2Id!=null && setProduct2Id.size()>0)
	{
		list<Product2> listProduct2=new list<Product2>([Select p.ProductCode, p.Id From Product2 p where p.ProductCode in:setProduct2Id]);
		if(listProduct2!=null && listProduct2.size()>0)
		{
			for(Product2 p:listProduct2)
			{
				mapProduct2.put(p.ProductCode,p);
			}
		}
		
		
	}
	if(setInvoice!=null && setInvoice.size()>0)
	{
		list<Invoice__c> listInvoice=new list<Invoice__c>([select id,name from Invoice__c where name in:setInvoice]);
		if(listInvoice!=null && listInvoice.size()>0)
		{
			for(Invoice__c i:listInvoice)
			{
				mapInvoice.put(i.name,i);
			}
		}
		
	}
	
	for(InvoiceDetails__c c:trigger.new)
	{
		if(mapOrders.containsKey(c.OrderData__c))
		{
			c.OrderId__c=mapOrders.get(c.OrderData__c).id;
			system.debug('订单编号：'+mapOrders.get(c.OrderData__c).id);
		}
		if(mapProduct2.containsKey(c.ProductName__c))
		{
			c.n_Product__c=mapProduct2.get(c.ProductName__c).id;
		}
		if(mapInvoice.containsKey(c.InvoiceData__c))
		{
			c.n_InvoiceId__c=mapInvoice.get(c.InvoiceData__c).id;
		}
		
	}
	}
	
}