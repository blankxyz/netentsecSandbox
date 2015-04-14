//该类为clsPredictActualPrice的引导类
//lurrykong
//2013年4月7日12:03:51

global class scheduleOrderDetailAutoUpdate  implements Schedulable{ 
	  global void execute(SchedulableContext SC) {
	    ID batchprocessid = Database.executeBatch(new clsPredictActualPrice(),50);
	  }
}