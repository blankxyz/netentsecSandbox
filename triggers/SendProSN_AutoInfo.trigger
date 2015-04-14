/**
*Dis:渠道样机订单个数统计
*Dis:统计压货订单下的剩余，库存，出售的数量
*Author：Gary_Hu
*Time:2013年4月17日16:16:29
**/
trigger SendProSN_AutoInfo on SendProSN__c (after delete, after insert, after update) {
	
	Set<Id> aId = new Set<Id>();  //客户编号
	Set<Id> sId = new Set<Id>(); //发货明细SNId
	String oTypeName = null;   //订单类型名称
	Integer snCount = 0;		//渠道样机个数
	Set<Id> snId = new Set<Id>(); //序列号的名称
	Integer snSell = 0; //出售
	Integer snOverstock = 0;//压货
	Integer snCounts = 0; //总数
	String  orderState = null; //订单审核状态

	/******************渠道样机客户统计渠道样机个数**************/
	if(trigger.isDelete){
		for(SendProSN__c sendsn : trigger.old){
			if(sendsn.OrderRecordType__c == '渠道样机订单'){
				if(sendsn.S_ShippingDetails__c != null){
					sId.add(sendsn.Id);
					snId.add(sendsn.S_SN__c);
				}
				if(sendsn.S_Client__c != null){
					aId.add(sendsn.S_Client__c);
					
				}
			}
		} 
	}else{
		for(SendProSN__c sendsn : trigger.new){
			if(sendsn.OrderRecordType__c == '渠道样机订单'){
				if(sendsn.S_ShippingDetails__c != null){
					sId.add(sendsn.Id);
					snId.add(sendsn.S_SN__c);
				}
				if(sendsn.S_Client__c != null){
					aId.add(sendsn.S_Client__c);
				}
			}
		}
	}
	
	
	if(sId.size() > 0 && aId.size() > 0){   
		//统计客户下所有的渠道样机个数
		list<SendProSN__c> list_sn = [select  S_ShippingDetails__r.n_Shipmentname__r.n_orders__r.Partners__r.Id  
										from SendProSN__c 
										where S_ShippingDetails__r.n_Shipmentname__r.n_orders__r.Partners__r.Id in: aId  
										and OrderRecordType__c ='渠道样机订单' and S_ShippingDetails__r.n_Shipmentname__r.n_orders__r.ApprovalStatus__c ='已审批'
										and CALENDAR_YEAR(CreatedDate) =: date.today().year()];
		
		
		//构建Map ,客户Id,已申请的样机个数
		map<Id,Double> mapCountCSn = new map<Id,Double>();
		if(list_sn.size() > 0){
			for(SendProSN__c list_snX :list_sn){
				if(!mapCountCSn.containsKey(String.valueOf(list_snX.S_ShippingDetails__r.n_Shipmentname__r.n_orders__r.Partners__r.Id))){
					mapCountCSn.put(String.valueOf(list_snX.S_ShippingDetails__r.n_Shipmentname__r.n_orders__r.Partners__r.Id),1);
				
				}else{
					Double sumX = mapCountCSn.get(String.valueOf(list_snX.S_ShippingDetails__r.n_Shipmentname__r.n_orders__r.Partners__r.Id));
					sumX++;
					mapCountCSn.put(String.valueOf(list_snX.S_ShippingDetails__r.n_Shipmentname__r.n_orders__r.Partners__r.Id),sumX);
					System.debug(sumX+'+++++++++++++++++++++++sumX+++++++++++++++++++++++++');
				}
			}
		}
		
		System.debug(mapCountCSn+'++++++++mapCountCSn++++++++++');
		//查询客户
		list<Account> list_acc = [select ChannelProCount__c,Id from Account where id in: aId];
									  
		if(list_acc.size() > 0){
			for(Account list_accX :list_acc){
				if(mapCountCSn.get(list_accX.Id) != null){
					list_accX.ChannelProCount__c = mapCountCSn.get(list_accX.Id);
				}else{
					list_accX.ChannelProCount__c = 0;
				}
			}
			update list_acc;
		}
	}
	
	

	/****统计压货订单的库存量******/
	set<Id> yOid = new set<Id> (); //压货订单
	Set<Id> oId = new Set<Id>();   //订单编号
	if(trigger.isDelete){
	  for(SendProSN__c sendsn : trigger.old){
		if(sendsn.OrderRecordType__c =='压货订单' && sendsn.S_Order__c != null){
			yOid.add(sendsn.S_Order__c);
			oId.add(sendsn.S_Order__c);
		}
	  }
	}else{
		for(SendProSN__c sendsn : trigger.new){
		if(sendsn.OrderRecordType__c =='压货订单' && sendsn.S_Order__c != null){
			yOid.add(sendsn.S_Order__c);
			oId.add(sendsn.S_Order__c);
		}
	  }
	}
	
	
	
	if(yOid.size() > 0 && oId.size() >0){
		System.debug(yOid+'+++++++++++++++yOid++++++++++++++++++');
		//压货
		list<SendProSN__c> list_snOS = [select Id, S_ShippingDetails__r.n_Shipmentname__r.n_orders__r.Id from SendProSN__c where S_ProductStatus__c = '压货' and S_ShippingDetails__r.n_Shipmentname__r.n_orders__r.Id in: yOid];
		//构建Map 订单Id 压货的个数
		map<String,Double> mapOs = new map<String,Double>();
		
		if(list_snOS.size() > 0){
			for(SendProSN__c list_snOSX: list_snOS){
				String yConKey = list_snOSX.S_ShippingDetails__r.n_Shipmentname__r.n_orders__r.Id;
				if(!mapOs.containsKey(yConKey)){
					mapOs.put(yConKey,1);
				}else{
					Double ySumX = mapOs.get(yConKey);
					ySumX++;
					mapOs.put(yConKey,ySumX);
				}
			}
		}
		System.debug(mapOs+'++++++++++mapOs+++++++++++');
		//出售
		list<SendProSN__c> list_snSell = [select Id,S_ShippingDetails__r.n_Shipmentname__r.n_orders__r.Id from SendProSN__c where S_ProductStatus__c = '出售' and S_ShippingDetails__r.n_Shipmentname__r.n_orders__r.Id in: yOid];
		//键订单Id,值：出售个数
		map<String,Double> mapSell = new map<String,Double>();
		if(list_snSell.size() > 0){
			for(SendProSN__c list_snSellX :list_snSell){
				String sConKey = list_snSellX.S_ShippingDetails__r.n_Shipmentname__r.n_orders__r.Id;
				if(!mapSell.containsKey(sConKey)){
					mapSell.put(sConKey,1);
				}else{
					Double sSumX = mapSell.get(sConKey);
					sSumX++;
					mapSell.put(sConKey,sSumX);
				}
			}
		}
		
		//查找订单
		list<Orders__c> list_oc = [select Id,Overstock__c,Sell__c,Residue__c from Orders__c where Id in: oId];
		if(list_oc.size() > 0){
			for(Orders__c list_ocX : list_oc){
				if(mapOs.get(list_ocX.Id) != null){
					list_ocX.Overstock__c = mapOs.get(list_ocX.Id); //压货
				}else{
					list_ocX.Overstock__c = 0;
				}
				if(mapSell.get(list_ocX.Id) != null){
					list_ocX.Sell__c = mapSell.get(list_ocX.Id);//出售
				}else{
					list_ocX.Sell__c = 0;
				}
				if(list_ocX.Overstock__c !=null && list_ocX.Sell__c !=null){
					list_ocX.Residue__c = (list_ocX.Overstock__c + list_ocX.Sell__c) - list_ocX.Sell__c;
				}else{
					list_ocX.Residue__c = 0;
				}
			}
		}
		update list_oc;
	}
}