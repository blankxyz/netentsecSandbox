global class  OrderSynchronization
{

	webservice static string OrderOperate(string ordersId)
	{
		system.debug('获取传入参数ordersId值 :'+ordersId);
		list<OrderDetails__c> orderDetail=new list<OrderDetails__c>();
		orderDetail=[Select o.Acount__r.Name,o.licenseWarranty__c,o.DurationOfTheAuthorization__c,o.WarrantyPeriod__c,o.versionNumber__c,o.Id, o.n_Sum__c, o.n_ProductByOrd__r.Name, o.n_ProCount__c, o.n_Price__c, o.n_PriceByord__c, o.n_OrderNo__r.Platform__c,o.n_OrderNo__r.OrderNum__c, o.n_OrderNo__r.order_Industry__c, o.n_OrderNo__r.SalesRegion__r.Name, o.n_OrderNo__r.Payer__r.Name, o.n_OrderNo__r.BusinessOwners__c,o.n_OrderNo__r.ordersClassify__c, o.n_OrderNo__r.CreatedDate, o.n_OrderNo__r.Name, o.n_DiscountByord__c, o.n_CustomModels__c,o.n_Remark__c,o.n_AccounSerNo__c, o.n_OrderNo__r.Remark__c From OrderDetails__c o where o.n_OrderNo__r.OrderNum__c=:ordersId and o.IsDeleted=false];
		 system.debug('获取orderDetail值 :'+orderDetail);
		 if(orderDetail.size()<=0)
		 {
		 	return '没有订单详细';
		 }
		 else
		 {
		 	WSDLOrderSynchronization.OrderSynchronizationSoap tt=new WSDLOrderSynchronization.OrderSynchronizationSoap();
		 	
			WSDLOrderSynchronization.ArrayOfOrderSynchronizationArray aa=new WSDLOrderSynchronization.ArrayOfOrderSynchronizationArray();
			 aa.OrderSynchronizationArray=(WSDLOrderSynchronization.OrderSynchronizationArray[])operatorData(orderDetail);
			 system.debug('获取salesforce数据库查询出满足条件aa值 :'+aa);
			  WSDLOrderSynchronization.ArrayOfString f=new WSDLOrderSynchronization.ArrayOfString();
		     f=tt.OrderSynchronizationByValue(aa);
		       system.debug('获取WSDLUpdateClient中CustomersByValue方法返回值赋值给f :'+f);
		        tt.timeout_x=120000;
		        operatorSynchronizationData(f);
	 	 	return '修改完成';
		 }
	}
	public static list<WSDLOrderSynchronization.OrderSynchronizationArray> operatorData(list<OrderDetails__c> orderDetail)
	{
		 list<WSDLOrderSynchronization.OrderSynchronizationArray> h=new list<WSDLOrderSynchronization.OrderSynchronizationArray>();
			 for(OrderDetails__c s:orderDetail)
			 {
			 	WSDLOrderSynchronization.OrderSynchronizationArray j=new WSDLOrderSynchronization.OrderSynchronizationArray();
			    j.BusinessOwners_xc=s.n_OrderNo__r.BusinessOwners__c;
			    system.debug('转化BusinessOwners__c值 :'+j.BusinessOwners_xc);
			    j.OrderNum_xc=s.n_OrderNo__r.OrderNum__c;
			    system.debug('转化OrderNum__c值 :'+j.OrderNum_xc);
			     j.order_Industry_xc=s.n_OrderNo__r.order_Industry__c;
			    system.debug('转化order_Industry__c值 :'+j.order_Industry_xc);
			     j.SalesRegion_xc=s.n_OrderNo__r.SalesRegion__r.Name;
			    system.debug('转化SalesRegion__r值 :'+j.SalesRegion_xc);
			     j.Payer_xc=s.n_OrderNo__r.Payer__r.Name;
			    system.debug('转化Payer__r值 :'+j.Payer_xc);
			    j.ordersClassify_xc=s.n_OrderNo__r.ordersClassify__c;
			    system.debug('转化n_OrderNo__r.ordersClassify__c值 :'+j.ordersClassify_xc);
			    j.CreatedDate=s.n_OrderNo__r.CreatedDate;
			    system.debug('转化n_OrderNo__r.CreatedDate值 :'+j.CreatedDate);
			     j.Name=s.n_OrderNo__r.Name;
			    system.debug('转化n_OrderNo__r.Name值 :'+j.Name);
			    j.Platform_xc=s.n_OrderNo__r.Platform__c;
			    system.debug('转化n_OrderNo__r.Platform__c值 :'+j.Platform_xc);
			    if(s.n_Sum__c ==null)
			    {
			    	j.n_Sum_xc=0;
				    system.debug('转化n_Sum__c值 :'+j.n_Sum_xc);
			    }
			    else
			    {
				    j.n_Sum_xc=s.n_Sum__c;
				    system.debug('转化n_Sum__c值 :'+j.n_Sum_xc);
			    }
			    j.n_ProductByOrd_xc=s.n_ProductByOrd__r.Name;
			    system.debug('转化n_ProductByOrd__r.Name值 :'+j.n_ProductByOrd_xc);
			    if(s.n_ProCount__c==null)
			    {
			    	j.n_ProCount_xc=0;
				    system.debug('转化n_ProCount__c值 :'+j.n_ProCount_xc);
			    }
			    else
			    {
				     j.n_ProCount_xc=s.n_ProCount__c;
				    system.debug('转化n_ProCount__c值 :'+j.n_ProCount_xc);
			    }
			    if(s.n_Price__c==null)
			    {
			    	j.n_Price_xc=0;
				    system.debug('转化n_Price__c值 :'+j.n_Price_xc);
			    }
			    else
			    {
				     j.n_Price_xc=s.n_Price__c;
				    system.debug('转化n_Price__c值 :'+j.n_Price_xc);
			    }
			    if(s.n_PriceByord__c==null)
			    {
			    	j.n_PriceByord_xc=0;
				    system.debug('转化n_PriceByord__c值 :'+j.n_PriceByord_xc);
			    }
			    else
			    {
				    j.n_PriceByord_xc=s.n_PriceByord__c;
				    system.debug('转化n_PriceByord__c值 :'+j.n_PriceByord_xc);
			    }
			    if(s.n_DiscountByord__c==null)
			    {
			    	j.n_DiscountByord_xc=0;
				    system.debug('转化n_DiscountByord__c值 :'+j.n_DiscountByord_xc);
			    }
			    else
			    {
				    j.n_DiscountByord_xc=s.n_DiscountByord__c;
				    system.debug('转化n_DiscountByord__c值 :'+j.n_DiscountByord_xc);
			    }
			    j.n_CustomModels_xc=s.n_CustomModels__c;
			    system.debug('转化n_CustomModels__c值 :'+j.n_CustomModels_xc);
			    j.versionNumber_xc=s.versionNumber__c;
			    system.debug('转化versionNumber__c值 :'+j.versionNumber_xc);
			    j.ID=s.Id;
			    system.debug('转化Id值 :'+j.ID);
			    j.n_AccounSerNo_xc=s.n_AccounSerNo__c;
			    system.debug('转化n_AccounSerNo__c值 :'+j.n_AccounSerNo_xc);
			    j.n_Remark_xc=s.n_Remark__c;
			    system.debug('转化n_Remark__c值 :'+j.n_Remark_xc);
			    j.Remark_xc=s.n_OrderNo__r.Remark__c;
			    system.debug('转化Remark__c值 :'+j.Remark_xc);
			    j.AcountName=s.Acount__r.Name;
			    system.debug('转化Acount__r.Name值 :'+j.AcountName);
			    j.WarrantyPeriod=s.WarrantyPeriod__c;
			    system.debug('转化j.WarrantyPeriod值 :'+j.WarrantyPeriod);
			    j.licenseWarranty=s.licenseWarranty__c;
			    system.debug('转化j.licenseWarranty值 :'+j.licenseWarranty);
			    j.DurationOfTheAuthorization=s.DurationOfTheAuthorization__c;
			    system.debug('转化j.DurationOfTheAuthorization值 :'+j.DurationOfTheAuthorization);
			    h.add(j);
			 }
			 return h;
	}
	
	public static  void operatorSynchronizationData(WSDLOrderSynchronization.ArrayOfString f)
	{ 
		     Map<string,string> numIdMap = new Map<string,string>();
			 string[] ss = f.string_x;
			  system.debug('from string is ss :'+ss);
			   for(string s:ss)
			 {
			 	string[] numID = s.split(',');
			 	for(string sNum:numID)
			 	{
			 		string[] sNumId=sNum.split('\\+');
			 		if(sNumId[1]!=null && sNumId[0]!=null)
			 		{
			 			numIdMap.put(sNumId[0],sNumId[1]);
			 		}
			 		
			 		system.debug('asd :'+sNumId[0]);
			 	    system.debug('das:'+sNumId[1]);
			 	}	
			 }
			 system.debug('返回值按照Id和标识码赋值给map（numIdMap） :'+numIdMap.size());
			 List<Orders__c > acc = [select OrderNum__c from Orders__c where OrderNum__c IN: numIdMap.keySet()]; 
			 system.debug('根据map中的id获取Account表中id :'+numIdMap);
			 for(Orders__c a:acc)
			 {
			 	a.SynchronizationStatus__c=numIdMap.get(a.OrderNum__c);
			 }
			 update acc;
		     system.debug('修改完成');
	}
	
}