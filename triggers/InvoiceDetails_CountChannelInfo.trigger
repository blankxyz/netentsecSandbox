/**
*Dis:发票明细，订单如果勾选特价，这修改该渠道代理商上的 渠道指标的相关信息。
*Author:Gary_Hu
*Time:2013年4月10日11:08:06
**/
trigger InvoiceDetails_CountChannelInfo on InvoiceDetails__c (after delete, after insert, after undelete, after update) {
	set<id> aId = new set<Id>(); //客户Id
	set<id> oId = new set<Id>(); //订单Id
	set<String> year = new set<String>(); //年
	set<String> quarter = new set<String>();//季度
	if(Trigger.isDelete){
		for(InvoiceDetails__c ic : trigger.old){
			if(ic.InvoicesCustomers__c != null){
				aId.add(ic.InvoicesCustomers__c);
			}
			if(ic.OrderId__c != null){
				oId.add(ic.OrderId__c);
			}
			if(ic.InvoiceYear__c != null){
				year.add(ic.InvoiceYear__c);
			}
			if(ic.Quarter__c != null){
				quarter.add(ic.Quarter__c);
			}
		}
	}
	else{
		for(InvoiceDetails__c ic : trigger.new){
		system.debug('***********ic.InvoicesCustomers__c***********************' + ic.InvoicesCustomers__c);
			if(ic.InvoicesCustomers__c != null){
				aId.add(ic.InvoicesCustomers__c);
			}
			if(ic.OrderId__c != null){
				oId.add(ic.OrderId__c);
			}
			if(ic.InvoiceYear__c != null){
				year.add(ic.InvoiceYear__c);
			}
			if(ic.Quarter__c != null){
				quarter.add(ic.Quarter__c);
			}
		}
	}

	
	
	/***********************所属订单的开票*******************************/
	/*
	//统计出所属订单的开票的金额
	AggregateResult [] inSumAmo = [select sum(Amount__c) iNAmoSum,OrderId__c from InvoiceDetails__c where OrderId__c in: oId group by OrderId__c ];
	
	//构建Map ，订单ID,所开票的金额
	Map<String,Double> mapOrderSum=new Map<String,Double>();
	for(AggregateResult arISum : inSumAmo){
		if(!mapOrderSum.containsKey(string.valueOf(arISum.get('OrderId__c')))){
			mapOrderSum.put(string.valueOf(arISum.get('OrderId__c')),Double.valueOf(arISum.get('iNAmoSum')));
		}
	}
	//查询出订单，键订单Id,值为订单对象
	list<Orders__c> oc = [select Partners__c,isSale__c,customer__c,Invoiced__c from Orders__c where Id in: oId];
	if(oc.size() > 0){
			for(Orders__c ocX : oc){
					if(mapOrderSum.containsKey(ocX.id))
					{
						if(mapOrderSum.get(ocX.id)!=null)
						{
							ocX.Invoiced__c=mapOrderSum.get(ocX.id);
						}
						else
						{
							ocX.Invoiced__c=0;
						}
					}else{
						ocX.Invoiced__c=0;
					}
				}
			}
	update oc;
	*/
   /***********************统计渠道指标上的开票业绩*******************************/
	system.debug('-------------------------***********************--------------------');
	list <SalesTargets__c> sc = [select Q1SpecialOffer__c,AQuarterOFtasks__c,Q2SpecialOffer__c,AQuarterOFtasks2__c,
								  Q3SpecialOffer__c,AQuarterOFtasks3__c,Q4SpecialOffer__c,AQuarterOFtasks4__c,Year__c,n_customerName__c
								  from SalesTargets__c 
								  where Year__c in: year and n_customerName__c in: aId
								  ];
					
								  
	system.debug('----------------------------sc.size()---------------------'+sc.size());
	system.debug('----------------------------year---------------------'+year);
	system.debug('----------------------------aId---------------------'+aId);
	
	AggregateResult [] allSumAmo = [select InvoiceYear__c,InvisSale__c,Quarter__c,InvoicesCustomers__c,sum(Amount__c) iNAmoSum
									from InvoiceDetails__c where InvoicesCustomers__c in: aId and InvoiceYear__c in: year 
									group by InvoicesCustomers__c,InvoiceYear__c,Quarter__c,InvisSale__c
									]; 
									
	//键为客户，年，季度，是否特价 值为金额
	map<String,Decimal> mapAmo = new map<String,Decimal>();
	for(AggregateResult allSumAmoX : allSumAmo){
		String conKey = String.valueOf(allSumAmoX.get('InvoiceYear__c')) + '-' + String.valueOf(allSumAmoX.get('InvisSale__c'))
						+ '-' + String.valueOf(allSumAmoX.get('Quarter__c')) + '-' + String.valueOf(allSumAmoX.get('InvoicesCustomers__c')) ;
	   if(!mapAmo.containsKey(conKey)){
	   		mapAmo.put(conKey,Double.valueOf(allSumAmoX.get('iNAmoSum')));
	   }
	}
	
	
	
	//键为客户+年+季度+每季度特价开票+正常开票，值为指标对象
	map<String,SalesTargets__c> mapSalesTargets = new map<String,SalesTargets__c>();
	
	if(sc.size() > 0){
	
		for(SalesTargets__c scX: sc){
		
			String conKeyX = String.valueOf(scX.n_customerName__c) +'-'+ String.valueOf(scX.Year__c);
			
			if(!mapSalesTargets.containsKey(conKeyX)){
				mapSalesTargets.put(conKeyX,scX);
			}
			
		}
		
		for(String s : mapSalesTargets.keySet()){
			
			List<String> parts = s.split('-'); 
		
			 	String conkeyT = parts[0]+'-'+ parts[1]; // mapSalesTargets 键
			 	
			 	String conkeySa = parts[1]+'-false'+'-Q1-' +parts[0];//mapAmo键 Q1正常开票业绩
			 
			 	if(mapAmo.containsKey(conkeySa)){
			 	
			 		if(mapAmo.get(conkeySa) != null){
				 		mapSalesTargets.get(conkeyT).AQuarterOFtasks__c = mapAmo.get(conkeySa);
				 		
			 		}else{
			 			mapSalesTargets.get(conkeyT).AQuarterOFtasks__c = 0;
			 		}
			 	}else{
			 			mapSalesTargets.get(conkeyT).AQuarterOFtasks__c = 0;
			 	}
			 	
			 	String conkeySb = parts[1]+'-true'+'-Q1-' +parts[0];//mapAmo键 Q1特价开票业绩
			 	if(mapAmo.containsKey(conkeySb)){
			 		if(mapAmo.get(conkeySb) != null){
				 		mapSalesTargets.get(conkeyT).Q1SpecialOffer__c = mapAmo.get(conkeySb);
			 		}else{
			 			mapSalesTargets.get(conkeyT).Q1SpecialOffer__c = 0;
			 		}
			 	}else{
			 		mapSalesTargets.get(conkeyT).Q1SpecialOffer__c = 0;
			 	}
			 	
			 	
			 	
			 	String conkeySc = parts[1]+'-false'+'-Q2-' +parts[0];//mapAmo键  Q2正常开票业绩
		 		if(mapAmo.containsKey(conkeySc)){
			 		if(mapAmo.get(conkeySc) != null){
				 		mapSalesTargets.get(conkeyT).AQuarterOFtasks2__c = mapAmo.get(conkeySc);
			 		}else{
			 			mapSalesTargets.get(conkeyT).AQuarterOFtasks2__c = 0;
			 		}
			 	}else{
			 			mapSalesTargets.get(conkeyT).AQuarterOFtasks2__c = 0;
			 	}	
			 	
 				String conkeySd = parts[1]+'-true'+'-Q2-' +parts[0];//mapAmo键  Q2特价开票业绩
		 		if(mapAmo.containsKey(conkeySd)){
			 		if(mapAmo.get(conkeySd) != null){
				 		mapSalesTargets.get(conkeyT).Q2SpecialOffer__c = mapAmo.get(conkeySd);
			 		}else{
			 			mapSalesTargets.get(conkeyT).Q2SpecialOffer__c = 0;
			 		}
			 	}else{
			 		mapSalesTargets.get(conkeyT).Q2SpecialOffer__c = 0;
			 	}	
			 	
			 	String conkeySe = parts[1]+'-false'+'-Q3-' +parts[0];//mapAmo键  Q3正常开票业绩
		 		if(mapAmo.containsKey(conkeySe)){
			 		if(mapAmo.get(conkeySe) != null){
				 		mapSalesTargets.get(conkeyT).AQuarterOFtasks3__c = mapAmo.get(conkeySe);
			 		}else{
			 			mapSalesTargets.get(conkeyT).AQuarterOFtasks3__c = 0;
			 		}
			 	}else{
			 		mapSalesTargets.get(conkeyT).AQuarterOFtasks3__c = 0;
			 	}	
			 	
			 	String conkeySf = parts[1]+'-true'+'-Q3-' +parts[0];//mapAmo键  Q3特价开票业绩
		 		if(mapAmo.containsKey(conkeySf)){
			 		if(mapAmo.get(conkeySf)!= null){
				 		mapSalesTargets.get(conkeyT).Q3SpecialOffer__c = mapAmo.get(conkeySf);
			 		}else{
			 			mapSalesTargets.get(conkeyT).Q3SpecialOffer__c = 0;
			 		}
			 	}else{
			 		mapSalesTargets.get(conkeyT).Q3SpecialOffer__c = 0;
			 	}
			 	
			 	String conkeySg = parts[1]+'-false'+'-Q4-' +parts[0];//mapAmo键  Q4正常开票业绩
		 		if(mapAmo.containsKey(conkeySg)){
			 		if(mapAmo.get(conkeySg) != null){
				 		mapSalesTargets.get(conkeyT).AQuarterOFtasks4__c = mapAmo.get(conkeySg);
			 		}else{
			 			mapSalesTargets.get(conkeyT).AQuarterOFtasks4__c = 0;
			 		}
			 	}else{
			 		mapSalesTargets.get(conkeyT).AQuarterOFtasks4__c = 0;
			 	}
			 	
			 	String conkeySh = parts[1]+'-true'+'-Q4-' +parts[0];//mapAmo键  Q4特价开票业绩
		 		if(mapAmo.containsKey(conkeySh)){
			 		if(mapAmo.get(conkeySh) != null){
				 		mapSalesTargets.get(conkeyT).Q4SpecialOffer__c = mapAmo.get(conkeySh);
			 		}else{
			 			mapSalesTargets.get(conkeyT).Q4SpecialOffer__c = 0;
			 		}
			 	}else{
			 		mapSalesTargets.get(conkeyT).Q4SpecialOffer__c = 0;
			 	}
			 	
		  }
		  update sc;
		
	}else{
		for(InvoiceDetails__c ic : trigger.new){
			DataFormat.SendEmailInvoi(ic.InvoicesCustomers__c, 3);
			ic.addError('对不起，该渠道代理商下还未新建销售指标，请确保信息完整后进行操作！');
		}
	}
	
	
	
}