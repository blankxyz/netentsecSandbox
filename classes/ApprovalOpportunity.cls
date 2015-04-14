/*
跨区报备的业务机会三天后自动审批通过

rogerSun 
982578975@qq.com
*/
global class  ApprovalOpportunity implements Database.Batchable<SObject>, Database.AllowsCallouts
{
     //自定义异常对象  
     public class MyException extends Exception {}
     global Database.queryLocator start(Database.BatchableContext ctx)
     {
           return Database.getQueryLocator([Select o.Status__c, o.OppProperty__c,o.InterregionalApproval__c, o.ApprovalDate__c,o.Id From Opportunity o where o.OppProperty__c='跨区报备'  and o.InterregionalApproval__c=true and o.Status__c='报备审批中']); 
     }
     global void execute(Database.BatchableContext ctx, List<Opportunity> scope)
     {
        system.debug('scope is infor:'+scope);
        
        set<string> setOpportunity=new set<string>();
        for(Opportunity opp:scope)
        {
            system.debug('opp.ApprovalDate__c is infor:'+opp.ApprovalDate__c);
                    system.debug('opp.ApprovalDate__c.addDays(3) is infor:'+opp.ApprovalDate__c.addDays(3));
                    system.debug('datetime.now()'+Datetime.now());
                    system.debug('datetime.valueOfGmt'+datetime.valueOfGmt(string.valueOf(datetime.now())));
                    system.debug('datetime.valueOfGmt(opp.ApprovalDate__c)'+Datetime.valueOfGmt(string.valueOf(opp.ApprovalDate__c)).addDays(3));
                    
                if(Datetime.valueOfGmt(string.valueOf(opp.ApprovalDate__c)).addDays(3)<=datetime.valueOfGmt(string.valueOf(datetime.now())))
                {
                    setOpportunity.add(opp.id);
                }
                
            //DateTime DatetImen=datetime.now().addDays(3);
            
        }
        if(setOpportunity!=null && setOpportunity.size()>0)
        {
            list<ProcessInstanceWorkitem> listProcessInstanceWorkitem=new list<ProcessInstanceWorkitem>([Select p.ProcessInstance.Status, p.ProcessInstance.TargetObjectId, p.ProcessInstance.Id, p.ProcessInstanceId, p.OriginalActorId, p.Id, p.ActorId From ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId in:setOpportunity]);
            system.debug('listProcessInstanceWorkitem is infor:'+listProcessInstanceWorkitem);
            
            List<Approval.ProcessWorkitemRequest>  list_request=new List<Approval.ProcessWorkitemRequest>();
            //获取到待审批记录对应的ProcessWorkItem
            for(ProcessInstanceWorkitem p: listProcessInstanceWorkitem)
            {
                //实例化ProcessWorkitemRequest 
                 Approval.ProcessWorkitemRequest req2 =new  Approval.ProcessWorkitemRequest();
                //指定审批操作行为（批准，拒绝，重新分配）
                req2.setAction('Approve');
                  req2.setComments('按照规定，跨区报备3天后，系统自动审批通过。');
                //制定审批记录对应的processworkitem的ID，必须指定
                
                req2.setWorkitemId(p.id);
                list_request.add(req2);
            }
            //进行审批
            Approval.ProcessResult[]  result2 = Approval.process(list_request);
        }
        
        
     }
     global void finish(Database.BatchableContext ctx)
     {
                
      }
}