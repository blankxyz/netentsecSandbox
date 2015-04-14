/**
*Dis:订单付款记录
*Dis:订单共享给对应的区域办事处主任、OSR
*Time:2015年3月11日10:16:18
*Author:Gary Hu
**/
trigger OrderPaymentRecords on OrderPaymentRecords__c (after delete, after insert, after update) {
		if(Trigger.isAfter)
		{
			//自动添加最早的收款时间
			Cbl_OrderPayment_AutoAddDate addDate = new Cbl_OrderPayment_AutoAddDate();
			
			if(Trigger.isInsert)
			{
				addDate.insertAutoAddDate(trigger.new);
				
				
			}
			if(Trigger.isUpdate)
			{
				System.debug('--------大爷来了---------');
				addDate.updateAutoAdd(trigger.new, trigger.oldMap);
				
				
			}
			if(Trigger.isDelete)
			{
				addDate.deleteAutoAdd(trigger.old);
			}
		}
}