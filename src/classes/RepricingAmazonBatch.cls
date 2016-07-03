/*
	Developed by: Konnor McDowell
	mcdowellkonnor@gmail.com
*/

global class RepricingAmazonBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
	
	public static PDI_Repricing__Repricing_Settings__c settings = [SELECT PDI_Repricing__Amazon_Access_Key_ID__c, PDI_Repricing__Amazon_Associate_ID__c, 
	 PDI_Repricing__Amazon_Secret_Key__c, PDI_Repricing__Amazon_Marketplace_ID__c, PDI_Repricing__Amazon_Seller_Key__c FROM PDI_Repricing__Repricing_Settings__c];
	    
	global Database.QueryLocator start(Database.BatchableContext bc){
		String query = 'SELECT PDI_Repricing__Competitor_A_Amazon_ID__c, PDI_Repricing__Competitor_A_Amazon_Price__c, PDI_Repricing__Competitor_B_Amazon_ID__c, ' +
		'PDI_Repricing__Competitor_B_Amazon_Price__c, PDI_Repricing__Linked_Product__c, PDI_Repricing__Competitor_C_Amazon_ID__c, PDI_Repricing__Competitor_C_Amazon_Price__c, PDI_Repricing__Our_Amazon_Price__c, ' + 
		'PDI_Repricing__Our_Amazon_ID__c, PDI_Repricing__Competitor_A_Amazon_Shipping__c, PDI_Repricing__Competitor_B_Amazon_Shipping__c, PDI_Repricing__Competitor_C_Amazon_Shipping__c, ' +
		'PDI_Repricing__Our_Amazon_Shipping__c  FROM  PDI_Repricing__Repricing_Info__c';
		return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
    	List<id> b2c_repricing_ids = new List<id>();
    	for (sObject o : scope){
    		b2c_repricing_ids.add((id)o.get('PDI_Repricing__Linked_Product__c'));
    	}
    	
    	List<ECS__Product__c> b2c_products = [SELECT PDI_Repricing__Linked_Repricing__c, Name, Id FROM ECS__Product__c WHERE id IN: b2c_repricing_ids];
    	
    	for (ECS__Product__c o : b2c_products){
    		for (sObject x : scope){
    			if ((String)x.get('PDI_Repricing__Linked_Product__c') == (String)o.Id){
    				o.PDI_Repricing__Linked_Repricing__c = (id)x.get('Id');
    			}
    		}
    	}
    	
    	List<String> ids;
    	for (sObject o : scope){
    		String a_id;
    		if (o.get('PDI_Repricing__Competitor_A_Amazon_ID__c')  == null || o.get('PDI_Repricing__Competitor_A_Amazon_ID__c') == 'NA'){
    			a_id = 'NONE';
    		} else {
    			a_id = (String)o.get('PDI_Repricing__Competitor_A_Amazon_ID__c');
    		}
    		
    		String b_id;
    		if (o.get('PDI_Repricing__Competitor_B_Amazon_ID__c') == null || o.get('PDI_Repricing__Competitor_B_Amazon_ID__c') == 'NA'){
    			b_id = 'NONE';
    		} else {
    			b_id = (String)o.get('PDI_Repricing__Competitor_B_Amazon_ID__c');
    		}
    		
    		String c_id;
    		if (o.get('PDI_Repricing__Competitor_C_Amazon_ID__c') == null || o.get('PDI_Repricing__Competitor_C_Amazon_ID__c') == 'NA'){
    			c_id = 'NONE';
    		} else {
    			c_id = (String)o.get('PDI_Repricing__Competitor_C_Amazon_ID__c');
    		}
    		
    		String our_id;
    		if(o.get('PDI_Repricing__Our_Amazon_ID__c') == null || o.get('PDI_Repricing__Our_Amazon_ID__c') == 'NA'){
    			our_id = 'NONE';
    		} else {
    			our_id = (String)o.get('PDI_Repricing__Our_Amazon_ID__c');
    		}
    		
    		ids = new List<String>{a_id, b_id, c_id, our_id};
    		
    		System.debug('======== Sending and getting information for the following repricing ID: ' + o.Id + ' ========');
    		List<String> response = PDI_Repricing.Repricing.AmazonGetItemInformation(ids, (String)settings.PDI_Repricing__Amazon_Secret_Key__c, (String)settings.PDI_Repricing__Amazon_Seller_Key__c, (String)settings.PDI_Repricing__Amazon_Access_Key_ID__c, (String)settings.PDI_Repricing__Amazon_Marketplace_ID__c);
    	
    		System.debug('Sent to amazon: ' + ids);
    	
    		String a_price = PDI_Repricing.Repricing.AmazonGetPrice(response[0]);
    		String b_price = PDI_Repricing.Repricing.AmazonGetPrice(response[1]);
    		String c_price = PDI_Repricing.Repricing.AmazonGetPrice(response[2]);
    		String our_price = PDI_Repricing.Repricing.AmazonGetPrice(response[3]);
    		
    		String a_shipping = PDI_Repricing.Repricing.AmazonGetShipping(response[0]);
    		String b_shipping = PDI_Repricing.Repricing.AmazonGetShipping(response[1]);
    		String c_shipping = PDI_Repricing.Repricing.AmazonGetShipping(response[2]);
    		String our_shipping = PDI_Repricing.Repricing.AmazonGetShipping(response[3]);
    		
    		System.debug('Extracted amazon information: ' + a_price + ' ' + b_price + ' ' + c_price + ' ' + our_price);
    		System.debug('Extracted amazon information: ' + a_shipping + ' ' + b_shipping + ' ' + c_shipping + ' ' + our_shipping);
    		
    		if (a_price == null){
    			o.put('PDI_Repricing__Competitor_A_Amazon_Price__c', 'NA');
    		} else {
    			o.put('PDI_Repricing__Competitor_A_Amazon_Price__c', a_price);
    		}
    		
    		if (b_price == null){
    			o.put('PDI_Repricing__Competitor_B_Amazon_Price__c', 'NA');
    		} else {
    			o.put('PDI_Repricing__Competitor_B_Amazon_Price__c', b_price);
    		}
    		
    		if (c_price == null){
    			o.put('PDI_Repricing__Competitor_C_Amazon_Price__c', 'NA');
    		} else {
    			o.put('PDI_Repricing__Competitor_C_Amazon_Price__c', c_price);
    		}
    		
    		if (our_price == null){
    			o.put('PDI_Repricing__Our_Amazon_Price__c', 'NA');
    		} else {
    			o.put('PDI_Repricing__Our_Amazon_Price__c', our_price);
    		}
    		
    		if (a_shipping == null){
    			o.put('PDI_Repricing__Competitor_A_Amazon_Shipping__c', 'NA');
    		} else {
    			o.put('PDI_Repricing__Competitor_A_Amazon_Shipping__c', a_shipping);
    		}
    		
    		if (b_shipping == null){
    			o.put('PDI_Repricing__Competitor_B_Amazon_Shipping__c', 'NA');
    		} else {
    			o.put('PDI_Repricing__Competitor_B_Amazon_Shipping__c', b_shipping);
    		}
    		
    		if (c_shipping == null){
    			o.put('PDI_Repricing__Competitor_C_Amazon_Shipping__c', 'NA');
    		} else {
    			o.put('PDI_Repricing__Competitor_C_Amazon_Shipping__c', c_shipping);
    		}
    		
    		if (our_shipping == null){
    			o.put('PDI_Repricing__Our_Amazon_Shipping__c', 'NA');
    		} else {
    			o.put('PDI_Repricing__Our_Amazon_Shipping__c', our_shipping);
    		}
    	}
    	
    	update scope;
    	
    	try{
    		update b2c_products;
    	} catch (System.DmlException e){
    		System.debug(e);
    	}
    }
    
    global void finish(Database.BatchableContext BC){
    }
}