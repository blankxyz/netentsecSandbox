//判断内部样机的实际(预计)费用是否超过费用指标,如果超标,50%,80%发邮件提醒
//lurrykong
//2013年5月2日。
//汇总当区域当月的费用指标的实际金额.(借用人已签收)
global class clsDetermineWhetherOverWeight implements Database.Batchable<SObject>, Database.Stateful
{
	global Database.queryLocator start(Database.BatchableContext ctx)
	{
		//得到内部样机订单下的订单明细																												条件：内部样机订单,测试完毕,借用人签收日期不为空
		return Database.getQueryLocator([Select id,n_OrderNo__r.RecordTypeName__c,n_OrderNo__r.IfCostOverWeight__c,n_OrderNo__r.Replacement1__c, n_OrderNo__r.customer__c, n_OrderNo__r.Id, n_OrderNo__c,
																												n_ProductByOrd__c,n_ProductByOrd__r.NewProductPrice__c,n_ProductByOrd__r.OldProductPrice__c,Field1__c,
																												Nowactual__c,demoamount__c,TestStatus__c,WhetherTheDelay__c,AddDate__c,KuguanContractDate__c,
																												Demostar__c,Demoend__c,BorrowerReceiptDate__c,IfNewProduct__c,PracticalExpectPrice__c	 
																		 										from OrderDetails__c 
																		 										where n_OrderNo__r.RecordTypeName__c='内部样机订单'and TestStatus__c='测试中' and BorrowerReceiptDate__c!=null 
																		 										and (n_OrderNo__r.ApprovalStatus__c='已审批' or n_OrderNo__r.ApprovalStatus__c='延期已审批')]); 											 											
	}
	global void execute(Database.BatchableContext ctx, List<Sobject> scope)
	{
		list<PrototypeCosts__c> listUpproto=new list<PrototypeCosts__c>();	  
		//销售区域,年,季度为键,list<PrototypeCosts>为值
		map<string,list<PrototypeCosts__c>> maplistProto=new map<string,list<PrototypeCosts__c>>();
		//id,季度,可用金额,年,实际金额,销售区域,预算金额,月,50%,80%,100%
		list<PrototypeCosts__c> listProtoTypeCost=[select id,Quarter__c,ReAmount__c,n_Year__c,n_FactAmount__c,n_SaleArea__c,n_BudgetAmount__c,n_Month__c,
																												IfOverWeight50__c,
																												IfOverWeight80__c,
																												IfOverWeight100__c from PrototypeCosts__c];
		if(listProtoTypeCost.size()>0)
		{
			system.debug('---------------------scope------------------'+scope); 
			for(PrototypeCosts__c protocost:listProtoTypeCost)
			{
				if(protocost.n_SaleArea__c!=null&&protocost.n_Year__c!=null&&protocost.Quarter__c!=null)				//销售区域,年,季度
				{
					string str=string.valueOf(protocost.n_SaleArea__c)+string.valueOf(protocost.n_Year__c)+string.valueOf(protocost.Quarter__c);
					if(!maplistProto.containsKey(str))
					{
						list<PrototypeCosts__c> listprocost=new list<PrototypeCosts__c>();
						listprocost.add(protocost);
						maplistProto.put(str,listprocost);
					}
					else
					{
						list<PrototypeCosts__c> listprocost=maplistProto.get(str);
						listprocost.add(protocost);
					}
				}
			}
		}
		
		
		
		//销售区域,年,季度为键,费用指标的预算金额为值
		map<string,decimal> mapBudgeAmount=new map<string,decimal>(); 

		//按费用指标的销售区域,年,季度,分组,汇总	预算金额
		AggregateResult[] aggProCostResult=[select sum(n_BudgetAmount__c)sumYuSuan,n_SaleArea__c,n_Year__c,Quarter__c from PrototypeCosts__c
																									where Quarter__c!=null and n_SaleArea__c!=null
																									group by n_SaleArea__c,n_Year__c,Quarter__c];
		system.debug('................................aggProCostResult...................................'+aggProCostResult);
		for(AggregateResult ar:aggProCostResult)
		{
			string str=string.valueOf(ar.get('n_SaleArea__c'))+string.valueOf(ar.get('n_Year__c'))+string.valueOf(ar.get('Quarter__c'));
			if(!mapBudgeAmount.containsKey(str))
			{
				decimal deci=decimal.valueOf(String.valueOf(ar.get('sumYuSuan')));
				mapBudgeAmount.put(str,deci);
			}
		}
		system.debug('................................mapBudgeAmount......................................'+mapBudgeAmount.values());
		//查询订单明细							汇总实际费用(预计费用),销售区域,年,季度					条件:内部样机订单,！=测试完毕,借用人签收日期！=null																							
		AggregateResult[] aggOrderDetailResult=[select sum(PracticalExpectPrice__c)sumFeiYong,n_OrderNo__r.SalesRegion__c,n_Year__c,Quarter__c from OrderDetails__c
																									where n_OrderNo__r.RecordTypeName__c='内部样机订单' and TestStatus__c='测试中' 
																									and BorrowerReceiptDate__c!=null and(n_OrderNo__r.ApprovalStatus__c='已审批' or n_OrderNo__r.ApprovalStatus__c='延期已审批') 
																									group by n_OrderNo__r.SalesRegion__c,n_Year__c,Quarter__c];	   
																				                             				
		system.debug('...............................................aggOrderDetailResult..'+aggOrderDetailResult);
		for(AggregateResult ar:aggOrderDetailResult)
		{ 
			string str=string.valueOf(ar.get('SalesRegion__c'))+string.valueOf(ar.get('n_Year__c'))+string.valueOf(ar.get('Quarter__c'));
			system.debug('str......................................'+str+'map=='+mapBudgeAmount.containsKey(str));
			system.debug('str222......................................'+str+'map=='+maplistProto.containsKey(str));  
			if(mapBudgeAmount.containsKey(str))
			{  
				decimal budgetAmount=mapBudgeAmount.get(str);																	//当前销售区域,年份,季度的费用指标的预算金额					
				decimal sumFeiYong=decimal.valueOf(string.valueOf(ar.get('sumFeiYong')));										//实际预计费用								
				system.debug('.....................................budgetAmount'+budgetAmount);
				system.debug('.....................................sumFeiYong'+sumFeiYong);		 		
				if(budgetAmount*0.8>sumFeiYong&&sumFeiYong>=budgetAmount*0.5)					//大于0.5,小于0.8
				{
					if(maplistProto.containsKey(str))
					{
						list<PrototypeCosts__c> listpro=maplistProto.get(str);
						if(listpro.size()>0)
						{
							for(PrototypeCosts__c pc:listpro)
							{
								pc.IfOverWeight50__c=true;
								pc.IfOverWeight80__c=false;		
								pc.IfOverWeight100__c=false;
								listUpproto.add(pc);
							}		
						}	
					}			
				}
				if(budgetAmount>sumFeiYong&&sumFeiYong>=budgetAmount*0.8)						//大于0.8,小于1
				{
					if(maplistProto.containsKey(str))
					{
						list<PrototypeCosts__c> listpro=maplistProto.get(str);
						if(listpro.size()>0)
						{
							for(PrototypeCosts__c pc:listpro)
							{
								pc.IfOverWeight80__c=true;	
								pc.IfOverWeight100__c=false;	
								pc.IfOverWeight50__c=false;
								listUpproto.add(pc);						
							}		
						}	
					}
				}
				if(sumFeiYong>budgetAmount)														//大于100%
				{
					if(maplistProto.containsKey(str))
					{
						list<PrototypeCosts__c> listpro=maplistProto.get(str);
						if(listpro.size()>0)
						{
							for(PrototypeCosts__c pc:listpro)
							{
								pc.IfOverWeight100__c=true;
								pc.IfOverWeight50__c=false;
								pc.IfOverWeight80__c=false;
								listUpproto.add(pc);
							}		
						}	
					}
				}
				
			}
		
		}
		system.debug('.....................listUpproto........................'+listUpproto);
		if(listUpproto.size()>0)
		update listUpproto;
	}
	global void finish(Database.BatchableContext ctx)
	{
	       	
	}
	
}