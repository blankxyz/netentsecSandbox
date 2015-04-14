/*
//压货订单按折扣审批
//lurrykong
//2013.4.18
*
*压货订单审批,压货订单不管涉不涉及价格问题，首先需要渠道部/办事处主任审批；
*若涉及价格需要走三级审批，三级审批是：
*第一级区域办事处主任、第二级销售VP、第三级财务VP。
*审批结果以系统自动邮件方式通知销售人员，审批通过后系统以邮件方式通知到商务人员。
*（系统根据折扣范围决定由那一级审批通过后，订单创建成功）
*Update:rogersun
*982578975@qq.com
*2014-04-16
*/
trigger OrderDetails_Approval on OrderDetails__c (after insert, after update, after delete) 
{   
	cbl_OrderDetails_Approval cblOrderDetailsApproval =new cbl_OrderDetails_Approval();	
	if(trigger.isInsert)
	{
		cblOrderDetailsApproval.cbl_OrderDetails_Approval_afterData(trigger.new);
	}
	else if(trigger.isUpdate)
	{
		for(OrderDetails__c os:trigger.new)
		{
			 OrderDetails__c oldOD = trigger.oldMap.get(os.id);
			if(os.n_DiscountByord__c!=oldOD.n_DiscountByord__c)
			{
				cblOrderDetailsApproval.cbl_OrderDetails_Approval_afterData(trigger.new);
			}
		}
	}
	else if(trigger.isDelete)
	{
		cblOrderDetailsApproval.cbl_OrderDetails_Approval_afterData(trigger.old);
	}
	
}