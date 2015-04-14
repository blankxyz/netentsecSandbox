/*
*RogerSun
*2013-06-01
*InvoiceOperate的测试类
*/
@isTest(SeeAllData=true)
public with sharing class cls_TestInvoiceOperate 
{
    static testMethod void myOrderSynchronization() 
     {
        Pricebook2 pricebook = [select Id from Pricebook2 where isStandard=true limit 1];   

        Profile profile=[Select p.Name, p.Id From Profile p where Name='Chatter External User'];
        list<RecordType> listrtp=[Select Name, Id, Description From RecordType];
        map<string,RecordType> maprtp=new map<string,RecordType>();
        if(listrtp.size()>0)
        {
            for(RecordType rt:listrtp)
            {
                if(!maprtp.containsKey(rt.Name))
                    maprtp.put(rt.Name,rt);
            }
        }
        RecordType listrtpQuDao=maprtp.get('渠道代理商'); 
        RecordType listrtpSales=maprtp.get('内部样机订单');
        RecordType listrtpDetailsType=maprtp.get('内部样机');
        User user=new User();                                            
        user.Phone='87413065';   
        user.MobilePhone='15167988026';
        user.Username='rogersun@hjgn.com3';
        user.Alias='DeLi';  //匿称
        user.CommunityNickname='DeLi';//绰号
        user.TimeZoneSidKey='Australia/Sydney';
        user.LocaleSidKey='en_AU';
        user.EmailEncodingKey='ISO-8859-1';
        user.ProfileId=profile.Id;
        user.LanguageLocaleKey='en_US';
        user.FirstName='于';
        user.LastName='NN';
        user.EmployeeNumber='1234q';
        user.Fax='0031388';
        user.Email='dlwork123@163.com';
        insert user;
        
       
        
         SalesRegion__c salesregion=new SalesRegion__c();
        salesregion.OfficeDirector__c=user.id;
        salesregion.Name='日本';
        insert salesregion;
        
        Account acc=new Account();
        acc.Name='五粮液';
        acc.Fax='8088';
        acc.Description='五粮液';
        acc.Phone='053187401697';
        acc.Industry='Finance';
        acc.RecordTypeId=listrtpQuDao.id;
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
        
        
       
        
        String Closetime='2005'+'-'+'10'+'-'+'5';
        Date dte=date.valueOf(Closetime);
        
        Opportunity opp=new Opportunity();      
        opp.OppProperties__c='商业市场';       
        opp.Name='五粮液商机';
        opp.Description='业务机会';
        opp.CloseDate=dte;  
        opp.AccountId=acc.Id;
        opp.StageName='关单';
        opp.Probability=100;                    //可行性
        opp.SalesRegion__c = salesregion.Id;
        insert opp;   
        
        Quote quote=new Quote();                //报价
        quote.OpportunityId=opp.Id;
        quote.Pricebook2Id=pricebook.Id;
        quote.Name='2013网康服务器报价';
        quote.Status='已批准';
        quote.yanhoukaipiaoliyouField3__c='延后开票信息';
        insert quote;
        
        Orders__c orders=new Orders__c();
        orders.Name='testorders';
        orders.SalesOpportunities__c=opp.id; 
        orders.Quote__c=quote.id;  
        orders.RecordTypeId=listrtpSales.id;
        orders.customer__c = acc.Id;
        orders.Partners__c = acc.Id;  
        orders.SalesRegion__c=salesregion.Id;
        insert orders;

        Orders__c cc= [select OrderNum__c from Orders__c where id =: orders.id]; 
        
        DateTime dtToday = Date.today();
        
        //订单明细
        DateTime nowToday = Date.today();
        list<OrderDetails__c> list_orDetails = new list<OrderDetails__c>();
        
        
        
        ProductSN__c psnYahuo=new ProductSN__c(); 
        psnYahuo.Name='lurrykong压货订单序列号';
        insert psnYahuo;
        
        //发票
        list<Invoice__c>listInv = new list<Invoice__c>();
        Invoice__c inv1 = new Invoice__c();
        inv1.Name=' fapiaobianhao'; 
        inv1.n_InvoiceClass__c = '增值税专用发票';
        inv1.n_InvoiceDate__c=Date.newinstance(2013, 2, 17);
        listInv.add(inv1);
        
        
        
        Invoice__c inv2 = new Invoice__c(); 
        inv2.Name=' 发票编号2';
        inv2.n_InvoiceClass__c = '增值税普通发票';
        inv2.n_InvoiceDate__c=Date.newinstance(2013, 5, 17);
        listInv.add(inv2);
        insert listInv;
        
        Invoice__c ic = [select Name,id from Invoice__c where id=:inv1.id];   
        
        list<InvoiceDetails__c> listInd = new list<InvoiceDetails__c>();
        InvoiceDetails__c ind1 = new InvoiceDetails__c();
        ind1.n_InvoiceId__c=inv1.Id;
        //ind1.InvoicesCustomers__c=acc.Id;
        ind1.OrderId__c=orders.Id; 
        ind1.onlyInvoice__c = '1qazxsw2';
        //ind1.InvoiceYear__c='2013'; 
        //ind1.Quarter__c='第一季度';
        listInd.add(ind1);
    
        InvoiceDetails__c ind2 = new InvoiceDetails__c();
        ind2.n_InvoiceId__c=inv1.Id;
        //ind2.InvoicesCustomers__c=acc.Id;
        ind2.OrderId__c=orders.Id;
        ind2.onlyInvoice__c = '123qwe';
        //ind2.InvoiceYear__c='2013';
        //ind2.Quarter__c='第二季度';
        listInd.add(ind2);
        
        InvoiceDetails__c ind3 = new InvoiceDetails__c();
        ind3.n_InvoiceId__c=inv2.Id;
        ind3.OrderId__c=orders.Id;
        ind3.onlyInvoice__c = 'qpqpqpq';
        listInd.add(ind3);
                try{
	        insert listInd;
        }catch(Exception e){
        }
        
        
        Product2 prod=new Product2();                       //产品
        prod.Name='iphone';
        prod.n_Unit__c='个';     
        insert prod;
        
        OrderDetails__c orderDetailsa = new OrderDetails__c();
        orderDetailsa.RecordTypeId = listrtpDetailsType.id;
        orderDetailsa.n_OrderNo__c = orders.Id;
        orderDetailsa.n_ProductByOrd__c=prod.id;                                    //产品
        orderDetailsa.n_ProCount__c=1;                                          //数量
        orderDetailsa.n_PriceByord__c=400;                                      //成交价
        orderDetailsa.TestStatus__c = '测试中';
        orderDetailsa.BorrowerReceiptDate__c = Date.valueOf(nowToday.addDays(-20));
        list_orDetails.add(orderDetailsa); 
        
        //旧样机的订单明细
        OrderDetails__c orderDetailsb = new OrderDetails__c();
        orderDetailsb.RecordTypeId = listrtpDetailsType.id;
        orderDetailsb.n_OrderNo__c = orders.Id;
        orderDetailsb.n_ProductByOrd__c=prod.id;                                    //产品
        orderDetailsb.n_ProCount__c=1;                                          //数量
        orderDetailsb.n_PriceByord__c=400;                                      //成交价
        orderDetailsb.TestStatus__c = '测试中';
        orderDetailsb.BorrowerReceiptDate__c = Date.valueOf(nowToday.addDays(-40));
        list_orDetails.add(orderDetailsb);
        
        insert list_orDetails;  
        list<Shipments__c> fahuo = new list<Shipments__c>();
        Shipments__c shipment2=new Shipments__c();                      //发货
        shipment2.n_orders__c=orders.id;
        shipment2.n_Deliverables__c=acc.id;
        shipment2.n_SendOrderNo__c = 'fahuodanhao';
        fahuo.add(shipment2);  
        
        Shipments__c shipment3=new Shipments__c();                      //发货
        shipment3.n_orders__c=orders.id;
        shipment3.n_Deliverables__c=acc.id; 
        fahuo.add(shipment3);
        insert fahuo;
        
        list<ShippingDetails__c> shippingdetail= new list<ShippingDetails__c>();
        ShippingDetails__c shipdetail3=new ShippingDetails__c();        //发货明细
        shipdetail3.ShipDetails__c='dd';
        shipdetail3.n_Shipmentname__c=shipment3.id;
        shippingdetail.add(shipdetail3);
        
        ShippingDetails__c shipdetail2=new ShippingDetails__c();        //发货明细
        shipdetail2.n_Shipmentname__c=shipment2.id;
        shipdetail2.ShipDetails__c='ddg';
        shippingdetail.add(shipdetail2); 
        insert shippingdetail; 
        
        SendProSN__c spro = new SendProSN__c();
        spro.S_Order__c = orders.id;
        spro.S_ShippingDetails__c = shipdetail3.id;  
        spro.S_Client__c = acc.id;
        spro.S_SN__c = psnYahuo.id; 
        insert spro;
        
        system.Test.startTest();
        //发票号0,发票类型1,开票时间2,发票备注3,客户4,产品5,数量6,
                    //含税单价7,金额8 ,发票明细备注9,发票明细唯一标识10,唯一值11,订单编号12,发票总金额13
        string str =ic.Name+'§'+inv1.n_InvoiceClass__c+'§'+date.valueOf('2013-5-5')+'§'+'发票备注'+'§'+acc.Name+'§'+prod.Name+'§'+'2'+'§'+200+'§'
                +'3000'+'§'+'发票明细备注'+'§'+ind1.onlyInvoice__c+'§'+'11111'+'§'+cc.OrderNum__c+'§'+8000;  
                 
        string str2 ='1212'+'§'+inv1.n_InvoiceClass__c+'§'+date.valueOf('2013-5-6')+'§'+'0000'+'§'+acc.Name+'§'+prod.Name+'§'+'2'+'§'+'333'+'§'
                +'3000'+'§'+'发票明细备注3'+'§'+'dddddddd'+'§'+'2222'+'§'+cc.OrderNum__c+'§'+900;
        list<string> a = new list<string>();      
        a.add(str);
        a.add(str2);
        WSDLInvoiceInformation.ArrayOfString ss = new WSDLInvoiceInformation.ArrayOfString();
        ss.string_x = a;
        InvoiceInformation.OperatorInvoiceInformations(ss);
        InvoiceInformation.OperatorInvoiceInformations(ss);     
        system.Test.stopTest();   
     }

}