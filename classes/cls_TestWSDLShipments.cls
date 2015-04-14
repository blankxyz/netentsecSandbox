/*
*RogerSun
*2013-05-31
*cls_TestWSDLShipments
*WSDLShipments的测试类
*/
@isTest(SeeAllData=true)
public with sharing class cls_TestWSDLShipments 
{
	static testMethod void operDataWSDLShipments() 
    {
    	WSDLShipments.ShipmentsSoap v=new WSDLShipments.ShipmentsSoap();
    	string a;
    	a='a'+'+'+'b'+'+'+'c';
    	v.OperShipmentsReturnValue(a);
    	WSDLShipments.ArrayOfString c=new WSDLShipments.ArrayOfString();
    	c=v.UpdateShipments();
    	WSDLShipments.ArrayOfString d=new WSDLShipments.ArrayOfString();
    	list<string> e=new list<string>();
    	e.add(a);
    	d.string_x=e;
    }
    
}