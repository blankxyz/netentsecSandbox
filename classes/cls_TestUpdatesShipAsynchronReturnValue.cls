/**
*Test:UpdatesShipAsynchronReturnValue 
*Author:Roger_Sun
*Time:2013年6月1日10:12
**/
//@isTest(SeeAllData=true)
public with sharing class cls_TestUpdatesShipAsynchronReturnValue 
{
    static testMethod void operDataUpdatesShipAsynchronReturnValue() 
    {
        string a;
        a='asd'+'+'+'已更新';
       // UpdatesShipAsynchronReturnValue.AsynchronReturnValue(a);
       Id batchInstanceId = Database.executeBatch(new UpdatesShipAsynchronReturnValue(a), 50);
    }
}