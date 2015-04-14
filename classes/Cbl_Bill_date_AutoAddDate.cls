/**
*Dis:税务发票：增加税务发票开票时间字段，选择发票数据中记录类型为税务发票的最早时间
*Time:2015年3月11日13:15:53
*Author:Gary Hu
**/
public  class Cbl_Bill_date_AutoAddDate {
	//插入赋值
	public void insertAutoAddDate(list<bill_date__c> listBillDate)
	{
		set<Id> setOderId = new set<Id>();
		for(bill_date__c b:listBillDate)
		{
				System.debug('---------------'+b.RecordType__c);			
			if(b.TaxDate__c != null && b.RecordType__c =='税务发票')
			{
				System.debug('---------------'+b.RecordType.DeveloperName);			
				setOderId.add(b.Orders__c);
			}
		}
		//键为 订单 值为日期
		map<String,Date> mapTaxDate = new map<String,Date>();
		if(setOderId.size() > 0)
		{
			list<bill_date__c> listBillDateX = [select TaxDate__c,Orders__c from bill_date__c where Orders__c in: setOderId order by TaxDate__c asc];
			if(listBillDateX.size() > 0)
			{
				bill_date__c obj_BillDate = listBillDateX[0];
				if(!mapTaxDate.containsKey(obj_BillDate.Orders__c))
				{
					mapTaxDate.put(obj_BillDate.Orders__c,obj_BillDate.TaxDate__c);
				}
			}
		}
		//获取订单
		list<Orders__c> listOrder = [select Billing_Time__c,Id from Orders__c where id in:setOderId];
		for(Orders__c od: listOrder)
		{
			if(mapTaxDate.containsKey(od.Id))
			{
				od.Billing_Time__c = mapTaxDate.get(od.Id);
			}
			else
			{
				od.Billing_Time__c = null;
			}
		
		}
		update listOrder;
		
	}
	//修改时间
	public void updateAutoAdd(list<bill_date__c> listoldBillDate,Map<id,bill_date__c> mapoldBillDate)
	{
		list<bill_date__c> listBillDate = new list<bill_date__c>();
		for(bill_date__c o : listoldBillDate)
		{
			if(o.TaxDate__c != mapoldBillDate.get(o.id).TaxDate__c && o.TaxDate__c != null)
			{
				listBillDate.add(o);
			}
		}
		if(listBillDate.size() > 0)
		{
			insertAutoAddDate(listBillDate);
		}
	}
	//删除修改时间
	public void deleteAutoAdd(list<bill_date__c> listBillDate)
	{
		insertAutoAddDate(listBillDate);
	}
	
	
}