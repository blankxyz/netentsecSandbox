/**
*Dis:部门触发器
*Author:Gary Hu
*Time:2015年3月25日14:53:09
**/
trigger SalesRegion on SalesRegion__c (after update) {
	if(Trigger.isAfter)
	{
		//修改共享的值
		Cbl_SalesRegionOffDir_AutoChange cbls = new Cbl_SalesRegionOffDir_AutoChange();
		if(Trigger.isUpdate)
		{
			System.debug('--------大爷来了xxxxx---------');
			cbls.updateAccountSharing(trigger.new,trigger.oldMap);
			cbls.updateOrderSharing(trigger.new,trigger.oldMap);
		}
		
	}
}