@isTest(SeeAllData=true)
private class TaskWapperTest {
    @isTest
    static void itShould()
    {
        
       Project_Task__c tid = [select id,Project_Milestone__c from Project_Task__c limit 1];
       id mid = [select id from Milestone__c limit 1].id;
       
       tid.Project_Milestone__c = mid;
       update tid;
    }
}