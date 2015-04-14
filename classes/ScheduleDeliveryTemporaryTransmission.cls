/**
*Roger
*2014-06-17
*Cls_WSDLInvoiceTransmission的引导类
*
**/

global class ScheduleDeliveryTemporaryTransmission implements Schedulable
{
	global void execute(SchedulableContext SC)
	{
		Cls_DeliveryTemporaryTransmission.DeliveryTemporaryTransmissionIm();
		
	}
}