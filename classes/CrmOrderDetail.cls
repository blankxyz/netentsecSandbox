/*
rogersun
2013-06-14
订单同步至用友CRM
*/
public with sharing class CrmOrderDetail 
{
	@Future(callout=true)
    public static void OrderDetailDataClient()
    {
        map<Id,Orders__c> mapOrder=new map<Id,Orders__c>([select o.SalesRegion__r.Name, o.RecordTypeName__c, o.BusinessOwners__c,o.Id,o.OrderNum__c,o.Name,o.Platform__c,o.AccountNo__c,o.ordersClassify__c,o.Type__c,o.Payer__r.Name,o.Partners__r.Name,o.customer__r.Name,o.Summary__c,o.ordersDate__c,o.shifouzaixiaoshou__c,o.order_Industry__c,o.Cooperation__c,o.Cooperativer__c,o.OpenSate__c,o.OrderAmount__c,o.DeliveredQuantity__c,o.DeliveryDate__c,o.SendProduct__r.Name,o.OrderCount__c,o.Remark__c from Orders__c o where (o.Statues__c='' or o.Statues__c='未同步') and  (o.Platform__c='网康科技' or o.Platform__c='奈特赛克') and (o.JudgeSynchronous__c=true or o.SynchronizationStatus__c='已同步')   LIMIT 50]);
        list<Orders__c> listorder=new list<Orders__c>();
        set<Id> setId =mapOrder.keyset();
        for(id i:setId)
        {
            listorder.add(mapOrder.get(i));
            system.debug('mapOrder.get(i)'+mapOrder.get(i));
        }
        system.debug('listorder'+listorder);
        list<OrderDetails__c> listOrderDetails=[select o.id,o.n_OrderNo__r.OrderNum__c,o.n_ProductByOrd__r.Name,o.n_Price__c,o.n_Unit__c,o.n_DiscountByord__c,o.n_PriceByord__c,o.n_ProCount__c,o.n_Sum__c,o.licenseWarranty__c,o.n_AccounSerNo__c,o.Acount__r.Name,o.versionNumber__c,o.n_CustomModels__c from OrderDetails__c o where o.n_OrderNo__c in:setId];
        //o.n_PriceByord__c,o.n_ProCount__c,o.n_Sum__c,o.licenseWarranty__c,o.n_AccounSerNo__c,o.o.Acount__r.Name,o.versionNumber__c,o.n_CustomModels__c
       system.debug('listOrderDetails'+listOrderDetails);
        if(listorder.size()>0)
        {
            WsdlorderDetail.orderDetailSoap  tt=new WsdlorderDetail.orderDetailSoap();
            WsdlorderDetail.ArrayOfOrderArray aa=new WsdlorderDetail.ArrayOfOrderArray();
            aa.orderArray=(WsdlorderDetail.orderArray[])orderArrayClientOperaton(listorder);
            WsdlorderDetail.ArrayOfOrderDetailArray bb=new WsdlorderDetail.ArrayOfOrderDetailArray();
            bb.orderDetailArray=(WsdlorderDetail.orderDetailArray[])orderDetailArrayClientOperaton(listOrderDetails);
            WsdlorderDetail.ArrayOfString f=new WsdlorderDetail.ArrayOfString();
            tt.timeout_x=120000;
            system.debug('aa的值是'+aa);
            system.debug('bb的值是'+bb);
            f=tt.operatorOrderDetail(aa,bb);
            system.debug('f的值是'+f);
            updateOrderStatuesData(f);
        }
       
    }
    public static list<WsdlorderDetail.orderDetailArray> orderDetailArrayClientOperaton(list<OrderDetails__c> a)
    {
        list<WsdlorderDetail.orderDetailArray> orderDetailArray=new list<WsdlorderDetail.orderDetailArray>();
        for(OrderDetails__c aa:a)
        {
            WsdlorderDetail.orderDetailArray b=new WsdlorderDetail.orderDetailArray();
            b.contractnumber1=aa.n_OrderNo__r.OrderNum__c;
            system.debug('aa.n_OrderNo__r.OrderNum__c的值'+aa.n_OrderNo__r.OrderNum__c);
            b.prodname=aa.n_ProductByOrd__r.Name;
            if(aa.n_Price__c==null)
            {
                b.standardPrice=0;
            }
            else
            {
                b.standardPrice=aa.n_Price__c;
            }
             system.debug('b.standardPrice的值'+b.standardPrice);
            b.bookPrice=0;
            b.unitname=aa.n_Unit__c;
            system.debug('b.unitname的值'+b.unitname);
            if(aa.n_DiscountByord__c==null)
            {
                b.discount=0;
            }
            else
            {
                b.discount=aa.n_DiscountByord__c;
            }
            system.debug('b.discount的值'+b.discount);
            if(aa.n_PriceByord__c==null)
            {
                b.finalprice=0;
            }
            else
            {
                b.finalprice=aa.n_PriceByord__c;
            }
            system.debug('b.finalprice的值'+b.finalprice);
            if(aa.n_ProCount__c==null)
            {
                b.prodquantity=0;
            }
            else
            {
                b.prodquantity=aa.n_ProCount__c;
            }
            system.debug('b.prodquantity的值'+b.prodquantity);
            if(aa.n_Sum__c==null)
            {
                b.prodamount=0;
            }
            else
            {
                b.prodamount=aa.n_Sum__c;
            }
            system.debug('b.prodamount的值'+b.prodamount);
            b.dcntrtchar03=aa.licenseWarranty__c;
            system.debug('b.dcntrtchar03的值'+b.dcntrtchar03);
            b.dcntrtchar10=aa.n_AccounSerNo__c;
            system.debug('b.dcntrtchar10的值'+b.dcntrtchar10);
            b.dcntrtrefid02=aa.Acount__r.Name;
             system.debug('b.dcntrtrefid02的值'+b.dcntrtrefid02);
            b.dcntrtchar09=aa.versionNumber__c;
            system.debug('b.dcntrtchar09的值'+b.dcntrtchar09);
           // b.dcntrtchar08='123';
           // b.dcntrtint02='1234';
            b.onlyCodeId=aa.Id;
             system.debug('b.onlyCodeId的值'+b.onlyCodeId);
            b.dcntrtchar06=aa.n_CustomModels__c;
             system.debug('b.dcntrtchar06的值'+b.dcntrtchar06);
            orderDetailArray.add(b); 
        }
        return orderDetailArray;
    }
    
    
    public static list<WsdlorderDetail.orderArray> orderArrayClientOperaton(list<Orders__c> a)
    {
        list<WsdlorderDetail.orderArray> b=new list<WsdlorderDetail.orderArray>();
        for(Orders__c aa:a)
        {
            WsdlorderDetail.orderArray bb=new WsdlorderDetail.orderArray();
            bb.contractnumber=aa.OrderNum__c;
            system.debug('bb.contractnumber的值'+bb.contractnumber);
            bb.contractname=aa.Name;
            system.debug('bb.contractname的值'+bb.contractname);
            bb.cntrtint09=aa.Platform__c;
            system.debug('bb.cntrtint09的值'+bb.cntrtint09);
            bb.cntrtint14=aa.AccountNo__c;
            system.debug('bb.cntrtint14的值'+bb.cntrtint14);
            bb.cntrtint10=aa.ordersClassify__c;
            system.debug('bb.cntrtint10的值'+bb.cntrtint10);
            bb.cntrtint12=aa.Type__c;
            system.debug('bb.cntrtint12的值'+bb.cntrtint12);
            bb.accountid=aa.Payer__r.Name;
            system.debug('bb.accountid的值'+bb.accountid);
            bb.copartnerid=aa.Partners__r.Name;
            system.debug('bb.copartnerid的值'+bb.copartnerid);
            bb.cntrtrefid01=aa.customer__r.Name;
            system.debug('bb.cntrtrefid01的值'+bb.cntrtrefid01);
            bb.cntrtchar05=aa.Summary__c;
            system.debug('bb.cntrtchar05的值'+bb.cntrtchar05);
            bb.createtime=aa.ordersDate__c;
            system.debug('bb.createtime的值'+bb.createtime);
            bb.cntrtint05=aa.shifouzaixiaoshou__c;
            system.debug('bb.cntrtint05的值'+bb.cntrtint05);
            bb.cntrtint16=aa.order_Industry__c;
            system.debug('bb.cntrtint16的值'+bb.cntrtint16);
            bb.cntrtmulti02=aa.Cooperation__c;
            system.debug('bb.cntrtmulti02的值'+bb.cntrtmulti02);
            bb.cntrtchar08=aa.Cooperativer__c;
            system.debug('bb.cntrtchar08的值'+bb.cntrtchar08);
            bb.cntrtint01=aa.OpenSate__c;
            system.debug('bb.cntrtint01的值'+bb.cntrtint01);
           // bb.cntrtint18='足额收款';
            //bb.cntrtint19='是';
            if(aa.OrderAmount__c==null)
            {
                bb.contractamount=0;
            }
            else
            {
                bb.contractamount=aa.OrderAmount__c;
            }
            system.debug('bb.contractamount的值'+bb.contractamount);
            //bb.contractpaymentdate=Date.today();
            if(aa.DeliveredQuantity__c==null)
            {
                bb.contractdeliveredquantity=0;
            }
            else
            {
                bb.contractdeliveredquantity=aa.DeliveredQuantity__c;
            }
            system.debug('bb.contractdeliveredquantity的值'+bb.contractdeliveredquantity);
            bb.contractdeliverydate=aa.DeliveryDate__c;
            system.debug('bb.contractdeliverydate的值'+bb.contractdeliverydate);
            bb.contractundeliveredquantity=0;
            bb.cntrtrefid02=aa.SendProduct__r.Name;
            system.debug('bb.cntrtrefid02的值'+bb.cntrtrefid02);
            if(aa.OrderCount__c==null)
            {
                bb.contractquantity=0;
            }
            else
            {
                bb.contractquantity=aa.OrderCount__c;
            }
            system.debug('bb.contractquantity的值'+bb.contractquantity);
            bb.cntrtchar09=aa.Partners__r.Name;
            system.debug('bb.cntrtchar09的值'+bb.cntrtchar09);
            bb.cntrtmulti04=aa.Remark__c;
            system.debug('bb.bb.cntrtmulti04的值'+bb.cntrtmulti04);
            bb.SalesRegion=aa.SalesRegion__r.Name;
            system.debug('bb.SalesRegion的值'+bb.SalesRegion);
            bb.RecordTypeName=aa.RecordTypeName__c;
            system.debug('bb.RecordTypeName的值'+bb.RecordTypeName);
            bb.BusinessOwners=aa.BusinessOwners__c;
            system.debug('bb.BusinessOwners的值'+bb.BusinessOwners);
            //o.SalesRegion__r.Name, o.RecordTypeName__c, o.BusinessOwners__c
            b.add(bb);
        }
        return b;
    }
    public static  void updateOrderStatuesData(WsdlorderDetail.ArrayOfString f)
    { 
             Map<string,string> numIdMap = new Map<string,string>();
             string[] ss = f.string_x;
              system.debug('from string is ss :'+ss);
               for(string s:ss)
             {
                string[] numID = s.split(',');
                for(string sNum:numID)
                {
                    string[] sNumId=sNum.split('\\+');
                    if(sNumId[1]!=null && sNumId[0]!=null)
                    {
                        numIdMap.put(sNumId[1],sNumId[0]);
                    }
                    
                    system.debug('asd :'+sNumId[0]);
                    system.debug('das:'+sNumId[1]);
                }   
             }
             system.debug('返回值按照Id和标识码赋值给map（numIdMap） :'+numIdMap.size());
             List<Orders__c > acc = [select OrderNum__c from Orders__c where OrderNum__c IN: numIdMap.keySet()]; 
             system.debug('根据map中的id获取Account表中id :'+numIdMap);
             for(Orders__c a:acc)
             {
                a.Statues__c=numIdMap.get(a.OrderNum__c);
                system.debug('a.IdentificationCode_c__c'+numIdMap.get(a.OrderNum__c));
             }
             update acc;
             system.debug('修改完成');
    }
  
}