/**
*Dis:创建发票明细时，自动给发票明细上的年份,季度,客户,是否特价赋值
*Author：Gary_Hu
*Time:2013年5月10日9:25:08
**/
trigger InvoiceDetails_ForAutoInsert on InvoiceDetails__c (before insert,before update) {
		set<Id> inId = new set<Id>(); //发票Id
		set<Id> oId = new set<Id>(); //订单Id
		Date inDate = null; //日期
		String inYear = null; //年
		Integer inMonth = null;//月 
		
		for(InvoiceDetails__c inc : trigger.new){
			if(inc.OrderId__c != null){
				oId.add(inc.OrderId__c);
			}
			if(inc.n_InvoiceId__c != null){
				inId.add(inc.n_InvoiceId__c);
			}
			
		}
		//键为订单Id,值为订单对象
		map<Id,Orders__c> mapOrder = new map<Id,Orders__c>([select isSale__c,Partners__c from Orders__c where id in: oId]);
		//键为发票Id,值为发票对象
		map<Id,Invoice__c> mapInvoice = new map<Id,Invoice__c>([select n_InvoiceDate__c from Invoice__c where Id in: inId]);
		for(InvoiceDetails__c inc : trigger.new){
			//订单
			if(mapOrder.size() > 0){
				if(mapOrder.containsKey(inc.OrderId__c)){
					inc.InvisSale__c = mapOrder.get(inc.OrderId__c).isSale__c;
					inc.InvoicesCustomers__c = mapOrder.get(inc.OrderId__c).Partners__c;
			}
		  }
		  //发票
		  if(mapInvoice.size() > 0){
		  	 if(mapInvoice.containsKey(inc.n_InvoiceId__c)){
		  	 	  inDate = mapInvoice.get(inc.n_InvoiceId__c).n_InvoiceDate__c;
		  	 	  inc.InvoiceYear__c = String.valueOf(inDate.year());
		  	 	  inMonth = Integer.valueOf(inDate.month());
		  	 	  System.debug(inDate.month()+'+++++++++++inDate.month()+++++++++++++++++');
		  	 	  
		  	 	  if(inMonth <= 3){
		  	 	  	system.debug('--------------------?????????????----------');
		  	 	  	inc.Quarter__c = 'Q1';
		  	 	  }
		  	 	  if(inMonth > 3 && inMonth <=6){
		  	 	  	inc.Quarter__c = 'Q2';
		  	 	  }
		  	 	  if(inMonth > =7 && inMonth <=9){
		  	 	  	inc.Quarter__c = 'Q3';
		  	 	  }
		  	 	  if(inMonth > =10 && inMonth <=12){
		  	 	  	inc.Quarter__c = 'Q4';
		  	 	  }
		  	 }
		  }
	}
}