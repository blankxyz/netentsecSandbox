/*
*RogerSun
*982578975@qq.com
*发票添加到临时发票信息
*/
trigger TmpInvoice on TmpInvoice__c (after insert, before insert) {
	Cbl_TmpInvoice CblTmpInvoice=new Cbl_TmpInvoice();
	if(trigger.isBefore && trigger.isInsert)
	{
		CblTmpInvoice.Cbl_TmpInvoice_beforeInsert(trigger.new);
	}
	if(trigger.isAfter && trigger.isInsert)
	{
		CblTmpInvoice.Cbl_TmpInvoice_afterInsert(trigger.new);
		
	}
}