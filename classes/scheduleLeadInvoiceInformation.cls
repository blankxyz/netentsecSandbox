/**
*Dis:该类为InvoiceInformation的引导类
*Author:Roger_Sun
*Time:2013年5月25日11:22:50
*/


global class scheduleLeadInvoiceInformation  implements Schedulable
{ 
      global void execute(SchedulableContext SC)
       {
        
         ID batchprocessid = Database.executeBatch(new InvoiceInformation(),50);
        
      }
}