/**
 * ---------------------------------------------------
 *  功能描述：
 *          Apex 审批过程
 *  创建日期：2015/03/25
 *  创建人：Dandy
 *  修改日期：
 *  修改人：
 * ---------------------------------------------------
 */

public with sharing class ApexApprovalUtil {
    public ApexApprovalUtil() {
        
    }

    /**
     *  提交一个审批
     */
    public static void submitForApproval(Sobject opp, List<Id> nextApprover){
        // Create an approval request for the Opportunity
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval automatically ');
        req1.setObjectId(opp.id);
        if(nextApprover != null && nextApprover.size()>0){
            req1.setNextApproverIds(nextApprover);
        }

        // Submit the approval request for the Opportunity
        Approval.ProcessResult result = Approval.process(req1);

    }   

    /*
    * 批准一个
    */
    public static void approveRecord(Sobject opp ,List<Id> nextApprover){
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments('Approving request automatically');
        req.setAction('Approve');
        if(nextApprover != null && nextApprover.size()>0){
            req.setNextApproverIds(nextApprover);
        }
        Id workItemId = getWorkItemId(opp.id); 

        if(workItemId == null)
        {
            opp.addError('Error Occured in Trigger');
        }
        else
        {
            req.setWorkitemId(workItemId);
            // Submit the request for approval
            Approval.ProcessResult result =  Approval.process(req);
        }
    }

    /**
     * 拒绝一个申请
     */
    public static void rejectRecord(Sobject opp)
    {
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments('Rejected request automatically');
        req.setAction('Reject');
        //req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        Id workItemId = getWorkItemId(opp.id); 

        if(workItemId == null)
        {
            opp.addError('Error Occured in Trigger');
        }
        else
        {
            req.setWorkitemId(workItemId);
            // Submit the request for approval
            Approval.ProcessResult result =  Approval.process(req);
        }
    }
    static Id getWorkItemId(Id targetObjectId)
    {
        Id retVal = null;

        for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p
            where p.ProcessInstance.TargetObjectId =: targetObjectId])
        {
            retVal  =  workItem.Id;
        }

        return retVal;
    }

    public static void submitForApproval(Sobject opp){
        ApexApprovalUtil.submitForApproval(opp, null);
    }    
    public static void approveRecord(Sobject opp){
        ApexApprovalUtil.approveRecord(opp, null);
    }

}