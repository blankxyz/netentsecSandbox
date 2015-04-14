/**
 * @author DanDy 
 * @date 10/04/2015
 * @description 技术服务部工作状态仪表盘控制类
 */
public with sharing class DegreeOfJobSuturationCtl extends DashboradBaseCtl{

    private final Map<id, SalesRegion__c> departlv1 = new Map<id, SalesRegion__c>([select id , name from SalesRegion__c where branchdepartment__r.name = '技术服务部']);
    private final Map<id, SalesRegion__c> departlv2 = new Map<id, SalesRegion__c>([select id , name, branchdepartment__r.name,branchdepartment__c from SalesRegion__c where branchdepartment__r.branchdepartment__r.name = '技术服务部']);
    /**
    public String isDepartChanged {
        get{
            if(isDepartChanged==Null) {
                return 'false';
            }
            return isDepartChanged;
        }
        set;
    }
    */
    private List<WeeklyReport__c> personData;
    public List<DegreeOfSuturationData> outputData;
    //按技术服务部数据检索SOQL
    public final String soql1 = '' +
                'select sum(dutyTimeCount__c) ds, ' +  
                '       sum(WeekHour_Number__c) ws, ' +
                '       sum(ServiceTimeCount__c) ss,  ' +  
                '       Employee__r.n_EmployeeAear__r.branchdepartment__r.name dName ' +
                'from WeeklyReport__c ' +
                'where Employee__r.n_EmployeeAear__r.branchdepartment__r.branchdepartment__r.name=\'技术服务部\' ' +
                'and Quarter__c in :paramQ ' +
                'and Year__c = :paramY  and StartOfWeek__c < today ' +
                'and approve_status__c = \'审批成功\' ' +
                'group by Employee__r.n_EmployeeAear__r.branchdepartment__r.name';
    //按大区数据检索SOQL
    public final String soql2 = ''+
                'select sum(dutyTimeCount__c) ds,  ' +  
                '       sum(WeekHour_Number__c) ws,  ' +  
                '       sum(ServiceTimeCount__c) ss,  ' +  
                '       Employee__r.n_EmployeeAear__r.name dName ' +   
                'from WeeklyReport__c  ' +  
                'where Employee__r.n_EmployeeAear__r.branchdepartment__c = :paramD ' +  
                'and Quarter__c in :paramQ  ' +  
                'and Year__c = :paramY  and StartOfWeek__c < today ' +  
                'and approve_status__c = \'审批成功\' ' +
                'group by Employee__r.n_EmployeeAear__r.name ';
    //按办事处数据检索SOQL
    public final String soql3 = ''+
                'select sum(dutyTimeCount__c) ds,  ' +  
                '       sum(WeekHour_Number__c) ws,  ' +  
                '       sum(ServiceTimeCount__c) ss,  ' +                  
                '       Employee__r.name dName ' +   
                'from WeeklyReport__c  ' +  
                'where Employee__r.n_EmployeeAear__c = :paramD ' +  
                'and Quarter__c in :paramQ  ' +  
                'and Year__c = :paramY  and StartOfWeek__c < today ' +                  
                'and approve_status__c = \'审批成功\' ' +
                'group by Employee__r.name ';

    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public DegreeOfJobSuturationCtl() {
        super();
        getChartData();
    }

    //dataJson = JSON.serializePretty(chartData);
    public pageReference getDepartData(){
        chartSubDepart = '';
        return getChartData();
    }
    
    /**
     * @author DanDy 
     * @date 10/04/2015
     * @description 获取仪表盘所需数据
     * @return null
     */
    //获取图表数据
    public pageReference getChartData(){

        List<DegreeOfSuturationData> outputData = new List<DegreeOfSuturationData>();

        //季度参数
        List<String> paramQ = new List<String>();
        for(String s : this.chartQuarter){
            paramQ.add('Q'+s);
        }
        //年度参数
        String paramY = this.chartYear;
        //部门参数
        String paramD = String.isBlank(chartSubDepart) ?this.chartDepart : this.chartSubDepart;
        String querySOQL = soql1;
        /***********按部门选取不同分类处理***************/
        if(paramD == 'All'){
            //技术服务部统计
            querySOQL = soql1;
        }else if(departlv1.containsKey(paramD)){
            //大区统计
            querySOQL = soql2;
        }else if(departlv2.containsKey(paramD)){
            //办事处统计
            querySOQL = soql3;
        }

        for (AggregateResult w : Database.query(querySOQL)){
            DegreeOfSuturationData data = new DegreeOfSuturationData();

            data.ds = String.isBlank(string.Valueof(w.get('ds'))) ? 0 : decimal.Valueof(string.Valueof(w.get('ds')));
            data.ss = String.isBlank(string.Valueof(w.get('ss'))) ? 0 : decimal.Valueof(string.Valueof(w.get('ss')));
            data.ws = decimal.ValueOf(string.Valueof(w.get('ws')));
            data.suturation = (data.ds*100/data.ws).setScale(2);
            data.effectivity = (data.ss*100/data.ws).setScale(2);

            data.area = (String)w.get('dName');

            outputData.add(data);
        }

        dataJson = outputData.size()>0 ? JSON.serializePretty(outputData) : '';

        return null;


    }
    public String dataJson {get;set;}
    public String chartSubDepart { get;  set;}
    public List<SelectOption> chartSubDepartOptions { 
        get{

            List<SelectOption> department = new List<SelectOption>();
            department.add(new SelectOption('','无'));
            if (chartDepart != Null && chartDepart != 'all' ) {
                for(SalesRegion__c s : departlv2.values()){
                    if(s.branchdepartment__c == this.chartDepart){
                        department.add(new SelectOption(s.id,s.name));
                    }
                }
            }
            //chartSubDepart = '';
            return department;

        }
         set; 
    }

    public List<SelectOption> getchartDepartOptions() {
        return getSubDepartOptions('技术服务部');
    }

    public class DegreeOfSuturationData{ 
        public decimal ds{get; set;}
        public decimal ws{get; set;}
        public decimal ss{get; set;} 
        public decimal effectivity{get;set;}
        public decimal suturation{get;set;}
        public String area {get; set;}
    }

}