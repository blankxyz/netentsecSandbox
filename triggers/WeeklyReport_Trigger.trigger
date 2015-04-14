trigger WeeklyReport_Trigger on WeeklyReport__c ( before insert , before update) {
	Set<ID> EmployeeIds = new Set<ID>();
	Map<Id, Employee__c> EmployeeIdMap = new Map<Id, Employee__c>();
	Map<String, WeeklyCalendarCustom__c> WeeklyCalendarMap = new Map<String, WeeklyCalendarCustom__c>();
	for(WeeklyReport__c rec : Trigger.new) {
		EmployeeIds.add(rec.Employee__c);
	}
	List<Employee__c> employees = [select id,name, Employee_Email__c, approver__c  from Employee__c where id in :EmployeeIds ];
	for(Employee__c u : employees) {
            EmployeeIdMap.put(u.id, u);
   }
   list <WeeklyCalendarCustom__c> weeklyCalendarList = [select id, Year__c, Quarter__c, Week_Number__c, StartDate__c, EndDate__c,WeeklyHour__c from WeeklyCalendarCustom__c];
   for(WeeklyCalendarCustom__c weeklyCalendar : weeklyCalendarList) {
   		WeeklyCalendarMap.put(weeklyCalendar.Year__c+weeklyCalendar.Quarter__c+weeklyCalendar.Week_Number__c, weeklyCalendar);
   }
	for(WeeklyReport__c rec : Trigger.new) {
		if(trigger.isInsert || (trigger.isUpdate && (rec.Year__c != trigger.oldMap.get(rec.id).Year__c || rec.Quarter__c != trigger.oldMap.get(rec.id).Quarter__c || rec.Week_Number__c != trigger.oldMap.get(rec.id).Week_Number__c))){
	
		    //Employee__c employee = [select id, approver__c,name, Employee_Email__c from Employee__c where id = :rec.Employee__c];
		    //list <WeeklyCalendarCustom__c> weeklyCalendarList = [select id,  StartDate__c, EndDate__c,WeeklyHour__c from WeeklyCalendarCustom__c where Year__c = :rec.Year__c and Quarter__c = :rec.Quarter__c and Week_Number__c = :rec.Week_Number__c];
		    
		   // for(WeeklyCalendarCustom__c weeklyCalendar : weeklyCalendarList) {
			    rec.name = 'FY'+rec.Year__c+rec.Quarter__c+'W'+rec.Week_Number__c+'_'+EmployeeIdMap.get(rec.Employee__c).name;
			    rec.approver__c = EmployeeIdMap.get(rec.Employee__c).approver__c; 
			    rec.StartOfWeek__c = WeeklyCalendarMap.get(rec.Year__c+rec.Quarter__c+rec.Week_Number__c).StartDate__c;
			    rec.EndOfWeek__c = WeeklyCalendarMap.get(rec.Year__c+rec.Quarter__c+rec.Week_Number__c).EndDate__c;
			    rec.WeekHour_Number__c = WeeklyCalendarMap.get(rec.Year__c+rec.Quarter__c+rec.Week_Number__c).WeeklyHour__c ;
			    rec.Email__c = EmployeeIdMap.get(rec.Employee__c).Employee_Email__c;  
		   // }   
		}
    }

}