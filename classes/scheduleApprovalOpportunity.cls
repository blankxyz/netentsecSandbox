/**
*Dis:该类为ApprovalOpportunity的引导类
*Author:Roger_Sun
*Time:2014年3月14日14:56
*Email:982578975@qq.com
*/

global class scheduleApprovalOpportunity  implements Schedulable
{ 
	  global void execute(SchedulableContext SC) 
	  {
	  	ID batchprocessid = Database.executeBatch(new ApprovalOpportunity(),50);
	  }
}