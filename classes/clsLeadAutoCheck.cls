/**
*Dis:判断潜在客户是否有操作，在一个月内没有操作自动将潜在客户Owner转移至Inside 负责人下
*Author：Gary_Hu
*Time:2013年4月1日11:42:01
**/
global class  clsLeadAutoCheck implements Database.Batchable<SObject>, Database.Stateful{
		private Integer k;
		public clsLeadAutoCheck(Integer i){
			k = i;
		}
		
		
		DateTime nowToday = Date.today();	//当前时间
		global Database.queryLocator start(Database.BatchableContext ctx){
	       return Database.getQueryLocator([Select l.OwnerId,Name,l.LastModifiedDate, (Select LastModifiedDate From Tasks order by LastModifiedDate desc limit 1), (Select LastModifiedDate From Events order by LastModifiedDate desc limit 1) From Lead l where l.IsConverted = false]); 
	    }
	   global void execute(Database.BatchableContext ctx, List<Sobject>  scope)
	      {

				set<Id> urId = new set<Id>();	//角色用户Id
			   list<User> user = [Select u.UserRole.Name,Id, u.UserRoleId From User u where u.UserRole.Name = 'Inside业务经理' and Name = '王 亚星' and Alias ='王亚星' and IsActive = true]; //查看用户信息

			 
			   List<Lead> leadList = new List<Lead>();
		      System.debug(scope.size()+'+++++++++++++++scope.size()+++++++++++++++++++++++++++++');
		       for(Sobject sc:scope)
		       	{
		       		DateTime dtToday = Date.today();	//当前时间
					DateTime lastAcDate = null; //最后修改时间
					DateTime acDate = null;     //task到期日期
					DateTime ecDate = null;		//event到期时间
		       		Lead lead = (Lead)sc;
			        lastAcDate = lead.LastModifiedDate;
		       		System.debug(dtToday+'----------------dtToday----------------------------------');
		       		System.debug(lead.Tasks.size()+'****************lead.Tasks.size()*******************');
		       		System.debug(lead.Events.size()+'****************lead.Events.size()*******************');
		       		if(lead.Tasks.size() != 0){
			       		acDate = lead.Tasks.get(0).LastModifiedDate;
		       		}
					if(lead.Events.size() != 0){
			       		ecDate = lead.Events.get(0).LastModifiedDate;
					}
					System.debug(lead.Name+'lead.Name++++++++++++'+acDate+'++'+ecDate+'++'+lastAcDate);
					System.debug(lastAcDate+'++++++++++lastAcDate+++++++++');
					System.debug(acDate+'++++++++++acDate+++++++++');
					System.debug(ecDate+'++++++++++ecDates+++++++++');
					if(acDate != null && ecDate == null){
			       		if(lastAcDate < dtToday.addDays(k) && acDate < dtToday.addDays(k)){
			       			System.debug('我执行了 ：lastAcDate.addDays(1) > dtToday && acDate.addDays(1) > dtToday && ecDate.addDays(1) > dtToday');
	       				    for(User u: user){
				       			lead.OwnerId = u.Id;
				       			leadList.add(lead);
				    		}
			       		}
			       		System.debug('acDate != null');
					
					}else if(ecDate != null && acDate == null){
			       		if(lastAcDate < dtToday.addDays(k) && ecDate < dtToday.addDays(k)){
			       			System.debug('我执行了 ：lastAcDate.addDays(1) > dtToday && acDate.addDays(1) > dtToday && ecDate.addDays(1) > dtToday');
	       				    for(User u: user){
				       			lead.OwnerId = u.Id;
				       			leadList.add(lead);
				    		}
			       		}	
						System.debug('ecDate != null');					
					}else if (acDate != null && ecDate != null){
						if(acDate < dtToday.addDays(k) && lastAcDate < dtToday.addDays(k) && ecDate < dtToday.addDays(k)){
							System.debug('我执行了 :lastAcDate != null && acDate != null && ecDate == null');
								for(User u: user){
					       			lead.OwnerId = u.Id;
					       			leadList.add(lead);
				    			}
						}
					      System.debug('acDate != null && ecDate != null');			
					}else if(acDate == null && ecDate == null){
						if(lastAcDate < dtToday.addDays(k)){
							System.debug('我执行了 :lastAcDate != null && acDate == null && lastAcDate == null');
							for(User u: user){
				       			lead.OwnerId = u.Id;
				       			leadList.add(lead);
			    			}
							
							System.debug(lead.Name+'lead.Name++++++++++++XXXXXXX');
						}
						System.debug('acDate == null && ecDate == null');
					}
		       	} 
		       	update leadList;
	       }
       global void finish(Database.BatchableContext ctx){

       }
}