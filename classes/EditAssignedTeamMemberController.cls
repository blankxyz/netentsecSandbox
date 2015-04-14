public class EditAssignedTeamMemberController {
    public Boolean ProjectTask { get; set; }
    public Id department {get; set;}
    public Project_Task__c task { get; set; }
    public Boolean hasQueryResult                {get; set;}
    public List<Time__c> Times           {get; set;}
    List<SalesRegion__c> listSalesRegion = new list<SalesRegion__c>();
    public EditAssignedTeamMemberController(ApexPages.StandardController controller) {
    task = (Project_Task__c)controller.getRecord();
    ProjectTask = false;
    if(task.recordtypeId == Schema.SObjectType.Project_Task__c.getRecordTypeInfosByName().get('项目任务').getRecordTypeId()) {
        ProjectTask = true;
    }
    for(Employee__c emp : [select id, n_EmployeeAear__c from Employee__c
            where Id = :task.Assigned_To__c ]){
            	department = emp.n_EmployeeAear__c;
            	 break;
            	
            }
    listSalesRegion = [Select Id, name From SalesRegion__c where  Name Like '%售前%' OR Name Like '%技术%' OR Name Like '%东%' OR Name Like '%西%' OR Name Like '%南%' OR Name Like '%北%'];

    }
     public void query() {

        String querySOQL = 'SELECT Project_Task__r.Name, StartTime__c, EndTime__c,  Employee__c, Project_Task__r.TaskStatus__c, Project_Task__r.Location__c,Description__c, Hours__c, Class__c FROM Time__c WHERE Project_Task__r.Complete__c =false and (Project_Task__r.TaskStatus__c = \'进行中\' or Project_Task__r.TaskStatus__c = null) and ' + 
            'Employee__r.n_EmployeeAear__c = :department AND ';


        // Filter Part
        Id AssignedTo;
        if (task.Assigned_To__c != null) {
            AssignedTo = task.Assigned_To__c;
             querySOQL += 'Employee__c  = :AssignedTo AND ';
        }
        DateTime startDate;
        DateTime endDate;
        startDate = task.Start_Date__c;
        endDate = task.Due_Date__c;
        if (task.Start_Date__c != null && task.Due_Date__c != null) {
            querySOQL += '((StartTime__c >= :startDate AND StartTime__c <= :endDate) OR (StartTime__c <= :startDate AND EndTime__c >= :startDate)) AND ';
        }else if(task.Start_Date__c != null && task.Due_Date__c == null){
            querySOQL += '(StartTime__c >= :startDate OR (StartTime__c <= :startDate AND EndTime__c >= :startDate)) AND ';   
        }else if(task.Start_Date__c == null && task.Due_Date__c != null){
            querySOQL += '(EndTime__c <= :endDate OR (StartTime__c <= :endDate AND EndTime__c >= :endDate)) AND ';   
        }
        
                   
        querySOQL = querySOQL.subString(0, querySOQL.length() - 4) + 
            'ORDER BY StartTime__c  ';
        System.debug('Debug Output ======> {' + querySOQL + '}');
        
        Times = Database.query(querySOQL);
        
        // If no query result, system alert no search result.
        hasQueryResult = (Times.size() > 0);
        if (!hasQueryResult) {
            this.addInfoMessage('无任务安排');
        }
    }
    private void addInfoMessage(String msg) {
        ApexPages.addMessage(new ApexPages.Message(
            ApexPages.severity.INFO, msg));
    }
    private void addErrorMessage(String msg) {
        ApexPages.addMessage(new ApexPages.Message(
            ApexPages.severity.ERROR, msg));
    }
    public PageReference refreshPage(){
        return null;
    }
        public List<SelectOption> departments {
        get {
            List<SelectOption> options = new List<SelectOption>();
            for(SalesRegion__c sr : listSalesRegion){
                options.add(new SelectOption(sr.id, sr.name));
            }
            return options;
        }
    }
    public List<SelectOption> getEmployees(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--None--'));
        for(Employee__c ep : [select id, Name from Employee__c
            where n_EmployeeAear__c = :department and n_EmployeeName__r.IsActive =true]){
            if(ep.Name != null){
                options.add(new SelectOption(ep.id, ep.Name));
            }
        }
        return options;
    }

}