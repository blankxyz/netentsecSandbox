/**
*Dis:该类为UpdatesShipments的引导类
*Author:Roger_Sun
*Time:2013年5月2日09:22:50
*/

global class scheduleleadUpdatesShipments  implements Schedulable{ 
	  global void execute(SchedulableContext SC) {
	     ID batchprocessid = Database.executeBatch(new UpdatesShipments(),50);
	  }
}