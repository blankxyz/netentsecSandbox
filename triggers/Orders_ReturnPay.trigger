/**
*Dis:压货订单，渠道样机订单，销售订单 勾选为特价时，修改相应的发票明细上的特价
*Author:Gary_Hu
*Time:2013年4月16日8:52:42
**/
trigger Orders_ReturnPay on Orders__c (after update) {
    /***压货订单，渠道样机订单，销售订单 勾选为特价时，修改相应的发票明细上的特价***/
    if(Trigger.isUpdate){
        set<Id> oId = new set<Id> (); //订单Id
        map<String,Boolean> mapIsSale = new map<String,Boolean>();
        for(Orders__c oc : trigger.new){
            if(oc.RecordTypeName__c =='压货订单' || oc.RecordTypeName__c =='渠道样机订单' || oc.RecordTypeName__c =='销售订单'){
                if(trigger.oldMap.get(oc.id).isSale__c != oc.isSale__c){
                    oId.add(oc.Id); //订单Id
                    if(!mapIsSale.containsKey(String.valueOf(oc.Id))){
                        mapIsSale.put(String.valueOf(oc.Id),oc.isSale__c);
                    }
                }
            }
        }
        if(oId.size() > 0){
            system.debug('--------------oId----------');
            list<InvoiceDetails__c> list_inv = [select InvisSale__c from InvoiceDetails__c where OrderId__c in: oId];
            if(list_inv.size() > 0){
                
                for(InvoiceDetails__c invX : list_inv){
                    
                    if(mapIsSale.containsKey(invX.Id)){
                        
                        if(mapIsSale.get(invX.Id) != null){
                            invX.InvisSale__c =  mapIsSale.get(invX.Id);
                        }else{
                            invX.InvisSale__c = invX.InvisSale__c;
                        }
                    }
                }
            }
            update list_inv;
        }
    }
    

}