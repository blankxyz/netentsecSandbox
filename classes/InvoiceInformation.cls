/*
*RogerSun
*2013-05-21
*U8发票信息同步至salesforce
*/
global class  InvoiceInformation implements Database.Batchable<SObject>, Database.AllowsCallouts,Database.Stateful
{
     global String OrdersNumDatas;
     global Database.queryLocator start(Database.BatchableContext ctx)
     {
           return Database.getQueryLocator([Select id from Invoice__c limit 100]); 
     }
     global void execute(Database.BatchableContext ctx, List<Invoice__c> scope)
     {
          WSDLInvoiceInformation.ArrayOfString b=new WSDLInvoiceInformation.ArrayOfString();
        WSDLInvoiceInformation.InvoiceInformationSoap InstantiatedWsdl=new WSDLInvoiceInformation.InvoiceInformationSoap();
        InstantiatedWsdl.timeout_x=120000;
        b=InstantiatedWsdl.InvoiceInformationValue();
        system.debug('获取传入值信息b:'+b);
        
        if(b!=null)
        {
            
            OrdersNumDatas=OperatorInvoiceInformations(b);
             system.debug('返回发票单号OrdersNumDatas :'+OrdersNumDatas);
        }
        else
        {
            system.debug('没有同步数据');
        }
     }
     /*
global class  InvoiceInformation
{
    @Future(callout=true)
    public static void InvoiceOperate()
    {
        WSDLInvoiceInformation.ArrayOfString b=new WSDLInvoiceInformation.ArrayOfString();
        WSDLInvoiceInformation.InvoiceInformationSoap InstantiatedWsdl=new WSDLInvoiceInformation.InvoiceInformationSoap();
        InstantiatedWsdl.timeout_x=120000;
        b=InstantiatedWsdl.InvoiceInformationValue();
        system.debug('获取传入值信息b:'+b);
        
        if(b!=null)
        {
            string arrayAValue=null;
            arrayAValue=OperatorInvoiceInformations(b);
             system.debug('返回发票单号arrayAValue :'+arrayAValue);
             //InvoiceInformationReturnValue.InvoiceInformationsValue(arrayAValue);
             InstantiatedWsdl.InvoiceInformationReturnValue(arrayAValue);//返回是否同步状态 
        }
        else
        {
            system.debug('没有同步数据');
        }
    }
    */
    public static string OperatorInvoiceInformations(WSDLInvoiceInformation.ArrayOfString b)
    {
            string[] ff=b.string_x;
            system.debug('获取传入值信息ff :'+ff);
            set<string> ProductData=new set<string>();       //产品
            set<string> ClientData=new set<string>();        //客户
            set<string> OrdersData=new set<string>();  //订单号
            set<string> InvoiceData=new set<string>(); //发票编号
            set<string> onlyInvoice=new set<string>();  //发票明细唯一标识
            for(string f:ff)
            {
                string[] ss=f.split(',');
                system.debug('按照逗号分隔后的数是ss :'+ss);
                for(string s:ss)
                {
                    string[] NumData=s.split('§');
                        //发票号0,发票类型1,开票时间2,发票备注3,客户4,产品5,数量6,
                    //含税单价7,金额8 ,发票明细备注9,发票明细唯一标识10,唯一值11,订单编号12,发票总金额13
                    if(NumData[4]!=null)
                    {
                        ClientData.add(NumData[4]);  //客户
                    }
                    if(NumData[5]!=null)
                    {
                        ProductData.add(NumData[5]);//产品
                    }
                    if(NumData[12]!=null)
                    {
                        OrdersData.add(NumData[12]);//订单编号  
                    }
                    
                    
                    InvoiceData.add(NumData[0]);
                    onlyInvoice.add(NumData[10]);
                }
            }
            //检测发票是否已经存储在系统中
            system.debug(InvoiceData); 
            list<Invoice__c> InvoiceOldData=[select Name,id from Invoice__c where Name in:InvoiceData];
            
            system.debug('--------------------InvoiceOldData--------------'+InvoiceOldData); 
            map<string,id>  mapOldInvoice=new map<string,id>();
            for(Invoice__c s:InvoiceOldData)
            {
                mapOldInvoice.put(s.Name,s.Id);
            }
            system.debug('----------------------mapOldInvoice------------------'+mapOldInvoice);
            //检测发票明细是否已经存在系统中
            list<InvoiceDetails__c> onlyInvoiceOldInformation=[select id,onlyInvoice__c from InvoiceDetails__c where onlyInvoice__c in:onlyInvoice];
            map<string,id> mapOldonlyInvoice=new map<string,id>();
            for(InvoiceDetails__c s:onlyInvoiceOldInformation)
            {
                mapOldonlyInvoice.put(s.onlyInvoice__c,s.id);
            }
            
            
            //客户对应的id
             list<Account> listAccount=[select Name,Id from Account where Name in: ClientData];
             map<string,Id> ClientDataNameForId=new map<string,Id>();
             for(Account s:listAccount)
             {
                ClientDataNameForId.put(s.Name,s.Id);
             }
             
              //产品对应的id
             list<Product2> listProduct2=[select Name,Id from Product2 where Name in: ProductData];
              map<string,Id> ProductDataProductForId=new map<string,Id>();
              for(Product2 s:listProduct2)
              {
                  ProductDataProductForId.put(s.Name,s.Id);
              }
              //订单对应的id
              list<Orders__c> listOrders=[select OrderNum__c,Id from Orders__c where OrderNum__c in: OrdersData];
             map<string,Id> OrdersDataOrdersForId=new map<string,Id>();
             for(Orders__c s:listOrders)
             {
                OrdersDataOrdersForId.put(s.OrderNum__c,s.Id);
                system.debug('订单对应的订单编号s.OrderNum__c :'+s.OrderNum__c);
                system.debug('订单对应的订单编号id s.Id :'+s.Id);
             }
             
           map<id,Invoice__c>  mapOldAlready=new map<id,Invoice__c>([select Name,id,n_InvoiceDate__c,n_Customer__c,n_InvoiceClass__c,n_Remark__c,n_CountAmount__c from Invoice__c where Name in:InvoiceData]);
           map<string,Invoice__c> mapInvoiceData =new map<string,Invoice__c>();
           map<string,Invoice__c> oldMapUpdateShipmentssKey=new map<string,Invoice__c>();
            for(string f:ff)
            {
                string[] ss=f.split(',');
                for(string s:ss)
                {
                    string[] NumData=s.split('§');
                        //发票号0,发票类型1,开票时间2,发票备注3,客户4,产品5,数量6,
                    //含税单价7,金额8 ,发票明细备注9,发票明细唯一标识10,唯一值11,订单编号12,发票总金额13
                    Invoice__c invoce=new Invoice__c();
                    invoce.Name=NumData[0];  //发票编号
                    invoce.n_InvoiceDate__c=date.valueOf(NumData[2]); //发票日期
                    if(NumData[4]!=null)
                    {
                        invoce.n_Customer__c=ClientDataNameForId.get(NumData[4]);//客户
                    }
                    invoce.n_InvoiceClass__c=NumData[1];  //发票类型
                    invoce.n_Remark__c=NumData[3];      //备注
                    invoce.n_CountAmount__c=Decimal.valueOf(NumData[13]); //发票总金额
                    if(mapOldInvoice.get(NumData[0])!=null)
                    {
                        //mapOldAlreadySendProduct.remove(AlreadySendProduct.get(sNumId[7]));
                                    //mapOldAlreadySendProduct.put(AlreadySendProduct.get(sNumId[7]),sShipments);
                            //mapOldAlready.remove(mapOldInvoice.get(NumData[0]));
                            Invoice__c invoceOld=mapOldAlready.get(mapOldInvoice.get(NumData[0]));
                            invoceOld.Name=NumData[0];  //发票编号
                            invoceOld.n_InvoiceDate__c=date.valueOf(NumData[2]); //发票日期
                            if(NumData[4]!=null)
                            {
                                invoceOld.n_Customer__c=ClientDataNameForId.get(NumData[4]);//客户
                            }
                            invoceOld.n_InvoiceClass__c=NumData[1];  //发票类型
                            invoceOld.n_Remark__c=NumData[3];      //备注
                            invoceOld.n_CountAmount__c=Decimal.valueOf(NumData[13]); //发票总金额
                            if(oldMapUpdateShipmentssKey.size()>0)
                            {
                                Set<string> oldMapShipmentssKey = oldMapUpdateShipmentssKey.keySet();
                                for(string mm:oldMapShipmentssKey)
                                {
                                    if(mm!=NumData[0])
                                    {
                                        
                                        oldMapUpdateShipmentssKey.put(NumData[0],invoceOld);
                                    }
                                }
                            }
                            else
                            {
                                oldMapUpdateShipmentssKey.put(NumData[0],invoceOld);
                            }
                                
                    }
                    else
                    {
                        if(mapInvoiceData.size()>0)
                        {
                            Set<string> mMapShipmentssKey = mapInvoiceData.keySet();
                            for(string m:mMapShipmentssKey)
                            {
                                if(m!=NumData[0])
                                {
                                    
                                    mapInvoiceData.put(NumData[0],invoce);
                                }
                            }
                        }
                        else
                        {
                            
                            mapInvoiceData.put(NumData[0],invoce);
                        }
                    }
                    
                }
                
            }
             list<Invoice__c> mapShipmentssTwo=new list<Invoice__c>();
             if(mapInvoiceData.size()>0)
             {
                 Set<string> mMapShipmentssKeyTwo = mapInvoiceData.keySet();
                 for(string m:mMapShipmentssKeyTwo)
                 {
                    mapShipmentssTwo.add(mapInvoiceData.get(m));
                    system.debug('添加发票信息mapInvoiceData.get(m) :'+mapInvoiceData.get(m));
                 }
                 insert mapShipmentssTwo;   //添加发票信息
             }
            
            if(oldMapUpdateShipmentssKey.size()>0)
            {
                list<Invoice__c> oldlistUpdateShipmentssKey=new list<Invoice__c>();
                set<string> anh=oldMapUpdateShipmentssKey.keySet();
                 for(string ab:anh)
                 {
                    oldlistUpdateShipmentssKey.add(oldMapUpdateShipmentssKey.get(ab));
                 }
                update oldlistUpdateShipmentssKey;
            }
            
            
             //查询刚添加发票编号对应的发票id
              list<Invoice__c> listInvoice=[select Name,Id from Invoice__c where Name in: InvoiceData];
             map<string,Id> InvoiceDataInvoiceForId=new map<string,Id>();
             for(Invoice__c s:listInvoice)
             {
                InvoiceDataInvoiceForId.put(s.Name,s.Id);
                system.debug('发票信息Name :'+s.Name);
                system.debug('发票信息id :'+s.id);
             }
            map<id,InvoiceDetails__c> mapOldInvoiceDetails =new map<id,InvoiceDetails__c>([select id,OrderId__c,n_Remark__c,n_Product__c,n_ProductsNumber__c,n_ContractedPrice__c,n_InvoiceId__c from InvoiceDetails__c where onlyInvoice__c in:onlyInvoice]);
             map<string,InvoiceDetails__c> mapInvoiceDetails=new map<string,InvoiceDetails__c>();
             map<string,InvoiceDetails__c> oldMapInvoiceDetailsKey=new map<string,InvoiceDetails__c>();
             for(string f:ff)
             {
                string[] ss=f.split(',');
                for(string s:ss)
                {
                    string[] NumData=s.split('§');
                        //发票号0,发票类型1,开票时间2,发票备注3,客户4,产品5,数量6,
                    //含税单价7,金额8 ,发票明细备注9,发票明细唯一标识10,唯一值11,订单编号12,发票总金额13
                    InvoiceDetails__c InvoiceDetails=new InvoiceDetails__c();
                    InvoiceDetails.OrderId__c=OrdersDataOrdersForId.get(NumData[12]);    //订单编号
                    system.debug('发票明细s :'+S);  
                    system.debug('添加发票明细时的订单编号 :'+NumData[12]);
                    system.debug('添加发票明细时的订单编号 :'+InvoiceDetails.OrderId__c);       
                    if(InvoiceDetails.OrderId__c !=null)
                    {
                        InvoiceDetails.n_Remark__c=NumData[9];//备注
                        if(NumData[5]!=null)
                        {
                            InvoiceDetails.n_Product__c=ProductDataProductForId.get(NumData[5]); //产品
                            system.debug('InvoiceDetails.n_Product__c :'+InvoiceDetails.n_Product__c);  
                        }
                        InvoiceDetails.onlyInvoice__c=NumData[10];//发票明细Id
                        InvoiceDetails.n_ProductsNumber__c=Decimal.valueOf(NumData[6]) ;//产品数量
                        
                        InvoiceDetails.n_ContractedPrice__c=Decimal.valueOf(NumData[7]);//成交价                   system.debug('订单编号NumData[0]:'+NumData[0]);
                        if(NumData[12]!=null && NumData[12]!='')
                        {
                            InvoiceDetails.OrderId__c=OrdersDataOrdersForId.get(NumData[12]);    //订单编号
                            system.debug('订单编号对应的id:'+InvoiceDetails.OrderId__c);
                            system.debug('订单编号对应的id:'+OrdersDataOrdersForId.get(NumData[12]));
                        }
                        
                        if(NumData[0]!=null && NumData[0]!='')
                        {
                            InvoiceDetails.n_InvoiceId__c=InvoiceDataInvoiceForId.get(NumData[0]); //发票id
                            system.debug('发票对应的InvoiceDetails.n_InvoiceId__c:'+OrdersDataOrdersForId.get(NumData[12]));
                            system.debug('发票对应的InvoiceDetails.n_InvoiceId__c:'+InvoiceDetails.n_InvoiceId__c);
                        }
                        if(InvoiceDetails.n_InvoiceId__c !=null)
                        { 
                            system.debug('InvoiceDetails.n_InvoiceId__c不为空');
                            if(mapOldonlyInvoice.get(NumData[10])!=null)
                            {
                                system.debug('mapOldonlyInvoice.get(NumData[10]:'+mapOldonlyInvoice.get(NumData[10]));
                                InvoiceDetails__c InvoiceDetailsOldData=mapOldInvoiceDetails.get(mapOldonlyInvoice.get(NumData[10]));
                                InvoiceDetails.n_Remark__c=NumData[9];//备注
                                if(NumData[5]!=null)
                                {
                                    InvoiceDetailsOldData.n_Product__c=ProductDataProductForId.get(NumData[5]); //产品
                                }
                                InvoiceDetailsOldData.n_ProductsNumber__c=Decimal.valueOf(NumData[6]) ;//产品数量
                                
                                InvoiceDetailsOldData.n_ContractedPrice__c=Decimal.valueOf(NumData[7]);//成交价                    system.debug('订单编号NumData[0]:'+NumData[0]);
                                /*
                                if(NumData[12]!=null && NumData[12]!='')
                                {
                                    InvoiceDetailsOldData.OrderId__c=OrdersDataOrdersForId.get(NumData[12]);    //订单编号
                                }
                                 
                                if(NumData[0]!=null && NumData[0]!='')
                                {
                                    InvoiceDetailsOldData.n_InvoiceId__c=InvoiceDataInvoiceForId.get(NumData[0]); //发票id
                                }
                                */
                                if(oldMapInvoiceDetailsKey.size()>0)
                                {
                                    Set<string> mmMapShipmentssKey = oldMapInvoiceDetailsKey.keySet();
                                    for(string mm:mmMapShipmentssKey)
                                    {
                                        if(mm!=NumData[11])
                                        {
                                            system.debug('唯一值 :'+NumData[11]);
                                            oldMapInvoiceDetailsKey.put(NumData[11],InvoiceDetailsOldData);
                                        }
                                    }
                                }
                                else
                                {
                                    
                                    oldMapInvoiceDetailsKey.put(NumData[11],InvoiceDetailsOldData);
                                }
                                //oldMapInvoiceDetailsKey
                                //mapOldInvoiceDetails.remove(mapOldonlyInvoice.get(NumData[10]));
                                //mapOldInvoiceDetails.put(mapOldonlyInvoice.get(NumData[10]),InvoiceDetails);
                            }
                            else
                            {
                                if(mapInvoiceDetails.size()>0)
                                {
                                    Set<string> mMapShipmentssKey = mapInvoiceDetails.keySet();
                                    for(string m:mMapShipmentssKey)
                                    {
                                        if(m!=NumData[11])
                                        {
                                            system.debug('唯一值 :'+NumData[11]);
                                            mapInvoiceDetails.put(NumData[11],InvoiceDetails);
                                        }
                                    }
                                }
                                else
                                {
                                    
                                    mapInvoiceDetails.put(NumData[11],InvoiceDetails);
                                }
                            }
                            
                        }
                    }
                }
             }
             list<InvoiceDetails__c> mapInvoiceDetailsAdd=new list<InvoiceDetails__c>();
             if(mapInvoiceDetails.size()>0)
             {
                 Set<string> mMapShipmentssKeyTwo = mapInvoiceDetails.keySet();
                 for(string m:mMapShipmentssKeyTwo)
                 {
                    system.debug('添加发票明细mapInvoiceDetails.get(m) :'+mapInvoiceDetails.get(m));  
                    mapInvoiceDetailsAdd.add(mapInvoiceDetails.get(m));
                 }
                 try{
	                 insert mapInvoiceDetailsAdd;   //添加发票明细信息
                 }catch(Exception e){
			
				}
             }
            
            if(oldMapInvoiceDetailsKey.size()>0)
            {
                list<InvoiceDetails__c> oldInvoiceDetailsKey=new list<InvoiceDetails__c>();
                set<string> listOldInvoiceDetailsKey=oldMapInvoiceDetailsKey.keySet();
                for(string mn:listOldInvoiceDetailsKey)
                {
                    oldInvoiceDetailsKey.add(oldMapInvoiceDetailsKey.get(mn));
                }
                update oldInvoiceDetailsKey;
            }
            
             
             string arrayAValue=null;
             set<string> setArray=InvoiceDataInvoiceForId.keySet();
             for(string s:setArray)
             {
                if(InvoiceDataInvoiceForId.get(s)!=null)
                {
                    If(arrayAValue !=null && arrayAValue !='')
                    {
                        arrayAValue=arrayAValue+','+s;
                        system.debug('返回发票单号s :'+s);    
                    }
                    else
                    {
                        arrayAValue=s;
                    }
                    
                }
             }
             return arrayAValue;
    }
    global void finish(Database.BatchableContext ctx)
   {    
           system.debug('执行调用：');
          system.debug('执行调用ctx集合的值是：'+ctx);
          system.debug('OrdersNumDatas:'+OrdersNumDatas);
         Id batchInstanceId = Database.executeBatch(new InvoiceInformationReturnValue(OrdersNumDatas), 50);   
         
    }
    
}