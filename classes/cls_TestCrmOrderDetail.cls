/*
rogersun
2013-06-17
cls_TestCrmOrderDetail
CrmOrderDetail测试类
*/
public with sharing class cls_TestCrmOrderDetail 
{
	static testMethod void operatilCrmOrderDetail() 
    {
    	Pricebook2 pricebook = [select Id from Pricebook2 where isStandard=true limit 1];   

    	Profile profile=[Select p.Name, p.Id From Profile p where Name='系统管理员'];
    	list<RecordType> listrtp=[Select Name, Id, Description From RecordType];
    	map<string,RecordType> maprtp=new map<string,RecordType>();
    	if(listrtp.size()>0)
    	{
    		for(RecordType rt:listrtp)
    		{
    			if(!maprtp.containsKey(rt.Name))
    				maprtp.put(rt.Name,rt);
    		}
    	}
    	RecordType listrtpQuDao=maprtp.get('渠道代理商'); 
    	RecordType listrtpSales=maprtp.get('内部样机订单');
    	RecordType listrtpDetailsType=maprtp.get('内部样机');
    	
    	User user=new User();											 
	    user.Phone='87413065';   
	    user.MobilePhone='15167988026';
	    user.Username='rogerGao@hjgfg.com5';
	    user.Alias='DeSun';  //匿称
	    user.CommunityNickname='DeSun';//绰号
	    user.TimeZoneSidKey='Australia/Sydney';
	    user.LocaleSidKey='en_AU';
	    user.EmailEncodingKey='ISO-8859-1';
	    user.ProfileId=profile.Id;
	    user.LanguageLocaleKey='en_US';
	    user.FirstName='于';
	    user.LastName='NN';
	    user.EmployeeNumber='1234q';
	    user.Fax='0031388';
	    user.Email='dlwork123@163.com';
	    user.EmployeeNumber='1234';
	    insert user;
	    
	     Account acc=new Account();
        acc.Name='五粮液';
        acc.Fax='8088';
        acc.Description='五粮液';
        acc.Phone='053187401697';
        acc.Industry='Finance';
        acc.n_ServiceCode__c='1234';
        acc.RecordTypeId=listrtpQuDao.id;
        insert acc;
         Account acc1=new Account();
        acc1.Name='五粮液1';
        acc1.Fax='80881';
        acc1.Description='五粮液1';
        acc1.Phone='0531874016971';
        acc1.Industry='Finance1';
        //acc1.n_ServiceCode__c='12341';
        //acc1.n_ServiceCode__c = '12341';
        acc1.RecordTypeId=listrtpQuDao.id;
        insert acc1;
	    
	    SalesRegion__c salesregion=new SalesRegion__c();
		salesregion.OfficeDirector__c=user.id;
		salesregion.Name='日本';
		insert salesregion;   
	    
	    
	    
	    String Closetime='2005'+'-'+'10'+'-'+'5';
        Date dte=date.valueOf(Closetime);
	   	Opportunity opp=new Opportunity();    	
	    opp.OppProperties__c='商业市场';       
        opp.Name='五粮液商机';
        opp.Description='业务机会';
        opp.industry__c='IT';
        opp.CloseDate=dte;  
        opp.AccountId=acc.Id;
        opp.StageName='关单';
        opp.Probability=100;					//可行性
        opp.SalesRegion__c = salesregion.Id;
	    insert opp;
    	
    	 Quote quote=new Quote();				//报价
        quote.OpportunityId=opp.Id;
        quote.Pricebook2Id=pricebook.Id;
        quote.Name='2013网康服务器报价';
        quote.kaipiaoyaoqiuField2__c = '发货自动开票';
        quote.Status='已批准';
        insert quote;
    	
    	 ProductModelSeries__c pms=new ProductModelSeries__c();	//产品型号系列
        pms.Name='NF-3000系列';
        pms.NewProductPrice__c = Double.valueOf(1000);
        pms.OldProductPrice__c = Double.valueOf(100);
        insert pms;
        list<ProductionLevel__c> listprod=new list<ProductionLevel__c>();
    	ProductionLevel__c pleone=new ProductionLevel__c();		//产品级别
        pleone.Name='产成品';
        pleone.n_level__c='一级';
        pleone.n_levelNO__c='B';
        listprod.add(pleone);
        ProductionLevel__c pleTwo=new ProductionLevel__c();		//产品级别
        pleTwo.Name='天晶政府';
        pleTwo.n_level__c='二级';
        pleTwo.n_levelNO__c='B';
        listprod.add(pleTwo);
        ProductionLevel__c pleThree=new ProductionLevel__c();		//产品级别
        pleThree.Name='配件';
        pleThree.n_level__c='三级';
        pleThree.n_levelNO__c='B';
        listprod.add(pleThree);
        ProductionLevel__c pleFour=new ProductionLevel__c();		//产品级别
        pleFour.Name='硬件';
        pleFour.n_level__c='四级';
        pleFour.n_levelNO__c='B';
        listprod.add(pleFour);
        
        Product2 prod=new Product2();						//产品
       	prod.Name='prodone';
        prod.n_Unit__c='个';									//计量单位
        prod.productmodelseries__c=pms.id;					//产品型号系列
    	prod.n_FirstLevel__c=pleone.id;						//一级产品
        prod.n_SecondLevel__c=pleTwo.id;					//二级产品
        prod.n_ThirdLevel__c=pleThree.id;					//三级产品
        prod.n_FourLevel__c=pleFour.id;						//四级产品
        prod.Family='ICG';
        insert prod;
        list<Orders__c> listOrder=new list<Orders__c>();
        
        Orders__c orders=new Orders__c();
        orders.Name='testorders';
        orders.CommerciaTraveller__c=user.Id;
        orders.SalesOpportunities__c=opp.id;
        orders.Quote__c=quote.id;  
        orders.RecordTypeId=listrtpSales.id;
        orders.OrderNum__c='ord201305311608';
        orders.customer__c = acc.Id;
        orders.Partners__c = acc.Id;
        orders.Payer__c=acc.Id;
        orders.ordersClassify__c='直销';
        orders.Platform__c='网康科技';
        orders.Remark__c='备注';
        orders.Type__c='再销售';
        orders.SalesRegion__c=salesregion.Id;
        orders.Statues__c='未同步';
        orders.SendProduct__c=acc1.Id;
        orders.ordersDate__c=Date.valueOf('2013-06-17 10:13:01');
        orders.OrderCount__c=2;
        orders.Summary__c='订单摘要';
        orders.PaymentAmount__c=123;
        orders.DeliveryDate__c=Date.valueOf('2013-06-17 10:13:01');
        orders.OpenSate__c='未开票';
        orders.shifouzaixiaoshou__c='是';
        orders.SalesRegion__c=salesregion.Id;
        orders.SynchronizationStatus__c='已同步';
        orders.CommerciaTraveller__c=user.Id;
        orders.DeliveredQuantity__c=12;
		insert orders;
		DateTime dtToday = Date.today();
		
		//订单明细
		DateTime nowToday = Date.today();
		list<OrderDetails__c> list_orDetails = new list<OrderDetails__c>();
		
		OrderDetails__c orderDetailsa = new OrderDetails__c();
		orderDetailsa.RecordTypeId = listrtpDetailsType.id;
		orderDetailsa.n_OrderNo__c = orders.Id;
		orderDetailsa.n_ProductByOrd__c=prod.id;									//产品
    	orderDetailsa.n_ProCount__c=1;					 						//数量
    	orderDetailsa.n_PriceByord__c=400;										//成交价
    	orderDetailsa.n_CustomModels__c='定制型号';
    	orderDetailsa.versionNumber__c='1.0.01';
    	orderDetailsa.n_Remark__c='sadfsdfv';
    	orderDetailsa.TestStatus__c = '测试中';
    	orderDetailsa.BorrowerReceiptDate__c = Date.valueOf(nowToday.addDays(-20));
    	orderDetailsa.licenseWarranty__c='1年';
    	orderDetailsa.DurationOfTheAuthorization__c='19月';
    	orderDetailsa.WarrantyPeriod__c='12月';
       	list_orDetails.add(orderDetailsa);
       	insert list_orDetails;
       	CrmOrderDetail.OrderDetailDataClient();
       	
       	 map<Id,Orders__c> mapOrder=new map<Id,Orders__c>([select o.Id,o.OrderNum__c,o.Name,o.Platform__c,o.AccountNo__c,o.ordersClassify__c,o.Type__c,o.Payer__r.Name,o.Partners__r.Name,o.customer__r.Name,o.Summary__c,o.ordersDate__c,o.shifouzaixiaoshou__c,o.order_Industry__c,o.Cooperation__c,o.Cooperativer__c,o.OpenSate__c,o.OrderAmount__c,o.DeliveredQuantity__c,o.DeliveryDate__c,o.SendProduct__r.Name,o.OrderCount__c,o.Remark__c from Orders__c o where o.SynchronizationStatus__c='已同步' and (o.Statues__c='' or o.Statues__c='未同步')]);
        list<Orders__c> listorder1=new list<Orders__c>();
        set<Id> setId =mapOrder.keyset();
        for(id i:setId)
        {
            listorder1.add(mapOrder.get(i));
            system.debug('mapOrder.get(i)'+mapOrder.get(i));
        }
        system.debug('listorder'+listorder1);
        
        list<OrderDetails__c> listOrderDetails=[select o.id,o.n_OrderNo__r.OrderNum__c,o.n_ProductByOrd__r.Name,o.n_Price__c,o.n_Unit__c,o.n_DiscountByord__c,o.n_PriceByord__c,o.n_ProCount__c,o.n_Sum__c,o.licenseWarranty__c,o.n_AccounSerNo__c,o.Acount__r.Name,o.versionNumber__c,o.n_CustomModels__c from OrderDetails__c o where o.n_OrderNo__c in:setId];
         if(listorder.size()>0)
        {
            WsdlorderDetail.orderDetailSoap  tt=new WsdlorderDetail.orderDetailSoap();
            WsdlorderDetail.ArrayOfOrderArray aa=new WsdlorderDetail.ArrayOfOrderArray();
            aa.orderArray=(WsdlorderDetail.orderArray[])CrmOrderDetail.orderArrayClientOperaton(listorder);
            WsdlorderDetail.ArrayOfOrderDetailArray bb=new WsdlorderDetail.ArrayOfOrderDetailArray();
            bb.orderDetailArray=(WsdlorderDetail.orderDetailArray[])CrmOrderDetail.orderDetailArrayClientOperaton(listOrderDetails);
            WsdlorderDetail.ArrayOfString f=new WsdlorderDetail.ArrayOfString();
            tt.timeout_x=120000;
            system.debug('aa的值是'+aa);
            system.debug('bb的值是'+bb);
            f=tt.operatorOrderDetail(aa,bb);
            system.debug('f的值是'+f);
            WsdlorderDetail.ArrayOfString g=new WsdlorderDetail.ArrayOfString();
              list<string> jhg=new list<string>();
		     
		     	string adv=null;
		     	adv=orders.OrderNum__c+'+'+'已更新';
		     	
		     list<string> axs=new list<string>();
		     axs.add(adv);
		     f.string_x=axs;
		     system.debug('获取WSDLUpdateClient中CustomersByValue方法返回值赋值给f :'+f);
		      if(f.string_x.size()>0)
		      {
		      	 CrmOrderDetail.updateOrderStatuesData(g);
		      }
           
        }
       	
    }
}