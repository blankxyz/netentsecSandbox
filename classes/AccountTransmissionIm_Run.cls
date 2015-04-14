public  class AccountTransmissionIm_Run {
@future (callout=true)
public static void OrderDetailTransmissionIm()
    {
        WSDLAccountTransmission.AccountTransmissionSoap soap=new WSDLAccountTransmission.AccountTransmissionSoap();
        UserAccount__c ua=[Select u.UserPassWord__c, u.UserName__c, u.SecurityToken__c, u.Name From UserAccount__c u where u.Name ='netentsec'];
        system.debug('信息'+ua.UserName__c+','+ua.UserPassWord__c+','+ua.SecurityToken__c);
        string SecurityToken=null;
        if(ua.SecurityToken__c==null)
        {
            SecurityToken='';
        }
        else
        {
            SecurityToken=ua.SecurityToken__c;
        }
          system.debug('转化后信息:'+ua.UserName__c+','+ua.UserPassWord__c+','+SecurityToken);
          soap.timeout_x= 120000;
        soap.AccountTransmissionIm(ua.UserName__c, ua.UserPassWord__c, SecurityToken);
        
    }
}