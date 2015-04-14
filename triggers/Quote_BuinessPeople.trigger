//如果“是否通知商务下订单”字段改变后,自动给商务人员发送电子邮件
//lurrykong
//2013.5.10
trigger Quote_BuinessPeople on Quote(after update) 
{
	set<id> setOppid=new set<id>();
	if(trigger.isAfter&&trigger.isUpdate)
	{
		set<id> setQuoteId=new set<id>();
		for(Quote quote:trigger.new)
		{
			Quote oldquote=trigger.oldMap.get(quote.id);												
			if(oldquote.Orders__c!=quote.Orders__c&&quote.Orders__c!=null)								//是否通知商务下订单字段前后发生变化
			{
				if(oldquote.Orders__c==false&&quote.Orders__c==true)
					setQuoteId.add(quote.id);
			}
		}
		if(setQuoteId.size()>0)
		{
			//查询所有报价   
			list<Quote> listQuote=[select id,Opportunity.SalesRegion__c,OpportunityId from Quote where id IN:setQuoteId];
			system.debug('............................listQuote...................................'+listQuote);
			set<id> setSaleregin=new set<id>();
			if(listQuote.size()>0&&listQuote!=null)
			{
				for(Quote quote:listQuote)
				{
					setSaleregin.add(quote.Opportunity.SalesRegion__c);
				}
			}system.debug('............................setSaleregin...................................'+setSaleregin);
			//员工							销售区域,员工名称
			list<Employee__c> listEmploy=[select id,n_EmployeeAear__c,n_EmployeeName__c from Employee__c where n_EmployeeAear__c IN:setSaleregin];
			system.debug('............................listEmploy...................................'+listEmploy);
			set<id> setUser=new set<id>();
			if(listEmploy.size()>0)
			{
				for(Employee__c emp:listEmploy)
				{
					if(emp.n_EmployeeName__c!=null)
						setUser.add(emp.n_EmployeeName__c);
				}
				if(setUser.size()>0)
				{
					set<id> setUserEmail=new set<id>();
					//用户
					list<User> listUser=[select id from User where id IN:setUser];				system.debug('....................listUser........................'+listUser); 
					//该用户的所有员工						id,员工名称,销售区域,销售区域Name
					list<Employee__c> listAllEmploy=[select id,n_EmployeeName__c,n_EmployeeAear__c,n_EmployeeAear__r.Name from Employee__c where n_EmployeeName__c IN:setUser];
					if(listAllEmploy.size()>0)
					{
						for(Employee__c emp:listAllEmploy)
						{
							if(emp.n_EmployeeAear__r.Name=='商务部')
								setUserEmail.add(emp.n_EmployeeName__c);
							system.debug('.....................emp.n_EmployeeAear__r.Name.......................'+emp.n_EmployeeAear__r.Name);
						}
						system.debug('.....................setUserEmail.......................'+setUserEmail); 
						if(setUserEmail.size()>0&&setUserEmail!=null&&setSaleregin.size()>0&&setSaleregin!=null&&setQuoteId.size()>0&&setQuoteId!=null)
							DataFormat.SendEmailBuiness(setUserEmail,setSaleregin,setQuoteId);
					}
				}
			} 		
		}
	}		
}