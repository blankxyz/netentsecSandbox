/*
*RogerSun
*2014-06-16
*添加发货信息时查重与分割发货、发货明细、发货明细SN、序列号信息

*/
public class Cbl_DeliveryTemporary 
{
    //自定义异常对象  
    public class MyException extends Exception {}
    public void Cbl_DeliveryTemporary_beforeInsert(list<DeliveryTemporary__c> listDeliveryTemporary)
    {
        set<string> setAutoId=new set<string>();
        map<string,DeliveryTemporary__c> mapDeliveryTemporary=new map<string,DeliveryTemporary__c>();
        for(DeliveryTemporary__c d: listDeliveryTemporary)
        {
            setAutoId.add(d.AutoID__c);
            if(mapDeliveryTemporary.containsKey(d.AutoID__c))
            {
                d.AddError('数据有重复插入');
                
            }
            else
            {
                mapDeliveryTemporary.put(d.AutoID__c,d);
            }
            
        }
        list<DeliveryTemporary__c> listDeliveryTemporarys=new list<DeliveryTemporary__c>([select id from DeliveryTemporary__c where AutoID__c in: setAutoId]);
        for(DeliveryTemporary__c dd: listDeliveryTemporarys)
        {
            throw new MyException('已存在不能重复插入');
            
        }
        
        
    }
    public void Cbl_DeliveryTemporary_afterInsert(list<DeliveryTemporary__c> listDeliveryTemporary)
    { 
    	
        map<string,Shipments__c> mapShipments = new map<string,Shipments__c>();
        map<string,ShippingDetails__c> mapShippingDetails = new map<string,ShippingDetails__c>();
        list<Shipments__c> listShipments = new list<Shipments__c>();
        list<ShippingDetails__c> listShippingDetails = new list<ShippingDetails__c>();
        list<SendProSN__c> listSendProSN = new list<SendProSN__c>();
        list<ProductSN__c> listProductSN = new list<ProductSN__c>();
        list<ProductSNDetial__c> listProductSNDetial=new list<ProductSNDetial__c>();
        map<string,ProductSN__c> mapProductSN = new map<string,ProductSN__c>();
        map<string,SendProSN__c> mapSendProSN = new map<string,SendProSN__c>();
        set<string> setcCodeId=new set<string>();
        set<string> setcAutoIDId=new set<string>();
        set<string> setsNameId=new set<string>();
        for(DeliveryTemporary__c d: listDeliveryTemporary)
        {
            setcCodeId.add(d.cCode__c);
            setcAutoIDId.add(d.AutoID__c);
            string a=null;
            system.debug('第一次信息：'+d.cDefine33__c+','+String.isnotBlank(d.cDefine33__c));
            if(String.isnotBlank(d.cDefine33__c))
            {
            	system.debug('第一次信息进来：'+d.cDefine33__c+','+String.isnotBlank(d.cDefine33__c));
                string[] sTest =d.Test__c.Split(',');
                for (string sName : sTest)
                {
                	system.debug('第二次信息：'+sName+','+String.isnotBlank(sName));
                    if(String.isnotBlank(sName))
                    {
                    	system.debug('第二次信息进来：'+sName+','+String.isnotBlank(sName));
                        setsNameId.add(sName);
                    }
                }
            }
        }
        list<Shipments__c> listShipmentsExtis = new list<Shipments__c>([select cCode__c,id from Shipments__c where cCode__c in: setcCodeId]);
        list<ShippingDetails__c> listShippingDetailsExtis = new list<ShippingDetails__c>([select id,ShipDetails__c from ShippingDetails__c where ShipDetails__c in: setcAutoIDId]);
        list<SendProSN__c> listSendProSNExtis = new list<SendProSN__c>([select id,SerialNumber__c,ShippingDetails__c from SendProSN__c where  SerialNumber__c in: setsNameId and ShippingDetails__c in: setcAutoIDId]);
        list<ProductSN__c> listProductSNExtis = new list<ProductSN__c>([select id,name from ProductSN__c where name in:setsNameId]);
        map<string,Shipments__c> mapShipmentsExtis=new map<string,Shipments__c>();
        map<string,ShippingDetails__c> mapShippingDetailsExtis=new map<string,ShippingDetails__c>();
        map<string,SendProSN__c> mapSendProSNExtis=new map<string,SendProSN__c>();
        map<string,ProductSN__c> mapProductSNExtis=new map<string,ProductSN__c>();
        if(listShipmentsExtis!=null && listShipmentsExtis.size()>0)
        {
            for(Shipments__c s:listShipmentsExtis)
            {
                mapShipmentsExtis.put(s.cCode__c,s);
            }
        }
        if(listShippingDetailsExtis!=null && listShippingDetailsExtis.size()>0)
        {
            for(ShippingDetails__c s:listShippingDetailsExtis)
            {
                mapShippingDetailsExtis.put(string.valueOf(s.ShipDetails__c),s);
            }
        }
        if(listSendProSNExtis!=null && listSendProSNExtis.size()>0)
        {
            for(SendProSN__c s:listSendProSNExtis)
            {
                mapSendProSNExtis.put(s.SerialNumber__c+string.valueOf(s.ShippingDetails__c),s);
            }
        }
        if(listProductSNExtis!=null && listProductSNExtis.size()>0)
        {
            for(ProductSN__c s:listProductSNExtis)
            {
                mapProductSNExtis.put(s.name,s);
            }
        }
        for(DeliveryTemporary__c d: listDeliveryTemporary)
        {
            if(!mapShipments.containsKey(d.cCode__c) && !mapShipmentsExtis.containsKey(d.cCode__c))
            {
                Shipments__c Shipments = new Shipments__c();
                
                Shipments.Account__c = d.cCusCode__c;
                Shipments.cCode__c=d.cCode__c;
                //Shipments.n_SendOrderNo__c = d.cBusCode__c;
                Shipments.n_Theme__c = d.cShipAddress__c;
                Shipments.CourierNumber__c = d.cDefine2__c;
                Shipments.CourierCompany__c = d.cDefine3__c;
                Shipments.n_DeliveryTime__c = d.dDate__c;
                Shipments.ShippingType__c = '销售出库';
                Shipments.n_Status__c = '已出库';
                Shipments.n_Description__c = d.cMemo__c;
                mapShipments.put(d.cCode__c,Shipments);
                listShipments.add(Shipments);
            }
            else
            {
                system.debug('发货已存在，不需要插入');
            }
            if(!mapShippingDetails.containsKey(d.AutoID__c) && !mapShippingDetailsExtis.containsKey(d.AutoID__c))
            {
                ShippingDetails__c ShippingDetails = new ShippingDetails__c();
                ShippingDetails.Delivery__c = d.cCode__c;
                ShippingDetails.Products__c = d.cInvCode__c;
                ShippingDetails.ordersSum__c = d.iQuantity__c;
                ShippingDetails.ShipDetails__c = d.AutoID__c;
                ShippingDetails.Order__c=d.cSOCode__c;
                ShippingDetails.CourierNumber__c = d.cDefine2__c;
                ShippingDetails.CourierCompany__c = d.cDefine3__c;
                ShippingDetails.n_SendOrderNo__c = d.cBusCode__c;
                mapShippingDetails.put(d.AutoID__c,ShippingDetails);
                listShippingDetails.add(ShippingDetails);
               // throw new MyException('listShippingDetails is infor:'+listShippingDetails);
            }
            system.debug('第三次信息：'+d.cDefine33__c+','+String.isnotBlank(d.cDefine33__c));
            if(String.isnotBlank(d.cDefine33__c))
            {
            	 system.debug('第三次信息进来：'+d.cDefine33__c+','+String.isnotBlank(d.cDefine33__c));
                string[] sTest =d.Test__c.Split(',');
                for (string sName : sTest)
                {
                	system.debug('第四次信息：'+sName+','+String.isnotBlank(sName));
                    if(String.isnotBlank(sName))
                    {
                    	system.debug('第四次信息进来：'+sName+','+String.isnotBlank(sName));
                        if(!mapProductSN.containsKey(sName) && !mapProductSNExtis.containsKey(sName))
                        {
                            ProductSN__c ProductSN = new ProductSN__c();
                            ProductSN.Order__c = d.cSOCode__c;
                            ProductSN.ShippingDetails__c = d.AutoID__c;
                            ProductSN.Account__c = d.cCusCode__c;
                            ProductSN.Name = sName;
                            ProductSN.n_Remark__c = d.cDefine33__c;
                            listProductSN.Add(ProductSN);
                            mapProductSN.put(sName,ProductSN);
                            system.debug('listProductSN is infor:'+listProductSN);
                            ProductSNDetial__c ProductSNDetial = new ProductSNDetial__c();
                            ProductSNDetial.ProductName__c = d.cInvCode__c;
                            ProductSNDetial.OrdersName__c=d.cSOCode__c;
                            ProductSNDetial.ProductSNname__c=sName;
                            ProductSNDetial.Remark__c='集成同步';
                            listProductSNDetial.Add(ProductSNDetial);
                            
                        }
                        
                        if(!mapSendProSNExtis.containsKey(sName+string.valueOf(d.AutoID__c)) && !mapSendProSN.containsKey(sName+string.valueOf(d.AutoID__c)))
                        {
                             SendProSN__c SendProSN = new SendProSN__c();
                            SendProSN.Department__c = d.cDepName__c;
                            SendProSN.Order__c = d.cSOCode__c;
                            SendProSN.ShippingDetails__c = d.AutoID__c;
                            SendProSN.Account__c = d.cCusCode__c;
                            SendProSN.SerialNumber__c = sName;
                            listSendProSN.Add(SendProSN);
                            mapSendProSN.put(sName+string.valueOf(d.AutoID__c),SendProSN);
                        }
                       
                           
                            
                             
                            
                        
                    }

                }
                 
            }
        }
        if(listShipments!=null && listShipments.size()>0)
        {
            insert listShipments;
        }
        if(listShippingDetails!=null && listShippingDetails.size()>0)
        {
            insert listShippingDetails;
        }
        if(listProductSN!=null && listProductSN.size()>0)
        {
            insert listProductSN;
            system.debug('listProductSN is infor进来信息:'+listProductSN);
        }
        if(listSendProSN!=null && listSendProSN.size()>0)
        {
            insert listSendProSN;
        }
        if(listProductSNDetial!=null && listProductSNDetial.size()>0)
        {
            insert listProductSNDetial;
        }
        
    }
}