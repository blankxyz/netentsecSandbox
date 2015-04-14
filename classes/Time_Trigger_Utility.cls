public class Time_Trigger_Utility { 
    public static void handleTimeAfterTrigger(List<Time__c> recs) {

        Set<ID> taskIds = new Set<ID>();
        Set<ID> ProjectIds = new Set<ID>();
        for(Time__c rec : recs) 
        { 
        	if(rec.Project_Task__c != null){
            	taskIds.add(rec.Project_Task__c); 
        	}
        	if(rec.Project__c != null){
            	ProjectIds.add(rec.Project__c); 
        	}
        }
        if(taskIds.size() > 0){
	        list<Project_Task__c> TaskList = [SELECT id, Total_Expense__c, Total_Hours__c FROM Project_Task__c WHERE Id in :taskIds]; 
	        list<Time__c> FullTimeList = [SELECT id, Project_Task__c , Hours__c, Time_Expense__c FROM Time__c WHERE Project_Task__c in :taskIds];
	        for(Project_Task__c task : TaskList){
	            task.Total_Expense__c = 0;
	            task.Total_Hours__c = 0;
	            for(Time__c TimeDetail : FullTimeList){
	               if(task.id == TimeDetail.Project_Task__c){
	                   task.Total_Expense__c = task.Total_Expense__c + TimeDetail.Time_Expense__c;
	                   task.Total_Hours__c = task.Total_Hours__c + TimeDetail.Hours__c;
	               }
	            }
	        }
	        update TaskList;
        }
        if(ProjectIds.size() > 0){
	        list<Project__c> ProjectList = [SELECT id, Total_Hours_Incurred_from_ProjectYime__c FROM Project__c WHERE Id in :ProjectIds]; 
	        list<Time__c> FullTimeList = [SELECT id, Project__c , Hours__c FROM Time__c WHERE Project__c in :ProjectIds];
	        for(Project__c project : ProjectList){
	            project.Total_Hours_Incurred_from_ProjectYime__c = 0;
	            for(Time__c TimeDetail : FullTimeList){
	               if(project.id == TimeDetail.Project__c){
	                   project.Total_Hours_Incurred_from_ProjectYime__c = project.Total_Hours_Incurred_from_ProjectYime__c + TimeDetail.Hours__c;
	               }
	            }
	        }
	        update ProjectList;
        }
    }

}