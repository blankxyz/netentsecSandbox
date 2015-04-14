/**
*Dis:该类为clsOrderDetailsAutoForNowactual的引导类
*Author:Gary_Hu
*Time:2013年4月26日9:47:34
*/

global class scheduleOrderDetailsAutoForNowactual  implements Schedulable{ 
	  global void execute(SchedulableContext SC) {
	    ID batchprocessid = Database.executeBatch(new clsOrderDetailsAutoForNowactual(),50);
	  }
}