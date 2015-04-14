/**
 *  检索用户设备功能
 */
public class getProductControllor {
	/** 工单Id **/
	public String taskId {
		get{
			taskId = ApexPages.currentPage().getParameters().get('TaskId');	
			return taskId;
		}
		set;
	}
	/** 顾客Id **/
	public String clientId {
		get{
			clientId = ApexPages.currentPage().getParameters().get('clientId');	
			return clientId;
		}
		set;
	}
	/** 选择的设备ID **/
	public String selectIds{
		get{
			if(selectIds == null) selectIds ='';
			return selectIds;
		}
		set;
	}

	public boolean isNoData{
		get;set;
	}

	public getProductControllor(){}

    public String getProductList() 
    {
    	isNoData = true;
    	system.debug('顾客id是：'+ clientid);
		
		//查询客户未添加设备
		Set<Id> prodIds = new Set<Id>();
		for(ProductSNLineItem__c p : [select ProductSN__c from ProductSNLineItem__c where Project_Task__c =:taskid]){
			prodIds.add(p.ProductSN__c);
		}

		String queryStr = 'select Id, ProductCategory__c,ProductStatus__c,Name ';
		queryStr += ' from ProductSN__c ';
		queryStr += ' where coustmer__c =:clientid ';
		if(prodIds.size()>0) queryStr += ' and id not in : prodIds';

		List<ProductSN__c> outputlst = Database.query(queryStr);
		if(outputlst.size()>1){
			isNoData = false;
		}

    	return JSON.serializePretty(outputlst);
    }

    public PageReference addProduct(){
    	system.debug('===============Seleced product ID:'+selectIds);
    	system.debug('===============String.isNotEmpty(selectIds)'+String.isNotEmpty(selectIds));

    	if (String.isNotEmpty(selectIds)){
			String queryStr = 'select Id, ProductCategory__c,ProductStatus__c,Name ';
			queryStr += ' from ProductSN__c ';
			queryStr += ' where id in ('+ selectIds + ')';
			
			Set<id>  pids = new Set<id>();
			for(ProductSNLineItem__c p :[select id,ProductSN__c from ProductSNLineItem__c where Project_Task__c =:taskId]){
				pids.add(p.ProductSN__c);
			}

			system.debug(queryStr);

			List<ProductSNLineItem__c> insertObjs = new List<ProductSNLineItem__c>();
			for(ProductSN__c p: Database.query(queryStr)){
				if(!pids.contains(p.id)){
					insertObjs.add(new ProductSNLineItem__c(
							ProductSN__c = p.Id,
							ProductCategory__c = p.ProductCategory__c,
							Status__c = p.ProductStatus__c,
							Project_Task__c = taskId
						));
				}
			}
			system.debug('==================选择的设备：'+insertObjs);
			if(insertObjs.size()>0) Database.insert(insertObjs, false);
		}
		PageReference pageRef = new PageReference('/apex/getProduct?clientId='+clientId+'&TaskId='+taskid);
		pageRef.setRedirect(true);
		return pageRef;

    }


}