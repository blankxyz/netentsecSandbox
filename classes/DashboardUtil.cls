/**
 * Dashboard 功能
 */
global class DashboardUtil {

    webservice String parameter { get; set; }

    public DashboardUtil() {
        this.parameter = 'value';
    }

    /**
     *  工作饱和度Dashboard
     */
    webservice static String getDegreeOfJobSaturation(){
        return '';
    }

    /**
     *  取得部门列表
     *  参数： 父部门ID
     *  返回：有父部门ID时，返回子部门列表
     *       无父部门ID时，返回最上级部门列表
     */
    webservice static String getDepartment(String parentD){

        return parentD != null ? JSON.serialize([select id , name, branchdepartment__c from SalesRegion__c where branchdepartment__c = :parentD]) : JSON.serialize([select id , name from SalesRegion__c where branchdepartment__c = NULL]);

    }
}