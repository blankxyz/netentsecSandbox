/**
 * WSDLOrderTransmission测试类
 */
@isTest(SeeAllData=true)
private class WSDLOrderTransmission_test {
 
    static testMethod void myUnitTest() {
        Test.setMock(WebServiceMock.class, new WSDLOrderTransmissionMockImpl());
        
       callOperatonCrmAccount();
    }
    
     public static void callOperatonCrmAccount()
    {
    	 WSDLOrderTransmission.OrderTransmissionSoap sample = new WSDLOrderTransmission.OrderTransmissionSoap(); 
        sample.endpoint_x = 'http://124.207.141.116:8089/OrderTransmission.asmx';
        UserAccount__c ua=[Select u.UserPassWord__c, u.UserName__c, u.SecurityToken__c, u.Name From UserAccount__c u where u.Name ='netentsec'];
        
        string SForceUserName=ua.UserName__c;
        string SForcePassWord=ua.UserPassWord__c;
        string SForceSecurityToken=null;
        if(ua.SecurityToken__c==null)
        {
        	SForceSecurityToken='';
        }
        else
        {
        	SForceSecurityToken=ua.SecurityToken__c;
        }
        sample.OrderTransmissionIm(SForceUserName, SForcePassWord, SForceSecurityToken,'ORD209906180001');
    }
}