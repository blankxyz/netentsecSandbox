/*
*RogerSun
*2013-06-01
*cls_TestWSDLInvoiceInformation 
*WSDLInvoiceInformation的测试类
*/
@isTest(SeeAllData=true)
public with sharing class cls_TestWSDLInvoiceInformation 
{
	static testMethod void operDataWSDLInvoiceInformation() 
    {
    	WSDLInvoiceInformation.InvoiceInformationSoap s=new WSDLInvoiceInformation.InvoiceInformationSoap();
    	string a;
    	a='asc'+'+'+'sdjhk';
    	s.InvoiceInformationReturnValue(a);
    	WSDLInvoiceInformation.ArrayOfString c=new WSDLInvoiceInformation.ArrayOfString();
    	c=s.InvoiceInformationValue();
    	s.timeout_x=120000;
    	WSDLInvoiceInformation.ArrayOfString d=new WSDLInvoiceInformation.ArrayOfString();
    	list<string> e=new list<string>();
    	e.add(a);
    	d.string_x=e;
    	
    	WSDLInvoiceInformation.InvoiceInformationReturnValue_element v=new WSDLInvoiceInformation.InvoiceInformationReturnValue_element();
    	v.s='asdfz';
    	WSDLInvoiceInformation.InvoiceInformationReturnValueResponse_element q=new WSDLInvoiceInformation.InvoiceInformationReturnValueResponse_element();
    	WSDLInvoiceInformation.InvoiceInformationValue_element n=new WSDLInvoiceInformation.InvoiceInformationValue_element();
    	WSDLInvoiceInformation.InvoiceInformationValueResponse_element u=new WSDLInvoiceInformation.InvoiceInformationValueResponse_element();
    }
}