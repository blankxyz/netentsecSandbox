/**
*Dis:该类为clsOppAutoUpdate的引导类
*Author:Gary_Hu
*Time：2013年4月7日12:03:51
**/
global class scheduleOppAutoUpdate  implements Schedulable{ 
	  global void execute(SchedulableContext SC) {
	    ID batchprocessid = Database.executeBatch(new clsOppAutoUpdate(),50);
	  }
}