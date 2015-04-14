/**
 * 部门销售任务完成柱状图
 */
public class AreaSalesTaskActl {

    public decimal amoSumS {  get ;set; }
    public decimal planSumS {get; set;}
    public decimal planPercent {get; set;}

	/**
	 * 部门
	 */
    public String chartFilter { 
        get {
            if (chartFilter == Null) chartFilter = 'all';
            return chartFilter;
        }
        set;
    }
	/**
	 * 年度
	 */
   public String chartYear { 
        get {
            if (chartYear == Null) chartYear = String.valueOf(System.today().year());
            return chartYear;
        }
        set;
    }
	/**
	 * 季度
	 */
    public String[] chartQuarter { 
        get {
            if (chartQuarter == Null) chartQuarter = new String[]{'1','2','3','4'};
            return chartQuarter;
        }
        set;
    }

    public static List<SelectOption> getChartFilterOptions() {
        List<SelectOption> department = new List<SelectOption>();

        department.add(new SelectOption('all','全公司'));
        for (SalesPlan__c s : [select Department__r.Name, Department__c,Department__r.branchdepartment__c from SalesPlan__c where Department__r.branchdepartment__c = null and Department__c != null]){
        	department.add(new SelectOption(s.Department__c,s.Department__r.Name));
        }
        return department;
    }

    public static List<SelectOption> getChartYearOptions() {
        List<SelectOption> years = new List<SelectOption>();

        Integer i;
        Integer endCondtion = Integer.valueOf(System.today().year()+1);

        for(i=2014; i<=endCondtion; i++){
        	String inputVal = String.valueOf(i);
        	years.add(new SelectOption(inputVal,inputVal));
        }

        return years;
    }

    public static List<SelectOption> getChartQuarterOptions() {
        List<SelectOption> season = new List<SelectOption>();
        //season.add(new SelectOption('all','全年'));
        season.add(new SelectOption('1','Q1'));
        season.add(new SelectOption('2','Q2'));
        season.add(new SelectOption('3','Q3'));
        season.add(new SelectOption('4','Q4'));
        return season;
    }

    public AreaSalesTaskActl(){
		//getDepartmentSalesTaskData();
    }

    public PageReference init(){
		system.debug('===========处理开始==============');
		amoSumS = 0;
		planSumS = 0;
		planPercent = 0;
		system.debug('============季度=============' + chartQuarter);
		system.debug('============年度=============' + chartYear);
		system.debug('============部门=============' + chartFilter);
		//获取部门数据
		Set<Id> departments = this.getSalesRegionInfo();
		departmentPieData= new List<PieWedgeData>();
		departmentSalesTaskData = new List<AreaSalesTaskData>();		
		system.debug('===========部门数据==============' + departments.size());	
		if(departments.size()>0){
			//获取计划数据
			Map<String,AreaSalesTaskData> plansData = this.getSalesPlan(departments);

			//获取销售数据
			Map<String,AreaSalesTaskData> salesData = this.getOrderInfo(departments);

			for(AreaSalesTaskData a : plansData.values()){

				if(salesData.containsKey(a.area)){
					a.orderAmount = salesData.get(a.area).orderAmount;
					departmentPieData.add(new PieWedgeData(a.area,a.orderAmount));
				}
				amoSumS += a.orderAmount;
				planSumS += a.plannedSale;
				departmentSalesTaskData.add(a);
			}
		}
		system.debug('===========销售额==============' + amoSumS);
		system.debug('===========计划销售额===========' + planSumS);	
		
		if(amoSumS>0 && planSumS>0){
			planPercent = (amoSumS * 100 / planSumS).setScale(2);
		}

		return null;
    }
	public List<PieWedgeData> departmentPieData;
	public List<PieWedgeData> getDepartmentPieData() {

		system.debug('===========处理开始==============');
		amoSumS = 0;
		planSumS = 0;
		planPercent = 0;
		system.debug('============季度=============' + chartQuarter);
		system.debug('============年度=============' + chartYear);
		system.debug('============部门=============' + chartFilter);
		//获取部门数据
		Set<Id> departments = this.getSalesRegionInfo();
		List<PieWedgeData> resultList = new List<PieWedgeData>();

		system.debug('===========部门数据==============' + departments.size());	
		if(departments.size()>0){
			//获取计划数据
			Map<String,AreaSalesTaskData> plansData = this.getSalesPlan(departments);

			//获取销售数据
			Map<String,AreaSalesTaskData> salesData = this.getOrderInfo(departments);

			for(AreaSalesTaskData a : plansData.values()){

				if(salesData.containsKey(a.area)){
					a.orderAmount = salesData.get(a.area).orderAmount;
					resultList.add(new PieWedgeData(a.area,a.orderAmount));
				}
				amoSumS += a.orderAmount;
				planSumS += a.plannedSale;

				
			}
		}
		system.debug('===========销售额==============' + amoSumS);
		system.debug('===========计划销售额===========' + planSumS);	
		
		if(amoSumS>0 && planSumS>0){
			planPercent = (amoSumS * 100 / planSumS).setScale(2);
		}
		
		system.debug('===========处理结束==============');
		system.debug('===========输出结果=============='+resultList);

	    return resultList;

	    return departmentPieData;
	}
	public List<AreaSalesTaskData> departmentSalesTaskData;
	public List<AreaSalesTaskData> getDepartmentSalesTaskData() {

		system.debug('===========处理开始==============');
		amoSumS = 0;
		planSumS = 0;
		planPercent = 0;
		system.debug('============季度=============' + chartQuarter);
		system.debug('============年度=============' + chartYear);
		system.debug('============部门=============' + chartFilter);
		//获取部门数据
		Set<Id> departments = this.getSalesRegionInfo();
		List<AreaSalesTaskData> resultList = new List<AreaSalesTaskData>();
		system.debug('===========部门数据==============' + departments.size());	
		if(departments.size()>0){
			//获取计划数据
			Map<String,AreaSalesTaskData> plansData = this.getSalesPlan(departments);

			//获取销售数据
			Map<String,AreaSalesTaskData> salesData = this.getOrderInfo(departments);

			for(AreaSalesTaskData a : plansData.values()){

				if(salesData.containsKey(a.area)){
					a.orderAmount = salesData.get(a.area).orderAmount;
				}
				amoSumS += a.orderAmount;
				planSumS += a.plannedSale;
				resultList.add(a);
			}
		}
		system.debug('===========销售额==============' + amoSumS);
		system.debug('===========计划销售额===========' + planSumS);	
		if(amoSumS>0 && planSumS>0){
			planPercent = (amoSumS * 100 / planSumS).setScale(2);
		}
		system.debug('===========处理结束==============');
		system.debug('===========输出结果=============='+resultList);

	    return resultList;

	}
    
    /**
     *  取得销售计划数据
     */
	private Map<String,AreaSalesTaskData> getSalesPlan(Set<Id> departments){

		//销售计划数据检索SOQL
		String queryAllStr =  'SELECT Department__r.Name, '+
			                  '       Department__c,  '+
			                  '       Id,  '+
		                      '       PlannedSale__c, '+ 
			                  '       Q1PlannedSale__c, '+ 
			                  '       Q2PlannedSale__c, '+ 
			                  '       Q3PlannedSale__c, '+ 
			                  '       Q4PlannedSale__c  '+
			                  'FROM SalesPlan__c '+
			                  'WHERE year__c = :chartYear';

		//如果有部门参数传入，追加部门检索条件
		if(departments.size()>0){
			queryAllStr += ' AND Department__c in :departments ';
		}

		//处理季度信息
		Set<Integer> quarter = new Set<Integer>();
    	for(String s : chartQuarter){
    		quarter.add(Integer.valueOf(s));
    	}

    	Map<String,AreaSalesTaskData> rtnResult = new Map<String,AreaSalesTaskData>();

    	system.debug('检索销售计划数据SOQL==========='+queryAllStr);
		//检索销售计划数据
		for(SalesPlan__c s : Database.query(queryAllStr)){
			AreaSalesTaskData c = new AreaSalesTaskData();
			c.area = s.Department__r.name;
			c.orderAmount = 0;
			c.plannedSale = 0;

			if(quarter.contains(1) && quarter.contains(2) &&
			   quarter.contains(3) && quarter.contains(4) ){
				c.plannedSale = s.PlannedSale__c;
			}else{
				if(quarter.contains(1)){
					if(s.Q1PlannedSale__c != Null) c.plannedSale += s.Q1PlannedSale__c;
				}
				if(quarter.contains(2)){
					if(s.Q2PlannedSale__c != Null) c.plannedSale += s.Q2PlannedSale__c;
				}
				if(quarter.contains(3)){
					if(s.Q3PlannedSale__c != Null) c.plannedSale += s.Q3PlannedSale__c;
				}
				if(quarter.contains(4)){
					if(s.Q4PlannedSale__c != Null) c.plannedSale += s.Q4PlannedSale__c;
				}
			}

			rtnResult.put(s.Department__r.name, c);
		}

		return rtnResult;
	}

    /**
     *  取得订单数据
     */
	private Map<String,AreaSalesTaskData> getOrderInfo(Set<Id> departments){

		Integer queryYear = Integer.valueOf(chartYear);

		//订单数据检索SOQL
		String queryStr = 'SELECT OrderAmount__c, '+ 
                          '       dingdansuozaiquyu__c, '+
                          '       dingdansuozaiquyu__r.name, '+
                          '       dingdansuozaiquyu__r.branchdepartment__c, '+
                          '       dingdansuozaiquyu__r.branchdepartment__r.name '+
    					  'from Orders__c '+
    					  'Where ( name like \'%TRY%\' or name like \'%ORD%\' or name like \'%STO%\') '+
    					  'and CALENDAR_YEAR(ordersDate__c) = :queryYear ' +
    					  'and (dingdansuozaiquyu__c in : departments OR ' +
    					  '     dingdansuozaiquyu__r.branchdepartment__c in :departments)';

		//处理季度信息
		Set<Integer> quarter = new Set<Integer>();
		if(chartQuarter.size()<4){
	    	for(String s : chartQuarter){
	    		quarter.add(Integer.valueOf(s));
	    	}
	    	queryStr  += ' and CALENDAR_QUARTER(ordersDate__c) in :quarter';
    	}

    	
    	Map<String,AreaSalesTaskData> rtnResult = new Map<String,AreaSalesTaskData>();

		system.debug('===========检索SQL：queryStr=============='+queryStr);
	    for(Orders__c o : Database.query(queryStr)){
	    	AreaSalesTaskData cur = new AreaSalesTaskData();
	    	
	    	String mapkey = o.dingdansuozaiquyu__r.name;
	    	if(chartFilter == 'all'){
	    		mapkey = o.dingdansuozaiquyu__r.branchdepartment__r.name;
	    	}

	    	decimal curAmount = o.OrderAmount__c;
	    	if(rtnResult.containsKey(mapkey)){
	    		AreaSalesTaskData c = rtnResult.get(mapkey);
	    		curAmount += c.orderAmount;
	    	}

	    	cur.area = mapkey;
	    	cur.orderAmount = curAmount;
	    	cur.plannedSale = 0;
			
			rtnResult.put(mapkey, cur);
	    }

		return rtnResult;
	}

	/**
	 *  获取部门信息,
	 */
	private Set<Id> getSalesRegionInfo(){

		String queryStr = 'select Department__r.Name, Department__c,Department__r.branchdepartment__c from SalesPlan__c';

		if(chartFilter != 'all'){
			queryStr += ' where Department__r.branchdepartment__c = :chartFilter';
		}else{
			queryStr += ' where Department__r.branchdepartment__c = Null and Department__c != Null';
		}

		Set<Id> rtnIds = new Set<Id>();

		system.debug('===========获取部门信息SOQL==============' + queryStr);
		for(SalesPlan__c s : Database.query(queryStr)){
			rtnIds.add(s.Department__c);
		}		
		system.debug('===========部门id==============' + rtnIds);

		return rtnIds;
	}

    public PageReference test() {
        return null;
    }

    public class PieWedgeData   {
		public String name { get; set; } 
		public decimal data { get; set; } 

		public PieWedgeData(String name, decimal data) { 
		           this.name = name; 
		           this.data = data; 
		} 
    }

    public class AreaSalesTaskData{ 
      public decimal orderAmount{get; set;}
      public decimal plannedSale{get; set;}
      public String area {get; set;}
    }
}