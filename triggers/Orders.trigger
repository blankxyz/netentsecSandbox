trigger Orders on Orders__c (after update) 
{
    list <Approval.ProcessSubmitRequest>  listRequest=new List< Approval.ProcessSubmitRequest >();
    list<Orders__c> listOrders=new list<Orders__c>();
    if(trigger.isAfter)
    {
        if(trigger.isUpdate)
        {
            for(Orders__c o:trigger.new)
            {
                if(o.Synchronous__c==true && o.SynchronizationStatus__c=='已同步')
                {
                    listOrders.add(o);
                    
                    system.debug('信息：'+o);
                }
            }
        }
        if(listOrders!=null && listOrders.size()>0)
        {
            for(Orders__c o:listOrders)
            {
                     Approval.ProcessSubmitRequest processSubmit =new Approval.ProcessSubmitRequest();
                 //添加提交的备注信息
                 //processSubmit.setComments('Submitting request for  approval.');
                 //制定提交审批记录的ID
                 processSubmit.setObjectId(o.Id); 
                 listRequest.add(processSubmit);
            }
             Approval.ProcessResult[]  result = Approval.process(listRequest);
        }
        
    }
}