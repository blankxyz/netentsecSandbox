/*
*功能：测试触发器InvoiceDetails_CountChannelInfo
*作者：Alisa
*时间：2013年5月15日
*/

@isTest(SeeAlldata=true)
public class TrgTest_InvoiceDetails_CountChannelInfo {
	static testMethod void myUnitTest(){
		List<InvoiceDetails__c> listInd = new List<InvoiceDetails__c>();
		List<Invoice__c> listInv = new List<Invoice__c>();
		list<Orders__c> listOr = new list<Orders__c>();
		SalesRegion__c salesregion=new SalesRegion__c();
		salesregion.Name='日本';
		insert salesregion; 
		
		Account acc = new Account();
		acc.Name='客户test';
		acc.PrimaryIndustry__c='金融';
		acc.TwoIndustries__c='债券';
		acc.ThreeIndustries__c='银行';
		acc.SellArea__c=SalesRegion.id;
		acc.Province__c='北京';
		acc.Phone='12345678';
		acc.PrimaryIndustry__c='金融';
		acc.TwoIndustries__c='债券';
		acc.ThreeIndustries__c='银行';
		acc.SellArea__c=SalesRegion.id;
		acc.Province__c='北京';
		insert acc;
		
		SalesTargets__c st = new SalesTargets__c();
		st.n_customerName__c = acc.id;
		st.Year__c = '2013';
		insert st;
		
		Orders__c o1 = new Orders__c();
		o1.Name='订单test1';
		o1.Partners__c = acc.id;
		o1.isSale__c=true;
		listOr.add(o1);
		Orders__c o2 = new Orders__c();
		o2.Name='订单test2';
		o2.Partners__c = acc.id;
		o2.isSale__c=false;
		listOr.add(o2);
		Orders__c o3 = new Orders__c();
		o3.Name='订单test3';
		o3.Partners__c = acc.id;
		o3.isSale__c=true;
		listOr.add(o3);
		Orders__c o4 = new Orders__c();
		o4.Name='订单test4';
		o4.Partners__c = acc.id;
		o4.isSale__c=false;
		listOr.add(o4);
		Orders__c o5 = new Orders__c();
		o5.Name='订单test5';
		o5.Partners__c = acc.id;
		o5.isSale__c=true;
		listOr.add(o5);
		Orders__c o6 = new Orders__c();
		o6.Name='订单test6';
		o6.Partners__c = acc.id;
		o6.isSale__c=false;
		listOr.add(o6);
		Orders__c o7 = new Orders__c();
		o7.Name='订单test87';
		o7.Partners__c = acc.id;
		o7.isSale__c=true;
		listOr.add(o7);
		Orders__c o8 = new Orders__c();
		o8.Name='订单test8';
		o8.Partners__c = acc.id;
		o8.isSale__c=false;
		listOr.add(o8);
		
		insert listOr;
		
		
		Invoice__c inv1 = new Invoice__c();
		inv1.Name=' 发票编号1';
		inv1.n_InvoiceDate__c=Date.newinstance(2013, 2, 17);
		listInv.add(inv1);
		
		Invoice__c inv2 = new Invoice__c();
		inv2.Name=' 发票编号2';
		inv2.n_InvoiceDate__c=Date.newinstance(2013, 5, 17);
		listInv.add(inv2);
		
		Invoice__c inv3 = new Invoice__c();
		inv3.Name=' 发票编号3';
		inv3.n_InvoiceDate__c=Date.newinstance(2013, 8, 17);
		listInv.add(inv3);
		
		Invoice__c inv4 = new Invoice__c();
		inv4.Name=' 发票编号4';
		inv4.n_InvoiceDate__c=Date.newinstance(2013, 11, 17);
		listInv.add(inv4);
		
		insert listInv;
		
		
		InvoiceDetails__c ind1 = new InvoiceDetails__c();
		ind1.n_InvoiceId__c=inv1.Id;
		//ind1.InvoicesCustomers__c=acc.Id;
		ind1.OrderId__c=o1.Id;
		//ind1.InvoiceYear__c='2013';
		//ind1.Quarter__c='第一季度';
		listInd.add(ind1);
	
		InvoiceDetails__c ind2 = new InvoiceDetails__c();
		ind2.n_InvoiceId__c=inv1.Id;
		//ind2.InvoicesCustomers__c=acc.Id;
		ind2.OrderId__c=o2.Id;
		//ind2.InvoiceYear__c='2013';
		//ind2.Quarter__c='第二季度';
		listInd.add(ind2);
		
		InvoiceDetails__c ind3 = new InvoiceDetails__c();
		ind3.n_InvoiceId__c=inv2.Id;
		ind3.OrderId__c=o3.Id;
		listInd.add(ind3);
	
		InvoiceDetails__c ind4 = new InvoiceDetails__c();
		ind4.n_InvoiceId__c=inv2.Id;
		ind4.OrderId__c=o4.Id;
		listInd.add(ind4);
		
		InvoiceDetails__c ind5 = new InvoiceDetails__c();
		ind5.n_InvoiceId__c=inv3.Id;
		ind5.OrderId__c=o5.Id;
		listInd.add(ind5);
	
		InvoiceDetails__c ind6 = new InvoiceDetails__c();
		ind6.n_InvoiceId__c=inv3.Id;
		ind6.OrderId__c=o6.Id;
		listInd.add(ind6);
		
		InvoiceDetails__c ind7 = new InvoiceDetails__c();
		ind7.n_InvoiceId__c=inv4.Id;
		ind7.OrderId__c=o7.Id;
		listInd.add(ind7);
	
		InvoiceDetails__c ind8 = new InvoiceDetails__c();
		ind8.n_InvoiceId__c=inv4.Id;
		ind8.OrderId__c=o8.Id;
		listInd.add(ind8);
	
		try{
		insert listInd;
		delete(listInd.get(0));
		}catch(Exception e){
			
		}
		
	}
}