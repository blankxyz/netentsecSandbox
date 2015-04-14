/**
*DIS:报价单上提醒销售副主任
*Author:Gary Hu
*Time:2014年5月22日15:56:25
********************华丽的分割线*******************
DIS:报价单上自动带入客户上联系人信息
Author:Gary Hu
Time:2014年6月19日16:33:10
**/
trigger Quote_AutoTask on Quote (after update,before update,before insert) {
	if(Trigger.isAfter)
	{
		if(Trigger.isUpdate)
		{
			set<Id> OidSet = new set<Id>();
			for(Quote q:trigger.new)
			{
				OidSet.add(q.QuoteOwner__c);
			}
			if(OidSet != null)
			{
				//键为所选区域，值为区域(区域办事处主任,区域销售助理,是否弹出业务机会报备事件提醒)
		   		list<Employee__c> listEmpDeputy = new list<Employee__c>([Select n_EmployeeName__c,n_salesDeputy__c,n_salesDeputy__r.EventToRemind__c,n_salesDeputy__r.SpecialRemind__c,n_salesDeputy__r.Email from Employee__c where  n_EmployeeName__c in: OidSet]);
				System.debug(OidSet+'----------OidSet-------------');
		   		System.debug(listEmpDeputy+'---------------listEmpDeputy--------------');
		   		//键为 员工名称、值为员工对象
		   		map<Id,Employee__c> mapEmpsalesDeputy = new map<Id,Employee__c>();
		   		if(listEmpDeputy.size() > 0){
		   			for(Employee__c listEmpDeputyX : listEmpDeputy){
		   			 	System.debug(listEmpDeputyX.n_salesDeputy__c+'---------------listEmpDeputyX.n_salesDeputy__c--------------');
		   			 	if(!mapEmpsalesDeputy.containsKey(listEmpDeputyX.n_salesDeputy__c)){
		   			 			mapEmpsalesDeputy.put(listEmpDeputyX.n_EmployeeName__c,listEmpDeputyX);
		   			 		}
		   			 	}
		   			 }
		   		System.debug('-----------mapEmpsalesDeputy---------------'+mapEmpsalesDeputy);
				List<Task> taskList = new List<Task>();
				set<Id> set_qId = new set<Id>(); //报价Id
				if(mapEmpsalesDeputy.size() > 0){
					for(Quote q:trigger.new){
						if(trigger.oldMap.get(q.id).Status != q.Status){
							if(mapEmpsalesDeputy.containsKey(q.QuoteOwner__c)){
								if(mapEmpsalesDeputy.get(q.QuoteOwner__c).n_salesDeputy__c != null){
									System.debug(q.Status+'xxxxxxxxxxxxx'+mapEmpsalesDeputy.get(q.QuoteOwner__c).n_salesDeputy__r.SpecialRemind__c +'xxxx'+mapEmpsalesDeputy.get(q.QuoteOwner__c).n_salesDeputy__c);
									if(q.Status == '审批中' && mapEmpsalesDeputy.get(q.QuoteOwner__c).n_salesDeputy__r.SpecialRemind__c == true){
										Task task = new Task();
					   			 		task.OwnerId=  mapEmpsalesDeputy.get(q.QuoteOwner__c).n_salesDeputy__c;//被分配人
					   			 		task.WhatId = q.Id;
					   			 		task.Subject = q.Name+'报价单特价审批提醒';//主题
					   			 		task.Description = '报价单特价审批提醒';
					   			 		task.Status = '未开始';// 状态
										task.Priority = '普通';// 优先级别
										task.IsReminderSet = true; //是否提醒（提醒）
										task.ReminderDateTime = DateTime.now().addMinutes(1);	
										taskList.add(task);	
										if(Trigger.oldMap.get(q.id).DealingMan__c != mapEmpsalesDeputy.get(q.QuoteOwner__c).n_salesDeputy__c)
										{
											set_qId.add(q.id);
										}
									}
								}
							}
						}
					}
					 //添加任务
			   		 insert(taskList);
				}
				if(set_qId.size() > 0)
				{
					list<Quote> listQuote = [select QuoteOwner__c,DealingMan__c,DealingManEmail__c from Quote where Id in: set_qId];
					if(listQuote.size() > 0)
					{
						for(Quote q : listQuote)
						{
							q.DealingMan__c = mapEmpsalesDeputy.get(q.QuoteOwner__c).n_salesDeputy__c;
							q.DealingManEmail__c = mapEmpsalesDeputy.get(q.QuoteOwner__c).n_salesDeputy__r.Email;
						}
					}
					update listQuote;
				}
			}
		}
	}
	if(Trigger.isBefore)
	{
		//修改
		if(Trigger.isUpdate)
		{
			Set<Id> set_accId = new Set<Id>();
			for(Quote q : Trigger.new)
			{
				if(Trigger.oldMap.get(q.Id).ZipCode__c != null || Trigger.oldMap.get(q.Id).ContactId != null || Trigger.oldMap.get(q.Id).Phone != null || Trigger.oldMap.get(q.Id).InvoiceAddress__c != null )
				{
					set_accId.add(q.AccountId__c);
				}
			}
			if(set_accId.size() > 0)
			{
				list<Account> list_Acc = [select ZipCode__c,LinkName__c,LinkPhone__c,InvoiceAddress__c from Account where Id in: set_accId];
				if(list_Acc.size() > 0)
				{
					for(Account list_AccX : list_Acc)
					{
						for(Quote q : Trigger.new)
						{
							if(list_AccX.ZipCode__c != null)
							{
								q.ZipCode__c = list_AccX.ZipCode__c;
							}
							if(list_AccX.LinkName__c != null)
							{
								q.ContactId = list_AccX.LinkName__c;
							}
							if(list_AccX.LinkPhone__c != null)
							{
								q.Phone  = list_AccX.LinkPhone__c;
							}
							if(list_AccX.InvoiceAddress__c != null)
							{
								q.InvoiceAddress__c = list_AccX.InvoiceAddress__c;
							}
						}
					}
				}
			}
		}
		//插入
		if(Trigger.isInsert)
		{
			System.debug('xxxxxxxxxxxxxxxxxxxxxx');
			Set<Id> set_accId = new Set<Id>();
			for(Quote q : Trigger.new)
			{
				set_accId.add(q.AccountId__c);
			}
			list<Account> list_Acc = [select ZipCode__c,LinkName__c,LinkPhone__c,InvoiceAddress__c from Account where Id in: set_accId];
			if(list_Acc.size() > 0)
			{
				for(Account list_AccX : list_Acc)
				{
					for(Quote q : Trigger.new)
					{
						if(list_AccX.ZipCode__c != null)
						{
							q.ZipCode__c = list_AccX.ZipCode__c;
						}
						if(list_AccX.LinkName__c != null)
						{
							q.ContactId = list_AccX.LinkName__c;
						}
						if(list_AccX.LinkPhone__c != null)
						{
							q.Phone  = list_AccX.LinkPhone__c;
						}
						if(list_AccX.InvoiceAddress__c != null)
						{
							q.InvoiceAddress__c = list_AccX.InvoiceAddress__c;
						}
					}
				}
			}
		}
	}
	




	
	
	
	
}