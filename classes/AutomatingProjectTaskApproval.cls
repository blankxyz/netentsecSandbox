/**
 * ---------------------------------------------------
 *  功能描述：
 *          工单提交7天自动审批
 *  创建日期：2015/03/25
 *  创建人：Dandy
 *  修改日期：
 *  修改人：
 * ---------------------------------------------------
 */

global class AutomatingProjectTaskApproval implements Schedulable {

	global void execute(SchedulableContext ctx) {

		Set<Id> tids = new Set<Id>();
		for(Project_Task__c t : [select id from Project_Task__c where Task_Stage__c = '审批中']){
			tids.add(t.id);
		}

        system.debug('=========执行日期===[ ' + system.today() +']===========');
        //system.debug('=========探测日期===[ ' + d +' ]===========');
        List<Approval.ProcessWorkitemRequest>  list_request=new List<Approval.ProcessWorkitemRequest>();
        //获取到待审批记录对应的ProcessWorkItem
        for(ProcessInstanceWorkitem p: [Select p.ProcessInstance.Status, 
        	                                   p.ProcessInstance.TargetObjectId, 
        	                                   p.ProcessInstance.Id, 
        	                                   p.ProcessInstanceId, 
        	                                   p.OriginalActorId, 
        	                                   p.Id, 
        	                                   p.ActorId 
        	                            From ProcessInstanceWorkitem p 
        	                            where p.ProcessInstance.TargetObjectId in :tids
        	                            and p.ProcessInstance.CreatedDate >= :system.today().addDays(-8)
                                        and p.ProcessInstance.CreatedDate < :system.today().addDays(-7)
                                        and p.ProcessInstance.Status = 'pending'
        	                         ])
        {
            //实例化ProcessWorkitemRequest 
             Approval.ProcessWorkitemRequest req2 =new  Approval.ProcessWorkitemRequest();
            //指定审批操作行为（批准，拒绝，重新分配）
            req2.setAction('Approve');
            req2.setComments('7天任务自动审批通过。');
            //制定审批记录对应的processworkitem的ID，必须指定
            
            req2.setWorkitemId(p.id);
            list_request.add(req2);
        }
        //进行审批
        Approval.ProcessResult[]  result2 = Approval.process(list_request);	
	}   
}