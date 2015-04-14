/**
*Dis:订单明细借用人签收后，查看本季度，本部门的费用指标是否超过预算金额的50%，80%，100%
*Author:Vito_He
*Time:2013年5月13日 15:27:42
**/
trigger OrderDetails_Cost on OrderDetails__c (after update) { 
    set<string> setBuYearQuater = new set<string>();
    if(trigger.isUpdate) 
    {  
        for(OrderDetails__c od : trigger.new) 
        {   
        	if(od.BorrowerReceiptDate__c!=null){ 
	            OrderDetails__c oldOD = trigger.oldMap.get(od.id);
	            if(od.PracticalExpectPrice__c != oldOD.PracticalExpectPrice__c)
	            {
	                setBuYearQuater.add(od.Bussines_Year_Quater__c);
	            } 
	            if(od.BorrowerReceiptDate__c != oldOD.BorrowerReceiptDate__c)
	            {
	                setBuYearQuater.add(od.Bussines_Year_Quater__c);
	            }
        	} 	 
        }   
        System.debug('---------------------------setBuYearQuater---------------'+setBuYearQuater);
        if(setBuYearQuater.size()>0){
            Map<string,Decimal> orderDetail_sum = new Map<string,Decimal>();   //按部门-年-季度 分组统计
            Map<string,Decimal> prototypeCost_sum = new Map<string,Decimal>(); //按部门-年-季度 分组统计
            Map<String,list<PrototypeCosts__c>> BuYearQuater_proList = new  Map<String,list<PrototypeCosts__c>>();//按部门-年-季度,费用指标
            list<PrototypeCosts__c> protoList = new list<PrototypeCosts__c>(); //要更新的费用指标list
            
        	//订单明细所有数据
        	list<OrderDetails__c> listOrderDetail =  [select Bussines_Year_Quater__c,PracticalExpectPrice__c
                                                from OrderDetails__c 
                                                where TestStatus__c = '测试中'
                                                	and n_OrderNo__r.ApprovalStatus__c = '已审批'
                                                    and BorrowerReceiptDate__c != null
                                                    and Bussines_Year_Quater__c in: setBuYearQuater];
            
            if(listOrderDetail!=null){
	            for(OrderDetails__c oc :listOrderDetail){
	            	if(orderDetail_sum.containsKey(oc.Bussines_Year_Quater__c)){
	            		Decimal price = orderDetail_sum.get(oc.Bussines_Year_Quater__c) + oc.PracticalExpectPrice__c;
	            		orderDetail_sum.put(oc.Bussines_Year_Quater__c,price);
	            	}else{
	            		orderDetail_sum.put(oc.Bussines_Year_Quater__c,oc.PracticalExpectPrice__c); 
	            	}
	            }                                         
            }
                                                
            System.debug('------------------------orderDetail_sum------------------'+orderDetail_sum);                               
	        //样机费用指标
	        list<PrototypeCosts__c> listPrototypeCosts = [select Bussines_Year_Quater__c,n_BudgetAmount__c
	                                                    from PrototypeCosts__c 
	                                                    where Bussines_Year_Quater__c in: setBuYearQuater
	                                                    ];
	        System.debug('------------------------listPrototypeCosts------------------'+listPrototypeCosts);
            if(listPrototypeCosts!=null){
            	for(PrototypeCosts__c pc :listPrototypeCosts){
	            	if(prototypeCost_sum.containsKey(pc.Bussines_Year_Quater__c)){
	            		Decimal price = prototypeCost_sum.get(pc.Bussines_Year_Quater__c)+pc.n_BudgetAmount__c;
	            		prototypeCost_sum.put(pc.Bussines_Year_Quater__c,price); 
	            	}else{ 
	            		prototypeCost_sum.put(pc.Bussines_Year_Quater__c,pc.n_BudgetAmount__c); 
	            	}
	            	//费用样机指标 按部门-年-季度,指标 Map
	            	if(BuYearQuater_proList.containsKey(pc.Bussines_Year_Quater__c)){
		        		BuYearQuater_proList.get(pc.Bussines_Year_Quater__c).add(pc);
		        	}else{
		        		list<PrototypeCosts__c> proList = new list<PrototypeCosts__c>();
		        		proList.add(pc); 
		        		BuYearQuater_proList.put(pc.Bussines_Year_Quater__c,proList); 
		        	}
            	}  
            }
	        for(string ord:orderDetail_sum.keySet()){   
	        	for(string pro:prototypeCost_sum.keySet()){
	        		//初始化
		            for(PrototypeCosts__c pr:BuYearQuater_proList.get(ord)){
						pr.IfOverWeight50__c = false; 
						pr.IfOverWeight80__c = false; 
						pr.IfOverWeight100__c = false; 
					}  
	        		if(ord == pro){
	        			System.debug('---------------------------orderDetail_sum.get(ord)---------------'+orderDetail_sum.get(ord));  
	        			System.debug('---------------------------prototypeCost_sum.get(ord)---------------'+prototypeCost_sum.get(ord));  
	        			if(orderDetail_sum.get(ord) > prototypeCost_sum.get(ord)){
	        				for(PrototypeCosts__c pr:BuYearQuater_proList.get(ord)){
	                        	pr.IfOverWeight50__c = false;  
	                        	pr.IfOverWeight80__c = false;  
	                        	pr.IfOverWeight100__c = true;
	                        }
	        			}
	        			else if(orderDetail_sum.get(ord) > prototypeCost_sum.get(ord)*4/5)  
	        			{ 
	        				for(PrototypeCosts__c pr:BuYearQuater_proList.get(ord)){ 
	                        	pr.IfOverWeight50__c = false;
	                        	pr.IfOverWeight80__c = true; 
	                        }
	        			}
	        			else if(orderDetail_sum.get(ord) > prototypeCost_sum.get(ord)*1/2){
	        				for(PrototypeCosts__c pr:BuYearQuater_proList.get(ord)){
	                        	pr.IfOverWeight50__c = true;  
	                        }
	        			}
	        		}
	       		}
	        }  
	        System.debug('============protoList================'+protoList);
	        for(string s:BuYearQuater_proList.keySet()){
	        	protoList.addAll(BuYearQuater_proList.get(s)); 
	        }
	        System.debug('============protoList================'+protoList);
	        if(protoList.size()>0)update protoList; 
        }
    }
}