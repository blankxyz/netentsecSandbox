/**
 *  Object: Project_Task__c
 *  Description: for Project_Task__c functional
 */
public class TaskWapper {

	//所有task
	private Set<Id> taskIds = new Set<Id>();
	private List<Project_Task__c> tasks = new List<Project_Task__c>();
	private Set<Id> milestoneIds = new Set<Id>();

	//已完成task
	private Set<Id> finishedTaskIds = new Set<Id>();



	//预处理过程
	public TaskWapper( List<Project_Task__c> ps) {
		//预处理
		for(Project_Task__c p : ps){
			
			taskIds.add(p.Id);
			this.tasks.add(p);
			milestoneIds.add(p.Project_Milestone__c);

			if(p.TaskStatus__c == '已完成'){
				finishedTaskIds.add(p.Id);
			}
		}
	}

	/**
	 *  项目阶段内的项目自动赋值
	 */
	public void AutoPopField(){
		
		if(milestoneIds.size()<1){
			return;
		}

		Map<id, Milestone__c> infos = new Map<Id,Milestone__c>(
		[select Id, Project__c, Project__r.Opportunity__r.AccountId, Project__r.Project_Manager__c from Milestone__c where id in :milestoneIds]);

		for(Project_Task__c t : tasks){
			if(infos.containsKey(t.Project_Milestone__c)){
				Milestone__c curM = infos.get(t.Project_Milestone__c);
				t.Employee__c = curM.Project__r.Project_Manager__c;
				t.Project__c = curM.Project__c;
				t.Customer__c = curM.Project__r.Opportunity__r.AccountId;
			}
		}
		
	}

	/**
	 * 任务的owner不是项目负责人时，将此条记录共享给项目负责人
	 */
	public void shareTaskToProjectManager(){

        List<Project_Task__Share> pTaskShareList = new List<Project_Task__Share>();


        for(Project_Task__c t : 
        	[select Id , OwnerId,project__r.Project_Manager__r.n_EmployeeName__c
        	 from Project_Task__c
        	 where id in :taskIds]){
        	if(t.OwnerId != t.project__r.Project_Manager__r.n_EmployeeName__c){
				pTaskShareList.add(
					new Project_Task__Share(ParentId = t.Id,
	                                        UserOrGroupId = t.project__r.Project_Manager__r.n_EmployeeName__c, 
	                                        AccessLevel =  'Edit'));
        	}
        }

        system.debug('======任务的owner不是项目负责人时，将此条记录共享给项目负责人=======');
        system.debug('======共享记录内容======'+pTaskShareList);
        if(pTaskShareList.size()>0){
        	Database.insert(pTaskShareList,false);
        }
	}

	/**
	 *  当工单状态为完成时，发送邮件给工单的技术支持和申请人，请他们对工单完成进行满意度评价。
	 */
	/**
	public void evalutionMailNotification(){
		
		Messaging.SingleEmailMessage initMail = null;
		List<Messaging.SingleEmailMessage> sendMails = new List<Messaging.SingleEmailMessage>();
		String sfBaseUrl = System.Url.getSalesforceBaseUrl().toExternalForm();

		for(Project_Task__c t : [Select Id, 
			                            Name, 
			                            Assigned_To__r.Name, 
			                            Assigned_To__r.Employee_Email__c,
			                            Employee__r.Name,
			                            Employee__r.Employee_Email__c
			                     From Project_Task__c
			                     Where Id in :finishedTaskIds]){

			if (t.Assigned_To__r.Employee_Email__c != null){
			    initMail = new Messaging.Singleemailmessage();
			    initMail.setSubject('任务/工单完成 满意度评价提醒');
			    initMail.setToAddresses(new String[]{t.Assigned_To__r.Employee_Email__c});
			    initMail.setSaveAsActivity(false);
			    initMail.setPlainTextBody(t.Assigned_To__r.Name + '您好：'+'\n'+
			    	                      '项目名称:'+t.Name + '已完成。'+'\n'+
			    	                      '请您对' + t.Employee__r.Name + '在本次任务中得表现进行评价。'+'\n'+
			    	                      '详细信息请看'+'\n'+ sfBaseUrl +'/'+t.id);
			    sendMails.add(initMail);
			}

			if (t.Employee__r.Employee_Email__c != null){
			    initMail = new Messaging.Singleemailmessage();
			    initMail.setSubject('任务/工单完成 满意度评价提醒');
			    initMail.setToAddresses(new String[]{t.Employee__r.Employee_Email__c});
			    initMail.setSaveAsActivity(false);
			    initMail.setPlainTextBody(t.Employee__r.Name + '您好：'+'\n'+
			    	                      '项目名称:'+t.Name + '已完成。'+'\n'+
			    	                      '请您对' + t.Assigned_To__r.Name + '在本次任务中得表现进行评价。'+'\n'+
			    	                      '详细信息请看'+'\n'+ sfBaseUrl +'/'+t.id);
			    sendMails.add(initMail);
			}
		}

		if(sendMails.size()>0) Messaging.sendEmail(sendMails);

	}
	*/
}