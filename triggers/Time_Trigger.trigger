trigger Time_Trigger on Time__c ( before insert, before update,after insert,after update, after delete ) {

  
  if(trigger.isAfter && trigger.isInsert) {
  	Set<ID> TaskIds = new Set<ID>();
    Set<ID> WeeklyReportIds = new Set<ID>();
    Set<ID> ProjectIds = new Set<ID>();
    Map<Id, Id> taskIDEmployeeId = new Map<Id, Id>();
    Map<Id, Id> weeklyReportIDEmployeeId = new Map<Id, Id>();
  	for(Time__c rec : Trigger.new) {
            if(rec.Project_Task__c != null){
                TaskIds.add(rec.Project_Task__c);
            }
            if(rec.WeeklyReport__c != null){
            	WeeklyReportIds.add(rec.WeeklyReport__c);
            }
            if(rec.Project__c != null){
            	ProjectIds.add(rec.Project__c);
            }
            
    }
    List<Time__Share> tTimeShareList = new List<Time__Share>();
    if(TaskIds.size() > 0){
            list<Project_Task__c> taskList = [SELECT id,  Approver__c FROM Project_Task__c WHERE id in :TaskIds]; 
            for(Project_Task__c taskDetail : taskList) {
                taskIDEmployeeId.put(taskDetail.id , taskDetail.Approver__c );
            }
            for(Time__c rec : Trigger.new) 
            { 
            	if(rec.Project_Task__c != null && taskIDEmployeeId.get(rec.Project_Task__c) != null){
	            	if(rec.OwnerId != taskIDEmployeeId.get(rec.Project_Task__c)){
			                    tTimeShareList.add(new Time__Share(ParentId = rec.Id,
			                                                    UserOrGroupId = taskIDEmployeeId.get(rec.Project_Task__c), 
			                                                    AccessLevel =  'Read'));
		            }
            	}
            }
    }
    List<Time__Share> wTimeShareList = new List<Time__Share>();
    if(WeeklyReportIds.size() > 0){
            list<WeeklyReport__c> weeklyReportList = [SELECT id,  Approver__c FROM WeeklyReport__c WHERE id in :WeeklyReportIds]; 
            for(WeeklyReport__c weeklyReportDetail : weeklyReportList) {
                weeklyReportIDEmployeeId.put(weeklyReportDetail.id , weeklyReportDetail.Approver__c );
            }
            for(Time__c rec : Trigger.new) 
            { 
            	if(rec.WeeklyReport__c != null && weeklyReportIDEmployeeId.get(rec.WeeklyReport__c) != null){
	            	if(rec.OwnerId != weeklyReportIDEmployeeId.get(rec.WeeklyReport__c)){
			                    wTimeShareList.add(new Time__Share(ParentId = rec.Id,
			                                                    UserOrGroupId = weeklyReportIDEmployeeId.get(rec.WeeklyReport__c), 
			                                                    AccessLevel =  'Read'));
		            }
            	}
            }
    }
    
    List<Time__Share> pTimeShareList = new List<Time__Share>();
    if(ProjectIds.size() > 0){
    	List<ID> employeeIdList = new List<ID>();
        Map<Id, List<Project_TeamMember__c>> pjtsMap = new Map<Id, List<Project_TeamMember__c>>();
        Map<Id, Id> userIdMap = new Map<Id, Id>();
    	List<Project_TeamMember__c> pjtms = [SELECT Id, Project__c, Team_Member__c 
            FROM Project_TeamMember__c where Project__c in :ProjectIds];
        for(Project_TeamMember__c pjtm : pjtms) {
            	employeeIdList.add(pjtm.Team_Member__c);
	            if(pjtsMap.keyset().contains(pjtm.Project__c)) {
	                pjtsMap.get(pjtm.Project__c).add(pjtm);
	            } else {
	                List<Project_TeamMember__c> dpjts = new List<Project_TeamMember__c>();
	                dpjts.add(pjtm);
	                pjtsMap.put(pjtm.Project__c,dpjts);
	            }
        }
        List<Employee__c> employees = [select id, n_EmployeeName__c from Employee__c where Id in :employeeIdList];
        for(Employee__c u : employees) {
            userIdMap.put(u.id, u.n_EmployeeName__c );
        }
        for(Time__c rec : Trigger.new) {
        	if(pjtms.size() > 0){
                for(Project_TeamMember__c pTm : pjtsMap.get(rec.project__c)) {
                	if(userIdMap.get(pTm.Team_Member__c) != null && rec.OwnerId != userIdMap.get(pTm.Team_Member__c) ){
                		pTimeShareList.add(new Time__Share(ParentId = rec.Id,
                                                UserOrGroupId = userIdMap.get(pTm.Team_Member__c), 
                                                AccessLevel =  'Read'));
                	}
            
            	}
        	}
	    }
    }
    if(tTimeShareList.size() > 0) insert tTimeShareList;
    if(wTimeShareList.size() > 0) insert wTimeShareList;
	if(pTimeShareList.size() > 0) insert pTimeShareList;
  }
	if(trigger.isAfter ){
		if(trigger.isdelete) {
		    Time_Trigger_Utility.handleTimeAfterTrigger(Trigger.old);
		}else{
		    Time_Trigger_Utility.handleTimeAfterTrigger(Trigger.new);
		}
		Set<ID> reportIds = new Set<ID>();
		  list<Time__c> TimeList = new list<Time__c>();
		  if(trigger.isdelete) {
		    TimeList = trigger.old;
		  }else{
		    TimeList = trigger.new;
		  }
	    for(Time__c rec : TimeList) 
	    { 
	      if(rec.WeeklyReport__c != null){
	           reportIds.add(rec.WeeklyReport__c); 
	      }
	    }
	    list<WeeklyReport__c> weeklyReportList = [SELECT id,  WeekHourActNumber__c, dutyTimeCount__c,ServiceTimeCount__c FROM WeeklyReport__c WHERE Id in :reportIds]; 
        list<Time__c> FullTimeList = [SELECT id, Hours__c, WeeklyReport__c,Class__c  FROM Time__c WHERE WeeklyReport__c in :reportIds];
        for(WeeklyReport__c weeklyReport : weeklyReportList){
        	weeklyReport.WeekHourActNumber__c = 0;
            weeklyReport.dutyTimeCount__c = 0;
            weeklyReport.ServiceTimeCount__c = 0;
        	for(Time__c TimeDetail : FullTimeList){

                Decimal hour = 0;
                if(TimeDetail.Hours__c != null) hour = TimeDetail.Hours__c;

        		if(weeklyReport.id == TimeDetail.WeeklyReport__c){                    
        			weeklyReport.WeekHourActNumber__c += hour;
                    //=================工时统计用========================
                    if(TimeDetail.Class__c  != '请假'){
                        weeklyReport.dutyTimeCount__c  += hour;

                        if(TimeDetail.Class__c  != '个人事项'){
                            weeklyReport.ServiceTimeCount__c  += hour;    
                        }
                    }
                    //==================================================

        		}
        	 	
        	}
        	
        }
        update weeklyReportList;
	} 
  if(trigger.isBefore){
    Set<ID> TaskIds = new Set<ID>();
    Set<ID> WeeklyReportIds = new Set<ID>();
    Map<Id, Id> taskIDProjectId = new Map<Id, Id>();
    Map<Id, Id> taskIDEmployeeId = new Map<Id, Id>();
    Map<Id, Id> weeklyReportIDEmployeeId = new Map<Id, Id>();
    if(trigger.isInsert || trigger.isUpdate){
        for(Time__c rec : Trigger.new) {
        	if(rec.StartTime__c != null){
        		rec.Date_Incurred__c = rec.StartTime__c.date();
        	}
            if(rec.Project_Task__c != null){
                TaskIds.add(rec.Project_Task__c);
            }
            if(rec.WeeklyReport__c != null){
            	WeeklyReportIds.add(rec.WeeklyReport__c);
            }
        }
        
        if(TaskIds.size() > 0){
            list<Project_Task__c> taskList = [SELECT id,  Assigned_To__c, Project__c FROM Project_Task__c WHERE id in :TaskIds]; 
            for(Project_Task__c taskDetail : taskList) {
                taskIDEmployeeId.put(taskDetail.id , taskDetail.Assigned_To__c );
                taskIDProjectId.put(taskDetail.id , taskDetail.Project__c );
            }
            for(Time__c rec : Trigger.new) 
            { 
            	if(rec.Project_Task__c != null){
            		if(rec.Project__c == null){
            			rec.Project__c = taskIDProjectId.get(rec.Project_Task__c);
            		}
                	rec.Employee__c = taskIDEmployeeId.get(rec.Project_Task__c);
            	}
            }
         }
         if(WeeklyReportIds.size() > 0){
        	list<WeeklyReport__c> weeklyReportList = [SELECT id,  Employee__c FROM WeeklyReport__c WHERE id in :WeeklyReportIds]; 
        	for(WeeklyReport__c weeklyReportDetail : weeklyReportList) {
                weeklyReportIDEmployeeId.put(weeklyReportDetail.id , weeklyReportDetail.Employee__c );
            }
            for(Time__c rec : Trigger.new) 
            { 
            	if(rec.WeeklyReport__c != null){
                	rec.Employee__c = weeklyReportIDEmployeeId.get(rec.WeeklyReport__c);
            	}
            }
         }
            

        
    }

        Set<ID> EmployeeIds = new Set<ID>();
        for(Time__c rec : Trigger.new) 
        { 
            if((trigger.isInsert || trigger.isUpdate && rec.Date_Incurred__c != trigger.oldMap.get(rec.id).Date_Incurred__c) && rec.WeeklyReport__c == null){
            	if(rec.Employee__c != null){
                	EmployeeIds.add(rec.Employee__c);
            	}
            }
        }
        if(EmployeeIds.size() > 0){

            list<WeeklyReport__c> WeeklyReportList = [SELECT id, Employee__c, StartOfWeek__c, EndOfWeek__c FROM WeeklyReport__c WHERE Employee__c in :EmployeeIds]; 
            //for(WeeklyReport__c WeeklyReport : WeeklyReportList) {
            //  WeeklyReportEmployeeIds.add(WeeklyReport.Employee__c);
            //}
            for(Time__c timeItem : Trigger.new) { 
            	if((trigger.isInsert || trigger.isUpdate && timeItem.Date_Incurred__c != trigger.oldMap.get(timeItem.id).Date_Incurred__c) && timeItem.WeeklyReport__c == null){
	                boolean ReportFlg = false;
	                for(WeeklyReport__c WeeklyReport : WeeklyReportList) {
	                    if(WeeklyReport.Employee__c == timeItem.Employee__c && WeeklyReport.StartOfWeek__c <= timeItem.Date_Incurred__c && WeeklyReport.EndOfWeek__c >= timeItem.Date_Incurred__c ){
	                        timeItem.WeeklyReport__c = WeeklyReport.id;
	                        ReportFlg = true;
	                        break;
	                    }
	                }
	                if(!ReportFlg){
	                    //Date StartOfWeek;
	                    //if(timeItem.Date_Incurred__c.toStartOfWeek().isSameDay(timeItem.Date_Incurred__c)){
	                    //    StartOfWeek = timeItem.Date_Incurred__c.toStartOfWeek().addDays(-6);
	                    //}else{
	                    //    StartOfWeek = timeItem.Date_Incurred__c.toStartOfWeek().addDays(1);
	                    //}
	                    //Date EndOfWeek = StartOfWeek.addDays(6);
	                    WeeklyCalendarCustom__c weeklyCalendar = [select id, Year__c, Quarter__c, Week_Number__c, StartDate__c, EndDate__c from WeeklyCalendarCustom__c where StartDate__c <= :timeItem.Date_Incurred__c and EndDate__c >= :timeItem.Date_Incurred__c];
	                    WeeklyReport__c NewWeeklyReport = new WeeklyReport__c( Year__c = weeklyCalendar.Year__c,Quarter__c = weeklyCalendar.Quarter__c,Week_Number__c = weeklyCalendar.Week_Number__c,approve_status__c = '未申请', Employee__c = timeItem.Employee__c);
	                    insert NewWeeklyReport;
	                    timeItem.WeeklyReport__c = NewWeeklyReport.id;
	                }
            	}
            }
        }
  }

}