/**
*Test:InvoiceInformationReturnValue 
*Author:Roger_Sun
*Time:2013年6月1日12:20
**/
//@isTest(SeeAllData=true)
public with sharing class cls_TestInvoiceInformationReturnValue 
{
    static testMethod void operDataUpdatesShipAsynchronReturnValue() 
    {
        string a;
        a='qwe'+'+'+'szfcsdf';
         Id batchInstanceId = Database.executeBatch(new InvoiceInformationReturnValue(a), 50);
    }
}