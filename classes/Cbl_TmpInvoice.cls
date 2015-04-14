/*
*RogerSun
*982578975@qq.com
*发票添加到临时发票信息
*/
public  class Cbl_TmpInvoice {
	//自定义异常对象  
    public class MyException extends Exception {}
	public void Cbl_TmpInvoice_beforeInsert(list<TmpInvoice__c> listTmpInvoice)
	{
		 set<string> setAutoId=new set<string>();
        map<string,TmpInvoice__c> mapDeliveryTemporary=new map<string,TmpInvoice__c>();
        for(TmpInvoice__c d: listTmpInvoice)
        {
            setAutoId.add(d.autoid__c);
            if(mapDeliveryTemporary.containsKey(d.autoid__c))
            {
                d.AddError('数据有重复插入');
                
            }
            else
            {
                mapDeliveryTemporary.put(d.autoid__c,d);
            }
            
        }
        list<TmpInvoice__c> listDeliveryTemporarys=new list<TmpInvoice__c>([select id from TmpInvoice__c where autoid__c in: setAutoId]);
        for(TmpInvoice__c dd: listDeliveryTemporarys)
        {
            throw new MyException('已存在不能重复插入');
            
        }
        
	}
	public void Cbl_TmpInvoice_afterInsert(list<TmpInvoice__c> listTmpInvoice)
	{
		map<string,Invoice__c> mapInvoice=new map<string,Invoice__c>();
		map<string,Invoice__c> mapInvoiceExtis=new map<string,Invoice__c>();
		list<Invoice__c> listInvoice=new list<Invoice__c>();
		
		map<string,InvoiceDetails__c> mapInvoiceDetails=new map<string,InvoiceDetails__c>();
		map<string,InvoiceDetails__c> mapInvoiceDetailsExtis=new map<string,InvoiceDetails__c>();
		list<InvoiceDetails__c> listInvoiceDetails=new list<InvoiceDetails__c>();
		
		set<string> setInvoice=new set<string>();
		set<string> setInvoiceDetails=new set<string>();
		for(TmpInvoice__c t:listTmpInvoice)
		{
			setInvoice.add(t.cSBVCode__c);
			setInvoiceDetails.add(t.autoid__c);
		}
		list<Invoice__c> listInvoiceExtis=new list<Invoice__c>([select id,Name from Invoice__c  where Name in: setInvoice]);
		list<InvoiceDetails__c> listInvoiceDetailsExtis=new list<InvoiceDetails__c>([select id,onlyInvoice__c from InvoiceDetails__c where onlyInvoice__c in: setInvoiceDetails]);
		if(listInvoiceExtis!=null && listInvoiceExtis.size()>0)
		{
			for(Invoice__c i: listInvoiceExtis)
			{
				mapInvoiceExtis.put(i.Name,i);
			}
		}
		if(listInvoiceDetailsExtis!=null && listInvoiceDetailsExtis.size()>0)
		{
			for(InvoiceDetails__c i: listInvoiceDetailsExtis)
			{
				mapInvoiceDetailsExtis.put(i.onlyInvoice__c,i);
			}
		}
		for(TmpInvoice__c t:listTmpInvoice)
		{
			if(!mapInvoiceExtis.containsKey(t.cSBVCode__c) && !mapInvoice.containsKey(t.cSBVCode__c))
			{
				Invoice__c aInvoices = new Invoice__c();
				 
				aInvoices.Name = t.cSBVCode__c;
                if (t.cVouchName__c == '专用发票')
                {
                    aInvoices.n_InvoiceClass__c = '增值税专用发票';
                }
                else if (t.cVouchName__c == '普通发票')
                {
                    aInvoices.n_InvoiceClass__c = '增值税普通发票';
                }
                aInvoices.n_Remark__c =t.cMemo__c;

                aInvoices.n_InvoiceDate__c = t.dDate__c;
                
                aInvoices.Customer__c = t.cCusCode__c;
                aInvoices.n_CountAmount__c = t.SumMoney__c;
                listInvoice.Add(aInvoices);
                mapInvoice.put(t.cSBVCode__c,aInvoices);
	           
                
                
			}
			if(!mapInvoiceDetailsExtis.containsKey(t.autoid__c) && !mapInvoiceDetails.containsKey(t.autoid__c))
			{
				InvoiceDetails__c InvoiceDetailss=new InvoiceDetails__c();
                InvoiceDetailss.OrderData__c = t.cSOCode__c;
                InvoiceDetailss.ProductName__c = t.cInvCode__c;
                InvoiceDetailss.InvoiceData__c = t.cSBVCode__c;
                InvoiceDetailss.n_Remark__c = t.cMemo1__c;
                InvoiceDetailss.n_ProductsNumber__c = t.iQuantity__c;
                
	
                InvoiceDetailss.n_ContractedPrice__c = t.iTaxUnitPrice__c;
                
                InvoiceDetailss.onlyInvoice__c = t.autoid__c;
                
                InvoiceDetailss.n_Discount__c = t.KL__c;
               
                listInvoiceDetails.Add(InvoiceDetailss);
                mapInvoiceDetails.put(t.autoid__c,InvoiceDetailss);
			}
			
		}
		if(listInvoice!=null && listInvoice.size()>0)
		{
			insert listInvoice;
		}
		if(listInvoiceDetails!=null && listInvoiceDetails.size()>0)
		{
			insert listInvoiceDetails;
		}
	}
	
}