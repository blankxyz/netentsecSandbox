/**
 *WSDLAccountTransmission测试类
 */
@isTest(SeeAllData=true)
private class WSDLAccountTransmission_test {

    static testMethod void myUnitTest() {
    	Test.setMock(WebServiceMock.class, new WSDLAccountTransmissionMockImpl());
       callOperatonCrmAccount();
    }
    public static void callOperatonCrmAccount()
    {
    	 WSDLAccountTransmission.AccountTransmissionSoap sample = new WSDLAccountTransmission.AccountTransmissionSoap(); 
        sample.endpoint_x = 'http://124.207.141.116:8089/AccountTransmission.asmx';
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
        sample.AccountTransmissionIm(SForceUserName, SForcePassWord, SForceSecurityToken);
    }
}