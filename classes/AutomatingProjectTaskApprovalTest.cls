@isTest(SeeAllData=true)
private class AutomatingProjectTaskApprovalTest
{
    @isTest
    static void itShould()
    {
        // Given
        // CRON expression: midnight on March 15.
        // Because this is a test, job executes
        // immediately after Test.stopTest().
        String CRON_EXP = '0 0 * * * ? *';
        Test.startTest();
        Project_Task__c t = [select id from Project_Task__c limit 1];

        ApexApprovalUtil.submitForApproval(t);
        // Schedule the test job
        String jobId = System.schedule('AutomatingProjectTaskApprovalTest',
                        CRON_EXP, 
                        new AutomatingProjectTaskApproval());
         
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, 
         ct.CronExpression);

        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);

        // Verify the next time the job will run
        //System.assertEquals('2022-03-15 00:00:00', 
        //String.valueOf(ct.NextFireTime));
        // Verify the scheduled job hasn't run yet.
        Test.stopTest();

        // Now that the scheduled job has executed after Test.stopTest(),
    }

}