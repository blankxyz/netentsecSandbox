public  class Cls_WSDLInvoiceTransmission {
    
    @future (callout=true)
public static void WSDLInvoiceTransmissionIm()
    {
        WSDLInvoiceTransmission.InvoiceTransmissionSoap soap=new WSDLInvoiceTransmission.InvoiceTransmissionSoap();
        UserAccount__c ua=[Select u.UserPassWord__c, u.UserName__c, u.SecurityToken__c, u.Name From UserAccount__c u where u.Name ='netentsec'];
        system.debug('发票同步信息'+ua.UserName__c+','+ua.UserPassWord__c+','+ua.SecurityToken__c);
        string SecurityToken=null;
        if(ua.SecurityToken__c==null)
        {
            SecurityToken='';
        }
        else
        {
            SecurityToken=ua.SecurityToken__c;
        }
          system.debug('发票同步转化后信息:'+ua.UserName__c+','+ua.UserPassWord__c+','+SecurityToken);
          soap.timeout_x= 120000;
        soap.InvoiceTransmissionIm(ua.UserName__c, ua.UserPassWord__c, SecurityToken);
    }

}