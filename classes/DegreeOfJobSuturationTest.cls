@isTest(SeeAllData=true)
private class DegreeOfJobSuturationTest
{

    @isTest
    static void itShould()
    {
    
        // When
        PageReference pageRef = Page.DegreeOfJobSuturation;
        Test.setCurrentPage(pageRef);
		
		id level1Id = [select id , name from SalesRegion__c where branchdepartment__r.name = '技术服务部' limit 1].id;
		id level2Id = [select id , name, branchdepartment__r.name,branchdepartment__c from SalesRegion__c where branchdepartment__r.branchdepartment__r.name = '技术服务部' limit 1].id;

        DegreeOfJobSuturationCtl ctl = new DegreeOfJobSuturationCtl();
        ctl.chartDepart = level1Id;
        ctl.getDepartData();

        List<SelectOption>  a = ctl.getChartYearOptions();
        List<SelectOption>  b = ctl.getChartQuarterOptions();
        List<SelectOption>  c = ctl.getchartDepartOptions();

        ctl.chartSubDepart = level2Id;
        ctl.getChartData();
        List<SelectOption>  d = ctl.chartSubDepartOptions;

    }
}