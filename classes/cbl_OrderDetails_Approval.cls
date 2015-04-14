/*
*
*压货订单审批,压货订单不管涉不涉及价格问题，首先需要渠道部/办事处主任审批；
*若涉及价格需要走三级审批，三级审批是：
*第一级区域办事处主任、第二级销售VP、第三级财务VP。
*审批结果以系统自动邮件方式通知销售人员，审批通过后系统以邮件方式通知到商务人员。
*（系统根据折扣范围决定由那一级审批通过后，订单创建成功）
*Update:rogersun
*982578975@qq.com
*2014-04-16
*/
public  class cbl_OrderDetails_Approval {
    
    //自定义异常对象  
    public class MyException extends Exception {}
    public void cbl_OrderDetails_Approval_afterData(list<OrderDetails__c> listOrderDetails)
    {
        set<string> setOrderId=new set<string>();
        set<string> setFamilyId=new set<string>();
        set<string> setAccountId=new set<string>();
        set<string> setProductmodelseriesId=new set<string>();
        for(OrderDetails__c os:listOrderDetails)
        {
            if(os.OrderRecordTypeName__c=='YahuoOrders')
            {
                setOrderId.add(os.n_OrderNo__c);
                setFamilyId.add(os.Family__c);
                setProductmodelseriesId.add(os.productmodelseries__c);
                
            }
            
        }
        map<id,OrderDetails__c> mapValueJudgment=new map<id,OrderDetails__c>();
        
        map<id,Account> mapAccount=new map<id,Account>();
        map<id,Orders__c> mapOrder=new map<id,Orders__c>();
        list<Orders__c> listOrder=new list<Orders__c>();
        map<string,ProdcutionDiscount__c> mapProdcutionDiscount=new map<string,ProdcutionDiscount__c>();
        if(setOrderId!=null && setOrderId.size()>0)
        {
            mapValueJudgment=getValueJudgment(setOrderId);
            setAccountId=getOrderDetailsSets(setOrderId);
            mapAccount=getAccountChannelTypeIdentity(setAccountId);
            mapOrder=getOrderInfor(setOrderId);
            mapProdcutionDiscount=getProductmodelseriesFamilyPrice(setFamilyId,setProductmodelseriesId);
            //throw new MyException('测试qmapProdcutionDiscount:'+mapProdcutionDiscount.keyset()+'+'+setFamilyId+'+'+setProductmodelseriesId);
            if(mapValueJudgment!=null && mapValueJudgment.size()>0)
            {
                for(string od:setOrderId)
                {
                    OrderDetails__c OrderDetails=mapValueJudgment.get(od);
                    Orders__c Orderss=new Orders__c();
                    Account AccountData=new Account();
                    Orderss=mapOrder.get(OrderDetails.n_OrderNo__c);
                    system.debug('Orderss.Payer__c is infor:'+Orderss.Payer__c);
                    AccountData=mapAccount.get(Orderss.Payer__c);
                    system.debug('AccountData is infor:'+AccountData);
                    system.debug('OrderDetails.Family__c:'+OrderDetails.Family__c);
                    system.debug('OrderDetails.productmodelseries__c:'+OrderDetails.productmodelseries__c);
                     system.debug('AccountData.ChannelType__c:'+AccountData.ChannelType__c);
                      system.debug('AccountData.Identity__c:'+AccountData.Identity__c);
                    system.debug('信息是：'+OrderDetails.Family__c+OrderDetails.productmodelseries__c+AccountData.ChannelType__c+AccountData.Identity__c);
                    if(mapProdcutionDiscount.containsKey(OrderDetails.Family__c+OrderDetails.productmodelseries__c+AccountData.ChannelType__c+AccountData.Identity__c))
                    {
                    	if(Orderss.isSale__c==true)
                    	{
                    		system.debug('特价走三级审批');
	                    	 Orderss.OfficeAdmApproval__c=true;
	                    	 Orderss.SalesVpApproval__c=true;
	                    	 Orderss.FinancialVpApproval__c=true;
                    	}
                    	else
                    	{
                    		if(OrderDetails.n_DiscountByord__c<mapProdcutionDiscount.get(OrderDetails.Family__c+OrderDetails.productmodelseries__c+AccountData.ChannelType__c+AccountData.Identity__c).n_Discount__c)
	                        {
	                            Orderss.OfficeAdmApproval__c=true;
	                            if(mapProdcutionDiscount.containsKey(OrderDetails.Family__c+OrderDetails.productmodelseries__c+null+'办事处主任'))
	                            {
	                                if(OrderDetails.n_DiscountByord__c<mapProdcutionDiscount.get(OrderDetails.Family__c+OrderDetails.productmodelseries__c+null+'办事处主任').n_Discount__c)
	                                {
	                                    Orderss.SalesVpApproval__c=true;
	                                }
	                                else
	                                {
	                                	Orderss.SalesVpApproval__c=false;
	                                }
	                            }
	                            else if(mapProdcutionDiscount.containsKey(OrderDetails.Family__c+null+null+'办事处主任'))
	                            {
	                                if(OrderDetails.n_DiscountByord__c<mapProdcutionDiscount.get(OrderDetails.Family__c+null+null+'办事处主任').n_Discount__c)
	                                {
	                                    Orderss.SalesVpApproval__c=true;
	                                }
	                                else
	                                {
	                                	Orderss.SalesVpApproval__c=false;
	                                }
	                            }
	                            if(mapProdcutionDiscount.containsKey(OrderDetails.Family__c+OrderDetails.productmodelseries__c+null+'销售VP'))
	                            {
	                                if(OrderDetails.n_DiscountByord__c<mapProdcutionDiscount.get(OrderDetails.Family__c+OrderDetails.productmodelseries__c+null+'销售VP').n_Discount__c)
	                                {
	                                    Orderss.FinancialVpApproval__c=true;
	                                }
	                                else
	                                {
	                                	Orderss.FinancialVpApproval__c=false;
	                                }
	                            }
	                            else if(mapProdcutionDiscount.containsKey(OrderDetails.Family__c+null+null+'销售VP'))
	                            {
	                                if(OrderDetails.n_DiscountByord__c<mapProdcutionDiscount.get(OrderDetails.Family__c+null+null+'销售VP').n_Discount__c)
	                                {
	                                    Orderss.FinancialVpApproval__c=true;
	                                }
	                                else
	                                {
	                                	Orderss.FinancialVpApproval__c=false;
	                                }
	                            }
	                        }
	                        else
	                        {
	                        	 Orderss.OfficeAdmApproval__c=false;
	                        	 Orderss.SalesVpApproval__c=false;
	                        	 Orderss.FinancialVpApproval__c=false;
	                        }
                    	}
                        
                        
                       // throw new MyException('listOrder is infor:'+listOrder);
                    }
                    else
                    {
                    	system.debug('不在签约等级的需要三级审批');
                    	 Orderss.OfficeAdmApproval__c=true;
                    	 Orderss.SalesVpApproval__c=true;
                    	 Orderss.FinancialVpApproval__c=true;
                    }
                    listOrder.add(Orderss);
                }
            }
            if(listOrder!=null && listOrder.size()>0)
            {
                //throw new MyException('listOrder is null infor:'+listOrder+'+'+listOrder.size());
                update listOrder;
                
            }
        }
        
        
    }
    
    //根据订单id获取订单信息列表
    public map<id,Orders__c> getOrderInfor(set<string> setOrderId)
    {
        list<Orders__c> listOrder=new list<Orders__c>([select id,OfficeAdm__c,Payer__c,customer__c,Partners__c,isSale__c,RecordTypeName__c,OfficeAdmApproval__c,FinancialVpApproval__c,SalesVpApproval__c,AccountingLevel__c,SalesRegion__c from Orders__c where id in:setOrderId]);
        system.debug('listOrder is infor:'+listOrder);
        map<id,Orders__c> mapOrder=new map<id,Orders__c>();
        for(Orders__c oc:listOrder)
        {
            mapOrder.put(oc.id,oc);
        }
        return mapOrder;
    }
    
    //根据产品系列、产品类型系列获取产品折扣  
    public map<string,ProdcutionDiscount__c> getProductmodelseriesFamilyPrice(set<string> setFamilyId,set<string> setProductmodelseriesId)
    {
        //set<string> setFamilyId=new set<string>(); 
        //set<string> setProductmodelseriesId=new set<string>();
        map<string,ProdcutionDiscount__c> mapProdcutionDiscount=new map<string,ProdcutionDiscount__c>();
        list<ProdcutionDiscount__c> listProdcutionDiscount=new list<ProdcutionDiscount__c>([Select p.n_ProductionLine__c, p.n_ProductionLevel__c, p.n_Discount__c, p.n_DiscountRole__c, p.Product__c, p.Name, p.Id, p.Family__c,p.Family__r.Name, p.ChannelType__c From ProdcutionDiscount__c p ]);
        for(ProdcutionDiscount__c pd:listProdcutionDiscount)
        {
            
            mapProdcutionDiscount.put(pd.n_ProductionLine__c+pd.Family__r.Name+pd.ChannelType__c+pd.n_DiscountRole__c,pd);
            system.debug('信息 is infor:'+pd.n_ProductionLine__c+pd.Family__r.Name+pd.ChannelType__c+pd.n_DiscountRole__c);
            //产品系列+产品型号系列+渠道类型+折扣角色
        }
        
        return mapProdcutionDiscount;
    }
    
    
    //根据订单id返回map(订单id对应订单明细)
    public map<id,list<OrderDetails__c>> getOrderDetailsMap(set<string> setOrderId)
    {
        map<id,list<OrderDetails__c>> mapOrderDetails=new map<id,list<OrderDetails__c>>();
        list<OrderDetails__c> listOrderDetails=new list<OrderDetails__c>();
        listOrderDetails=getOrderDetailsLists(setOrderId);
        for(OrderDetails__c od:listOrderDetails)
        {
            if(mapOrderDetails.containsKey(od.n_OrderNo__c))
            {
                mapOrderDetails.get(od.n_OrderNo__c).add(od);
            }
            else
            {
                list<OrderDetails__c> listOrder=new list<OrderDetails__c>();
                listOrder.add(od);
                mapOrderDetails.put(od.n_OrderNo__c,listOrder);
            }
        }
        return mapOrderDetails;
    }
    
    //根据订单id，返回订单明细列表
    public list<OrderDetails__c> getOrderDetailsLists(set<string> setOrderId)
    {
        list<OrderDetails__c> listOrderDetails=new list<OrderDetails__c>([Select o.productmodelseries__c,o.id,o.n_OrderNo__r.customer__c, o.n_ProductByOrd__c, o.n_OrderNo__c, o.n_DiscountByord__c, o.OrderRecordTypeName__c, o.Family__c From OrderDetails__c o where o.n_OrderNo__c in:setOrderId]);
        return listOrderDetails;
    }
    
    //根据订单id，返回set(客户id)
    public set<string> getOrderDetailsSets(set<string> setOrderId)
    {
        set<string> setAccountId=new set<string>();
        list<OrderDetails__c> listOrderDetails=new list<OrderDetails__c>([Select o.productmodelseries__c,o.n_OrderNo__r.Payer__c,o.id,o.n_OrderNo__r.customer__c, o.n_ProductByOrd__c, o.n_OrderNo__c, o.n_DiscountByord__c, o.OrderRecordTypeName__c, o.Family__c From OrderDetails__c o where o.n_OrderNo__c in:setOrderId]);
        for(OrderDetails__c od:listOrderDetails)
        {
            setAccountId.add(od.n_OrderNo__r.Payer__c);
        }
        return setAccountId;
    }
    
    //根据客户id获取客户签约等级
    public map<id,Account> getAccountChannelTypeIdentity(set<string> setAccountId)
    {
    	system.debug('setAccountId is infor:'+setAccountId);
        list<Account> listAccount=new list<Account>([select id,Identity__c,ChannelType__c from Account where id in:setAccountId]);
         system.debug('listAccount is infor:'+listAccount);
         map<id,Account> mapAccount=new map<id,Account>();
         for(Account a:listAccount)
         {
            mapAccount.put(a.id,a);
         }
         return mapAccount;
    }
    
    
    //根据订单id获取订单明细中订单明细最低折扣产品
    public map<id,OrderDetails__c> getValueJudgment(set<string> setOrderId)
    {
        DataFormat DataFormatData=new DataFormat();
        map<string,string> mapServiceItem=new map<string,string>();
        mapServiceItem=DataFormatData.mapGetService();
        map<string,string> mapEquipMentItem=new map<string,string>();
        mapEquipMentItem=DataFormatData.mapGetEquipMent();
        
        map<id,OrderDetails__c> mapOrderDetails=new map<id,OrderDetails__c>();
        map<id,list<OrderDetails__c>> mapOrderDetailsLists=new map<id,list<OrderDetails__c>>();
        mapOrderDetailsLists=getOrderDetailsMap(setOrderId);
        map<string,list<OrderDetails__c>> mapService=new map<string,list<OrderDetails__c>>();
        map<string,list<OrderDetails__c>> mapEquipment=new map<string,list<OrderDetails__c>>();
        for(string oi:setOrderId)
        {
        	if(mapOrderDetailsLists.containsKey(oi))
        	{
        		for(OrderDetails__c od:mapOrderDetailsLists.get(oi))
	            {
	                if(mapServiceItem.containsKey(od.Family__c))
	                {
	                    if(mapService.containsKey(od.n_OrderNo__c))
	                    {
	                        mapService.get(od.n_OrderNo__c).add(od);
	                    }
	                    else
	                    {
	                        list<OrderDetails__c> listOrder=new list<OrderDetails__c>();
	                        listOrder.add(od);
	                        mapService.put(od.n_OrderNo__c,listOrder);
	                    }
	                }
	                else if(mapEquipMentItem.containsKey(od.Family__c))
	                {
	                    if(mapEquipment.containsKey(od.n_OrderNo__c))
	                    {
	                        mapEquipment.get(od.n_OrderNo__c).add(od);
	                    }
	                    else
	                    {
	                        list<OrderDetails__c> listOrder=new list<OrderDetails__c>();
	                        listOrder.add(od);
	                        mapEquipment.put(od.n_OrderNo__c,listOrder);
	                    }
	                }
	            }
        	}
            
            if(mapService!=null && mapService.size()>0 && mapEquipment!=null && mapEquipment.size()>0)
            {
                for(OrderDetails__c odd:mapEquipment.get(oi))
                {
                    if(mapOrderDetails.containsKey(odd.n_OrderNo__c))
                    {
                        if(mapOrderDetails.get(odd.n_OrderNo__c).n_DiscountByord__c>odd.n_DiscountByord__c)
                        {
                            mapOrderDetails.put(odd.n_OrderNo__c,odd);
                        }
                    }
                    else
                    {
                        mapOrderDetails.put(odd.n_OrderNo__c,odd);
                    }
                }
                
            }
            else if(mapEquipment!=null && mapEquipment.size()>0)
            {
                for(OrderDetails__c odd:mapEquipment.get(oi))
                {
                    if(mapOrderDetails.containsKey(odd.n_OrderNo__c))
                    {
                        if(mapOrderDetails.get(odd.n_OrderNo__c).n_DiscountByord__c>odd.n_DiscountByord__c)
                        {
                            mapOrderDetails.put(odd.n_OrderNo__c,odd);
                        }
                    }
                    else
                    {
                        mapOrderDetails.put(odd.n_OrderNo__c,odd);
                    }
                }
            }
            else if(mapService!=null && mapService.size()>0)
            {
                for(OrderDetails__c odd:mapService.get(oi))
                {
                    if(mapOrderDetails.containsKey(odd.n_OrderNo__c))
                    {
                        if(mapOrderDetails.get(odd.n_OrderNo__c).n_DiscountByord__c>odd.n_DiscountByord__c)
                        {
                            mapOrderDetails.put(odd.n_OrderNo__c,odd);
                        }
                    }
                    else
                    {
                        mapOrderDetails.put(odd.n_OrderNo__c,odd);
                    }
                }
            }
        }
        return mapOrderDetails;
    }
    
}