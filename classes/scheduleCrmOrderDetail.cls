/**
*Roger
*2013-08-13
*CrmOrderDetail的引导类
*
**/
global class scheduleCrmOrderDetail implements Schedulable
{
	global void execute(SchedulableContext SC)
	{
		CrmOrderDetail.OrderDetailDataClient();
		
	}
}