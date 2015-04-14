trigger ProductSNDetialCommissioner on ProductSNDetial__c (after insert,before insert) 
{
	cbl_ProductSNDetialCommissioner ProductSNDetialCommissioner=new cbl_ProductSNDetialCommissioner();
	if(trigger.isAfter && trigger.isInsert)
	{
		ProductSNDetialCommissioner.cbl_ProductSNDetialCommissioner_beforeInsert(trigger.new);
	}
    if(trigger.isBefore && trigger.isInsert)
    {
    	ProductSNDetialCommissioner.cbl_ProductSNDetialCommissioner_AfterInsert(trigger.new);
    }
}