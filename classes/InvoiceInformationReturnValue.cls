/*
*RogerSun
*2013-05-23
*异步获取发货单返回给U8

global class InvoiceInformationReturnValue
{
  @future(callout=true)
  public static void InvoiceInformationsValue(String a)
   {
        WSDLInvoiceInformation.InvoiceInformationSoap bReturn=new WSDLInvoiceInformation.InvoiceInformationSoap();
        bReturn.timeout_x=120000;
        bReturn.InvoiceInformationReturnValue(a);//返回是否同步状态
   }
}
*/
global class  InvoiceInformationReturnValue implements Database.Batchable<SObject>, Database.AllowsCallouts,Database.Stateful
{
    global final String Query;
    global InvoiceInformationReturnValue(String q)
    {
        system.debug('获取q的值：'+q);
        Query=q;
        system.debug('获取q的值赋值给Query：'+Query);
    }
     global Database.queryLocator start(Database.BatchableContext ctx)
     {
           return Database.getQueryLocator([Select id from Invoice__c limit 100]); 
     }
     global void execute(Database.BatchableContext ctx, List<Invoice__c> scope)
     {
        system.debug('开始执行返回值');
        system.debug('开始执行返回值Query：'+Query);
        
        WSDLInvoiceInformation.InvoiceInformationSoap bReturn=new WSDLInvoiceInformation.InvoiceInformationSoap();
        bReturn.timeout_x=120000;
        bReturn.InvoiceInformationReturnValue(Query);//返回是否同步状态
     }
     global void finish(Database.BatchableContext ctx)
   {
    
   }
}