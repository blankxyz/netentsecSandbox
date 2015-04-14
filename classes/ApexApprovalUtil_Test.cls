@isTest(SeeAllData = true)
private class ApexApprovalUtil_Test
{
	@isTest
	static void itShould()
	{
		// Given
		Project_Task__c acc = [select id from Project_Task__c limit 1];

		// When
		ApexApprovalUtil.submitForApproval(acc);
		ApexApprovalUtil.approveRecord(acc);
		ApexApprovalUtil.submitForApproval(acc);
		ApexApprovalUtil.rejectRecord(acc);
		// Then

	}
}