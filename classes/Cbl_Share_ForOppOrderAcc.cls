/**
*Dis:订单上共享对应的OSR、
*Dis:客户、业务机会、订单上共享给对应的区域办事处主任
*
**/
public class Cbl_Share_ForOppOrderAcc {
	//订单插入时共享给对应的OSR
	public void orderInsertOSRShare(list<Orders__c> listOrders)
	{
		//OSRId
		set<Id> setOSRid = new set<Id>();
		
		//OSR用户Id 是否启用
		map<Id,Boolean> mapOSRid = new map<Id,Boolean>();
		
		for(Orders__c o : listOrders)
		{
			//OSRId
			if(o.duiyingOSR__c != null)
			{
				setOSRid.add(o.duiyingOSR__c);
			}
		}
		if(setOSRid.size() > 0)
		{
			mapOSRid = getUser(setOSRid);
			List<Orders__Share> listOrdShare = new List<Orders__Share>();
			//共享给 OSRmapOSRid
			for(Orders__c o : listOrders)
			{
				if(o.duiyingOSR__c != null && o.duiyingOSR__c != o.OwnerId && mapOSRid.get(o.duiyingOSR__c) == true)
				{
					Orders__Share order_Share = new Orders__Share();
					order_Share.UserOrGroupId = o.duiyingOSR__c;
					order_Share.ParentId = o.id;
					order_Share.AccessLevel = 'Read';
					listOrdShare.add(order_Share);
				}
			}
			 Database.insert(listOrdShare,false);  
		}
		
	}
	
	
	//订单插入是 共享给订单所在区域的 
	public void orderInsertQyShare(list<Orders__c> listOrders)
	{
		
		//订单所在区域
		set<Id> setQyId = new set<Id>();
		
		//区域Id,OwnerId
		map<Id,Id> mapOwQy = new map<Id,Id>();
		
		//区域Id, orderId
		map<Id,Id> mapParId = new map<Id,Id>();
		
		//区域办事处主任
		set<Id> setOfficeDir = new set<Id>();
		
		//区域办事处用户Id 是否启用
		map<Id,Boolean> mapOfficeDirector = new map<Id,Boolean>();
		
		//订单所在区域
		for(Orders__c o : listOrders)
		{
			
			if(o.dingdansuozaiquyu__c != null)
			{
				setQyId.add(o.dingdansuozaiquyu__c);
				if(!mapOwQy.containsKey(o.dingdansuozaiquyu__c))
				{
					mapOwQy.put(o.dingdansuozaiquyu__c,o.OwnerId);
				}
				if(!mapParId.containsKey(o.dingdansuozaiquyu__c))
				{
					mapParId.put(o.dingdansuozaiquyu__c,o.Id);
				}
			}
		}
			
		//共享给区域办事处主任
		if(setQyId.size() > 0)
		{
			System.debug('--------大爷来共享了2---------');
			//获取区域办事处主任
			list<SalesRegion__c> listSalesRegion = getOfficeDir(setQyId);
			if(listSalesRegion.size() > 0)
			{
				System.debug('--------大爷来共享了3---------');
				for(SalesRegion__c s : listSalesRegion)
				{
					if(s.OfficeDirector__c != null)
					{
						setOfficeDir.add(s.OfficeDirector__c);
					}
				}
				if(setOfficeDir.size() > 0)
				{
					mapOfficeDirector = getUser(setOfficeDir);
				}
				
				List<Orders__Share> listOrdShare = new List<Orders__Share>();
				for(SalesRegion__c s : listSalesRegion)
				{
					if(s.OfficeDirector__c != null && s.OfficeDirector__c != mapOwQy.get(s.Id) && mapOfficeDirector.get(s.OfficeDirector__c)== true )
					{
						Orders__Share order_Share = new Orders__Share();
						order_Share.UserOrGroupId = s.OfficeDirector__c;
						order_Share.ParentId = mapParId.get(s.Id);
						order_Share.AccessLevel = 'Read';
						listOrdShare.add(order_Share);
					}
				}
				Database.insert(listOrdShare,false);  
			}
		}
	}
	
	//共享客户上的所在部门的办事处主任
	public void accInsertSellArea(list<Account> listAccount)
	{
		System.debug('----------大爷来共享了 客户部门3--------------');
		//部门区域办事处主任Id
		set<Id> setODId = new set<Id>();
		//办事处主任Id 是否启用
		map<Id,Boolean> mapOfficeDirector = new map<Id,Boolean>();
		
		for(Account a : listAccount)
		{
			if(a.SellArea__c != null)
			{
				setODId.add(a.OfficeDirector__c);
			}
		}
		if(setODId.size() > 0)
		{
			System.debug('----------大爷来共享了 客户部门4--------------');
			mapOfficeDirector = getUser(setODId);
			
			List<AccountShare> listAccShare = new List<AccountShare>();
			for(Account a : listAccount)
			{
				if(a.OfficeDirector__c != null && a.OfficeDirector__c != a.OwnerId && mapOfficeDirector.get(a.OfficeDirector__c) ==true)
				{
					System.debug('----------大爷来共享了 客户部门5--------------');
					AccountShare account_Share = new AccountShare();
					account_Share.UserOrGroupId = a.OfficeDirector__c;
					account_Share.AccountId = a.id;
					account_Share.AccountAccessLevel = 'Read';
					account_Share.OpportunityAccessLevel  = 'Read';
					listAccShare.add(account_Share);
				}
			}
			 Database.insert(listAccShare,false);		
		}
		
		
	}
	
	//修改  共享给订单所在区域的 
	public void orderUpdateQyShare(list<Orders__c> list_newOrds,list<Orders__c> list_oldOrds,Map<id,Orders__c> map_old)
	{
		System.debug('--------大爷来共享了---------');
		//old 共享Id
		set<Id> setOshId = new set<Id>();
		//记录Id
		set<Id> setRcid = new set<Id>();
		//区域Id
		set<Id> setRgId = new set<Id>();
		list<Orders__c> listOrd = new list<Orders__c>();
		for(Orders__c o: list_newOrds)
		{
			if(o.dingdansuozaiquyu__c != map_old.get(o.id).dingdansuozaiquyu__c && o.dingdansuozaiquyu__c != null)
			{
				listOrd.add(o);
				setRcid.add(o.id);
			}
		}
		
		if(listOrd.size() > 0)
		{
			for(Orders__c o :list_oldOrds)
			{
				if(o.dingdansuozaiquyu__c != null)
				{
					setRgId.add(o.dingdansuozaiquyu__c);
				}
			}
		}
		list<SalesRegion__c> listSR = new list<SalesRegion__c> ();
		if(setRgId.size() > 0)
		{
			listSR = getOfficeDir(setRgId);
		}
		
		if(listSR != null && listSR.size() > 0)
		{
			for(SalesRegion__c s : listSR)
			{
				setOshId.add(s.OfficeDirector__c);
			}
		}
		if(setOshId.size() > 0 && setRcid.size() > 0 && listOrd.size() > 0)
		{
			
			List<Orders__Share> listOrdSh = [select Id,UserOrGroupId,ParentId,RowCause from Orders__Share where UserOrGroupId in: setOShId and ParentId in: setRcid and RowCause='Manual' ];
			delete listOrdSh;
			orderInsertQyShare(listOrd);
		}
	}
	
	//修改对应的OSRid
	public void orderUpdateOSRShare(list<Orders__c> list_newOrds,list<Orders__c> list_oldOrds,Map<id,Orders__c> map_old)
	{
		//old 共享Id
		set<Id> setOshId = new set<Id>();
		//记录Id
		set<Id> setRcid = new set<Id>();
		list<Orders__c> listOrd = new list<Orders__c>();
		for(Orders__c o : list_newOrds)
		{
			if(o.duiyingOSR__c != map_old.get(o.id).duiyingOSR__c && o.duiyingOSR__c != null)
			{
				listOrd.add(o);
				setRcid.add(o.id);
			}
		}		
		if(listOrd.size() > 0)
		{
			for(Orders__c o : list_oldOrds)
			{
				setOshId.add(o.duiyingOSR__c);
			}
		}
		if(setOshId.size() > 0 && setRcid.size() > 0 && listOrd.size() > 0)
		{
			List<Orders__Share> listOrdSh = [select Id,UserOrGroupId,ParentId,RowCause from Orders__Share where UserOrGroupId in: setOShId and ParentId in: setRcid and RowCause='Manual' ];
			delete listOrdSh;
			orderInsertOSRShare(listOrd);
		}
	}
	
	//修改客户部门共享
	public void accUpdateSellArea(list<Account> list_newAcc,list<Account> list_oldAcc,Map<id,Account> map_old)
	{
		//old 共享Id
		set<Id> setOshId = new set<Id>();
		//记录Id
		set<Id> setRcid = new set<Id>();
		System.debug('----------大爷来共享了 客户部门--------------');
		list<Account> listAcc = new list<Account>();
		for(Account a : list_newAcc)
		{
			if(a.OfficeDirector__c != map_old.get(a.id).OfficeDirector__c && a.OfficeDirector__c != null)
			{
				listAcc.add(a);
				setRcid.add(a.id);
			}
		}
		if(listAcc.size() > 0)
		{
			for(Account a: list_oldAcc)
			{
				setOshId.add(a.OfficeDirector__c);
				System.debug(a.OfficeDirector__c+'-------OldOfficeDirector__c--------');
			}
		}
		if(setOshId.size() > 0 && setRcid.size() > 0 && listAcc.size() > 0)
		{
			System.debug(setOshId+'-----------setOshId----------');
			System.debug(setRcid+'-----------setRcid----------');
			List<AccountShare> listAccShare = [select id,UserOrGroupId,RowCause,AccountId from AccountShare where UserOrGroupId in: setOShId and AccountId in: setRcid and  RowCause='Manual'];
			System.debug(listAccShare.size()+'-----------listAccShare----------');
			//删除之前的共享
			delete listAccShare;
			//插入新的共享
			System.debug('----------大爷来共享了 客户部门2--------------');
			accInsertSellArea(listAcc);
		}
		
	
	}
	
	//获取部门区域办事处主任的公共方法
	public list<SalesRegion__c> getOfficeDir(set<Id> setQyId)
	{
		//获取区域办事处主任
		list<SalesRegion__c> listSalesRegion = [select OfficeDirector__c,Id from SalesRegion__c where id in: setQyId];
		return listSalesRegion;
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