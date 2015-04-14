//业务机会销售价格计算
//lurrykong
//2013.5.9
trigger OpportunityLineItem_DiscountUnitPrice on OpportunityLineItem (after insert, before update) 
{
	set<string> setId=new set<string>();
    if(trigger.isInsert)
    {
        for(OpportunityLineItem opplite:trigger.new)
        {
           setId.add(opplite.id);
        }
        
        if(setId!=null && setId.size()>0)
        {
        	list<OpportunityLineItem> listOpportunityLineItem=new list<OpportunityLineItem>([select id,ProductDiscount__c,ListPrice,UnitPrice from OpportunityLineItem where id in:setId]);
        	for(OpportunityLineItem opplite:listOpportunityLineItem)
        	{
        		 if(opplite.ProductDiscount__c!=null&&opplite.ListPrice!=null)
	            {
	                opplite.UnitPrice=opplite.ListPrice*opplite.ProductDiscount__c/100;
	            }
	            if(opplite.ProductDiscount__c == null){
	            	system.debug('信息：'+opplite.UnitPrice+','+opplite.ListPrice);
	                opplite.ProductDiscount__c = opplite.UnitPrice/opplite.ListPrice *100;
	            }
        	}
        	update listOpportunityLineItem;
        }
    }
    if(trigger.isUpdate)
    {
        for(OpportunityLineItem opplite:trigger.new)
        {
            OpportunityLineItem oldopplite=trigger.oldMap.get(opplite.id);
            if(oldopplite.ProductDiscount__c!=opplite.ProductDiscount__c&&opplite.ProductDiscount__c!=null&&opplite.ListPrice!=null)
            {   system.debug('......................opplite.ProductDiscount__c........................'+opplite.ProductDiscount__c);
                system.debug('......................opplite.ListPrice........................'+opplite.ListPrice);
                opplite.UnitPrice=opplite.ListPrice*opplite.ProductDiscount__c/100;
                
                system.debug('......................opplite.UnitPrice........................'+opplite.UnitPrice);
            }
            if(opplite.ProductDiscount__c == null || oldopplite.UnitPrice != opplite.UnitPrice){
                opplite.ProductDiscount__c =opplite.UnitPrice/opplite.ListPrice *100;
            }
        }
    }
}