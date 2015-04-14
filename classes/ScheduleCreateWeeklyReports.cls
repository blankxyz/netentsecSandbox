global class ScheduleCreateWeeklyReports implements Schedulable {
	 

    global void execute(SchedulableContext sc) {

		WeeklyCalendarCustom__c weeklyCalendar = [select id, Year__c, Quarter__c, Week_Number__c, StartDate__c, EndDate__c from WeeklyCalendarCustom__c where StartDate__c > NEXT_N_DAYS:7 and StartDate__c = NEXT_N_DAYS:14];
        list<WeeklyReport__c> WeeklyReportList = [SELECT id, Year__c,Quarter__c,Week_Number__c, Employee__c, StartOfWeek__c, EndOfWeek__c FROM WeeklyReport__c WHERE Week_Number__c = :weeklyCalendar.Week_Number__c and Year__c = :weeklyCalendar.Year__c and Quarter__c = :weeklyCalendar.Quarter__c]; 
		Set<ID> EEIds = new Set<ID>();
		for(WeeklyReport__c WW : WeeklyReportList) {
		EEIds.add(WW.Employee__c);
		}
		list<WeeklyReport__c> newWeeklyReportList = new list<WeeklyReport__c>();
		list<Employee__c> EEList = [Select Id, n_EmployeeName__c From Employee__c where n_EmployeeName__r.IsActive = true and week_report__c = true and On_Job__c = true and (n_EmployeeAear__r.Name Like '%技术支撑中心-%' OR n_EmployeeAear__r.Name Like '%技术%' OR n_EmployeeAear__r.Name Like '%京津冀区-%' OR n_EmployeeAear__r.Name Like '%东区-%' OR n_EmployeeAear__r.Name Like '%西区-%' OR n_EmployeeAear__r.Name Like '%南区-%' OR n_EmployeeAear__r.Name Like '%北区-%')];
		for(Employee__c EE : EEList) {
		if(EEIds.contains(EE.id)){
		
		}else{
		WeeklyReport__c NewWeeklyReport = new WeeklyReport__c( ownerid = EE.n_EmployeeName__c,Year__c = weeklyCalendar.Year__c,Quarter__c = weeklyCalendar.Quarter__c,Week_Number__c = weeklyCalendar.Week_Number__c,approve_status__c = '未申请', Employee__c = EE.id);
			                    newWeeklyReportList.add( NewWeeklyReport);
		}
		}
		insert newWeeklyReportList;
    }
    
}