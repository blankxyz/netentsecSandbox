/*
RogerSun
2013-06-14
同步客户信息、订单信息至用友CRM

*/
global class scheduleOrderOrAccount  implements Schedulable
{
	global void execute(SchedulableContext SC)
	{
		AccountClient.OrderAccountClient();
	}
}