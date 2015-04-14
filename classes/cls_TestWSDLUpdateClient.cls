/*
*RogerSun
*2013-05-23
*cls_TestWSDLUpdateClient
*WSDLUpdateClient的测试类
*/
@isTest(SeeAllData=true)
private class cls_TestWSDLUpdateClient
{
	 static testMethod void ClientTest() 
    {
		WSDLUpdateClient.UpdateClientSoap a=new WSDLUpdateClient.UpdateClientSoap();
		list<WSDLUpdateClient.CustomArray> b=new list<WSDLUpdateClient.CustomArray>();
		WSDLUpdateClient.CustomArray c=new WSDLUpdateClient.CustomArray();
		c.Corporate='测试';
		c.CreatedDate=date.valueOf('2013-05-23 12:11');
		c.Id='id90876';
		c.Name='rogerSun';
		c.PrimaryIndustry='sad';
		c.Province='北京';
		c.RecordTypeName='记录';
		c.TaxId='asd';
        b.add(c);
		WSDLUpdateClient.ArrayOfCustomArray d=new WSDLUpdateClient.ArrayOfCustomArray();
		d.CustomArray=b;
		 WSDLUpdateClient.ArrayOfString f=new WSDLUpdateClient.ArrayOfString();
		f=a.CustomersByValue(d);
		 string[] ss = f.string_x;
		
    }
	
	
}