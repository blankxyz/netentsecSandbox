/*
*RogerSun
*982578975@qq.com
*1、业务机会所有人变更后销售自动添加销售部门  cbl_OpportunityChangeOwner
*2、跨区报备的客户、订单、业务机会共享给客户所在区域办事处主任
*/
trigger OpportunityChangeOwner on Opportunity (after insert,after update) 
{
    cbl_OpportunityChangeOwner OpportunityChangeOwner=new cbl_OpportunityChangeOwner();
    if(trigger.isAfter)
    {
        if(trigger.isInsert)
        {
            OpportunityChangeOwner.cbl_OpportunityChangeOwner_ShareInfor(trigger.new);
        }
        else if(trigger.isUpdate)
        {
            OpportunityChangeOwner.cbl_OpportunityChangeOwner_UpdateShareInfor(trigger.new,trigger.oldMap);
            
        }
    }

}