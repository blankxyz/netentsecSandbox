/**
*Dis:订单上累计汇总 T1级代理商 上的渠道返点
*Time:2015年3月12日9:47:05
*Author:Gary Hu
**/
public  class Cbl_Order_SumChannelPoint {
	public void insertSum(list<Orders__c> listOrder)
	{
		//T1 代理商
		set<Id> setPartners = new set<Id>();
		for(Orders__c o:listOrder)
		{
			if(o.Partners__c != null)
			{
				setPartners.add(o.Partners__c);
			}
		}
		//键为T1代理商 值为渠道金额
		map<String,Double> mapChannelPoint = new map<String,Double>();
		if(setPartners.size() > 0)
		{
			AggregateResult [] sumChannelPoint = [select Partners__c,sum(FDZE__c) sumChannelPoint  
												  from Orders__c 
												  where Partners__c in : setPartners group by Partners__c];
			for(AggregateResult sumChannelPointX :sumChannelPoint )
			{
				if(!mapChannelPoint.containsKey(String.valueOf(sumChannelPointX.get('Partners__c'))))
				{
					mapChannelPoint.put(String.valueOf(sumChannelPointX.get('Partners__c')),Double.valueOf(sumChannelPointX.get('sumChannelPoint')));
				}
			}
			System.debug(mapChannelPoint+'-------------mapChannelPoint-----------------');
			//T1代理商
			list<Account> listAccount = [select YYFDJE__c,Id from  Account where Id in: setPartners];
			for(Account a : listAccount)
			{
				if(mapChannelPoint.containsKey(a.Id))
				{
					a.YYFDJE__c = mapChannelPoint.get(a.Id);
				}
				else
				{
					a.YYFDJE__c  = null;
				}
			}
			update listAccount;
		}
		
	}
	//修改计算
	public void updateSum(list<Orders__c> listOrder,Map<id,Orders__c> mapoldOrder)
	{
		list<Orders__c> listOrders = new list<Orders__c>();
		System.debug('--------大爷又来了---------');
		for(Orders__c o:listOrder)
		{
			if(o.FDZE__c != mapoldOrder.get(o.id).FDZE__c)
			{
				listOrders.add(o);
			}
		}
		if(listOrders.size() > 0)
		{
			insertSum(listOrders);
		}
	}
	//删除计算
	public void deleteSum(list<Orders__c> listOldOrder)
	{
		insertSum(listOldOrder);
	}
}