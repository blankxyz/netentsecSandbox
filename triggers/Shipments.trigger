/*
*RogerSun
*2014-06-02
*发货同步时添加信息转换
*/
trigger Shipments on Shipments__c (after insert, after update) 
{
    set<string> setOrder=new set<string>();
    set<string> setAccount=new set<string>();
    map<string,Account> mapAccount=new map<string,Account>();
    map<string,Orders__c> mapOrder=new map<string,Orders__c>();
    map<string,Shipments__c> mapShipmentsOrders=new map<string,Shipments__c>();
    set<string> setShipments=new set<string>();
    if(trigger.isAfter)
    {
        if(trigger.isInsert)
        {
            for(Shipments__c s:trigger.new)
            {
                if(s.Account__c!=null)
                {
                    setAccount.add(s.Account__c);
                    setShipments.add(s.id);
                }
                
            }
        }
        else if(trigger.isUpdate)
        {
            for(Shipments__c s:trigger.new)
            {
                Shipments__c oldMap=trigger.oldMap.get(s.id);
                if(s.Account__c!=oldMap.Account__c)
                {
                    setAccount.add(s.Account__c);
                    setShipments.add(s.id);
                }
               
            }
        }
        if(setAccount!=null && setAccount.size()>0)
        {
            list<Account> listAccount=new list<Account>([select id,IdentificationCode_c__c,name from Account where IdentificationCode_c__c in:setAccount]);
            if(listAccount!=null && listAccount.size()>0)
            {
                for(Account a:listAccount)
                {
                    if(!mapAccount.containsKey(a.IdentificationCode_c__c))
                    {
                        mapAccount.put(a.IdentificationCode_c__c,a);
                    }
                    
                }
                
            }
            
        }
        
        if(setShipments !=null && setShipments.size()>0)
        {
            list<Shipments__c> listShipments=new list<Shipments__c>([select id,name,Order__c,Account__c,n_orders__c,n_Deliverables__c from Shipments__c where id in:setShipments]);
            for(Shipments__c s:listShipments)
            {
                
               
                if(mapAccount.containsKey(s.Account__c))
                {
                    s.n_Deliverables__c=mapAccount.get(s.Account__c).id;
                }
                
            }
            if(listShipments!=null && listShipments.size()>0)
            {
                update listShipments;
            }
        }
         
    }
    
}