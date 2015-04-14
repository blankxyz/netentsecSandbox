/**
 * RogerSun
 * 2014-06-03
 *
 *
 */
@isTest(SeeAllData=true)
private class TrgTest_Synchronous {

    static testMethod void myUnitTest() {
    	
        list<RecordType> listRt = new list<RecordType>();
		listRt=[select Id,Name from RecordType where DeveloperName='YahuoOrders' or DeveloperName='ChannelPrototypeOrders' or DeveloperName='salesOrders'];
		
		SalesRegion__c salesregion=new SalesRegion__c();
		salesregion.Name='北京办事处1';
		insert salesregion;  
		
		SalesRegion__c salesregion1=new SalesRegion__c();
		salesregion1.Name='北京办事处2';
		insert salesregion1; 
		Account acc = new Account();
		acc.Name='客户test';
		acc.PrimaryIndustry__c='金融';
		acc.TwoIndustries__c='债券';
		acc.ThreeIndustries__c='银行';
		acc.SellArea__c=SalesRegion.id;
		acc.Province__c='北京';
		acc.Phone='053187401697';
        acc.Industry='Finance';
        acc.IdentificationCode_c__c ='A00001';
		insert acc;
		
		Account acc1 = new Account();
		acc1.Name='客户test0001';
		acc1.PrimaryIndustry__c='金融';
		acc1.TwoIndustries__c='债券';
		acc1.ThreeIndustries__c='银行';
		acc1.SellArea__c=SalesRegion.id;
		acc1.Province__c='北京';
		acc1.Phone='053187401697';
        acc1.Industry='Finance';
        acc1.IdentificationCode_c__c ='A00002';
		insert acc1;
		
		SalesTargets__c st = new SalesTargets__c();
		st.n_customerName__c = acc.id;
		st.Year__c = '2013';
		st.QuarterOFtasks1__c = 0;
		
		insert st;
		
		Orders__c o = new Orders__c();
		o.RecordTypeId=listRt.get(0).Id;
		o.Name='订单test';
		o.Partners__c = acc.id;
		o.isSale__c=true;
		o.OrderNum__c='O0001';
		insert o;
		
		Orders__c o1 = new Orders__c();
		o1.RecordTypeId=listRt.get(0).Id;
		o1.Name='订单test';
		o1.Partners__c = acc.id;
		o1.OrderNum__c='O0002';
		o1.isSale__c=true;
		insert o1;
		
		Pricebook2 p=new Pricebook2();
		p.Name='超市价格';
		p.IsActive=true;
		insert p;
		
		Product2 pp=new Product2();
		pp.Name='sdhsdh-0001';
		pp.IsActive=true;
		pp.ProductCode='p00001';
		insert pp;
		
		Product2 pp1=new Product2();
		pp1.Name='sdhsdh-00011';
		pp1.IsActive=true;
		pp1.ProductCode='p000011';
		insert pp1;
		
		test.startTest();
		
		Invoice__c inv = new Invoice__c();
		inv.Name='FP000001';
		inv.n_InvoiceDate__c=Date.newinstance(2013, 5, 16);
		inv.Customer__c='A00001';
		insert inv;
		
		Invoice__c inv1 = new Invoice__c();
		inv1.Name='FP000002';
		inv1.n_InvoiceDate__c = Date.today(); //Date.newinstance(2013, 5, 16);
		inv1.Customer__c='A00001';
		insert inv1;
		
		InvoiceDetails__c ind=new InvoiceDetails__c();
		ind.ProductName__c='p00001';
		ind.OrderData__c='O0001';
		ind.InvoiceData__c='FP000001';
		ind.InvisSale__c=true;
		try{
			insert ind;
			
		}catch(Exception ex){
		}
		o.isSale__c=false;
		update o;
		ind.ProductName__c='p000011';
		ind.OrderData__c='O0002';
		ind.InvoiceData__c='FP000002';
		
		try{
			update ind;
			
		}catch(Exception ex){
		}
		try{
			inv.Customer__c='A00002';
			update inv;
			
		}catch(Exception ex){
		}
		
		Shipments__c ShipmentsData=new Shipments__c();
		ShipmentsData.Account__c='A00001';
		ShipmentsData.Order__c=o.OrderNum__c;
		ShipmentsData.n_Theme__c='上海虹桥';
		ShipmentsData.CourierNumber__c='Q000001';
		ShipmentsData.CourierCompany__c='顺丰';
		ShipmentsData.n_Description__c='信息数据';
		ShipmentsData.n_SendOrderNo__c='s000001';
		insert ShipmentsData;
		
		Shipments__c ShipmentsData1=new Shipments__c();
		ShipmentsData1.Account__c='A00002';
		ShipmentsData1.Order__c=o.OrderNum__c;
		ShipmentsData1.n_Theme__c='上海虹桥';
		ShipmentsData1.CourierNumber__c='Q000002';
		ShipmentsData1.CourierCompany__c='顺丰';
		ShipmentsData1.n_Description__c='信息数据';
		ShipmentsData1.n_SendOrderNo__c='s000002';
		insert ShipmentsData1;
		
		try
		{
			ShipmentsData.Account__c='A00002';
		    ShipmentsData.Order__c=o1.OrderNum__c;
		    update ShipmentsData;
		}catch(Exception ex){
		}
		
		ShippingDetails__c ss=new ShippingDetails__c();
		ss.Products__c='p00001';
		ss.Delivery__c='s000001';
		ss.n_Remark__c='xinxi';
		ss.ShipDetails__c='s000001';
		ss.ordersSum__c=1000;
		ss.CourierNumber__c='Q000001';
		ss.CourierCompany__c='顺丰';
		ss.Order__c=o.OrderNum__c;
		insert ss;
		
		ss.Products__c='p000011';
		ss.Delivery__c='s000002';
		ss.ShipDetails__c='s000002';
		update ss;
		
		ShippingDetails__c ss1=new ShippingDetails__c();
		ss1.Products__c='p000011';
		ss1.Delivery__c='s000002';
		ss1.n_Remark__c='xinxi';
		ss1.ShipDetails__c='s000002';
		ss1.ordersSum__c=1000;
		ss1.CourierNumber__c='Q000001';
		ss1.CourierCompany__c='顺丰';
		ss1.Order__c=o.OrderNum__c;
		insert ss1;
		
		
		ProductSN__c ps=new ProductSN__c();
		ps.Name='ps000001';
		ps.Order__c=o.OrderNum__c;
		ps.ShippingDetails__c='s000001';
		ps.Account__c='A00001';
		ps.SerialNumberId__c='123';
		ps.n_Remark__c='wertfd';
		insert ps;
		
		ps.Order__c=o1.OrderNum__c;
		ps.ShippingDetails__c='s000002';
		ps.Account__c='A00002';
		update ps;
		
		
		ProductSN__c ps1=new ProductSN__c();
		ps1.Name='ps000002';
		ps1.Order__c=o1.OrderNum__c;
		ps1.ShippingDetails__c='s000002';
		ps1.Account__c='A00002';
		ps1.SerialNumberId__c='1232';
		insert ps1;
		
		ProductSNDetial__c ProductSNDetial=new ProductSNDetial__c();
		ProductSNDetial.ProductName__c='p00001';
		ProductSNDetial.OrdersName__c='O0001';
		ProductSNDetial.ProductSNname__c='ps000002';
		ProductSNDetial.Remark__c='dsfjkhsf';
		ProductSNDetial.Reason__c='xinxij';
		insert ProductSNDetial;
		
		SendProSN__c sp=new SendProSN__c();
		sp.Department__c='北京办事处1';
		sp.Order__c=o.OrderNum__c;
		sp.ShippingDetails__c='s000001';
		sp.Account__c='A00001';
		sp.SerialNumber__c='ps000001';
		insert sp;
		
		sp.Department__c='北京办事处2';
		sp.Order__c=o1.OrderNum__c;
		sp.ShippingDetails__c='s000002';
		sp.Account__c='A00002';
		sp.SerialNumber__c='ps000002';
		update sp;
		test.stopTest();
		
        TmpInvoice__c TmpInvoice=new TmpInvoice__c();
        TmpInvoice.KL__c=12;
        TmpInvoice.cInvName__c='sdhsdh-00011';
        TmpInvoice.cInvCode__c='p00001';
        TmpInvoice.cSOCode__c='O0001';
        TmpInvoice.dDate__c=Date.today();
        TmpInvoice.cMemo__c='备注信息';
        TmpInvoice.cMemo1__c='信息备份';
        TmpInvoice.cSBVCode__c='S00001';
        TmpInvoice.cVouchName__c='专用发票';
        TmpInvoice.autoid__c='A00001';
        TmpInvoice.SumMoney__c=10000;
        TmpInvoice.iTaxUnitPrice__c=12;
        TmpInvoice.iSum__c=122222;
        TmpInvoice.cCusName__c='上海怡海';
        TmpInvoice.cCusCode__c='A00001';
        TmpInvoice.iQuantity__c=32;
        
        
        try
		{
			insert TmpInvoice;
		}catch(Exception ex){
		}
        
        DeliveryTemporary__c d=new DeliveryTemporary__c();
            d.cDefine10__c = '信息';
            d.cDefine12__c = '信息';
            d.cDefine13__c = '信息';
            d.cDefine2__c = '信息';
            d.cDefine22__c = '信息';
            d.cDefine23__c = '信息';
            d.cDefine24__c = '信息';
            d.cDefine25__c = '信息';
            d.cDefine28__c = '信息';
            d.cDefine29__c = '信息';
            d.cDefine3__c = '信息';
            d.cDefine30__c = '信息';
            d.cDefine31__c = '信息';
            d.cDefine32__c = '信息';
            d.cDefine33__c = '信息';
            d.cDefine8__c = '信息';
            d.cDefine9__c = '信息';
            d.cSOCode__c = 'O0001';
          
            d.iQuantity__c = 1112;
            d.cMemo__c = '备注';
            d.cDepName__c = '北京办事处1';
            d.Test__c = 'aksjhas,sdqdef,w345,kewh987';
            d.cInvCode__c = 'p00001';
            d.dDate__c = Date.today();
            d.iorderdid__c = 'dsf0001';
            d.cBusCode__c = 'sd234';
            d.cShipAddress__c = '货物地址';
            d.cDLCode__c = '2345';
            d.cCusCode__c = 'A00001';
            d.cHandler__c = '张飞';
            d.iFNum__c = 11;
         
            d.iFQuantity__c = 12;
            
            d.cCode__c = 'as0001';
            d.AutoID__c = '12345';
            d.cPersonCode__c = null;
            d.iNQuantity__c =1234;
           try
		{
			insert d;
		}catch(Exception ex){
		}
        
            
		
    }
}