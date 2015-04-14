/**
*Dis:该类为CustomerUpdates的引导类
*Author:Roger_Sun
*Time:2013年6月8日09:22:50
*/
global class scheduletotalBootstrapClass  implements Schedulable
{
    global void execute(SchedulableContext SC)
    {
            ID batchprocessid = Database.executeBatch(new CustomerUpdates(),50);
    }
    
}