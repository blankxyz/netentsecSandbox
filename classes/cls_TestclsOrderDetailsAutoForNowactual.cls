/**
*Test:clsOrderDetailsAutoForNowactual
*Author:Garu_Hu
*Time:2013年5月15日20:12:58
**/

@isTest(SeeAllData=true) 
private class cls_TestclsOrderDetailsAutoForNowactual {
 
    static testMethod void myUnitTest() {  
          
    
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
        user.Username='LurryKong@fccz.com2';
        user.Alias='DeLi';  //匿称
        user.CommunityNickname='DeLi';//绰号
        user.TimeZoneSidKey='Australia/Sydney';
        user.LocaleSidKey='en_AU';
        user.EmailEncodingKey='ISO-8859-1';
        user.ProfileId=profile.Id;
        user.LanguageLocaleKey='en_US';
        user.FirstName='于';
        user.LastName='NN';
        user.Fax='0031388';
        user.Email='dlwork123@163.com';
        insert user;
         
        Account acc=new Account();
        acc.Name='五粮液';
        acc.Fax='8088';
        acc.Description='五粮液';
        acc.Phone='053187401697';
        acc.Industry='Finance';
        acc.IdentificationCode_c__c='1234589';
        acc.RecordTypeId=listrtpQuDao.id;
        insert acc;
        
        SalesRegion__c salesregion=new SalesRegion__c();
        salesregion.OfficeDirector__c=user.id;
        salesregion.Name='日本';
        insert salesregion;      
        
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
        quote.kaipiaoyaoqiuField2__c = '发货自动开票';
        quote.Name='2013网康服务器报价';
        quote.Status='已批准';
        insert quote;
        
        Product2 prod=new Product2();                       //产品
        prod.Name='prodone';
        prod.n_Unit__c='个';     
        insert prod;
        
 
        ProductSN__c psnYahuo=new ProductSN__c(); 
        psnYahuo.Name='lurrykong压货订单序列号';
        insert psnYahuo;
        
        ProductSN__c psnYahuo2=new ProductSN__c();
        psnYahuo2.Name='lurrykong压货订单序列号ww';
        insert psnYahuo2; 
        
        
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
        shipment2.n_SendOrderNo__c = 'fahuodanhao123';
        fahuo.add(shipment2);  
        
        Shipments__c shipment3=new Shipments__c();                      //发货
        shipment3.n_orders__c=orders.id;
        shipment3.n_Deliverables__c=acc.id; 
        shipment3.n_SendOrderNo__c = 'fahuodanhao12';
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
        //-- 订单号0 +序列号1+产品2+定制型号3+客户简称4+软件版本号5+序列号数量6+发货单号7+日期8+数量    9+部门10 +随机码11+子表id 12
        string str =cc.OrderNum__c+'§'+string.valueOf(psnYahuo.Name)+'§'+ string.valueOf(prod.Name)+'§'+'0000'+'§'+acc.IdentificationCode_c__c+'§'+'27'+'§'+'2'+'§'+shipment2.n_SendOrderNo__c+'§'
                +'2013-5-27'+'§'+'3'+'§'+string.valueOf(salesregion.Name)+'§'+'11111'+'§'+'dd';  
                 
            system.debug('str值：'+str);  
        string str2 =cc.OrderNum__c+'§'+'sss'+'§'+string.valueOf(prod.Name)+'§'+'0000'+'§'+acc.IdentificationCode_c__c+'§'+'27'+'§'+'2'+'§'+'333'+'§'
                +'2013-5-27'+'§'+'3'+'§'+string.valueOf(salesregion.Name)+'§'+'2222'+'§'+'4444';
            system.debug('str2值：'+str2);    
            system.debug('截取值是：'+str2.split('§'));  
        //订单号，产品名称，部门名称，客户   添加数据，自己造数据
        list<string> a = new list<string>();    
        a.add(str);
        a.add(str2);
        system.debug('list中的值是：'+a);
        WSDLShipments.ArrayOfString b = new WSDLShipments.ArrayOfString();
        b.string_x = a; 
        UpdatesShipments.OperdateData(b);   
        UpdatesShipments.OperdateData(b);   
        
        
        
        
        
        system.Test.stopTest();  
        
        
    }
}