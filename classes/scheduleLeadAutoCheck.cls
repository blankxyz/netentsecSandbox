/**
*Dis:该类为clsLeadAutoCheck的引导类
*Author:Gary_Hu
*Time:2013年4月7日12:16:03
*/

global class scheduleLeadAutoCheck  implements Schedulable{ 
	  global void execute(SchedulableContext SC) {
	    ID batchprocessid = Database.executeBatch(new clsLeadAutoCheck(-30),50);
	  }
}