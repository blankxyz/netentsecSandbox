/*
*RogerSun
*2013-05-31
*cls_TestWSDLOrderSynchronization
*WSDLOrderSynchronization的测试类
*/
@isTest(SeeAllData=true)
private with sharing class cls_TestWSDLOrderSynchronization
{
	 static testMethod void SynchronizationTest() 
    {
    	WSDLOrderSynchronization.OrderSynchronizationArray a=new WSDLOrderSynchronization.OrderSynchronizationArray();
    	list<WSDLOrderSynchronization.OrderSynchronizationArray> b=new list<WSDLOrderSynchronization.OrderSynchronizationArray>();
    	a.AcountName='测试';
    	a.BusinessOwners_xc='RogerSun';
    	a.CreatedDate=date.valueOf('2013-05-31 15:39');
    	a.ID='id';
    	a.n_AccounSerNo_xc='sadwe';
    	a.n_CustomModels_xc='asxc';
    	a.n_DiscountByord_xc=123;
    	a.n_Price_xc=12;
    	a.n_PriceByord_xc=12;
    	a.n_ProCount_xc=1;
    	a.n_ProductByOrd_xc='weds';
    	a.n_Remark_xc='sdfc';
    	a.n_Sum_xc=1234;
    	a.Name='sdfsdf';
    	a.order_Industry_xc='sadfsf';
    	a.OrderNum_xc='34';
    	a.ordersClassify_xc='sdf';
    	a.Payer_xc='sd';
    	a.Platform_xc='网康科技';
    	a.Remark_xc='备注';
    	a.SalesRegion_xc='sd';
    	a.versionNumber_xc='12.0.0';
    	b.add(a);
    	WSDLOrderSynchronization.OrderSynchronizationSoap tt=new WSDLOrderSynchronization.OrderSynchronizationSoap();
    	WSDLOrderSynchronization.ArrayOfOrderSynchronizationArray aa=new WSDLOrderSynchronization.ArrayOfOrderSynchronizationArray();
			 aa.OrderSynchronizationArray=(WSDLOrderSynchronization.OrderSynchronizationArray[])b;
			  WSDLOrderSynchronization.ArrayOfString f=new WSDLOrderSynchronization.ArrayOfString();
		     f=tt.OrderSynchronizationByValue(aa);
		     tt.timeout_x=120000;
    	
    }	
}