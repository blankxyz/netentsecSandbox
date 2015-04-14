/**
*Dis:服务商机如果在预定的结束日期能没有关单，系统在预定日期结束后的一个月自动将商机Owner更改至Inside sales负责人。
*Author:Gary_Hu
*Time:2013年4月7日12:08:08
**/
global class  clsOppAutoUpdate implements Database.Batchable<SObject>, Database.Stateful{
	 DateTime nowToday = Date.today();	//当前时间
	 global Database.queryLocator start(Database.BatchableContext ctx){
	       return Database.getQueryLocator([Select  CloseDate,OwnerId From Opportunity where StageName <>'关单' and RecordType.Name = '服务商机']); 
	 }
	 global void execute(Database.BatchableContext ctx, List<Sobject>  scope){

		list<User> user = [Select u.UserRole.Name,Id, u.UserRoleId From User u where u.UserRole.Name = 'Inside业务经理' and Name = '王 亚星' and Alias ='王亚星' and IsActive = true]; //查看用户信息
	    List<Opportunity> oppList = new List<Opportunity>();
	    for(Sobject sc : scope){
	    	DateTime dtToday = Date.today();	//当前时间
	 		DateTime closeDate = null; //最后修改时间
	    	Opportunity oppr = (Opportunity)sc;
	    	closeDate = oppr.CloseDate;
	    if(closeDate != null && user.size() > 0){
	    	if(closeDate.addDays(30) > dtToday){	
	       			oppr.OwnerId = user[0].Id;
	       			oppList.add(oppr);
		    }
	    }
	 }
	 update oppList;
 }
   global void finish(Database.BatchableContext ctx){
	       	
    }
}