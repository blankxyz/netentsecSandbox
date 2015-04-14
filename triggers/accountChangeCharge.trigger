/*
*RogerSun
*2014-04-21
*客户的专员负责人变更后相应的序列号明细中的专员也变更
*/
trigger accountChangeCharge on Account (after update,after insert) {
	cbl_accountChangeCharge cblaccountChangeCharge=new cbl_accountChangeCharge();
	if(trigger.isUpdate)
	{
		cblaccountChangeCharge.cbl_accountChangeCharge_afterUpdate(trigger.new,trigger.oldMap,trigger.newMap);
		
		
	}
	else if(trigger.isInsert)
	{
		cblaccountChangeCharge.cbl_accountCheckRepeat(trigger.new);
	}
}