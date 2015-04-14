public virtual class DashboradBaseCtl {

	/**
	 * 部门
	 */
    public String chartDepart { 
        get {
            if (chartDepart == Null) chartDepart = 'all';
            return chartDepart;
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

    public  List<SelectOption> getSubDepartOptions(String parentName) {
        List<SelectOption> department = new List<SelectOption>();

        if(String.isBlank(parentName)){
 	    	department.add(new SelectOption('all','全公司'));
	        for (SalesRegion__c s : [select Id, Name, Branchdepartment__c from SalesRegion__c where  Branchdepartment__c = Null]){
	        	department.add(new SelectOption(s.Id,s.Name));
	        } 
        }else{
        	department.add(new SelectOption('all','全-'+parentName));
        	for (SalesRegion__c s : [select Id, Name, Branchdepartment__c from SalesRegion__c where Branchdepartment__r.Name = :parentName and Branchdepartment__c != Null]){
        		department.add(new SelectOption(s.Id,s.Name));
        	}        	
        }

        return department;
    }


    public  List<SelectOption> getChartYearOptions() {
        List<SelectOption> years = new List<SelectOption>();

        Integer i;
        Integer endCondtion = Integer.valueOf(System.today().year()+1);

        for(i=2014; i<=endCondtion; i++){
        	String inputVal = String.valueOf(i);
        	years.add(new SelectOption(inputVal,inputVal));
        }

        return years;
    }

    public  List<SelectOption> getChartQuarterOptions() {
        List<SelectOption> season = new List<SelectOption>();
        //season.add(new SelectOption('all','全年'));
        season.add(new SelectOption('1','Q1'));
        season.add(new SelectOption('2','Q2'));
        season.add(new SelectOption('3','Q3'));
        season.add(new SelectOption('4','Q4'));
        return season;
    }


	public DashboradBaseCtl() {
		
	}
}