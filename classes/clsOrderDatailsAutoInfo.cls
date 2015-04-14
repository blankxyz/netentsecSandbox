/**
*Dis:更改是否发邮件的状态
*Author:vito_He
*Time:2013年4月23日 10:20:05
**/
global class  clsOrderDatailsAutoInfo implements Database.Batchable<SObject>, Database.Stateful{
	 global Database.queryLocator start(Database.BatchableContext ctx){
	     return Database.getQueryLocator([Select BorrowerReceiptDate__c,n_ProductByOrd__c,whether_send_message__c From OrderDetails__c where  
	     				n_OrderNo__r.RecordType.Name = '内部样机订单' and whether_send_message__c = false]); 
	 }
	 global void execute(Database.BatchableContext ctx, List<OrderDetails__c>  scope){
	 	DateTime nowToday = Date.today();	//当前时间
	 	List<OrderDetails__c> ordList = new  List<OrderDetails__c>();
	    for(Sobject sc: scope){
	    	OrderDetails__c orderDetail = (OrderDetails__c)sc;
	    	if(orderDetail!=null && orderDetail.BorrowerReceiptDate__c!=null && orderDetail.BorrowerReceiptDate__c.addDays(90) < nowToday){    // 超过90天
		    	if(orderDetail.whether_send_message__c == false){ 								   // 未发送邮件
			    	orderDetail.whether_send_message__c = true;
			    	ordList.add(orderDetail);
		    	}
	    	}  
	    } 
	    update ordList;
 	 }
     global void finish(Database.BatchableContext ctx){
	       	
     }
}