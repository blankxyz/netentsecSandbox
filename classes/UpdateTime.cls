global class UpdateTime implements Database.Batchable<sObject> {
	
	String query = 'select id from time__c';
	
	global UpdateTime() {
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		Database.update(scope, false);
	}
	
	global void finish(Database.BatchableContext BC) {
		system.debug('更新工作已完成');
		
	}
	
}