/**
*Dis:新样机转旧样机提醒,给管理员发邮件
*Author:vito_He
*Time:2013年4月23日 10:20:05
**/
global class scheduleOrderDatailsAutoInfo implements Schedulable{ 
	  global void execute(SchedulableContext SC) {
	    ID batchprocessid = Database.executeBatch(new clsOrderDatailsAutoInfo(),50);
	  }
}