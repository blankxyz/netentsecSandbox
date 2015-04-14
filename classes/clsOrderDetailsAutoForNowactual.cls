/**
*Dis:订单明细上自动统计截止到目前的金额
*Author:Gary_Hu
*Time:2013年4月7日12:08:08
**/
global class  clsOrderDetailsAutoForNowactual implements Database.Batchable<SObject>, Database.Stateful{
	 global Database.queryLocator start(Database.BatchableContext ctx){
	       return Database.getQueryLocator([Select o.orders__r.Id
     										From OfYahuoTurnSeller__c o 
     										where o.orders__r.n_OrderNo__r.RecordType.Name ='内部样机订单' 
     										and orders__r.BorrowerReceiptDate__c <> null and orders__r.TestStatus__c = '测试中'] ); 
	 }
	 global void execute(Database.BatchableContext ctx, List<Sobject>  scope){
	 	Date dtToday = Date.today();	//当前时间
		Integer intYear = dtToday.year();			
		Integer intMonth = dtToday.month();
		Integer intDay = dtToday.day();
	 	Double nowAmount = 0;	//当前费用
	 	Set<Id> oId = new Set<Id>(); //订单
	 	Double  demoAmount = 0; //样机费用
	 	Set<Id> pId = new Set<Id>(); // 产品Id
	 	String pState = null; //样机状态
	 	Integer iNo = 0;	//系数
	 	Integer iCount = 0;
	    List<OrderDetails__c> orderList = new List<OrderDetails__c>();
	    for(Sobject sc : scope){
	    	OfYahuoTurnSeller__c orders = (OfYahuoTurnSeller__c)sc;
	    	if(orders != null){
			 	oId.add(orders.orders__r.Id);
	    	}
	    	
	 }
	 //查询出订单明细
	 list<OrderDetails__c> list_orc = [Select o.Id,o.n_ProductByOrd__r.OldProductPrice__c, o.n_ProductByOrd__r.NewProductPrice__c, o.n_ProductByOrd__c, o.Nowactual__c,o.BorrowerReceiptDate__c From OrderDetails__c o where Id in: oId ];
	 //查询发货明细SN 
	 list<OfYahuoTurnSeller__c> list_sellSn = [Select o.orders__r.Id, o.orders__c, o.n_SN__r.demoStatus__c, o.n_SN__c From OfYahuoTurnSeller__c o where o.orders__r.Id in: oId];
	 //
	 for(OrderDetails__c orcList : list_orc){
	 	for(OfYahuoTurnSeller__c sellSnList : list_sellSn){
	 		if(orcList.Id == sellSnList.orders__r.Id){
	 			iNo = orcList.BorrowerReceiptDate__c.daysBetween(Date.today());
	 			System.debug(orcList+'**************orcList***************');
	 			System.debug(orcList+'**************orcList***************');
			 	if(iNo <= 30){
			 		iCount = 1;	
			 	}
			 	if(iNo > 30){
			 		iCount = iNo / 30;
			 		if(iNo > iCount * 30){
			 			iCount = iCount + 1;
			 		}
			 	}
			 	System.debug(iCount+'************iCount***************');
			 	pState = sellSnList.n_SN__r.demoStatus__c;
			 	if(pState == '新样机'){
			 		if(orcList.n_ProductByOrd__r.NewProductPrice__c != null){
				 		demoAmount = orcList.n_ProductByOrd__r.NewProductPrice__c;
			 		}else{
			 			demoAmount = 0;
			 		}
			 	}
				if(pState == '旧样机'){
			 		if(orcList.n_ProductByOrd__r.NewProductPrice__c != null){
				 		demoAmount = orcList.n_ProductByOrd__r.NewProductPrice__c;
			 		}else{
			 			demoAmount = 0;
			 		}
			 	}
			 	if(orcList.Nowactual__c == null){
			 		orcList.Nowactual__c =0;
			 	}
			 	
			 	
			 	decimal predictprice = demoAmount * iCount;
			 	orcList.Nowactual__c = predictprice;
			 	System.debug(pState+'*********************'+orcList.Nowactual__c+'******'+demoAmount+'基础费用'+iCount+'系数');
			 	System.debug(list_orc.size()+'**********orcList.size()***********');
			 	orderList.add(orcList);
	 		}
	 	}
	 }
	 update orderList;
	 
	 
	  
 }
   global void finish(Database.BatchableContext ctx){
	       	
    }
}