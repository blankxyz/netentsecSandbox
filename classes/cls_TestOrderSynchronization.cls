/*
*RogerSun
*2013-05-31
*OrderSynchronization的测试类
*/
@isTest(SeeAllData=true)
public with sharing class cls_TestOrderSynchronization 
{
	 static testMethod void myOrderSynchronization() 
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
	    user.Username='rogersun@hjgn.com3';
	    user.Alias='DeLi';  //匿称
	    user.CommunityNickname='DeLi';//绰号
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
        quote.Status='已批准';
        quote.kaipiaoyaoqiuField2__c = '发货自动开票';
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
        orders.SalesRegion__c=salesregion.Id;
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
       	OrderSynchronization.OrderOperate(orders.OrderNum__c);
		
		list<OrderDetails__c> orderDetail=new list<OrderDetails__c>();
		orderDetail=[Select o.licenseWarranty__c,o.DurationOfTheAuthorization__c,o.WarrantyPeriod__c,o.Acount__r.Name,o.versionNumber__c,o.Id, o.n_Sum__c, o.n_ProductByOrd__r.Name, o.n_ProCount__c, o.n_Price__c, o.n_PriceByord__c, o.n_OrderNo__r.Platform__c,o.n_OrderNo__r.OrderNum__c, o.n_OrderNo__r.order_Industry__c, o.n_OrderNo__r.SalesRegion__r.Name, o.n_OrderNo__r.Payer__r.Name, o.n_OrderNo__r.BusinessOwners__c,o.n_OrderNo__r.ordersClassify__c, o.n_OrderNo__r.CreatedDate, o.n_OrderNo__r.Name, o.n_DiscountByord__c, o.n_CustomModels__c,o.n_Remark__c,o.n_AccounSerNo__c, o.n_OrderNo__r.Remark__c From OrderDetails__c o];
		  system.debug('orderDetail.size() :'+orderDetail.size());
		WSDLOrderSynchronization.ArrayOfOrderSynchronizationArray aa=new WSDLOrderSynchronization.ArrayOfOrderSynchronizationArray();
//	    aa.OrderSynchronizationArray=(WSDLOrderSynchronization.OrderSynchronizationArray[])OrderSynchronization.operatorData(orderDetail);
        WSDLOrderSynchronization.ArrayOfString f=new WSDLOrderSynchronization.ArrayOfString();
         string aswe;
		     list<string> jhg=new list<string>();
		     
		     	string adv=null;
		     	adv=orders.OrderNum__c+'+'+'已更新';
		     	
		     list<string> axs=new list<string>();
		     axs.add(adv);
		     f.string_x=axs;
		     system.debug('获取WSDLUpdateClient中CustomersByValue方法返回值赋值给f :'+f);
		      if(f.string_x.size()>0)
		      {
		      	 OrderSynchronization.operatorSynchronizationData(f);	
		      }
	 }
}