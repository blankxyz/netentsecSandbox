/**
*Dis:默认情况下如果订单付款方不填写，则与渠道代理商的值相等
*Author:Vito_He
*Time:2013年4月24日 13:49
*Modify:Gary_Hu
*Dis:创建，修改订单时，给订单加上客户的服务编号
*Dis:创建订单时，自动赋业务机会上的业务机会类型
*Time：2013年4月26日21:51:41
*Dis:当业务员不为空时，自动将订单所有者更改为业务员
*Time:2013年6月4日 09:43:51
*Modifly Dis: 自动给 所在区域 赋值
*Modifly Time:2013年8月8日11:55:15
**/
trigger Order_Payer on Orders__c (before insert, before update) { 
    
    set<Id> cId = new set<Id>();                         //客户Id
    Map<Id,string> accService = new Map<Id,string>();    //客户id,服务编号    
    set<Id> oId = new set<Id>();//业务机会Id
      set<Id> sId = new set<Id>();
    for(Orders__c orderc : trigger.new){
    	//如果新增订单并且订单日期没有值的情况，修改订单日期为当前值
        if(trigger.isInsert){
    		if(orderc.ordersDate__c==null){
    			orderc.ordersDate__c=date.today(); 
    		}
    	}
        if(orderc.Partners__c != null && orderc.Payer__c == null){  //如果渠道代理商不为空并且付款方为空的情况下
            orderc.Payer__c = orderc.Partners__c; 
        }
        if(orderc.SalesOpportunities__c != null){ 
            oId.add(orderc.SalesOpportunities__c);
        } 
        if(orderc.CommerciaTraveller__c != null){
        	orderc.OwnerId = orderc.CommerciaTraveller__c;
        }
        //订单区域
        if(orderc.SalesRegion__c != null && orderc.RecordTypeName__c == '退货订单'){
        	sId.add(orderc.SalesRegion__c );
        }
        
    }
     if(sId.size()>0){
    	map<String,String> mapRegionName = new map<String,String>();
    	list<SalesRegion__c> listRegion = [Select s.Name, s.Id From SalesRegion__c s where id in:sId];
    	if(listRegion.size() > 0){
	    	for(SalesRegion__c listRegionX : listRegion ){
	    		if(!mapRegionName.containsKey(String.valueOf(listRegionX.Id))){
	    			mapRegionName.put(String.valueOf(listRegionX.Id),String.valueOf(listRegionX.Name));
	    		}
	    	}
    	}
    	for(Orders__c orderc : trigger.new){
    		orderc.AutoDep__c = mapRegionName.get(orderc.SalesRegion__c);
    	}
    }
    
  /***订单上自动加上业务机会的类型,自动添加业务员***/
  system.debug('-----------------oId.size()---------------'+oId.size());
  if(oId.size()>0){
  	 system.debug('-----------------oId.size()---------------'+oId.size());
     map<Id,Opportunity> mapOppType = new map<Id,Opportunity>([select Id,OppProperties__c,OwnerId from Opportunity where Id in: oId]);  
     system.debug('-----------------mapOppType---------------'+mapOppType);

     for(Orders__c orderc : trigger.new){ 
        if(orderc.OppRecordType__c == null){
            if(mapOppType.containsKey(orderc.SalesOpportunities__c)){
                orderc.OppRecordType__c = mapOppType.get(orderc.SalesOpportunities__c).OppProperties__c;
            }
        }
        if(orderc.CommerciaTraveller__c == null){
        	   if(mapOppType.containsKey(orderc.SalesOpportunities__c)){
        	   	system.debug('-------------mapOppType.get(orderc.SalesOpportunities__c).OwnerId-----------'+mapOppType.get(orderc.SalesOpportunities__c).OwnerId);
                orderc.CommerciaTraveller__c = mapOppType.get(orderc.SalesOpportunities__c).OwnerId; 
                
            }
        }
        if(orderc.CommerciaTraveller__c != null){
        	orderc.OwnerId = orderc.CommerciaTraveller__c;
        }
     }
  }
}