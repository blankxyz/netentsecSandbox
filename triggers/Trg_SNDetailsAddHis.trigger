/**
*Dis:记录序列号明细的更改
*Time:2014年4月28日11:22:12
*Author:Gary Hu
**/
trigger Trg_SNDetailsAddHis on ProductSNDetial__c (after insert, after update) {
	
	
	
	public map<Id,Id> getOrder(list<ProductSNDetial__c> listProductSNDetial)
	{ 
		//订单明细Id
		Set<Id> setOrId = new Set<Id>();
		for(ProductSNDetial__c proSN : listProductSNDetial)
		{
			if(	proSN.OrdersDetail__c != null)
			{
				setOrId.add(proSN.OrdersDetail__c);
			}
			
		}
		list<ProductSNDetial__c> listOrdDe = null;
		system.debug('setOrId is infor:'+setOrId);
		if(setOrId != null && setOrId.size()>0)
		{
			system.debug('setOrId is infor信息进来！：'+setOrId);
			system.debug('setOrId is infor信息进来123！：'+setOrId.size());
			listOrdDe = [Select Id,OrdersDetail__r.n_OrderNo__c From ProductSNDetial__c 
			where OrdersDetail__r.n_OrderNo__c in: setOrId
			];
			system.debug('listOrdDe is infor:'+listOrdDe);
		}
		map<Id,Id> mapOrdDes = new map<Id,Id>();
		if(listOrdDe != null &&  listOrdDe.size() > 0)
		{
			for(ProductSNDetial__c listOrdDeX : listOrdDe)
			{
				if(!mapOrdDes.containsKey(listOrdDeX.Id))
				{
					mapOrdDes.put(listOrdDeX.Id,listOrdDeX.OrdersDetail__r.n_OrderNo__c);
				}
			}
		}
		return mapOrdDes;
	}
	
	List<SerialNumberHis__c> listSerHis = new List<SerialNumberHis__c>();	
	if(Trigger.isInsert)
	{
		map<Id,Id> mapOrdDes = new map<Id,Id>();
		mapOrdDes = getOrder(trigger.new);
	    for(ProductSNDetial__c proSN : trigger.new)
		{
			SerialNumberHis__c serHis = new SerialNumberHis__c();
		 	if(mapOrdDes.containsKey(proSN.Id))
		 	{
		 		serHis.Order__c = mapOrdDes.get(proSN.Id);
		 	}
		 	
		 	serHis.ModificationTime__c = proSN.LastModifiedDate;
			serHis.Modifier__c = proSN.LastModifiedById;
			serHis.HistoryReason__c = proSN.Remark__c;
			serHis.SNDetails__c = proSN.id;
			if(proSN.Order__c != null)
			{
				serHis.Order__c = proSN.Order__c;
			}
			String contentB = '';
			String contentC = '';
			if(proSN.StartDate__c!=null)
			{
				contentB = '开始时间：添加为     '+proSN.StartDate__c.format('yyyy-MM-dd HH:mm:ss','Asia/Shanghai') +'\n';
			
			}
			if(proSN.EndDate__c!=null)
			{
				contentC = '结束时间：添加为     '+proSN.EndDate__c.format('yyyy-MM-dd HH:mm:ss','Asia/Shanghai') +'\n';
			
			}
			serHis.Content__c =  contentB + contentC;
			listSerHis.add(serHis);
		}
		insert listSerHis;
	}

	if(Trigger.isUpdate){
		map<Id,Id> mapOrdDes = new map<Id,Id>();
		mapOrdDes = getOrder(trigger.new);
		for(ProductSNDetial__c proSN : trigger.new)
		{
			System.debug('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
			system.debug(trigger.old+'-------------------xxxxxxxxx------------------');
			if(proSN.EndDate__c != trigger.oldMap.get(proSN.Id).EndDate__c || proSN.StartDate__c != trigger.oldMap.get(proSN.Id).StartDate__c || proSN.Order__c != trigger.oldMap.get(proSN.Id).Order__c)
			{
			
				SerialNumberHis__c serHis = new SerialNumberHis__c();
			 	if(mapOrdDes.containsKey(proSN.Id))
			 	{
			 		serHis.Order__c = mapOrdDes.get(proSN.Id);
			 	}
				serHis.ModificationTime__c = proSN.LastModifiedDate;
				serHis.Modifier__c = proSN.LastModifiedById;
				serHis.HistoryReason__c = proSN.Remark__c;
				serHis.SNDetails__c = proSN.id;
				if(proSN.Order__c != null)
				{
					serHis.Order__c = proSN.Order__c;
				}
				String contentB = '';
				String contentC = '';
				if(proSN.StartDate__c != null && proSN.StartDate__c != trigger.oldMap.get(proSN.Id).StartDate__c)
				{
					contentB = '开始时间：从    ' + trigger.oldMap.get(proSN.Id).StartDate__c.format('yyyy-MM-dd HH:mm:ss','Asia/Shanghai') +'  修改为  ' + proSN.StartDate__c.format('yyyy-MM-dd HH:mm:ss','Asia/Shanghai') +'\n';
				}
				if(proSN.EndDate__c != null && proSN.EndDate__c != trigger.oldMap.get(proSN.Id).EndDate__c)
				{
					System.debug(trigger.oldMap.get(proSN.Id).EndDate__c+'-----------------trigger.oldMap.get(proSN.Id).EndDate__c----------------------');
					System.debug(proSN.EndDate__c+'-----------------proSN.EndDate__c----------------------');
					contentC = '结束时间：从    ' + trigger.oldMap.get(proSN.Id).EndDate__c.format('yyyy-MM-dd HH:mm:ss','Asia/Shanghai') +'  修改为    ' + proSN.EndDate__c.format('yyyy-MM-dd HH:mm:ss','Asia/Shanghai') +'\n';
				}
				
				serHis.Content__c = contentB + contentC;
				System.debug(serHis.Content__c+'--------------------------serHis.Content__c-------------------------------');
				System.debug(serHis+'--------------------------serHis-------------------------------');
				listSerHis.add(serHis);
			}
			
		}
		System.debug(listSerHis+'--------------listSerHis------------------');
		insert listSerHis;
	}
	
	
}