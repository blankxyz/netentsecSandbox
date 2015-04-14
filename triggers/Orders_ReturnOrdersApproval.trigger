//Modify：Gary_Hu
//Dis:换货订单、退货订单上的销售区域字段必填，根据此字段取出销售区域的办公室主任
//Time:2013年4月26日22:29:33
//
trigger Orders_ReturnOrdersApproval on Orders__c (before insert,before update)
{
    Set<Id> sId = new Set<Id>();     //销售区域Id
    Set<Id> oId = new Set<Id>();     //业务机会Id
    Set<id> typeId = new Set<Id>();  //订单类型id
    for(Orders__c orders:trigger.new)
    {
        typeId.add(orders.RecordTypeId);
        if(trigger.isInsert&&orders.SalesRegion__c!=null)   
    		sId.add(orders.SalesRegion__c);
    	if(trigger.isUpdate)
    	{
    		Orders__c oldorder=trigger.oldMap.get(orders.id);
    		if(orders.SalesRegion__c!=oldorder.SalesRegion__c&&orders.SalesRegion__c!=null)
    			sId.add(orders.SalesRegion__c);
    	}	
    }
    if(sId.size()>0)
    {
    	map<id,RecordType> maprec = new map<id,RecordType>([select Name from RecordType where id in : typeId]);
		Map<id,SalesRegion__c> orderSellArea = new Map<id,SalesRegion__c>([select id,Name,SEPersonInCharge__c,OfficeDirector__c,FinancialVp__c,SalesVp__c,OperationsAssistant__c from SalesRegion__c where id IN:sId]); 
	    system.debug('--------------------------orderSellArea--------------------'+orderSellArea);
		if(orderSellArea.size()>0)
		{
		    for(Orders__c orders:trigger.new) 
		    {
		    	string ordertp='';
		    	if(maprec.containsKey(orders.RecordTypeId))
		    		ordertp=maprec.get(orders.RecordTypeId).Name;
		    	if(ordertp!=''&&orderSellArea.containsKey(orders.SalesRegion__c))
		    	{	
			        if(ordertp=='退货订单'||ordertp=='换货订单'||ordertp=='压货转销售订单'||ordertp=='销售订单'||ordertp=='压货订单'||ordertp=='内部样机订单')
			        {
			        	orders.OfficeAdm__c = orderSellArea.get(orders.SalesRegion__c).OfficeDirector__c;       //办公室主任
			        }
			        if(ordertp=='内部样机订单')
			        {
			            orders.SEPersonInCharge__c = orderSellArea.get(orders.SalesRegion__c).SEPersonInCharge__c;   //se负责人
			        }
		    	}
		    } 
		}
    }
}