/**
*Dis:该类为ApprovalOpportunity的引导类
*Author:Roger_Sun
*Time:2014年6月5日09:22:50
*/
global class scheduleleadApprovalOpportunity  implements Schedulable
{ 
	  global void execute(SchedulableContext SC) 
	  {
	  	ID batchprocessid = Database.executeBatch(new ApprovalOpportunity(),50);
	  	
	  }
}