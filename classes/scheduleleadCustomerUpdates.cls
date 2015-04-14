/**
*Dis:该类为CustomerUpdates的引导类
*Author:Roger_Sun
*Time:2013年5月2日09:22:50
*/

global class scheduleleadCustomerUpdates  implements Schedulable
{ 
	  global void execute(SchedulableContext SC) 
	  {
	  	try
	  	{
	    	ID batchprocessid = Database.executeBatch(new CustomerUpdates(),50);
	  	}
	  	catch(Exception e)
	  	{
	  		ID batchprocessid = Database.executeBatch(new CustomerUpdates(),50);
	  	}
	  }
}