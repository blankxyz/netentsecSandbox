//新增 发货明细SN对象（SendProSN__c）自动更新序列号(状态,客户,订单),订单自动为当前发货明细sn的订单
//lurrykong
//2013.4.16
trigger SendProSN_Insert on SendProSN__c (before insert,before update) 
{
    if(trigger.isInsert||trigger.isUpdate)
    {
        set<id> setSNid=new set<id>();                                  //序列号id
        set<id> setShipDetailid=new set<id>();                          //发货明细id
        set<id> setOrderId=new set<id>();                               //订单id
        //list<ProductSN__c> listUpdteProductSN=new list<ProductSN__c>();
        for(SendProSN__c sendprosn:trigger.new)
        {
            if(sendprosn.S_SN__c!=null)
                setSNid.add(sendprosn.S_SN__c);
            if(sendprosn.S_ShippingDetails__c!=null)
                setShipDetailid.add(sendprosn.S_ShippingDetails__c);
        }
        //序列号id为键,序列号对象为值           id,License开始日,License结束日,硬件License开始日,硬件License结束日,设备类型,设备状态,客户所在部门,渠道样机订单,内部样机订单,销售订单,压货订单,换货订单
        map<id,ProductSN__c> mapProductsn=new map<id,ProductSN__c>([select id,Licensestar__c,Licenseend__c,EmpLicense__c,EmpLicenseEndDate__c,ProductCategory__c,ProductStatus__c,AccountSaleArea__c,
                                                                                                        ChannelOrder__c,InsideOrder__c,SelaOrder__c,OversTockOrder__c,ReplaceMentOrder__c
                                                                                                        from ProductSN__c 
                                                                                                        where id=:setSNid]);
                                                                                                        
        list<ProductSN__c> listUpdteProductSN=new list<ProductSN__c>([select id,Licensestar__c,Licenseend__c,EmpLicense__c,EmpLicenseEndDate__c,ProductCategory__c,ProductStatus__c,AccountSaleArea__c,
                                                                                                        ChannelOrder__c,InsideOrder__c,SelaOrder__c,OversTockOrder__c,ReplaceMentOrder__c
                                                                                                        from ProductSN__c 
                                                                                                        where id=:setSNid]);
        //得出所有发货明细  id,发货,产品,产品Name,发货的订单
        list<ShippingDetails__c> listShipDetail=[select id,n_Shipmentname__c,n_Products__c,n_Products__r.Name,n_Shipmentname__r.n_orders__c 
                                                                                                        from ShippingDetails__c 
                                                                                                        where id IN:setShipDetailid];
        //发货明细id为键,订单id为值
        map<id,id> mapOrder=new map<id,id>();
        if(listShipDetail.size()>0)
        {
            for(ShippingDetails__c shipdetail:listShipDetail)
            {
                if(shipdetail.n_Shipmentname__r.n_orders__c!=null)
                {
                    setOrderId.add(shipdetail.n_Shipmentname__r.n_orders__c);
                    if(!mapOrder.containsKey(shipdetail.id))
                        mapOrder.put(shipdetail.id,shipdetail.n_Shipmentname__r.n_orders__c);
                }
            }
        }
        /*
        //订单id为键,订单对象为值             
        map<id,Orders__c> mapOrderObj=new map<id,Orders__c>([select id,customer__c,replacementParty__c,SalesRegion__c,DoReturnAccount__c,SendProduct__c,RecordTypeName__c,Replacement1__c,Partners__c 
                                                                                                                                    from Orders__c
                                                                                                                                    where id IN:setOrderId]);
        */
        //查询出所有的订单          id,客户名称,被退货方,出货方,记录类型名称,换货方,合作伙伴
        list<Orders__c> listOrder=[select id,customer__c,replacementParty__c,SalesRegion__c,DoReturnAccount__c,SendProduct__c,RecordTypeName__c,Replacement1__c,Partners__c 
                                                                                                                                    from Orders__c
                                                                                                                                    where id IN:setOrderId];
        //订单id为键,订单为值
        map<id,Orders__c> mapOrderObj=new map<id,Orders__c>();
        //所有客户id
        set<id> setAccId=new set<id>();
        if(listOrder.size()>0)
        {
            for(Orders__c ord:listOrder)
            {
                if(!mapOrderObj.containsKey(ord.id))
                    mapOrderObj.put(ord.id,ord);
                if(ord.customer__c!=null)
                    setAccId.add(ord.customer__c);
            }
        }
        //客户id为键,客户为值
        map<id,Account> mapAcc=new map<id,Account>([select id,SellArea__c from Account where id IN:setAccId]);
        system.debug('...................setOrderId.......................'+setOrderId);
        system.debug('...................mapOrderObj......................'+mapOrderObj);
        for(SendProSN__c sendprosn:trigger.new)
        {
            if(sendprosn.S_ShippingDetails__c!=null)
            {
                if(sendprosn.S_SN__c!=null)
                {       
                    if(mapProductSN.containsKey(sendprosn.S_SN__c))
                    {   
                        ProductSN__c psn=mapProductSN.get(sendprosn.S_SN__c);                   system.debug('..........psn..........'+psn);
                        /*
                        psn.Licensestar__c=sendprosn.S_Licensestar__c;                          //License开始日
                        psn.Licenseend__c=sendprosn.S_Licenseend__c;                            //License到期日
                        psn.EmpLicense__c=sendprosn.S_HardLicenstar__c;                         //硬件License开始日
                        psn.EmpLicenseEndDate__c=sendprosn.S_HardLicenseend__c;                 //硬件License结束日
                        psn.ProductCategory__c=sendprosn.S_ProductCategory__c;                  //设备类型
                        psn.ProductStatus__c=sendprosn.S_ProductStatus__c;                      //设备状态
                        */
                        if(mapOrder.containsKey(sendprosn.S_ShippingDetails__c))                //发货明细
                        {    
                            ID ordid=mapOrder.get(sendprosn.S_ShippingDetails__c);system.debug('................ordid.................'+ordid);
                            sendprosn.S_Order__c=ordid;
                            if(ordid!=null&&mapOrderObj.containsKey(ordid))
                            {
                                Orders__c ord=mapOrderObj.get(ordid); system.debug('..............ord...............'+ord);
                                if(ord.RecordTypeName__c=='销售订单'||ord.RecordTypeName__c=='内部样机订单'||ord.RecordTypeName__c=='渠道样机订单'||ord.RecordTypeName__c=='内部核算订单')
                                {
                                    psn.coustmer__c=ord.customer__c;        //客户名称    
                                    if(ord.RecordTypeName__c=='销售订单'||ord.RecordTypeName__c=='内部核算订单')
                                        psn.SelaOrder__c=ordid;
                                    if(ord.RecordTypeName__c=='渠道样机订单')
                                        psn.ChannelOrder__c=ordid;
                                    if(ord.RecordTypeName__c=='内部样机订单')
                                        psn.InsideOrder__c=ordid;
                                    sendprosn.S_Client__c = ord.customer__c; //加客户
                                    sendprosn.S_area__c = ord.SalesRegion__c; //销售区域
                                    if(mapAcc.containsKey(ord.customer__c)){
                                        Account acc=mapAcc.get(ord.customer__c);
                                        psn.AccountSaleArea__c=acc.SellArea__c;
                                    }
                                }
                                if(ord.RecordTypeName__c=='换货订单')
                                {
                                    psn.coustmer__c=ord.Replacement1__c;    //换货方   
                                    psn.ReplaceMentOrder__c=ordid;          //换货订单
                                    sendprosn.S_Client__c = ord.customer__c;//加客户
                                    sendprosn.S_area__c = ord.SalesRegion__c; //销售区域
                                    if(mapAcc.containsKey(ord.customer__c)){
                                        Account acc=mapAcc.get(ord.customer__c);
                                        psn.AccountSaleArea__c=acc.SellArea__c;
                                    }
                                    
                                }
                                if(ord.RecordTypeName__c=='压货订单')
                                {
                                    psn.coustmer__c=ord.customer__c;        //客户名称  
                                    psn.OversTockOrder__c=ordid;            //压货订单
                                    sendprosn.S_Client__c = ord.customer__c;//加客户
                                    sendprosn.S_area__c = ord.SalesRegion__c; //销售区域
                                    if(mapAcc.containsKey(ord.customer__c)){
                                        Account acc=mapAcc.get(ord.customer__c);
                                        psn.AccountSaleArea__c=acc.SellArea__c;
                                    }                                
                                }
                            }
                        }
                        system.debug('sendprosn...............................................................'+sendprosn);
                        listUpdteProductSN.add(psn);
                        system.debug('......................listUpdteProductSN.........................'+listUpdteProductSN);
                    }
                }   
            
            }               
        }       
        update listUpdteProductSN;                                                                          
    }
                
}