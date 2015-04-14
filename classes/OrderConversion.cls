//转订单webService类
//lurrykong
//2013.4.3
//modify vito_He 验证报价单转订单（业务机会为 关单状态才能转）有重复则删除重复的订单
//2013.4.27 
/**
*Modify Gary_Hu
*Dis:添加订单字段对应OSR
*Dis:添加订单字段订单所在区域
*Dis:添加订单明细返点金额
**/
global class OrderConversion 
{

    //报价单转订单操作 
    webservice static string OrderOperate(Boolean Iftur,ID QuoteId,string repeat)
    {
        Quote quote;        
        string productFamily;  
        list<QuoteLineItem> listquotelineitem;
        list<Orders__c> listorders=new list<Orders__c>();
        list<OrderDetails__c> listorderdtail=new list<OrderDetails__c>();                                   //订单明细                                                                  
        map<string,list<QuoteLineItem>> maplistQuotelineitem=new map<string,list<QuoteLineItem>>();         //产品系列为键,报价行集合为值
        RecordType Sales=[Select r.Name, r.Id, r.Description From RecordType r where Name='销售订单'];      
        RecordType overStockToSale=[Select r.Name, r.Id, r.Description From RecordType r where Name='压货转销售订单'];
        RecordType overStockAndSale=[Select r.Name, r.Id, r.Description From RecordType r where Name='销售和压货']; 
        if(QuoteId!=null)
        {   
            //如果是有重复的则先删除重复的订单
            if(repeat=='repeat_yes'){
                list<Orders__c> orders = queryRepeatOrderList(QuoteId);
                //判断是否有发货
                string flag = if_have_shipment(orders);
                if(flag!='有发货条目'){
                    list<OrderDetails__c> orderDetails = queryRepeatOrderDetailsList(orders);
                    delete orderDetails;  //删除订单明细
                    delete orders;        //删除订单
                }else{ 
                    return '有发货条目'; 
                }
            }
            //业务机会的客户id,业务机会id,是否压货转销售,报价id,报价付款方,代理商,出货方           
            quote=[Select q.Opportunity.AccountId, q.Opportunity.Id,q.IfSpecialPrice__c,q.Opportunity.SalesRegion__c,q.OpportunityId,q.Yahuoorders__c,q.Name,q.Id,q.Payer__c,q.Agents__c,q.ShippingSide__c,q.Field1__c,q.T3dailishang__c,q.duiyingField3__c,q.Opportunity.dingdansuozaiquyu__c 
            	   ,Equipment_Serial_Number__c,shifoushuangsuanField3__c
            	   From Quote q where q.Id=:QuoteId];
            //报价行产品,产品折扣,产品系列,销售价格,总价,小计                
            listquotelineitem=[Select n_Discount__c,Family__c,UnitPrice,TotalPrice,Subtotal,SortOrder,ServiceDate,QuoteId,Quantity,PricebookEntryId,PricebookEntry.Product2Id,ListPrice,LineNumber,Id,Discount,Description,o_CustomModels__c,Rebate_Amount__c
                              From QuoteLineItem where QuoteId=:QuoteId];     
            system.debug('.....................QuoteId........................'+QuoteId);
            if(listquotelineitem.size()>0)
            {
            	 	Orders__c orders=new Orders__c();
                    orders.Name=quote.Name;   								//订单名和报价名相同
                    orders.SalesOpportunities__c=quote.Opportunity.Id;      //销售机会
                    orders.SalesRegion__c=quote.Opportunity.SalesRegion__c; //销售区域
                    orders.Quote__c=quote.id;                               //报价单
                    orders.customer__c=quote.Opportunity.AccountId;         //客户名称
                    orders.Payer__c=quote.Payer__c;                         //付款方   
                    orders.SendProduct__c=quote.ShippingSide__c;            //出货方
                    orders.Partners__c=quote.Agents__c;                     //合作伙伴=代理商
                    orders.Middleman__c=quote.Field1__c;                     //T2级代理商
                    orders.T3dailishang__c=quote.T3dailishang__c;                     //T3代理商
                    /*新增同步字段*/
                    orders.duiyingOSR__c = quote.duiyingField3__c;          //对应OSR
                    orders.dingdansuozaiquyu__c = quote.Opportunity.dingdansuozaiquyu__c;//订单所在区域
                    orders.shebeixuliehaoField1__c = quote.Equipment_Serial_Number__c;//设备序列号
                    orders.shifoushuangsField1__c = quote.shifoushuangsuanField3__c;//是否双算
                    
                    /*新增同步字段*/
                    
                    if(quote.Yahuoorders__c==true)                          //压货转销售
                        orders.RecordTypeId=overStockToSale.id;                 
                    if(quote.Yahuoorders__c==false)                         //销售
                        orders.RecordTypeId=Sales.id;   
                    if(quote.IfSpecialPrice__c==true)                       //特价
                        orders.isSale__c=true;  

                    insert orders;
                for(QuoteLineItem qlitem:listquotelineitem) 
                {   
                    OrderDetails__c ordetail=new OrderDetails__c();
                    ordetail.n_OrderNo__c=orders.Id;                                  //订单
                    ordetail.RecordTypeId=overStockAndSale.Id;                        //记录类型
                    ordetail.n_ProductByOrd__c=qlitem.PricebookEntry.Product2Id;      //产品  
                    ordetail.n_ProCount__c=qlitem.Quantity;                           //数量  
                    ordetail.n_Price__c=qlitem.ListPrice;                             //定价
                    ordetail.n_PriceByord__c=qlitem.UnitPrice; 
                    ordetail.n_CustomModels__c = qlitem.o_CustomModels__c;			  //定制型号
                    ordetail.Rebate_Amount__c = qlitem.Rebate_Amount__c;            //返点金额
                    
                    listorderdtail.add(ordetail);     
                }
                insert listorderdtail;
	            return '转订单操作已成功';
            }else{
                return '没有报价行项目';  
            }
        }   
        else
        {
            return null;
        }
    }
    
    //内部样机订单和渠道样机订单转为销售订单
    webservice static string OrderToSalesOperate(ID OrderId)
    {
        Orders__c orders;
        RecordType Sales=[Select r.Name, r.Id, r.Description From RecordType r where Name='销售订单'];  
        if(OrderId!=null)
        {
            orders=[Select id,RecordType.Name,RecordTypeId From Orders__c where id=:OrderId];
            if(orders.RecordType.Name=='渠道样机订单')
                orders.ReplacementORD__c='渠道样机置换';
            if(orders.RecordType.Name=='内部样机订单')
                orders.ReplacementORD__c='内部样机置换';
            orders.RecordTypeId=Sales.id;
            update orders;                      
            string str='记录类型已经改变';
            return str;
        }
        else
        {
            return null;
        }
    }
    
    //验证报价转订单（业务机会必须是关单才能转）
    webservice static string OrderOperateVerify(ID QuoteId)
    {
        if(QuoteId!=null)
        {
            Quote quote=[Select OpportunityId From Quote where id=:QuoteId];
            Opportunity opp=[Select StageName From Opportunity where id=:quote.OpportunityId];
            if(opp!=null && opp.StageName=='关单'){
                return '关单';
            }
        }
        return null;
    }
    
    //判断转订单后是否会有重复的名称
    webservice static string OrderOperateHaveOrNo(ID QuoteId)
    {
        if(QuoteId!=null)
        {   
            list<Orders__c> orders = queryRepeatOrderList(QuoteId);
            if(orders!=null && orders.size()>0){
                return '存在';
            }
        }
        return null;
    }
    
    //查询出有重复的订单名称的订单
    public static list<Orders__c> queryRepeatOrderList(ID QuoteId){
        if(QuoteId!=null){
            //查到所有系列的名称   
            Quote quote=[Select Name,Id From Quote where id=:QuoteId]; 
            string sql = 'Select r.Name, r.Id From Orders__c r where Quote__c=\''+QuoteId+'\' and Name=\''+quote.Name+'\'';   
            return Database.query(sql);   
        } 
        return null;
    }
    
    //查询订单下的订单详情
    public static list<OrderDetails__c> queryRepeatOrderDetailsList(list<Orders__c> orders){
        if(orders!=null && orders.size()>0){
            list<OrderDetails__c> listorderdtail=new list<OrderDetails__c>();
            Set<ID> ids = new Set<ID>();
            for(Orders__c o:orders){ 
                ids.add(o.Id);
            }
            list<OrderDetails__c> orderDetails=[select id from OrderDetails__c where n_OrderNo__c IN :ids];
            return orderDetails;
        } 
        return null;
    }
    
    //根据订单判断是否有发货
    public static string if_have_shipment(list<Orders__c> orders){
        Set<ID> ids = new Set<ID>();
        for(Orders__c o:orders){ 
            ids.add(o.Id);
        }
        list<Shipments__c> ships = [select id from Shipments__c where n_orders__c IN :ids];
        if(ships!=null && ships.size()>0)return '有发货条目'; 
        return '没有发货条目';
    }
    
}