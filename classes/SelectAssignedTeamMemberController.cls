public class SelectAssignedTeamMemberController {
    public String TaskRecordtype{ get; set; }
    public String WorkOrdertype{ get; set; }
    public Project_Task__c task                  {get; set;}
    public Boolean hasQueryResult                {get; set;}
    public List<Time__c> Times                   {get; set;}
    public Boolean hasMessage                    {get; set;}
    public Integer countLstInner = 0;
    public List<innerClass> lstInner = new List<innerClass>();
    public List<ProductSNLineItem__c>lstRec = new List<ProductSNLineItem__c>();
    public List<ProductSNLineItem__c>LstRecDel = new List<ProductSNLineItem__c>();
    public String selectedRowIndex               {get;set;} 
    public boolean isEdit { get; set; }
    Map<Id, Id> SalesRegionIDUserId = new Map<Id, Id>();
    Map<Id, Id> UserIdEmployeeID = new Map<Id, Id>();
    public List<innerClass> getLstInner(){
    
        return lstInner;
    }
    public void InitLstInner() {
    	system.debug('task+++++'+task);
        if(task.Customer__c != null){
            countLstInner=0;
            lstInner = new List<innerClass>();
    
            for(ProductSN__c thisProSn: [select Id, ProductCategory__c
    
                from ProductSN__c 
    
                where coustmer__c =:task.Customer__c]){
    
                lstInner.add(new innerClass(countLstInner, new ProductSNLineItem__c(Project_Task__c = task.id, ProductSN__c= thisProSn.Id, ProductCategory__c = thisProSn.ProductCategory__c)));
    
                countLstInner++;
    
            }
        }
        system.debug('lstInner1+++++'+lstInner);
    
    }

    Id ProjectId;
    Id MilestoneId;
    public Id department {get; set;}
    //List<ID> employeeIdList = new List<ID>();
    List<SalesRegion__c> listSalesRegion = new list<SalesRegion__c>();
   
    public SelectAssignedTeamMemberController(ApexPages.StandardController controller){
        if(((Project_Task__c)controller.getRecord()).id != null){
            isEdit =true;
            task = (Project_Task__c)controller.getRecord();
            task = [select Id, TestResult__c, Contact__c, TroubleDescription__c, OtherInfo__c, TopoMap__c, TroubleResult__c, TroublePriority__c, RemoteControlDetail__c, RemoteControlMode__c, ManagerContact__c, CustomizedInfo__c, TestCategory__c, Competitors__c, ProductManager__c, ProductManagerContact__c, DevlopManager__c, DepartmentManagerContact__c, CustomizedNum__c, recordtypeId, name, Location__c, Assigned_To__c, Start_Date__c, Due_Date__c, Description__c, Priority__c, Blocked__c, Blocked_Reason__c, Estimated_Hours__c, Project_Milestone__c, Project__c, Customer__c, Employee__c, WorkOrderPlan__c, OtherWorks__c, Report__c, FeedBack__c, Content1__c, Comment1__c, CompletionRate1__c, CompletionConfirm1__c, OtherComment__c, TaskStatus__c, ProjectDenyReason__c, CustonPhone__c, Address__c, Bandwidth__c, NumberOfEmployees__c, SalesContact__c, PreSaleContact__c, CustomContact__c from Project_Task__c where Id = :task.Id];  
            if(task.recordtypeId == Schema.SObjectType.Project_Task__c.getRecordTypeInfosByName().get('项目任务').getRecordTypeId()){
                TaskRecordtype = 'ProjectTask';
            }else if(task.recordtypeId == Schema.SObjectType.Project_Task__c.getRecordTypeInfosByName().get('工单（实施交付类）').getRecordTypeId()){
                TaskRecordtype = 'WorkOrder';
                WorkOrdertype = '实施';
            }else if(task.recordtypeId == Schema.SObjectType.Project_Task__c.getRecordTypeInfosByName().get('工单（测试类）').getRecordTypeId()){
                TaskRecordtype = 'WorkOrder';
                WorkOrdertype = '测试';
            }else if(task.recordtypeId == Schema.SObjectType.Project_Task__c.getRecordTypeInfosByName().get('工单（故障类）').getRecordTypeId()){
                TaskRecordtype = 'WorkOrder';
                WorkOrdertype = '故障';
            }else if(task.recordtypeId == Schema.SObjectType.Project_Task__c.getRecordTypeInfosByName().get('项目外任务').getRecordTypeId()){
                TaskRecordtype = 'NoneProjectTask';
            }
            if(task.id !=null){
                for(ProductSNLineItem__c thisProSnItem: [select ProductSN__c, ProductCategory__c, ProductSNString__c, Status__c
        
                    from ProductSNLineItem__c
        
                    where Project_Task__c =:task.id]){
        
                        lstInner.add(new innerClass(countLstInner, thisProSnItem));
            
                        countLstInner++;
        
                }
            }
        }else{
            isEdit =false;
            task = new Project_Task__c();
            if(ApexPages.currentPage().getParameters().get('ProjectTask') != null){
                task.recordtypeId = Schema.SObjectType.Project_Task__c.getRecordTypeInfosByName().get('项目任务').getRecordTypeId();
                TaskRecordtype = 'ProjectTask';
            }else if(ApexPages.currentPage().getParameters().get('WorkOrder') != null){
            	if(ApexPages.currentPage().getParameters().get('AccountId') != null){
            		task.Customer__c = ApexPages.currentPage().getParameters().get('AccountId');
            	}
                task.recordtypeId = Schema.SObjectType.Project_Task__c.getRecordTypeInfosByName().get('工单（实施交付类）').getRecordTypeId();
                TaskRecordtype = 'WorkOrder';
                WorkOrdertype = '实施';
            }else if(ApexPages.currentPage().getParameters().get('WorkOrderTest') != null){
            	if(ApexPages.currentPage().getParameters().get('AccountId') != null){
            		task.Customer__c = ApexPages.currentPage().getParameters().get('AccountId');
            	}
                task.recordtypeId = Schema.SObjectType.Project_Task__c.getRecordTypeInfosByName().get('工单（测试类）').getRecordTypeId();
                TaskRecordtype = 'WorkOrder';
                WorkOrdertype = '测试';
            }else if(ApexPages.currentPage().getParameters().get('WorkOrderTrouble') != null){
            	if(ApexPages.currentPage().getParameters().get('AccountId') != null){
            		task.Customer__c = ApexPages.currentPage().getParameters().get('AccountId');
            	}
                task.recordtypeId = Schema.SObjectType.Project_Task__c.getRecordTypeInfosByName().get('工单（故障类）').getRecordTypeId();
                TaskRecordtype = 'WorkOrder';
                WorkOrdertype = '故障';
            }else if(ApexPages.currentPage().getParameters().get('NoneProjectTask') != null){
                task.recordtypeId = Schema.SObjectType.Project_Task__c.getRecordTypeInfosByName().get('项目外任务').getRecordTypeId();
                TaskRecordtype = 'NoneProjectTask';
            }
            if(ApexPages.currentPage().getParameters().get('ProjectId') != null){
                ProjectId = ApexPages.currentPage().getParameters().get('ProjectId');
                task.Project__c = ProjectId;
            }
            if(ApexPages.currentPage().getParameters().get('MilestoneId') != null){
                MilestoneId = ApexPages.currentPage().getParameters().get('MilestoneId');
                task.Project_Milestone__c = MilestoneId;
            }
        }
        listSalesRegion = [Select Id, name, SEPersonInCharge__c From SalesRegion__c where  Name Like '%北京区-%' OR Name Like '%技术支撑中心-%' OR Name Like '%东区-%' OR Name Like '%西区-%' OR Name Like '%南区-%' OR Name Like '%北区-%'];
        if(task.Assigned_To__c != null){
            for(Employee__c emp : [select id, n_EmployeeAear__c from Employee__c
            where Id = :task.Assigned_To__c ]){
                department = emp.n_EmployeeAear__c;
                 break;
                
            }
        }else{
            for(SalesRegion__c sr : listSalesRegion ) {
                    department = sr.id;
                    break;
            }
        }
        for(SalesRegion__c sr : listSalesRegion ) {
        	SalesRegionIDUserId.put(sr.id, sr.SEPersonInCharge__c);
        }
        selectedRowIndex = '0';
    }
    
    public void query() {

        String querySOQL = 'SELECT Project_Task__r.Name, StartTime__c, EndTime__c,  Employee__c, Project_Task__r.Location__c,Description__c, Hours__c, Class__c FROM Time__c WHERE Project_Task__r.Complete__c =false and ' + 
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
    public PageReference save() {
        if (task.Name == null ) {
            this.addErrorMessage('任务名称不能为空');
        }
        if (task.Assigned_To__c == null) {
        	for(Employee__c emp : [select id from Employee__c
            where n_EmployeeName__c = :SalesRegionIDUserId.get(department) ]){
                task.Assigned_To__c = emp.id;
                 break;
                
            }
        	
        }
        if (task.Employee__c == null ) {
            this.addErrorMessage('申请人不能为空');
        }
        if (task.Start_Date__c == null ) {
            this.addErrorMessage('任务/工单开始日不能为空');
        }
        if (task.Due_Date__c == null ) {
            this.addErrorMessage('任务/工单结束日不能为空');
        }
        if(TaskRecordtype == 'WorkOrder'){
        	if (task.CustomContact__c == null ) {
            	this.addErrorMessage('客户联系人不能为空');
        	}
        	if (task.CustonPhone__c == null ) {
            	this.addErrorMessage('客户联系方式不能为空');
        	}
        	if (task.Address__c == null ) {
            	this.addErrorMessage('客户地址不能为空');
        	}
        	if (task.Bandwidth__c == null ) {
            	this.addErrorMessage('出口带宽不能为空');
        	}
        	if (task.NumberOfEmployees__c == null ) {
            	this.addErrorMessage('客户人数不能为空');
        	}
        	if (task.SalesContact__c == null ) {
            	this.addErrorMessage('销售/联系方式不能为空');
        	}
        	if (task.PreSaleContact__c == null ) {
            	this.addErrorMessage('售前/联系方式不能为空');
        	}
        	if (task.Content1__c == null ) {
            	this.addErrorMessage('支持内容及预期目标不能为空');
        	}
        	
        }
        if(ApexPages.getMessages().size() > 0){
        	 return null;
        }
            //try {
        upsert task;
        for(innerClass rec :lstInner)
       {
           rec.proSnItem.Project_Task__c = task.id;
           lstRec.add(rec.proSnItem);
    
       }
    
       upsert lstRec;
       if(LstRecDel.size() > 0){
           Delete LstRecDel;
       }
           // }
            //catch(Exception ex) {
            //    this.addErrorMessage(ex.getMessage());
           // }
            
            PageReference pr;
            //if(ApexPages.currentPage().getParameters().get('ret') != null) {
             //   pr = new PageReference(ApexPages.currentPage().getParameters().get('ret'));
            //}
           // else {
        if(MilestoneId != null){
            //pr = new PageReference('/' + MilestoneId);
            pr = new PageReference('/' + task.id);
        }else{
            //pr = new PageReference('/' + 'a0j');
            pr = new PageReference('/' + task.id);
        }
            //}
        return pr;
    }
    
    public PageReference cancel() {
        if(MilestoneId != null){
            return new PageReference('/' + MilestoneId);
        }else{
            return new PageReference('/' + 'a0j');
        }
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
    public void Del()

    {
    	system.debug('lstInner3+++++'+lstInner);
        innerClass innerDel = lstInner[Integer.valueOf(selectedRowIndex)];
        ProductSNLineItem__c RecDel = innerDel.proSnItem;
        if(RecDel.id != null){
            LstRecDel.add(RecDel);
        }
        lstInner.remove(Integer.valueOf(selectedRowIndex));
        countLstInner =0;
        for(innerClass n: lstInner)
        { Integer thisInt = countLstInner; n.recCount = thisInt.format(); 
        countLstInner++;
        }
        //countLstInner = countLstInner - 1;
    
         
    
    }
    public void MassDel()

    {
    	system.debug('lstInner2+++++'+lstInner);
        List<ProductSNLineItem__c> newLstRec = new List<ProductSNLineItem__c>();
        for(innerClass rec: lstInner){
                if(rec.selected == true){
                        if(rec.proSnItem.id != null){
                        LstRecDel.add(rec.proSnItem);
                        }
                }else{
                        newLstRec.add(rec.proSnItem);
                }       
        }
        lstInner = new List<innerClass>();
        countLstInner =0;
        for(ProductSNLineItem__c n: newLstRec)
        { 
                innerClass objInnerClass = new innerClass(countLstInner, n);
                        lstInner.add(objInnerClass);
                countLstInner++;
        }
        //countLstInner = countLstInner - 1;
    system.debug('countLstInner+++++'+countLstInner);
         system.debug('lstInner4+++++'+lstInner);
    
    }
    public void addMore()
    
    {
    
        //call to the iner class constructor
        
        innerClass objInnerClass = new innerClass(countLstInner, null);
        countLstInner = countLstInner +1;
    
         
    
        //add the record to the inner class list
    
        lstInner.add(objInnerClass);   
         
    
    }
    public class innerClass
    {      
        public String recCount
    
        {get;set;}
        public Boolean selected {get; set;}
    
        public ProductSNLineItem__c proSnItem
    
        {get;set;}
    
        public innerClass(Integer intCount , ProductSNLineItem__c proSnItemPar)
    
        {
    
            recCount = String.valueOf(intCount);       
            if(proSnItemPar == null){
                proSnItem = new ProductSNLineItem__c();
            }else{
                proSnItem = proSnItemPar;
            }

        }
    }
}