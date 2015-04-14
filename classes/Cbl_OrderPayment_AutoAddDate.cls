/**
*Dis:订单中添加“收款时间”字段，并赋值为关联的订单收款中收款时间最早的收款时间
*Time:2015年3月11日10:24:44
*Author:Gary Hu
**/
public class Cbl_OrderPayment_AutoAddDate {
	//添加插入时间
	public void insertAutoAddDate(list<OrderPaymentRecords__c> listOrderPayMent)
	{
		//订单收款纪录ID
		set<Id> setOrderPayId = new set<Id>();
		//订单Id
		set<Id> setOrderId = new set<Id>();
		for(OrderPaymentRecords__c o: listOrderPayMent)
		{
			//付款日期不等于空
			if(o.Orders__c != null && o.fukuandateField1__c != null)
			{
				setOrderId.add(o.Orders__c);
			}
		}
		//键为 订单、值为Date 
		map<String,Date> mapOrdDate = new map<String,Date>();
		
		if(setOrderId.size() > 0)
		{
			list<OrderPaymentRecords__c> listOrdPay = [select fukuandateField1__c,Orders__c 
													   from OrderPaymentRecords__c 
													   where Orders__c in: setOrderId order by fukuandateField1__c asc];
			if(listOrdPay.size() > 0)
			{
				
				OrderPaymentRecords__c obj_OrderPayment = listOrdPay[0];
				
				
				if(!mapOrdDate.containsKey(obj_OrderPayment.Orders__c))
				{
					mapOrdDate.put(obj_OrderPayment.Orders__c,obj_OrderPayment.fukuandateField1__c);
				}
			}
			
			//获取订单
			list<Orders__c> listOrder = [select Collection_Time__c,Id from Orders__c where id in:setOrderId];
			for(Orders__c od: listOrder)
			{
				if(mapOrdDate.containsKey(od.Id))
				{
					od.Collection_Time__c = mapOrdDate.get(od.Id);
				}
				else
				{
					od.Collection_Time__c = null;
				}
			
			}
			update listOrder;
		}
	}
	
	//修改时间
	public void updateAutoAdd(list<OrderPaymentRecords__c> listoldOrderPay,Map<id,OrderPaymentRecords__c> mapoldOrderPay)
	{
		list<OrderPaymentRecords__c> listOrderPayMent = new list<OrderPaymentRecords__c>();
		for(OrderPaymentRecords__c o : listoldOrderPay)
		{
			if(o.fukuandateField1__c != mapoldOrderPay.get(o.id).fukuandateField1__c && o.fukuandateField1__c != null)
			{
				listOrderPayMent.add(o);
			}
		}
		if(listOrderPayMent.size() > 0)
		{
			insertAutoAddDate(listOrderPayMent);
		}
	}
	//删除修改时间
	public void deleteAutoAdd(list<OrderPaymentRecords__c> listOrderPayMent)
	{
		insertAutoAddDate(listOrderPayMent);
	}
	
}