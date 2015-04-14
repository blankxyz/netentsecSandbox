/*
*RogerSun
*982578975@qq.com
*发货明细同步的时候
*/
trigger ShippingDetails on ShippingDetails__c (after insert, after update) {
	 public class MyException extends Exception {}
    set<string> setProductId=new set<string>();
    set<string> setDeliveryId=new set<string>();
    set<string> setShippingDetailsId=new set<string>();
    map<string,Product2> mapProduct2=new map<string,Product2>();
    map<string,Shipments__c> mapShippingDetails=new map<string,Shipments__c>();
    map<string,Orders__c> mapOrder=new map<string,Orders__c>();
    map<string,ShippingDetails__c > mapShipmentsOrders=new map<string,ShippingDetails__c >();
    set<string> setOrder=new set<string>();
    if(trigger.isAfter)
    {
        if(trigger.isInsert)
        {
            for(ShippingDetails__c s:trigger.new)
            {
                if(s.Products__c!=null)
                {
                    setProductId.add(s.Products__c);
                }
                if(s.Delivery__c!=null)
                {
                    setDeliveryId.add(s.Delivery__c);
                }
                 if(s.Order__c!=null)
                {
                  setOrder.add(s.Order__c);
                  if(!mapShipmentsOrders.containsKey(s.Order__c))
                  {
                    mapShipmentsOrders.put(s.Order__c,s);
                  }
                }
                if(s.Products__c!=null || s.Delivery__c!=null || s.Order__c!=null)
                {
                    setShippingDetailsId.add(s.id);
                }
            }
        }
        else if(trigger.isUpdate)
        {
            for(ShippingDetails__c s:trigger.new)
            {
                ShippingDetails__c oldMap=trigger.oldMap.get(s.id);
                if(s.Products__c!=oldMap.Products__c)
                {
                    setProductId.add(s.Products__c);
                }
                if(s.Delivery__c!=oldMap.Delivery__c)
                {
                    setDeliveryId.add(s.Delivery__c);
                }
                if(s.Order__c!=oldMap.Order__c)
                {
                  setOrder.add(s.Order__c);
                  if(!mapShipmentsOrders.containsKey(s.Order__c))
                  {
                    mapShipmentsOrders.put(s.Order__c,s);
                  }
                }
                if(s.Products__c!=oldMap.Products__c || s.Delivery__c!=oldMap.Delivery__c || s.Order__c!=oldMap.Order__c)
                {
                    setShippingDetailsId.add(s.id);
                }
            }
        }
        if(setProductId!=null && setProductId.size()>0)
        {
            list<Product2> listProduct2=new list<Product2>([Select p.ProductCode, p.Name, p.Id From Product2 p 
            where p.ProductCode in:setProductId
            and p.IsDeleted=false
            ]);
            for(Product2 p:listProduct2)
            {
                if(!mapProduct2.containsKey(p.ProductCode))
                {
                    mapProduct2.put(p.ProductCode,p);
                }
                
            }
            
        }
         if(setOrder!=null && setOrder.size()>0)
    {
      list<Orders__c> listOrder=new list<Orders__c>([select id,name,OrderNum__c,CourierNumber__c,CourierCompany__c 
      from Orders__c 
      where OrderNum__c in:setOrder
      and IsDeleted=false
      ]);
      if(listOrder!=null && listOrder.size()>0)
      {
        for(Orders__c a:listOrder)
        {
          if(!mapOrder.containsKey(a.OrderNum__c))
          {
            a.CourierNumber__c=mapShipmentsOrders.get(a.OrderNum__c).CourierNumber__c;
            a.CourierCompany__c=mapShipmentsOrders.get(a.OrderNum__c).CourierCompany__c;
            mapOrder.put(a.OrderNum__c,a);
          }
          
        }
        update listOrder;
      }
      
    }
        if(setDeliveryId!=null && setDeliveryId.size()>0)
        {
            list<Shipments__c> listShipments=new list<Shipments__c>([Select p.n_SendOrderNo__c,p.cCode__c, p.Name, p.Id From Shipments__c p 
            where p.cCode__c in:setDeliveryId
            and IsDeleted=false
            ]);
            for(Shipments__c p:listShipments)
            {
                if(!mapShippingDetails.containsKey(p.cCode__c))
                {
                    mapShippingDetails.put(p.cCode__c,p);
                }
                
            }
            
        }
      //  throw new MyException('listShippingDetails is infor:'+listShippingDetails);
        if(setShippingDetailsId!=null && setShippingDetailsId.size()>0)
        {
            list<ShippingDetails__c> listShippingDetails=new list<ShippingDetails__c>([Select s.n_order__c,s.n_Shipmentname__c,s.Order__c, s.n_Products__c, s.Products__c, s.Name, s.Id, s.Delivery__c From ShippingDetails__c s 
            where s.Id in: setShippingDetailsId
            and IsDeleted=false
            ]);
            for(ShippingDetails__c s:listShippingDetails)
            {
                if(mapOrder.containsKey(s.Order__c))
                {
                  s.n_order__c=mapOrder.get(s.Order__c).id;
                }
                if(mapProduct2.containsKey(s.Products__c))
                {
                    s.n_Products__c=mapProduct2.get(s.Products__c).id;
                }
                if(mapShippingDetails.containsKey(s.Delivery__c))
                {
                    s.n_Shipmentname__c=mapShippingDetails.get(s.Delivery__c).id;
                }
            }
           
            update listShippingDetails;
            //throw new MyException('listShippingDetails is infor:'+listShippingDetails);
        }
        
    }
}