trigger Project_TeamMember_Trigger on Project_TeamMember__c (before insert, before update, before delete, after insert) {

    if(trigger.isBefore && trigger.isInsert) {
        Project_TeamMember_Trigger_Utility.shareToUserInsert(trigger.new);
    }
    
    
    if(trigger.isBefore && trigger.isDelete) {
        Project_TeamMember_Trigger_Utility.shareToUserDelete(trigger.old);
    }
}