global class  cls_OrderSynchronization
{
    webservice static string OrderOperate(string ordersId)
  {
      system.debug('订单id：'+ordersId);
      list<Orders__c> listOrder=new list<Orders__c>([select id,name,Synchronous__c from Orders__c where OrderNum__c =:ordersId]);
      system.debug('订单信息：'+listOrder);
      for(Orders__c s:listOrder)
      {
          s.Synchronous__c =true;
      }
      system.debug('订单修改完成：'+listOrder);
      update listOrder;
      return '修改完成';
  }
}