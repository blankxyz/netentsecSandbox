/**
*Dis:税务发票：增加税务发票开票时间字段，选择发票数据中记录类型为税务发票的最早时间
*Time:2015年3月11日14:00:34
*Author:Gary Hu
**/
trigger BillDate on bill_date__c (after delete, after insert, after update) {
	if(Trigger.isAfter)
	{
		//自动添加税务发票的最早时间
		Cbl_Bill_date_AutoAddDate addDate = new Cbl_Bill_date_AutoAddDate();
		if(Trigger.isInsert)
		{
			addDate.insertAutoAddDate(trigger.new);
		}
		if(Trigger.isUpdate)
		{
			addDate.updateAutoAdd(trigger.new, trigger.oldMap);
		}
		if(Trigger.isDelete)
		{
			addDate.deleteAutoAdd(trigger.old);
		}
	}
}