/**
 *  仪表盘销售任务测试类
 */
@isTest(SeeAllData = true)
private class AreaSalesTaskActlTest
{
	/**
	 * 柱状图测试
	 */
	@isTest
	static void itShould_A()
	{
		 //Test converage for the myPage visualforce page
		PageReference pageRef = Page.AreaSalesTask1;
		Test.setCurrentPageReference(pageRef);
		// Given
		AreaSalesTaskActl ctl = new AreaSalesTaskActl();

		ctl.getDepartmentSalesTaskData();

	}

	/**
	 * 饼图测试
	 */
	@isTest
	static void itShould_B()
	{
		 //Test converage for the myPage visualforce page
		PageReference pageRef = Page.AreaSalesTaskPie1;
		Test.setCurrentPageReference(pageRef);
		// Given
		AreaSalesTaskActl ctl = new AreaSalesTaskActl();

		ctl.getDepartmentSalesTaskData();
		ctl.getDepartmentPieData();

	}	
}