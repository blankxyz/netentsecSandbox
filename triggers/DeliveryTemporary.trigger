/*
*RogerSun
*2014-06-16
*添加发货信息时查重与分割发货、发货明细、发货明细SN、序列号信息
*/
trigger DeliveryTemporary on DeliveryTemporary__c (before insert, before update,after insert) {
	Cbl_DeliveryTemporary CblDeliveryTemporary=new Cbl_DeliveryTemporary();
	if(trigger.isBefore && trigger.isInsert)
	{
		CblDeliveryTemporary.Cbl_DeliveryTemporary_beforeInsert(trigger.new);
	}
	if(trigger.isAfter && trigger.isInsert)
	{
		CblDeliveryTemporary.Cbl_DeliveryTemporary_afterInsert(trigger.new);
	}
}