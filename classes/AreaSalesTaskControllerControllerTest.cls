@isTest(seeAllData=TRUE)
public class AreaSalesTaskControllerControllerTest {
    
    @isTest static void testAreaSalesTaskController(){
        
        AreaSalesTaskController controller = new AreaSalesTaskController();
        controller.chartFilter = 'all';
        controller.chartYear = '2014';
        controller.chartQuarter  = 'all';
        controller.getDepartmentPieData();
        controller.getDepartmentSalesTaskData();
        AreaSalesTaskController.getChartFilterOptions();
        AreaSalesTaskController.getChartYearOptions();
        AreaSalesTaskController.getChartQuarterOptions();
        controller.chartFilter = 'area1';
        controller.chartQuarter  = 'Q1';
        controller.getDepartmentPieData();
        controller.getDepartmentSalesTaskData();
        controller.chartFilter = 'area2';
        controller.chartQuarter  = 'Q2';
        controller.getDepartmentPieData();
        controller.getDepartmentSalesTaskData();
        controller.chartFilter = 'area3';
        controller.chartQuarter  = 'Q3';
        controller.getDepartmentPieData();
        controller.getDepartmentSalesTaskData();
        controller.getProductsSalesData();
        controller.getProductsSalesTaskData();
        controller.getProductsSalesPieData();
        
        Project_Task__c projTask = new Project_Task__c();
        projTask.name = '测试';
        projTask.Start_Date__c = datetime.now();
        projTask.Due_Date__c = datetime.now();
        insert projTask;
        SelectAssignedTeamMemberController controller1 = new SelectAssignedTeamMemberController(new ApexPages.StandardController(projTask));
        controller1.query();
        controller1.save();
        //EditAssignedTeamMemberController controller2 = new EditAssignedTeamMemberController();
        //controller2.query();

    }
}