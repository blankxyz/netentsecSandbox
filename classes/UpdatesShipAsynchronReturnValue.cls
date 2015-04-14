/*
*RogerSun
*2013-05-23
*异步获取发货单返回给U8
*/
/*
public class UpdatesShipAsynchronReturnValue
{
  @Future(callout=true)
  public static void AsynchronReturnValue(String a)
   {
        WSDLShipments.ShipmentsSoap bReturn=new WSDLShipments.ShipmentsSoap();
        bReturn.timeout_x=120000;
        bReturn.OperShipmentsReturnValue(a);//返回是否同步状态
   }
}
*/
global class  UpdatesShipAsynchronReturnValue implements Database.Batchable<SObject>, Database.AllowsCallouts
{
    global final String Query;
    global UpdatesShipAsynchronReturnValue(String q)
    {
        system.debug('获取q的值：'+q);
        Query=q;
        system.debug('获取q的值赋值给Query：'+Query);
    }
     global Database.queryLocator start(Database.BatchableContext ctx)
     {
           return Database.getQueryLocator([Select id from Shipments__c limit 100]); 
     }
     global void execute(Database.BatchableContext ctx, List<Shipments__c> scope)
     {
        system.debug('开始执行返回值');
        system.debug('开始执行返回值Query：'+Query);
        WSDLShipments.ShipmentsSoap bReturn=new WSDLShipments.ShipmentsSoap();
        bReturn.timeout_x=120000;
        bReturn.OperShipmentsReturnValue(Query);//返回是否同步状态
     }
     global void finish(Database.BatchableContext ctx)
   {
    
   }
    
}