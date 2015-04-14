/**
*Dis:在修改潜在客户所有人时添加一个task,转给谁就给谁提醒
*Time:2014年3月14日14:25:32
*Author:Gary_Hu
**/
trigger Trg_Lead_AutoInfo on Lead (before update) {
	 List<Task> taskList = new List<Task>();
	if(trigger.isUpdate){
		for(Lead l :trigger.new){
			if(trigger.oldMap.get(l.id).OwnerId != l.OwnerId){
				Task task = new Task();
				task.OwnerId = l.OwnerId;//所有人
				task.WhoId = l.id;
				task.Subject =l.Company+'所有人转移提醒';//主题
   			 	task.Status = '未开始';// 状态
				task.Priority = '普通';// 优先级别
				task.IsReminderSet = true; //是否提醒（提醒）
				task.ReminderDateTime = DateTime.now().addMinutes(1);	
				taskList.add(task);				
			}
		}
		 //添加任务
	   	insert(taskList);	
	}
}