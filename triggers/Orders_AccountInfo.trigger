/**
*Dis:判断客户是否有订单，如果有就勾选为正式客户
*Author:Gary_Hu
*Time:2013年4月1日9:44:23
***************华丽的分割线**************
*Modify:Gary Hu
*Dis:进行取消订单处理，订单上添加取消订单金额，以及带入相关的订单明细
**/
trigger Orders_AccountInfo on Orders__c (after insert) {
    set<Id> cId = new set<Id>();//客户Id
    String oTypeName = null;   //订单类型名称
    List<Account> acList = new List<Account>();
    
     
     set<string> setOrderId=new set<string>();
    for(Orders__c orderc : trigger.new){
    	setOrderId.add(orderc.id);
        if(orderc.customer__c != null){
            cId.add(orderc.customer__c);
        }
        if(orderc.Payer__c != null)
        {
        	cId.add(orderc.Payer__c);
        }
    }
    
    list<Orders__c> listOrders=new list<Orders__c>([select id,name,CommercialAttache__c,CreatedById,RecordTypeName__c,AboutOrder__c,AboutOrder__r.OrderAmount__c  
    												from Orders__c where id in:setOrderId]);
    if(listOrders!=null && listOrders.size()>0)
    {
    	for(Orders__c Orders:listOrders)
	    {
	    	
	    	Orders.CommercialAttache__c=Orders.CreatedById;
	    	
	    }
    	update listOrders;
    }
   
    if(cId.size() > 0){
        list<Account> account = [select Whether__c from Account where Id in : cId];
        /**************判断客户********************/
        if(account.size() != 0){
            for(Account ac : account){
                if(ac.Whether__c == false){
                        ac.Whether__c = true;
                        acList.add(ac);
                }
            }
            update acList;
            
        }
    }
    
    
}