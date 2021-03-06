/**
 * 测试WSDLDeliveryTemporaryTransmission
 *RogerSun
 *982578975@qq.com
 */
@isTest(SeeAllData=true)
private class WSDLDeliveryTemporaryTransmission_test {

    static testMethod void myUnitTest() {
        Test.setMock(WebServiceMock.class, new WSDLDeliveryTemporaryTransmissionMockImp());
        
       callOperatonCrmAccount();
    }
    
    public static void callOperatonCrmAccount()
    {
    	 WSDLDeliveryTemporaryTransmission.DeliveryTemporaryTransmissionSoap sample = new WSDLDeliveryTemporaryTransmission.DeliveryTemporaryTransmissionSoap(); 
        sample.endpoint_x = 'http://124.207.141.116:8089/DeliveryTemporaryTransmission.asmx';
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
        sample.DeliveryTemporaryTransmissionIm(SForceUserName, SForcePassWord, SForceSecurityToken);
    }
}