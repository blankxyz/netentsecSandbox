/**
*Dis:订单上累计汇总 T1级代理商 上的渠道返点
*Dis:订单付款记录
*Dis:订单共享给对应的区域办事处主任、OSR
*Time:2015年3月12日9:41:53
*Author:Gary Hu
**/
trigger OrderChannelPoint on Orders__c (after delete, after insert, after update) {
	if(Trigger.isAfter)
	{	
		//订单上累计汇总 T1级代理商 上的渠道返点
		Cbl_Order_SumChannelPoint orderSum = new Cbl_Order_SumChannelPoint();
		//共享 区域的办事处主任 OSR
		Cbl_Share_ForOppOrderAcc cblShare = new Cbl_Share_ForOppOrderAcc();
		//取消订单操作
		Cbl_Order_UnOrderUpdate cblOrdUn = new Cbl_Order_UnOrderUpdate();

		if(Trigger.isInsert)
		{
			//累计汇总T代理商
			orderSum.insertSum(trigger.new);
			//OSR
			cblShare.orderInsertOSRShare(trigger.new);
			//区域办事处主任
			cblShare.orderInsertQyShare(trigger.new);
		}
		if(Trigger.isUpdate)
		{
			orderSum.updateSum(trigger.new, trigger.oldMap);
			//修改OSR
			cblShare.orderUpdateOSRShare(trigger.new,trigger.old,trigger.oldMap);
			//修改区域办事处主任
			cblShare.orderUpdateQyShare(trigger.new,trigger.old,trigger.oldMap);
			//取消订单操作
			cblOrdUn.updateUnOrder(trigger.new, trigger.oldMap);
		}
		if(Trigger.isDelete)
		{
			System.debug('-----------大爷来了--------------');
			orderSum.deleteSum(trigger.old);
		}
	}
}