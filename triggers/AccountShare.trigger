/**
*Dis:客户 共享 trigger
*Time:2015年3月16日15:19:05
*Author:Gary Hu
**/
trigger AccountShare on Account (after delete, after insert, after update) {
	if(Trigger.isAfter)
	{
		//共享 客户所对应的部门主任
		Cbl_Share_ForOppOrderAcc cblShare = new Cbl_Share_ForOppOrderAcc();
		if(Trigger.isInsert)
		{
			cblShare.accInsertSellArea(trigger.new);
		}
		if(Trigger.isUpdate)
		{
			cblShare.accUpdateSellArea(trigger.new,trigger.old,trigger.oldMap);
		}
		
	}
	
	
}