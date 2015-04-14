/**
*Roger
*2014-06-17
*AccountTransmissionIm_Run的引导类
*
**/

global class ScheduleAccountTransmissionIm implements Schedulable
{
	global void execute(SchedulableContext SC)
	{
		AccountTransmissionIm_Run.OrderDetailTransmissionIm();
		
	}
}