/*
*功能：测试触发器Orders_ReturnPay
*作者：Alisa
*时间：2013年5月16日
*/

@isTest(SeeAlldata=true)
public class trgTest_Orders_ReturnPay {
	static testMethod void myUnitTest(){
		list<RecordType> listRt = new list<RecordType>();
		listRt=[select Id,Name from RecordType where DeveloperName='YahuoOrders' or DeveloperName='ChannelPrototypeOrders' or DeveloperName='salesOrders'];
		
		SalesRegion__c salesregion=new SalesRegion__c();
		salesregion.Name='china';
		insert salesregion;  
		
		Account acc = new Account();
		acc.Name='客户test';
		acc.PrimaryIndustry__c='金融';
		acc.TwoIndustries__c='债券';
		acc.ThreeIndustries__c='银行';
		acc.SellArea__c=SalesRegion.id;
		acc.Province__c='北京';
		acc.Phone='053187401697';
        acc.Industry='Finance';
		insert acc;
		
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
		insert o;
		
		Invoice__c inv = new Invoice__c();
		inv.Name=' 发票编号';
		inv.n_InvoiceDate__c=Date.newinstance(2013, 5, 16);
		insert inv;
		
		InvoiceDetails__c ind=new InvoiceDetails__c();
		ind.n_InvoiceId__c=inv.Id;
		ind.OrderId__c=o.Id;
		ind.InvisSale__c=true;
		try{
			insert ind;
		}catch(Exception ex){
		}
		o.isSale__c=false;
		update o;
		
	}
}