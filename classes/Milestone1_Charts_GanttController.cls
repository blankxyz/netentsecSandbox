public with sharing class Milestone1_Charts_GanttController {

    public String mytarget {get; 
        set{
            this.mytarget = value;
            init();
        }
        }
    public String objectType {get;set;}
    public String startDateFieldName {get;set;}
    public String endDateFieldName {get;set;}
    public String idFieldName {get;set;}
    public String fullViewURL {get;set;}
    public String projectGanttJson{get;set;}
 
    private String nameFieldName;
    private String completedFieldName;
    private String filterFieldName;
    
    
    private List<Sobject> sobjectList;
    private static final String REGEXP_QUOTES    = '(?<!\\\\)"';
    
    public static final String COLOR_COMPLETE = '#333333';
    public static final String COLOR_LATE = '#ee3322';
    public static final String COLOR_FUTURE = '#666666';
    public static final String COLOR_CURRENT = '#2299bb';
    
    public Milestone1_Charts_GanttController()
    {
        init();
    }
    
    private void init()
    {
        if (myTarget != null)
        {
         initFieldNames();
         retrieveData();
        projectGanttJson = toJSon();
        
        }
    }
    
    public String getProjectGanttJson() {
        
        init();
        return projectGanttJson;
    }
    
    /*
    *   Initialize the variables depending on the object type possible values: 
    *   Milestone1_Milestone__c and Milestone1_Task__c
    */
    private void initFieldNames(){
        if(mytarget != null){
            if(mytarget.startsWith(Schema.SObjectType.Project__c.getKeyPrefix())){
                /*startDateFieldName = 'Kickoff__c';
                endDateFieldName = 'Deadline__c';
                nameFieldName = 'NameClean__c';
                filterFieldName = 'Project__c';*/
                
                startDateFieldName = Milestone__c.Kickoff__c.getDescribe().getName();
                endDateFieldName = Milestone__c.Deadline__c.getDescribe().getName();
                nameFieldName = Milestone__c.Name.getDescribe().getName();
                filterFieldName = Milestone__c.Project__c.getDescribe().getName();
                                
                //objectType = 'Milestone1_Milestone__c';
                objectType = Schema.SObjectType.Milestone__c.getName();
            }else if(mytarget.startsWith(Schema.SObjectType.Milestone__c.getKeyPrefix())){

                startDateFieldName = Project_Task__c.Start_Date__c.getDescribe().getName();
                endDateFieldName = Project_Task__c.Due_Date__c.getDescribe().getName();
                nameFieldName = Project_Task__c.Name.getDescribe().getName();
                filterFieldName = Project_Task__c.Project_Milestone__c.getDescribe().getName();
                                
                objectType = Schema.SObjectType.Project_Task__c.getName();
            } else {
                //throw new Milestone1_Exception('[initFieldNames] Unable to generate JSON for ' + mytarget);
            }
            idFieldName = 'Id';
            completedFieldName = 'Complete__c'; 
        }
    }
    
    /*
    *   Retrieve the data doing a dynamic query by object type.
    */
    private void retrieveData(){
        
        String query = 'Select '+idFieldName+','+startDateFieldName+','+endDateFieldName+','+nameFieldName+','+completedFieldName+
                       ' from '+objectType+ ' where '+filterFieldName+'=\''+mytarget+'\' order by Name';
        sobjectList = Database.query(query);
    }
    
    /**
    *   Generate the output in json format to be rendered in the jquery gantt.
    */
    private String toJSon(){
        
        String ret = 'var ganttData' +mytarget + ' = [{id: 1, name: "", series: [';
        Boolean addComma=false,completed;
        Date startDate,endDate;
        String name,id;
        for (Sobject current : sobjectList){ 
            
            if(current.get(startDateFieldName) == null){
                startDate = Date.today();
            }else{
                startDate = Date.valueOf(current.get(startDateFieldName));
            }
            if(current.get(endDateFieldName) == null){
                endDate = startDate;
            }else{
                endDate = Date.valueOf(current.get(endDateFieldName));
            }
            completed = Boolean.valueOf(current.get(completedFieldName));
            name = escapeDoubleQuotes(String.valueOf(current.get(nameFieldName)));
            id = String.valueOf(current.get(idFieldName));
            if (addComma) { ret += ','; }
            
            String color=COLOR_CURRENT;
            
            if (completed) {
                color=COLOR_COMPLETE;
            } else if (endDate < Date.today()) {
                color=COLOR_LATE;
            } else if (startDate > Date.today()) {
                color=COLOR_FUTURE;
            }
            
            ret +=  '{'+
                    'id:"'+id+'",'+ 
                    'name: "'+name+'",'+
                    'start: new Date(' +startDate.year() +',' + (startDate.month()-1) +',' + startDate.day() +'),'+
                    'end: new Date(' +endDate.year() +',' + (endDate.month()-1) + ',' + endDate.day() +'), ' +
                    'color: "' + color + '"'+
                    '}';
                    
            addComma=true;
            
        }
        
        ret+=']}];';
        return ret;     
    }
    
    private String escapeDoubleQuotes(String word){
        return word.replaceAll(REGEXP_QUOTES,'\\\\"');
    }

}