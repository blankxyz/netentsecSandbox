/**
*Dis:自动切换客户、订单上所对应的部门的办事处主任的共享
*Time:2015年3月25日15:03:09
*Auhtor:Gary Hu
**/
public  class Cbl_SalesRegionOffDir_AutoChange {
	
	public void orderInsertSharing(list<SalesRegion__c> listSalesRegion)
	{
		//部门/区域Id
		set<Id> setRid = new set<Id>();
		//办事处主任Id
		set<Id> setDir = new set<Id>();
		//订单Id
		set<Id> setOrd = new set<Id>();
		//区域办事处用户Id 是否启用
		map<Id,Boolean> mapOfficeDirector = new map<Id,Boolean>();
				
		//区域Id,OwnerId
		map<Id,Id> mapOwSA = new map<Id,Id>();
				
		//区域Id, OrdId
		map<Id,Id> mapOrdId = new map<Id,Id>();
		
		for(SalesRegion__c s : listSalesRegion)
		{
			if(s.OfficeDirector__c != null)
			{
				setRid.add(s.Id); //部门
				setDir.add(s.OfficeDirector__c);//办事处主任
			}
		}
		//获取订单的ID owner
		list<Orders__c> listOrdS = new list<Orders__c>();
		if(setRid.size() > 0)
		{
			listOrdS = getOrderList(setRid);
		}
		if(listOrdS.size() > 0)
		{
			for(Orders__c o : listOrdS)
			{
				if(o.OwnerId != null)
				{
					if(!mapOwSA.containsKey(o.dingdansuozaiquyu__c))
					{
						mapOwSA.put(o.dingdansuozaiquyu__c,o.OwnerId);					
					}
				}
				if(!mapOrdId.containsKey(o.dingdansuozaiquyu__c))
				{
					mapOrdId.put(o.dingdansuozaiquyu__c,o.id);
				}
			}
		}
		if(setDir.size() > 0)
		{
			mapOfficeDirector = getUser(setDir);
		}
		List<Orders__Share> listOrdShare = new List<Orders__Share>();
		for(SalesRegion__c s : listSalesRegion)
		{
			if(s.OfficeDirector__c != null && mapOwSA.get(s.id) != s.OfficeDirector__c && mapOfficeDirector.get(s.OfficeDirector__c) == true)
			{
				System.debug('-----------------大爷来了X3-----------------');
				Orders__Share order_Share = new Orders__Share();
				order_Share.UserOrGroupId = s.OfficeDirector__c;
				order_Share.ParentId = mapOrdId.get(s.Id);
				order_Share.AccessLevel = 'Read';
				listOrdShare.add(order_Share);
			}
		}
		Database.insert(listOrdShare,false);  
	}
	
	
	
	//修改客户上的共享规则
	public void accountInsertSharing(list<SalesRegion__c> listSalesRegion)
	{
		/****************客户对象处理方法 start***********************/
		//部门/区域Id
		set<Id> setRid = new set<Id>();
		//办事处主任Id
		set<Id> setDir = new set<Id>();
		//客户Id
		set<Id> setAcc = new set<Id>();
		
		//区域办事处用户Id 是否启用
		map<Id,Boolean> mapOfficeDirector = new map<Id,Boolean>();
				
		//区域Id,OwnerId
		map<Id,Id> mapOwSA = new map<Id,Id>();
				
		//区域Id, AccId
		map<Id,Id> mapAccId = new map<Id,Id>();
		
		for(SalesRegion__c s : listSalesRegion)
		{
			if(s.OfficeDirector__c != null)
			{
				setRid.add(s.Id); //部门
				setDir.add(s.OfficeDirector__c);//办事处主任
			}
		}
		//获取客户的ID owner
		list<Account> listAccS = new list<Account>();
		if(setRid.size() > 0)
		{
			listAccS = getAccList(setRid);
		}
		if(listAccS.size() > 0)
		{
			for(Account a : listAccS)
			{
				if(a.OwnerId != null)
				{
					//客户所有Id
					if(!mapOwSA.containsKey(a.SellArea__c))
					{
						mapOwSA.put(a.SellArea__c,a.OwnerId);
					}
				}
				//客户Id
				if(!mapAccId.containsKey(a.SellArea__c))
				{
					mapAccId.put(a.SellArea__c,a.id);
				}
				
			}
			//获取用户是否启用
			if(setDir.size() > 0)
			{
				mapOfficeDirector = getUser(setDir);
			}
			List<AccountShare> listAccShare = new List<AccountShare>();
			for(SalesRegion__c s : listSalesRegion)
			{
				if(s.OfficeDirector__c != null && mapOwSA.get(s.id) != s.OfficeDirector__c && mapOfficeDirector.get(s.OfficeDirector__c) == true)
				{
					AccountShare account_Share = new AccountShare();
					account_Share.UserOrGroupId = s.OfficeDirector__c;
					account_Share.AccountId = mapAccId.get(s.id);
					account_Share.AccountAccessLevel = 'Read';
					account_Share.OpportunityAccessLevel  = 'Read';
					listAccShare.add(account_Share);
				}
			
			}
			Database.insert(listAccShare,false);	
			/****************客户对象处理方法 end***********************/
		}
		
	}
	
	
	//订单共享修改处理方法
	public void updateOrderSharing(list<SalesRegion__c> listSalesRegion,Map<id,SalesRegion__c> map_old)
	{
		System.debug('-----------------大爷来了-----------------');
		list<SalesRegion__c> listSalesRegionX = new list<SalesRegion__c>();
		//记录Id
		set<Id> setRid = new set<Id>();
		//共享者Id
		set<Id> setOShId = new set<Id>();
		//订单Id
		set<Id> setOrdId = new set<Id>();
		for(SalesRegion__c s: listSalesRegion)
		{
			if(s.OfficeDirector__c != map_old.get(s.id).OfficeDirector__c && s.OfficeDirector__c != null)
			{
				setRid.add(s.id);
				setOShId.add(map_old.get(s.id).OfficeDirector__c);
				listSalesRegionX.add(s);
			}	
		}
		list<Orders__c> listOrder = new list<Orders__c>();
		if(setRid.size() > 0)
		{
			listOrder = getOrderList(setRid);
		}
		if(listOrder.size() > 0)
		{
			for(Orders__c o: listOrder)
			{
				setOrdId.add(o.id);
			}
		}
		if(setOrdId.size() > 0 && setOShId.size() > 0 && listSalesRegionX.size() > 0)
		{
			List<Orders__Share> listOrdSh = [select Id,UserOrGroupId,ParentId,RowCause from Orders__Share where UserOrGroupId in: setOShId and ParentId in: setOrdId and RowCause='Manual' ];
			System.debug('-----------------listOrdSh-----------------'+listOrdSh);
			delete listOrdSh;
			System.debug('-----------------大爷来了X2-----------------');
			orderInsertSharing(listSalesRegionX);
		}
		
	}
	
	//客户共享修改处理方法
	public void updateAccountSharing(list<SalesRegion__c> listSalesRegion,Map<id,SalesRegion__c> map_old)
	{
		list<SalesRegion__c> listSalesRegionX = new list<SalesRegion__c>();
		//记录Id
		set<Id> setRid = new set<Id>();
		//共享者Id
		set<Id> setOShId = new set<Id>();
		//客户Id
		set<Id> setAccId = new set<Id>();
		
		for(SalesRegion__c s: listSalesRegion)
		{
			if(s.OfficeDirector__c != map_old.get(s.id).OfficeDirector__c && s.OfficeDirector__c != null)
			{
				setRid.add(s.id);
				setOShId.add(map_old.get(s.id).OfficeDirector__c);
				listSalesRegionX.add(s);
			}
		}
		//获取客户Id
		list<Account> listAccS = new list<Account>();
		if(setRid.size() > 0)
		{
			listAccS = getAccList(setRid);
		}
		if(listAccS.size() > 0)
		{
			for(Account a : listAccS)
			{
				setAccId.add(a.id);
			}
		}
		//删除客户之前的共享
		if(setAccId.size() > 0 && listSalesRegionX.size() > 0 && setOShId.size() > 0)
		{
			List<AccountShare> listAccShare = [select id,UserOrGroupId,RowCause,AccountId from AccountShare where UserOrGroupId in: setOShId and AccountId in: setAccId and  RowCause='Manual'];
			System.debug(listAccShare.size()+'-----------listAccShare----------');
			//删除之前的共享
			delete listAccShare;
			//插入新的共享
			accountInsertSharing(listSalesRegionX);
		}
	}
	
	//获取客户List
	public list<Account> getAccList(set<Id> setAreaid)
	{
		list<Account> listAcc = [select Id,OwnerId,SellArea__c from Account where SellArea__c in:setAreaid];
		return listAcc;
	}
	
	//获取订单list
	public list<Orders__c> getOrderList(set<Id> setQyId)
	{
		list<Orders__c> listOrder = [select Id,dingdansuozaiquyu__c,OwnerId from Orders__c where dingdansuozaiquyu__c in: setQyId];
		return listOrder;
	}
	
    //获取用户的公共方法
	public map<Id,Boolean> getUser(set<Id> setOwId)
	{
		//键为用Id 值为是否启用
		map<Id,Boolean> mapShareOwUser = new map<Id,Boolean>();
		if(setOwId.size() > 0)
		{
			list<User> listUser = [select Id,IsActive from User where Id in : setOwId];
			for(User listUserX : listUser)
			{
				if(!mapShareOwUser.containsKey(listUserX.Id))
				{
					mapShareOwUser.put(listUserX.Id,listUserX.IsActive);
				}
			}
		}
		return mapShareOwUser;
	}

}