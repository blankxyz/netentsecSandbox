//费用指标超标管理
//lurrykong
//2013.5.12
global class scheduleWhetherOverWeight implements Schedulable{ 
	global void execute(SchedulableContext SC) {	  
	    ID batchprocessidTwo = Database.executeBatch(new clsDetermineWhetherOverWeight(),50);
	  }
}