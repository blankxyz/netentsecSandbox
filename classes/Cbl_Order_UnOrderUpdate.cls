/**
*Dis:取消订单的操作
*Time:2015年3月30日9:39:35
*Author:Gary Hu
**/
public class Cbl_Order_UnOrderUpdate {
	//插入操作
	public void insertUnOrder(list<Orders__c> listOrds)
	{
	    //取消订单
	    set<Id> setUnOrder = new set<Id>(); 
	
	    //关联订单
	    set<Id> setAboutOrder = new set<Id>();
	    
	    //取消订单编号,关联订单编号
   		map<String,String> mapUnOder = new map<String,String>();
	    
		for(Orders__c o:listOrds)
		{
			if(o.RecordTypeName__c =='取消订单' && o.AboutOrder__c != null)
			{
				setUnOrder.add(o.id);
				setAboutOrder.add(o.AboutOrder__c);
				 if(!mapUnOder.containsKey(o.AboutOrder__c))
    			{
    				mapUnOder.put(String.valueOf(o.AboutOrder__c),String.valueOf(o.id));
    			}
			}
		}
		if(setUnOrder.size() > 0)
		{
			//修改编号
			list<Orders__c> listOrd = [select OrderNum__c from Orders__c where id in: setUnOrder];
			if(listOrd.size() > 0)
			{
				for(Orders__c o : listOrd)
				{
					o.OrderNum__c = UtilsCreateAutoNum.createAutoNum('CAN','ORDOrderNumber',4);
				}
			}
			update listOrd;
		}
		//关联的订单明细
    	list<OrderDetails__c> listOrderDetails = new list<OrderDetails__c>();
		//插入订单明细
		if(setUnOrder.size() > 0 && setAboutOrder.size()> 0)
		{
			listOrderDetails = [select Id,n_OrderNo__c,RecordTypeId,n_ProductByOrd__c,Acount__c,n_ProCount__c,n_Price__c,n_PriceByord__c,OrddetailDiscount__c,Rebate_Amount__c
    							 from OrderDetails__c where n_OrderNo__c in: setAboutOrder];
		}
		if(listOrderDetails.size() > 0)
		{
			List<OrderDetails__c> OrderDetailsList = new List<OrderDetails__c>();
    		for(OrderDetails__c od: listOrderDetails)
    		{
    			if(mapUnOder.containsKey(od.n_OrderNo__c))
    			{
		    		OrderDetails__c ods = new OrderDetails__c();
    				ods.RecordTypeId = od.RecordTypeId;  //记录类型
    				ods.n_OrderNo__c = mapUnOder.get(od.n_OrderNo__c); //订单
    				ods.n_ProductByOrd__c = od.n_ProductByOrd__c;//产品
    				ods.Acount__c = od.Acount__c;//客户
    				ods.n_ProCount__c = -od.n_ProCount__c;//数量
    				ods.n_Price__c = od.n_Price__c;
    				ods.n_PriceByord__c = od.n_PriceByord__c;
    				ods.OrddetailDiscount__c = od.OrddetailDiscount__c;
    				if(od.Rebate_Amount__c != null)
    				{
	    				ods.Rebate_Amount__c = -od.Rebate_Amount__c;
    				}
    				OrderDetailsList.add(ods);
    			}
    		}
    		insert OrderDetailsList;
		}
		
	}
	//修改
	public void updateUnOrder(list<Orders__c> listOrd,Map<id,Orders__c> mapOrder)
	{ 
		list<Orders__c> listOrder = new list<Orders__c>();
		for(Orders__c o : listOrd)
		{
			
			if(o.RecordTypeName__c != mapOrder.get(o.id).RecordTypeName__c && o.RecordTypeName__c =='取消订单'&& o.AboutOrder__c != null)
			{
				listOrder.add(o);
			}
			
		}
		if(listOrder.size() > 0)
		{
			insertUnOrder(listOrder);
		}
	}
}