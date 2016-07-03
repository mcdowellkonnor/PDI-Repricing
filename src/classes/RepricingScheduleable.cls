/*
	Developed by: Konnor McDowell
	mcdowellkonnor@gmail.com
*/

global class RepricingScheduleable implements Database.Batchable<sObject>, Database.AllowsCallouts{
	
	global Boolean continueRunning = True;
    global String sched = '0 00 00 * * ?';
	
    global Database.QueryLocator start(Database.BatchableContext bc){
    	String query = 'select PDI_Repricing__Continue_Running__c from PDI_Repricing__Repricing_Settings__c';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        for(sObject o : scope){
            system.debug((Boolean)o.get('PDI_Repricing__Continue_Running__c'));
            if ((Boolean)o.get('PDI_Repricing__Continue_Running__c') == True){
                continueRunning = True;
                system.debug('Continue running is ' + continueRunning);
            } else {
                continueRunning = False;
                system.debug('Continue running is ' + continueRunning);
            }
        } 
        update scope;     
    }

    global void finish(Database.BatchableContext BC){
        if( continueRunning == True ) {
            PDI_Repricing.RepricingEbayBatch e = new PDI_Repricing.RepricingEbayBatch();
            PDI_Repricing.RepricingAmazonBatch a = new PDI_Repricing.RepricingAmazonBatch();
            if (!Test.isRunningTest()){
            Database.executeBatch(e,1);
            Database.executeBatch(a,1);
            }
        }
        scheduleBatch();
    }
    
    public static void scheduleBatch() {
        sObject UpdatePeriodObject = Database.query('select PDI_Repricing__Update_Period__c from PDI_Repricing__Repricing_Settings__c');
        Decimal UpdatePeriodDecimal = (Decimal)UpdatePeriodObject.get('PDI_Repricing__Update_Period__c');
        Integer UpdatePeriodInteger = Integer.valueOf(UpdatePeriodDecimal);
       	PDI_Repricing.RepricingScheduleable sc = new PDI_Repricing.RepricingScheduleable();
        if(Test.isRunningTest()){
            system.debug('Normally would execute batch again');
        } else {
        	system.scheduleBatch(sc, 'Repricing Lookup', UpdatePeriodInteger);
        }
    }
}