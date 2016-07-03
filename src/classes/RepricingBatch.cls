/*
	Developed by: Konnor McDowell
	mcdowellkonnor@gmail.com
	konnorm@pdiautoparts.com
*/

global class RepricingBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
    
	global Database.QueryLocator start(Database.BatchableContext bc){
		String query = 'SELECT ID FROM ECS__Product__c';
		return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sOBject> scope){
    	
    }
    
    global void finish(Database.BatchableContext BC){
    }
}