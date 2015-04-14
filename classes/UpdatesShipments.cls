/*
*rogerSun
*2013/05/15
*更新发货信息
global class UpdatesShipments 
{ 
*/

global class  UpdatesShipments implements Database.Batchable<SObject>, Database.AllowsCallouts,Database.Stateful
{
     global String OrdersNumDatas;
     global Database.queryLocator start(Database.BatchableContext ctx)
     {
           return Database.getQueryLocator([Select id from Shipments__c limit 100]); 
     }
     global void execute(Database.BatchableContext ctx, List<Shipments__c> scope)
     {
        WSDLShipments.ArrayOfString a=new WSDLShipments.ArrayOfString();
        WSDLShipments.ShipmentsSoap b=new WSDLShipments.ShipmentsSoap();
        b.timeout_x=120000;
        a=b.UpdateShipments();
        system.debug('传入值a的信息'+a); 
        
        if(a!=null)
        {
            OrdersNumDatas=OperdateData(a);
            system.debug('获得返回OrdersNumDatas的值：'+OrdersNumDatas);
           // UpdatesShipAsynchronReturnValue.AsynchronReturnValue(OrdersNum);
            //b.OperShipmentsReturnValue(OrdersNum);//返回是否同步状态 
        }   
        else
        {
            system.debug('无需要同步信息');
        } 
     }
    public static string OperdateData(WSDLShipments.ArrayOfString a)
    {
             string[] ff=a.string_x;
             set<string> SegmentationData=new set<string>();  //订单号
             set<string> ProductData=new set<string>();       //产品 
             set<string> ClientData=new set<string>();        //客户
             set<string> SalesRegionData=new set<string>();        //销售部门
             set<string> ProductSNData=new set<string>();         //序列号
             set<string> SendProductData=new set<string>();   //发货单号
             set<string> ShipDetailsData=new set<string>(); //发货明细id
             set<string> SerialNumberId =new set<string>(); //序列号
             for(string f:ff)
             {
                string[] ss=f.split(',');
                for(string s:ss)
                {
                    string[] sNumId=s.split('§');
                    //-- 订单号0 +序列号1+产品2+定制型号3+客户简称4+软件版本号5+序列号数量6+发货单号7+日期8+数量    9+部门10 +随机码11+子表id 12
                     if(sNumId[0]!='' && sNumId[0]!=null)
                    { 
                        SegmentationData.add(sNumId[0]);
                    }
                     if(sNumId[2]!='' && sNumId[2]!=null)
                    { 
                        ProductData.add(sNumId[2]);
                        
                    }
                     if(sNumId[4]!='' && sNumId[4]!=null)
                    { 
                        ClientData.add(sNumId[4]);
                    }
                     if(sNumId[10]!='' && sNumId[10]!=null)
                    { 
                        SalesRegionData.add(sNumId[10]);
                    }
                    if(sNumId[1]!='' && sNumId[1]!=null)
                    { 
                        ProductSNData.add(sNumId[1]);
                    }
                    if(sNumId[7]!='' && sNumId[7]!=null)
                    {
                        SendProductData.add(sNumId[7]);
                    }
                    //发货单号
                    if(sNumId[12]!='' && sNumId[12]!=null)
                    { 
                        ShipDetailsData.add(string.valueOf(sNumId[12]));
                    }
                    //发货子表id
                    if(sNumId[11]!='' && sNumId[11]!=null)
                    {
                        SerialNumberId.add(sNumId[11]);
                    }
                    //序列号随机号码
                }
             }        
              //查看salesforce中是否包含已有发货单数据
              map<string,Id> AlreadySendProduct =new map<string,Id>();
              list<Shipments__c> listAlreadySendProduct=[select n_SendOrderNo__c,Id from Shipments__c where n_SendOrderNo__c in:SendProductData];
              for(Shipments__c c:listAlreadySendProduct)
              {
                    AlreadySendProduct.put(c.n_SendOrderNo__c,c.Id);
              }
              map<id,Shipments__c> mapOldAlreadySendProduct=new map<id,Shipments__c>([select s.Id,s.n_SendOrderNo__c,s.n_orders__c,s.n_Deliverables__c,s.n_DeliveryTime__c from Shipments__c s where s.n_SendOrderNo__c  in:SendProductData]);
              
              system.debug('-----mapOldAlreadySendProduct-----'+mapOldAlreadySendProduct); 
              //查看原数据是否已经存在序列号
              map<string,Id> mapGetSFOldSerialNumber=new  map<string,Id>();
               list<ProductSN__c> listGetSFOldSerialNumber=[select Name,Id from ProductSN__c where Name in: ProductSNData];
               for(ProductSN__c s:listGetSFOldSerialNumber)
               {
                   mapGetSFOldSerialNumber.put(s.name,s.Id);
               }
               map<string,ProductSN__c> oldmapGetSFOldSerialNumber=new map<string,ProductSN__c>([select Name,n_Production__c,CustomModels__c,shipmentdetile__c,SerialNumberId__c,coustmer__c,AccountSaleArea__c,Version__c,Quantity__c,ProductCategory__c,ProductStatus__c from ProductSN__c where Name in: ProductSNData]);
               //查看是否存在发货明细sn
               
               set<string> setOldShipDetailsSn=mapGetSFOldSerialNumber.keySet();
               set<string> setOldProductSNData=new set<string>();
               for(string sc:setOldShipDetailsSn)
               {
                    setOldProductSNData.add(mapGetSFOldSerialNumber.get(sc));
               }
               
               map<string,Id> mapShipDetailsSnOld=new map<string,Id>();
               list<SendProSN__c> listOldShipDetailsSn=[select Id,S_SN__c from SendProSN__c where S_SN__c in:setOldProductSNData];
               for(SendProSN__c s:listOldShipDetailsSn)
               {
                    mapShipDetailsSnOld.put(s.S_SN__c,s.Id);
               }
               map<string,SendProSN__c> napOldSendProSNData=new  map<string,SendProSN__c>([select Id,S_Order__c,S_ShippingDetails__c,S_Client__c,S_area__c,S_SN__c,S_ProductCategory__c,S_ProductStatus__c from SendProSN__c where S_SN__c in:setOldProductSNData]);
               
               map<string,Id> mapShipDetailsDataId=new map<string,Id>();
               list<ShippingDetails__c> listShipDetailsDataId=[select ShipDetails__c,Id from ShippingDetails__c where ShipDetails__c in: ShipDetailsData];
               for(ShippingDetails__c s:listShipDetailsDataId)
               {
                    mapShipDetailsDataId.put(s.ShipDetails__c,s.Id);
               }
               map<string,ShippingDetails__c> mapOldDataShippingDetails=new map<string,ShippingDetails__c>([select Id,n_Shipmentname__c,n_Products__c,ShipDetails__c,ordersSum__c from ShippingDetails__c where ShipDetails__c in: ShipDetailsData]);
               
               
               //n_Shipmentname__c,n_Products__c,ShipDetails__c,ordersSum__c mapShipDetailsDataId,mapOldDataShippingDetails
               map<string,ProductSN__c> DeviceTypeCategory =new map<string,ProductSN__c>();
               ProductSN__c q=new ProductSN__c();
               q.ProductCategory__c='样机';   //设备类别
               q.ProductStatus__c='测试机';     //设备状态
               DeviceTypeCategory.put('内部样机订单',q);
               
               ProductSN__c q1=new ProductSN__c();
               q1.ProductCategory__c='产品';   //设备类别
               q1.ProductStatus__c='出售';     //设备状态
               DeviceTypeCategory.put('销售订单',q1);
               
               ProductSN__c q2=new ProductSN__c();
               q2.ProductCategory__c='产品';   //设备类别
               q2.ProductStatus__c='出售';     //设备状态
               DeviceTypeCategory.put('换货订单',q2);
               
               ProductSN__c q3=new ProductSN__c();
               q3.ProductCategory__c='产品';   //设备类别
               q3.ProductStatus__c='压货';     //设备状态
               DeviceTypeCategory.put('压货订单',q3);
               
               ProductSN__c q4=new ProductSN__c();
               q4.ProductCategory__c='产品';   //设备类别
               q4.ProductStatus__c='出售';     //设备状态
               DeviceTypeCategory.put('渠道样机订单',q4);
               
             //根据订单编号获取订单id和订单编号存储在listOrders中
             list<Orders__c> listOrders=[select o.OrderNum__c,o.Id from Orders__c o where o.OrderNum__c in: SegmentationData];
             map<string,Id> SegmentationDataOrders=new map<string,Id>();
             for(Orders__c s:listOrders)
             {
                SegmentationDataOrders.put(s.OrderNum__c,s.Id);
                //system.debug('SegmentationDataOrders订单编号s.OrderNum__c'+s.OrderNum__c);
                //system.debug('SegmentationDataOrders订单Id s.Id'+s.Id);
             }
             system.debug('SegmentationDataOrders的信息是：'+SegmentationDataOrders);
             Set<string> key = SegmentationDataOrders.keySet();
             set<string> OrdersId=new set<string>();
             for(string s:key)
             {
                OrdersId.add(s);
             }
             
             //根据订单编号获取记录类型
               map<string,string> mapDeviceType=new map<string,string>();
               list<Orders__c> listDeviceType =[Select RecordTypeName__c,OrderNum__c From Orders__c where OrderNum__c in: OrdersId];
               for(Orders__c s:listDeviceType)
               {
                    mapDeviceType.put(s.OrderNum__c,s.RecordTypeName__c);
               }
             
             
             //根据销售部门名称获取销售id
             list<SalesRegion__c> listSalesRegion=[select Name,Id from SalesRegion__c where Name in: SalesRegionData];
             map<string,Id> mapSalesRegion=new  map<string,Id>();
             for(SalesRegion__c s:listSalesRegion)
             {
                mapSalesRegion.put(s.Name,s.Id);
             }
              Set<string> SalesRegionkey = mapSalesRegion.keySet();
             for(string s:SalesRegionkey)
             {
                //system.debug('销售部门对应的部门id'+mapSalesRegion.get(s));
             }
    
             //根据产品获取产品和产品id存储在listProduct2
             list<Product2> listProduct2=[select Name,Id from Product2 where Name in: ProductData];
              map<string,Id> ProductDataProduct=new map<string,Id>();
              for(Product2 s:listProduct2)
              {
                  ProductDataProduct.put(s.Name,s.Id);
              }
             
             //根据客户名称获取客户信息
             system.debug('ClientData的信息是：'+ClientData);
             list<Account> listAccount=[select Name,Id,IdentificationCode_c__c from Account where IdentificationCode_c__c in: ClientData];
             map<string,Id> ClientDataProduct=new map<string,Id>();
             for(Account s:listAccount)
             {
                ClientDataProduct.put(s.IdentificationCode_c__c,s.Id);
             }
             system.debug('ClientDataProduct客户信息是：'+ClientDataProduct);
              map<string,Shipments__c> mMapShipmentss =new  map<string,Shipments__c>();
              map<string,Shipments__c> mMapAleryShipmentss =new  map<string,Shipments__c>();
             for(string f:ff)
             {
                string[] ss=f.split(',');
                for(string s:ss)
                {
                    string[] sNumId=s.split('§');
                    system.debug('sNumId的信息是：'+sNumId);
                    //-- 订单号0 +序列号1+产品2+定制型号3+客户简称4+软件版本号5+序列号数量6+发货单号7+日期8+数量    9+部门10+一条信息
                        Shipments__c sShipments = new Shipments__c();
                        sShipments.n_SendOrderNo__c=sNumId[7];
                        sShipments.n_orders__c=SegmentationDataOrders.get(sNumId[0]);
                        sShipments.n_Deliverables__c=ClientDataProduct.get(sNumId[4]);
                        
                        sShipments.n_DeliveryTime__c=date.valueOf(sNumId[8]);
                        
                        if (sShipments.n_orders__c != null)
                        {
                            if(AlreadySendProduct.get(sNumId[7])!=null) 
                            {
                                    Shipments__c sShipmentsOld =mapOldAlreadySendProduct.get(AlreadySendProduct.get(sNumId[7]));
                                   // system.debug('-----------------------sShipmentsOld----------------'+sShipmentsOld);
                                    sShipmentsOld.n_SendOrderNo__c=sNumId[7];
                                    sShipmentsOld.n_orders__c=SegmentationDataOrders.get(sNumId[0]);
                                    //sShipmentsOld.n_Deliverables__c=ClientDataProduct.get(sNumId[4]);
                                    sShipmentsOld.n_DeliveryTime__c=date.valueOf(sNumId[8]); 
                                    if(mMapAleryShipmentss.size()>0)
                                    {
                                        Set<string> mMapOldShipmentssKey = mMapAleryShipmentss.keySet();
                                        for(string mmm:mMapOldShipmentssKey)
                                        {
                                            if(mmm!=sNumId[7])
                                            {
                                                mMapAleryShipmentss.put(sNumId[7],sShipmentsOld);
                                            }
                                        }
                                    }
                                    else
                                    {
                                        mMapAleryShipmentss.put(sNumId[7],sShipmentsOld);
                                    }
                                
                            }
                            else
                            {
                                if(mMapShipmentss.size()>0)
                                {
                                    Set<string> mMapShipmentssKey = mMapShipmentss.keySet();
                                    for(string m:mMapShipmentssKey)
                                    {
                                        if(m!=sNumId[7])
                                        {
                                            //system.debug('sShipments发货信息 :'+sShipments);
                                            mMapShipmentss.put(sNumId[7],sShipments);
                                        }
                                    }
                                }
                                else
                                {
                                    //system.debug('sShipments发货信息 :'+sShipments);
                                    mMapShipmentss.put(sNumId[7],sShipments);
                                }
                            }
                            
                        }   
                }
             }
             list<Shipments__c> mapShipmentssTwo=new list<Shipments__c>();
             if(mMapShipmentss.size()>0)
             {
                 Set<string> mMapShipmentssKeyTwo = mMapShipmentss.keySet();
                
                 for(string m:mMapShipmentssKeyTwo)
                 {
                     system.debug('m:'+m);
                    mapShipmentssTwo.add(mMapShipmentss.get(m));
                 }
                 system.debug('mapShipmentssTwo的信息是：'+mapShipmentssTwo);
                 insert mapShipmentssTwo;   //添加发货信息
             }
            list<Shipments__c> oldUpdateShipmentssKey=new list<Shipments__c>();
            if(mMapAleryShipmentss.size()>0)
            {
                set<string> oldlistShipmentsId=mMapAleryShipmentss.keySet();
                for(string x:oldlistShipmentsId)
                {
                    oldUpdateShipmentssKey.add(mMapAleryShipmentss.get(x));
                }
                update oldUpdateShipmentssKey;
            }

             //发货单号对应发货id SendProductData
             list<Shipments__c> listShipments =[select n_SendOrderNo__c,Id from Shipments__c where n_SendOrderNo__c in: SendProductData];
             map<string,Id> ShipmentsId=new map<string,Id>();
             for(Shipments__c s:listShipments)
             {
                ShipmentsId.put(s.n_SendOrderNo__c,s.Id);
             }
             Set<string> Shipmentskey = ShipmentsId.keySet();
             for(string s:Shipmentskey)
             {
                //system.debug('发货单号对应的发货id'+ShipmentsId.get(s));
             }
             
              
              map<string,ShippingDetails__c> mapShippingDetailss =new map<string,ShippingDetails__c>();
              map<string,ShippingDetails__c> mapShippingDetailssOld=new map<string,ShippingDetails__c>();
             for(string f:ff)
             {
                string[] ss=f.split(',');
                for(string s:ss)
                {
                    string[] sNumId=s.split('§');
                    //-- 订单号0 +序列号1+产品2+定制型号3+客户简称4+软件版本号5+序列号数量6+发货单号7+日期8+数量    9
                    ShippingDetails__c sShipments = new ShippingDetails__c();
                    //订单号获取订单id 订单id获取发货id
                    sShipments.n_Shipmentname__c=ShipmentsId.get(sNumId[7]);  //发货id
                    sShipments.n_Products__c=ProductDataProduct.get(sNumId[2]);     //产品id
                    sShipments.ShipDetails__c=sNumId[12];  //发货明细对应的u8 id
                    sShipments.ordersSum__c=double.valueOf(sNumId[9]);//数量
                    //mapShipDetailsDataId,mapOldDataShippingDetails
                    
                     if(sShipments.n_Shipmentname__c != null)
                     {
                        if(mapShipDetailsDataId.get(sNumId[12])!=null)
                        {
                            ShippingDetails__c sShipmentsDataOld =mapOldDataShippingDetails.get(mapShipDetailsDataId.get(sNumId[12]));
                            //订单号获取订单id 订单id获取发货id
                            //sShipmentsDataOld.n_Shipmentname__c=ShipmentsId.get(sNumId[7]);  //发货id
                            sShipmentsDataOld.n_Products__c=ProductDataProduct.get(sNumId[2]);     //产品id
                            sShipmentsDataOld.ShipDetails__c=sNumId[12];  //发货明细对应的u8 id
                            sShipmentsDataOld.ordersSum__c=double.valueOf(sNumId[9]);//数量
                            if(mapShippingDetailssOld.size()>0)
                            {
                                 Set<string> ShipmentskeyDetailssaOld = mapShippingDetailssOld.keySet();
                                 for(string m:ShipmentskeyDetailssaOld)
                                 {
                                    if(m!=sNumId[12])
                                    {
                                        mapShippingDetailssOld.put(sNumId[12],sShipmentsDataOld);
                                    }
                                 }
                            }
                            else
                            {
                                //system.debug('sShipments发货明细 :'+sShipments);
                                mapShippingDetailssOld.put(sNumId[12],sShipmentsDataOld);
                            }
                            //
                        }
                        else
                        {
                            if(mapShippingDetailss.size()>0)
                            {
                                 Set<string> ShipmentskeyDetailssa = mapShippingDetailss.keySet();
                                 for(string m:ShipmentskeyDetailssa)
                                 {
                                    if(m!=sNumId[12])
                                    {
                                       // system.debug('sShipments发货明细 :'+sShipments);
                                        mapShippingDetailss.put(sNumId[12],sShipments);
                                    }
                                 }
                            }
                            else
                            {
                                //system.debug('sShipments发货明细 :'+sShipments);
                                mapShippingDetailss.put(sNumId[12],sShipments);
                            }
                        }
                        
                     }
                }
             }
              
              list<ShippingDetails__c> ShippingDetailss=new list<ShippingDetails__c>();
              if(mapShippingDetailss.size()>0)
              {
                 Set<string> ShipmentskeyDetailssaTwo = mapShippingDetailss.keySet();
                 for(string m:ShipmentskeyDetailssaTwo)
                 {
                    ShippingDetailss.add(mapShippingDetailss.get(m));
                 }
               //  system.debug('ShippingDetailss发货明细汇总 :'+ShippingDetailss);
                insert ShippingDetailss; //添加发货明细
              }
              //mapShippingDetailssOld
               list<ShippingDetails__c> ShippingDetailssOld=new list<ShippingDetails__c>();
              if(mapShippingDetailssOld.size()>0)
              {
                 Set<string> ShipmentskeyDetailssaTwo = mapShippingDetailssOld.keySet();
                 for(string m:ShipmentskeyDetailssaTwo)
                 {
                    ShippingDetailssOld.add(mapShippingDetailssOld.get(m));
                 }
                 update ShippingDetailssOld;
              }
              
             
              //获取发货明细id ShipDetailsIdData
              list<ShippingDetails__c> listProductSN=[select ShipDetails__c,Id from ShippingDetails__c where ShipDetails__c in: ShipDetailsData];
             map<string,id> mapProductSN=new map<string,id>();  //发货明细Id
             for(ShippingDetails__c s:listProductSN)
             {
                mapProductSN.put(s.ShipDetails__c,s.Id);
             }
          
            string OrdersNum=null;
             
         
              Set<string> ProductSnkey = mapProductSN.keySet();
             for(string s:ProductSnkey)
             {
               // system.debug('发货id对应的发货明细id'+mapProductSN.get(s));
             }
              
              map<string,ProductSN__c> mapProductSNBt =new map<string,ProductSN__c>();
               map<string,ProductSN__c> mapOldProductSNBt =new map<string,ProductSN__c>();
               
             for(string f:ff)
             {
                string[] ss=f.split(',');
                for(string s:ss)
                {
                    string[] sNumId=s.split('§');
                    //-- 订单号0 +序列号1+产品2+定制型号3+客户简称4+软件版本号5+序列号数量6+发货单号7+日期8+数量    9
                    if(sNumId[1] !='' && sNumId[1]!=null)
                    {
                        ProductSN__c sShipments = new ProductSN__c();
                        sShipments.Name=sNumId[1];//序列号
                        sShipments.n_Production__c=ProductDataProduct.get(sNumId[2]);//产品名称
                        sShipments.CustomModels__c=sNumId[3];//定制型号
                        sShipments.shipmentdetile__c=mapProductSN.get(string.valueOf(sNumId[12]));//发货明细id
                        sShipments.SerialNumberId__c=sNumId[11];
                        sShipments.coustmer__c=ClientDataProduct.get(sNumId[4]); //客户
                        sShipments.AccountSaleArea__c=mapSalesRegion.get(sNumId[10]); //客户所在部门
                        sShipments.Version__c=sNumId[5]; //软件版本号
                        sShipments.Quantity__c=double.valueOf(sNumId[6]); //数量
                        //sShipments.SelaOrder__c=SegmentationDataOrders.get(sNumId[0]); //订单
                        if(mapDeviceType.get(sNumId[0])!=null && mapDeviceType.get(sNumId[0])!='')
                        {
                            sShipments.ProductCategory__c=DeviceTypeCategory.get(mapDeviceType.get(sNumId[0])).ProductCategory__c;//设备类别
                            sShipments.ProductStatus__c=DeviceTypeCategory.get(mapDeviceType.get(sNumId[0])).ProductStatus__c;  //设备状态
                            if(mapDeviceType.get(sNumId[0])=='内部样机订单')
                            {
                                 sShipments.PrototypeStatus__c='空闲';
                            }
                        }
                        if(SegmentationDataOrders.get(sNumId[0]) != null)
                        {
                           // system.debug('sShipments序列号:'+sShipments);
                            if(mapGetSFOldSerialNumber.get(sNumId[1])==null)
                            {
                                
                                //ProductSNss.add(sShipments);
                                if(mapProductSNBt.size()>0)
                                {
                                    Set<string> ShipmentskeyProductSN = mapProductSNBt.keySet();
                                     for(string m:ShipmentskeyProductSN)
                                     {
                                        if(m!=sNumId[1])
                                        {
                                            //system.debug('sShipments发货明细 :'+sShipments);
                                            mapProductSNBt.put(sNumId[1],sShipments);
                                        }
                                     }
                                }
                                else
                                {
                                    mapProductSNBt.put(sNumId[1],sShipments);
                                }
                            }
                            else
                            {
                                //oldmapGetSFOldSerialNumber
                                ProductSN__c sShipmentsOld =oldmapGetSFOldSerialNumber.get(mapGetSFOldSerialNumber.get(sNumId[1]));
                                sShipmentsOld.Name=sNumId[1];//序列号
                                sShipmentsOld.n_Production__c=ProductDataProduct.get(sNumId[2]);//产品名称
                                sShipmentsOld.CustomModels__c=sNumId[3];//定制型号
                                sShipmentsOld.shipmentdetile__c=mapProductSN.get(string.valueOf(sNumId[12]));//发货明细id
                                sShipmentsOld.SerialNumberId__c=sNumId[11];
                                sShipmentsOld.coustmer__c=ClientDataProduct.get(sNumId[4]); //客户
                                sShipmentsOld.AccountSaleArea__c=mapSalesRegion.get(sNumId[10]); //客户所在部门
                                sShipmentsOld.Version__c=sNumId[5]; //软件版本号
                                sShipmentsOld.Quantity__c=double.valueOf(sNumId[6]); //数量
                                //sShipments.SelaOrder__c=SegmentationDataOrders.get(sNumId[0]); //订单
                                if(mapDeviceType.get(sNumId[0])!=null && mapDeviceType.get(sNumId[0])!='')
                                {
                                    sShipmentsOld.ProductCategory__c=DeviceTypeCategory.get(mapDeviceType.get(sNumId[0])).ProductCategory__c;//设备类别
                                    sShipmentsOld.ProductStatus__c=DeviceTypeCategory.get(mapDeviceType.get(sNumId[0])).ProductStatus__c;  //设备状态
                                    if(mapDeviceType.get(sNumId[0])=='内部样机订单')
                                    {
                                        sShipmentsOld.PrototypeStatus__c='空闲';
                                    }
                                }
                                if(mapOldProductSNBt.size()>0)
                                {
                                    Set<string> ShipmentsOldkeyProductSN = mapOldProductSNBt.keySet();
                                     for(string m:ShipmentsOldkeyProductSN)
                                     {
                                        if(m!=sNumId[1])
                                        {
                                            //system.debug('sShipments发货明细 :'+sShipments);
                                            mapOldProductSNBt.put(sNumId[1],sShipmentsOld);
                                        }
                                     }
                                }
                                else
                                {
                                    mapOldProductSNBt.put(sNumId[1],sShipmentsOld);
                                }
                                
                            }
                        }
                    }
                }
             }
             if(mapProductSNBt.size()>0)
             {
                 list<ProductSN__c> ProductSNss=new list<ProductSN__c>();
                 Set<string> ProductSNssTwo = mapProductSNBt.keySet();
                 for(string m:ProductSNssTwo)
                 {
                    ProductSNss.add(mapProductSNBt.get(m));
                 }
                  system.debug('ProductSNss序列号 :'+ProductSNss);
                 insert ProductSNss;  //添加序列号
             }  
             
             if(mapOldProductSNBt.size()>0)
             {
                 list<ProductSN__c> OldProductSNss=new list<ProductSN__c>();
                 Set<string> ProductSNssOldTwo = mapOldProductSNBt.keySet();
                 for(string m:ProductSNssOldTwo)
                 {
                    OldProductSNss.add(mapOldProductSNBt.get(m));
                 }
                 
             }
             
             //获取序列号id
             list<ProductSN__c> listSendProSNss=[select Name,Id from ProductSN__c where Name in: ProductSNData];
             map<string,id> mapSendProSN=new map<string,id>();
             for(ProductSN__c s:listSendProSNss)
             {
                mapSendProSN.put(s.Name,s.Id);
             }
             
            map<string,SendProSN__c> mapSendProSNOnly=new map<string,SendProSN__c>();
            map<string,SendProSN__c> mapOldSendProSNOnly=new map<string,SendProSN__c>();
             for(string f:ff)
             {
                string[] ss=f.split(',');
                for(string s:ss)
                {
                    string[] sNumId=s.split('§');
                    //-- 订单号0 +序列号1+产品2+定制型号3+客户简称4+软件版本号5+序列号数量6+发货单号7+日期8+数量    9
                    if(sNumId[1] !='' && sNumId[1]!=null)
                    {
                        SendProSN__c sShipments = new SendProSN__c();
                        sShipments.S_Order__c=SegmentationDataOrders.get(sNumId[0]); //订单
                        sShipments.S_ShippingDetails__c=mapProductSN.get(string.valueOf(sNumId[12]));//发货明细
                        sShipments.S_Client__c=ClientDataProduct.get(sNumId[4]); //客户
                        sShipments.S_area__c=mapSalesRegion.get(sNumId[10]); //销售部门
                        sShipments.S_SN__c=mapSendProSN.get(sNumId[1]);      //序列号
                        if(mapDeviceType.get(sNumId[0])!=null && mapDeviceType.get(sNumId[0])!='')
                        {
                            sShipments.S_ProductCategory__c=DeviceTypeCategory.get(mapDeviceType.get(sNumId[0])).ProductCategory__c;//设备类别
                            sShipments.S_ProductStatus__c=DeviceTypeCategory.get(mapDeviceType.get(sNumId[0])).ProductStatus__c;  //设备状态
                            
                        }   
                        if(sShipments.S_Order__c !=null)
                        {
                            //system.debug('sShipments发货明细Sn:'+sShipments);
                            if(mapGetSFOldSerialNumber.get(sNumId[1])==null)
                            {
                                if(mapSendProSNOnly.size()>0)
                                {
                                    Set<string> SendProSNOnly = mapSendProSNOnly.keySet();
                                         for(string m:SendProSNOnly)
                                         {
                                            if(m!=sNumId[1])
                                            {
                                                //system.debug('sShipments发货明细 :'+sShipments);
                                                mapSendProSNOnly.put(sNumId[1],sShipments);
                                            }
                                         }
                                }
                                else
                                {
                                    mapSendProSNOnly.put(sNumId[1],sShipments);
                                }
                            }
                            else
                            {
                                //mapOldSendProSNOnly
                                system.debug('--------------mapGetSFOldSerialNumber.get(sNumId[1])--------'+mapGetSFOldSerialNumber.get(sNumId[1]));
                                system.debug('mapShipDetailsSnOld.get(mapGetSFOldSerialNumber.get(sNumId[1]))的信息值是：'+mapShipDetailsSnOld.get(mapGetSFOldSerialNumber.get(sNumId[1])));
                                SendProSN__c sShipmentsOldData =napOldSendProSNData.get(mapShipDetailsSnOld.get(mapGetSFOldSerialNumber.get(sNumId[1])));
                                system.debug('sShipmentsOldData的值是：'+sShipmentsOldData);
                                system.debug('sNumId[0]发货明细SN中：'+sNumId[0]);
                                system.debug('SegmentationDataOrders.get(sNumId[0])的信息是：'+SegmentationDataOrders.get(sNumId[0]));
                                sShipmentsOldData.S_Order__c=SegmentationDataOrders.get(sNumId[0]); //订单 
                                sShipmentsOldData.S_ShippingDetails__c=mapProductSN.get(string.valueOf(sNumId[12]));//发货明细
                                sShipmentsOldData.S_Client__c=ClientDataProduct.get(sNumId[4]); //客户
                                sShipmentsOldData.S_area__c=mapSalesRegion.get(sNumId[10]); //销售部门
                                sShipmentsOldData.S_SN__c=mapSendProSN.get(sNumId[1]);      //序列号
                                if(mapDeviceType.get(sNumId[0])!=null && mapDeviceType.get(sNumId[0])!='')
                                {
                                    sShipmentsOldData.S_ProductCategory__c=DeviceTypeCategory.get(mapDeviceType.get(sNumId[0])).ProductCategory__c;//设备类别
                                    sShipmentsOldData.S_ProductStatus__c=DeviceTypeCategory.get(mapDeviceType.get(sNumId[0])).ProductStatus__c;  //设备状态
                                }
                                //mapShipDetailsSnOld   
                                if(mapOldSendProSNOnly.size()>0)
                                {
                                    Set<string> OldSendProSNOnly = mapOldSendProSNOnly.keySet();
                                         for(string m:OldSendProSNOnly)
                                         {
                                            if(m!=sNumId[1])
                                            {
                                                //system.debug('sShipments发货明细 :'+sShipments);
                                                mapOldSendProSNOnly.put(sNumId[1],sShipmentsOldData);
                                            }
                                         }
                                }
                                else
                                {
                                    mapOldSendProSNOnly.put(sNumId[1],sShipmentsOldData);
                                }
                            }
                            
                        }
                    }
                }
             }
             //system.debug('SendProSNss发货明细Sn汇总:'+SendProSNss);
             if(mapSendProSNOnly.size()>0)
             {
                list<SendProSN__c> SendProSNss=new list<SendProSN__c>();
                
                 Set<string> SendProSNssNssTwo = mapSendProSNOnly.keySet();
                 for(string m:SendProSNssNssTwo)
                 {
                    SendProSNss.add(mapSendProSNOnly.get(m));
                 }
                //SendProSNss.add();
                insert SendProSNss;
             }
            if(mapOldSendProSNOnly.size()>0)
            {
                list<SendProSN__c> SendProSNssData=new list<SendProSN__c>();
                
                 Set<string> SendProSNssNssDataTwo = mapOldSendProSNOnly.keySet();
                 for(string m:SendProSNssNssDataTwo)
                 {
                    SendProSNssData.add(mapOldSendProSNOnly.get(m));
                 }
                 update SendProSNssData;
            }
              set<string> ShippingDetailsDataa=new set<string>();
              
              set<string> OrderNumJ=ShipmentsId.keySet();
              for(string s:OrderNumJ)
              {
                    ShippingDetailsDataa.add(ShipmentsId.get(s));
              }
              
             list<ShippingDetails__c> listShippingDetailsSN=[select n_Shipmentname__c,Id from ShippingDetails__c where n_Shipmentname__c in: ShippingDetailsDataa];
             map<string,id> mapShippingDetailsSN=new map<string,id>();  //发货明细Id
             for(ShippingDetails__c s:listShippingDetailsSN)
             {
                system.debug('s.n_Shipmentname__c:'+s.n_Shipmentname__c);
                system.debug('s.n_Shipmentname__c:'+s);
                mapShippingDetailsSN.put(s.n_Shipmentname__c,s.Id);
             }
             for(string s:OrderNumJ)
             {
                system.debug('添加成功后返回s:'+s);
             
                
                if(mapShippingDetailsSN.get(ShipmentsId.get(s))!=null)
                {
                    if(OrdersNum !=null && OrdersNum !='')
                    {
                        OrdersNum=OrdersNum+'+'+s;
                    }
                    else
                    { 
                        OrdersNum=s;
                    }
                    
                }
             } 
            system.debug('添加成功后返回:'+OrdersNum);
           return OrdersNum;
    }
    
    global void finish(Database.BatchableContext ctx)
   {    
           system.debug('执行调用：');
          system.debug('执行调用ctx集合的值是：'+ctx);
          system.debug('OrdersNumDatas:'+OrdersNumDatas);
         Id batchInstanceId = Database.executeBatch(new UpdatesShipAsynchronReturnValue(OrdersNumDatas), 10);   
         
    }
}