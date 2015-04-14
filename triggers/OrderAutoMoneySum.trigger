/**
*Dis:订单上各种的钱的统计汇总
*Author:Gary_hu
*Time:2013年5月14日18:55:54
**/
trigger OrderAutoMoneySum on Orders__c (after delete, after insert, after update) {
    
    cbl_OrderAutoMoneySum OrderAutoMoneySum=new cbl_OrderAutoMoneySum();
    set<Id> payId = new set<id>(); //付款方
    set<Id> oId = new set<Id> (); //订单Id
    set<Id> reOid = new set<Id>(); //退货订单Id
    set<Id> reAid = new set<Id>(); //退货方客户ID
    if(trigger.isDelete){
        for(Orders__c oc: trigger.old){
            if(oc.Payer__c != null && oc.Id != null){
                if(oc.RecordTypeName__c == '销售订单'){
                    payId.add(oc.Payer__c);
                    oId.add(oc.Id );
                }
            }
            if(oc.Payer__c != null && oc.Id != null && oc.ApprovalStatus__c =='已审批'){
                if(oc.RecordTypeName__c=='渠道样机订单'|| oc.RecordTypeName__c =='压货订单' ){
                    payId.add(oc.Payer__c);
                    oId.add(oc.Id );
                }
            }
            if(oc.ReturnPayAccount__c != null && oc.RecordTypeName__c =='退货订单'&& oc.Id != null && oc.ApprovalStatus__c =='已审批'){
                reAid.add(oc.ReturnPayAccount__c);
                reOid.add(oc.Id);
            }
            
        }
    }
    else if(Trigger.isInsert){
        OrderAutoMoneySum.cbl_OrderAutoMoneySum_afterInsert(trigger.new);
        for(Orders__c oc: trigger.new){
            if(oc.Payer__c != null && oc.Id != null){
                if(oc.RecordTypeName__c == '销售订单'){
                    payId.add(oc.Payer__c);
                    oId.add(oc.Id );
                }
            }
            if(oc.Payer__c != null && oc.Id != null && oc.ApprovalStatus__c =='已审批'){
                if(oc.RecordTypeName__c=='渠道样机订单'|| oc.RecordTypeName__c =='压货订单' ){
                    payId.add(oc.Payer__c);
                    oId.add(oc.Id );
                }
            }
            if(oc.ReturnPayAccount__c != null && oc.RecordTypeName__c =='退货订单'&& oc.Id != null && oc.ApprovalStatus__c =='已审批'){
                reAid.add(oc.ReturnPayAccount__c);
                reOid.add(oc.Id);
            }
        }
    }
   else{
        for(Orders__c oc: trigger.new){
            if(oc.Payer__c != null && oc.Id != null){
                if(oc.RecordTypeName__c == '销售订单' ){
                   if(trigger.oldMap.get(oc.id).UnReceiveAmount__c != oc.UnReceiveAmount__c || trigger.oldMap.get(oc.id).ReceiveRebate__c != oc.ReceiveRebate__c || trigger.oldMap.get(oc.id).ReceiveUnRebate__c != oc.ReceiveUnRebate__c){
                        payId.add(oc.Payer__c);
                        oId.add(oc.Id );
                    }
                }
            }
            if(oc.Payer__c != null && oc.Id != null && oc.ApprovalStatus__c =='已审批'){
                if(oc.RecordTypeName__c=='渠道样机订单'|| oc.RecordTypeName__c =='压货订单'){
                        payId.add(oc.Payer__c);
                        oId.add(oc.Id );
                }
            }
            if(oc.ReturnPayAccount__c != null && oc.RecordTypeName__c =='退货订单'&& oc.Id != null && oc.ApprovalStatus__c =='已审批'){
                reAid.add(oc.ReturnPayAccount__c);
                reOid.add(oc.Id);
            }
        }
    }
    if(payId.size()>0&&oId.size()>0){
            //统计订单上的订单未付款,已付款金额-返点,已付款金额-非返点
        AggregateResult [] inSumAll = [select sum(UnReceiveAmount__c) unAmoSum,
									        sum(ReceiveRebate__c) recAmoSum,
									        sum(ReceiveUnRebate__c) recUnAmoSum,
									        Payer__c 
                                            from Orders__c 
                                            where Payer__c in: payId group by Payer__c];
        //构建Map 客户Id,订单未付款
        map<Id,Double> mapSumUnAmo = new map<Id,Double>();
        
        //构建Map 客户Id,已付款金额-返点
        map<Id,Double> mapSumRecAmo = new map<Id,Double>();
        
        //构建Map 客户Id,已付款金额-非返点
        map<Id,Double> mapSumUnRecAmo = new map<Id,Double>();
        
        for(AggregateResult inSumAllX: inSumAll){
            //统计订单上的订单未付款
            if(!mapSumUnAmo.containsKey(String.valueOf(inSumAllX.get('Payer__c')))){
                 mapSumUnAmo.put(String.valueOf(inSumAllX.get('Payer__c')),Double.valueOf(inSumAllX.get('unAmoSum')));
            }
            //统计订单上的已付款金额-返点
            if(!mapSumRecAmo.containsKey(String.valueOf(inSumAllX.get('Payer__c')))){
                mapSumRecAmo.put(String.valueOf(inSumAllX.get('Payer__c')),Double.valueOf(inSumAllX.get('recAmoSum')));
            }
            //统计订单上的已付款金额-非返点
            if(!mapSumUnRecAmo.containsKey(String.valueOf(inSumAllX.get('Payer__c')))){
                mapSumUnRecAmo.put(String.valueOf(inSumAllX.get('Payer__c')),Double.valueOf(inSumAllX.get('recUnAmoSum')));
            }
        }
        

        
        //查找客户上的金额 订单未付款，付款金额返点，付款金额非返点
        list<Account> list_acc = [select UnPayOrderAmountX__c,PayAmount_RebatesX__c,PayAmount_UnRebatesX__c,Id from Account where Id in: payId];
        //操作客户
        if(list_acc.size() > 0){
            for(Account list_accX : list_acc){
                String conKey = list_accX.Id;
                //订单未付款
                if(mapSumUnAmo.containsKey(conKey)){
                    if(mapSumUnAmo.get(conKey) != null){
                        list_accX.UnPayOrderAmountX__c = mapSumUnAmo.get(conKey);
                    }else{
                        list_accX.UnPayOrderAmountX__c = list_accX.UnPayOrderAmountX__c;
                    }
                }
                //订单用返点支付的金额
                if(mapSumRecAmo.containsKey(conKey)){
                    if(mapSumRecAmo.get(conKey) != null){
                        list_accX.PayAmount_RebatesX__c = mapSumRecAmo.get(conKey);
                    }else{
                        list_accX.PayAmount_RebatesX__c = list_accX.PayAmount_RebatesX__c;
                    }
                }
                //付款金额非返点
                if(mapSumUnRecAmo.containsKey(conKey)){
                    if(mapSumUnRecAmo.get(conKey) != null){
                        list_accX.PayAmount_UnRebatesX__c = mapSumUnRecAmo.get(conKey);
                    }else{
                        list_accX.PayAmount_UnRebatesX__c = list_accX.PayAmount_UnRebatesX__c;
                    }
                }
                
            }
        }
        update list_acc;
    }
    
    if(reAid.size()>0 && reOid.size()>0){
    //统计退货订单上的订单金额
    AggregateResult [] ReturnAmount = [select sum(OrderAmount__c) ReAmoSum,
    ReturnPayAccount__c from Orders__c 
    where ReturnPayAccount__c in: reAid 
    and ApprovalStatus__c = '已审批'
    group by ReturnPayAccount__c];
    //构建Map 客户Id,订单金额
    map<Id,Double> mapReturnAmount = new map<Id,Double>();
    //查找客户上的金额 订单未付款，付款金额返点，付款金额非返点
    for(AggregateResult ReturnAmountX : ReturnAmount){
        if(!mapReturnAmount.containsKey(String.valueOf(ReturnAmountX.get('ReturnPayAccount__c')))){
            mapReturnAmount.put(String.valueOf(ReturnAmountX.get('ReturnPayAccount__c')),Double.valueOf(ReturnAmountX.get('ReAmoSum')));
        }
    }
    system.debug('mapReturnAmount is infor:'+mapReturnAmount);
    list<Account> list_acR = [select OrderReturnAmount__c,Id  from Account where Id in:reAid];
    if(list_acR.size() > 0){
        for(Account accX : list_acR){
            if(mapReturnAmount.containsKey(accX.Id)){
                if(mapReturnAmount.containsKey(accX.Id)){
                     if(mapReturnAmount.get(accX.Id) < 0)
                     {
                         accX.OrderReturnAmount__c = mapReturnAmount.get(accX.Id) * (-1);
                     } 
                     else
                     {
                    accX.OrderReturnAmount__c = mapReturnAmount.get(accX.Id);
                    }
                }else{
                if(accX.OrderReturnAmount__c < 0)
                {
                    accX.OrderReturnAmount__c = accX.OrderReturnAmount__c * (-1);  
                }
                else
                {
                    accX.OrderReturnAmount__c = accX.OrderReturnAmount__c;  
                }
                    
                }
            }
        }
    }
    update list_acR;
  }
}