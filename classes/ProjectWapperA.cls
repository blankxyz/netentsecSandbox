/**
 *  Type：  Functionality
 *  Object：Project_c
 *  Description:
 */
public class ProjectWapperA {
    public ProjectWapperA() {
        
    }

    /**
     *项目完成评价流程
     *1. 创建一个task,并将该task assagin to sales。
     *2. 向assagined sales 发送一封邮件，要求处理评价task。
     */
    public static void createProjectEvaProcess(Set<Id> evaIds){
        List<Task> evaTasks = new List<Task>();
        List<Messaging.Singleemailmessage> emails = new List<Messaging.Singleemailmessage>();
        Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('项目评价任务').getRecordTypeId();

        for(project__c o : 
                [select Id,Name, Opportunity__r.Owner.Name, Opportunity__r.Owner.Email, Opportunity__r.OwnerId 
                 From project__c 
                 where opportunity__c != null
                 and Id in: evaIds]
        ){
            //创建task，类型为ProjectEvaluationT
            Task evaTask = new task(
                WhatId = o.id,
                Subject = '项目评价任务',
                Priority= '高',
                Status = '未开始',
                Description = '',
                RecordTypeId = recTypeId,
                OwnerId = o.Opportunity__r.OwnerId,
                ActivityDate = Date.today()
            );

            evaTasks.add(evaTask);

        }

        Database.insert (evaTasks,false);

    }

    /**
     *  共享给销售流程
     */
    public static void shareToSalesProcess(Set<Id> pIds){
        List<Project__Share> sharePs = new List<Project__Share>();
        for(project__c o : 
                [select Id, Name, Opportunity__r.OwnerId 
                 From project__c 
                 where opportunity__c != null
                 and Id in: pIds]
        ){
            Project__Share p = new Project__Share(
                ParentId = o.Id,
                UserOrGroupId = o.Opportunity__r.OwnerId,
                AccessLevel = 'Read',
                RowCause = Schema.Project__Share.RowCause.SRTOSALES__c
            );

            sharePs.add(p);
        }

        Database.insert(sharePs,false);

    }
}