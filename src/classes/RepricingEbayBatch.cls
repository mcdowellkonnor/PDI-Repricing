/*
	Developed by: Konnor McDowell
	mcdowellkonnor@gmail.com
*/

global class RepricingEbayBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
	
	public static PDI_Repricing__Repricing_Settings__c settings = [SELECT PDI_Repricing__eBay_App_ID__c, PDI_Repricing__eBay_Auth_Token_1__c, 
	PDI_Repricing__eBay_Auth_Token_2__c, PDI_Repricing__eBay_Auth_Token_3__c, PDI_Repricing__eBay_Auth_Token_4__c FROM PDI_Repricing__Repricing_Settings__c];
	public static String user_token = settings.PDI_Repricing__eBay_Auth_Token_1__c + settings.PDI_Repricing__eBay_Auth_Token_2__c + 
	settings.PDI_Repricing__eBay_Auth_Token_3__c + settings.PDI_Repricing__eBay_Auth_Token_4__c;
	public static String app_id = settings.PDI_Repricing__eBay_App_ID__c;
	    
	global Database.QueryLocator start(Database.BatchableContext bc){
		String query = 'SELECT PDI_Repricing__Competitor_A_eBay_ID__c, PDI_Repricing__Competitor_A_eBay_Price__c, PDI_Repricing__Competitor_A_eBay_Shipping__c, '+
		'PDI_Repricing__Competitor_B_eBay_ID__c, PDI_Repricing__Competitor_B_eBay_Price__c, PDI_Repricing__Competitor_B_eBay_Shipping__c, ' +
		'PDI_Repricing__Competitor_C_eBay_ID__c, PDI_Repricing__Competitor_C_eBay_Price__c, PDI_Repricing__Competitor_C_eBay_Shipping__c, ' +
		'PDI_Repricing__Our_eBay_ID_Depot__c, PDI_Repricing__Our_eBay_Price_Depot__c, PDI_Repricing__Our_eBay_Shipping_Depot__c, ' +
		'PDI_Repricing__Our_eBay_ID_Uzooka__c, PDI_Repricing__Our_eBay_Price_Uzooka__c, PDI_Repricing__Linked_Product__c, PDI_Repricing__Our_eBay_Shipping_Uzooka__c FROM ' +
		'PDI_Repricing__Repricing_Info__c' ;
		return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<PDI_Repricing__Repricing_Info__c> scope){
    	List<id> b2c_repricing_ids = new List<id>();
    	for (PDI_Repricing__Repricing_Info__c o : scope){
    		b2c_repricing_ids.add((id)o.PDI_Repricing__Linked_Product__c);
    	}
    	
    	List<ECS__Product__c> b2c_products = [SELECT PDI_Repricing__Linked_Repricing__c, Name, Id FROM ECS__Product__c WHERE id IN: b2c_repricing_ids];
    	
    	for (ECS__Product__c o : b2c_products){
    		for (PDI_Repricing__Repricing_Info__c x : scope){
    			if ((String)x.PDI_Repricing__Linked_Product__c == (String)o.Id){
    				o.PDI_Repricing__Linked_Repricing__c = x.Id;
    			}
    		}
    	}
    	
    	List<String> ids;
    	for (PDI_Repricing__Repricing_Info__c repricing_info : scope){
    		String our_ebay_id_depot = '';
    		if (repricing_info.PDI_Repricing__Our_eBay_ID_Depot__c == null || repricing_info.PDI_Repricing__Our_eBay_ID_Depot__c == ''){
    			our_ebay_id_depot = 'NONE';
    		} else {
    			our_ebay_id_depot = repricing_info.PDI_Repricing__Our_eBay_ID_Depot__c;
    		}
    		
    		String our_ebay_id_uzooka = '';
    		if (repricing_info.PDI_Repricing__Our_eBay_ID_Uzooka__c == null || repricing_info.PDI_Repricing__Our_eBay_ID_Uzooka__c == ''){
    			our_ebay_id_uzooka = 'NONE';
    		} else {
    			our_ebay_id_uzooka = repricing_info.PDI_Repricing__Our_eBay_ID_Uzooka__c;
    		}
    		
    		String comp_a_id = '';
    		if (repricing_info.PDI_Repricing__Competitor_A_eBay_ID__c == null || repricing_info.PDI_Repricing__Competitor_A_eBay_ID__c == ''){
    			comp_a_id = 'NONE'; 
    		} else {
    			comp_a_id = repricing_info.PDI_Repricing__Competitor_A_eBay_ID__c;
    		}
    		
    		String comp_b_id = '';
    		if (repricing_info.PDI_Repricing__Competitor_B_eBay_ID__c == null || repricing_info.PDI_Repricing__Competitor_B_eBay_ID__c == ''){
    			comp_b_id = 'NONE'; 
    		} else {
    			comp_b_id = repricing_info.PDI_Repricing__Competitor_B_eBay_ID__c;
    		}
    		
    		String comp_c_id = '';
    		if (repricing_info.PDI_Repricing__Competitor_C_eBay_ID__c == null || repricing_info.PDI_Repricing__Competitor_C_eBay_ID__c == ''){
    			comp_c_id = 'NONE'; 
    		} else {
    			comp_c_id = repricing_info.PDI_Repricing__Competitor_C_eBay_ID__c;
    		}
    		
    		ids = new List<String>{our_ebay_id_depot, our_ebay_id_uzooka, comp_a_id, comp_b_id, comp_c_id};
    		
    		List<String> response = PDI_Repricing.Repricing.eBayGetItem(ids, user_token, app_id);
    		
    		System.debug('eBay method responded with a list with size: ' + response.size());
    		
    		repricing_info.PDI_Repricing__Our_eBay_Price_Depot__c = PDI_Repricing.Repricing.eBayGetPrice(response[0]);
    		repricing_info.PDI_Repricing__Our_eBay_Price_Uzooka__c = PDI_Repricing.Repricing.eBayGetPrice(response[1]);
    		repricing_info.PDI_Repricing__Competitor_A_eBay_Price__c = PDI_Repricing.Repricing.eBayGetPrice(response[2]);
    		repricing_info.PDI_Repricing__Competitor_B_eBay_Price__c = PDI_Repricing.Repricing.eBayGetPrice(response[3]);
    		repricing_info.PDI_Repricing__Competitor_C_eBay_Price__c = PDI_Repricing.Repricing.eBayGetPrice(response[4]);
    		
    		repricing_info.PDI_Repricing__Our_eBay_Shipping_Depot__c = PDI_Repricing.Repricing.eBayGetShipping(response[0]);
    		repricing_info.PDI_Repricing__Our_eBay_Shipping_Uzooka__c = PDI_Repricing.Repricing.eBayGetShipping(response[1]);
    		repricing_info.PDI_Repricing__Competitor_A_eBay_Shipping__c = PDI_Repricing.Repricing.eBayGetShipping(response[2]);
    		repricing_info.PDI_Repricing__Competitor_B_eBay_Shipping__c = PDI_Repricing.Repricing.eBayGetShipping(response[3]);
    		repricing_info.PDI_Repricing__Competitor_C_eBay_Shipping__c = PDI_Repricing.Repricing.eBayGetShipping(response[4]);
    		
    		if (PDI_Repricing.Repricing.eBayGetRelist(response[0]) != repricing_info.PDI_Repricing__Our_eBay_ID_Depot__c && PDI_Repricing.Repricing.eBayGetRelist(response[0]) != 'NA'){
    			repricing_info.PDI_Repricing__Our_eBay_ID_Depot__c = PDI_Repricing.Repricing.eBayGetRelist(response[0]);
    		}
    		
    		if (PDI_Repricing.Repricing.eBayGetRelist(response[1]) != repricing_info.PDI_Repricing__Our_eBay_ID_Uzooka__c  && PDI_Repricing.Repricing.eBayGetRelist(response[1]) != 'NA'){
    			repricing_info.PDI_Repricing__Our_eBay_ID_Uzooka__c = PDI_Repricing.Repricing.eBayGetRelist(response[1]);
    		}
    		
    		if (PDI_Repricing.Repricing.eBayGetRelist(response[2]) != repricing_info.PDI_Repricing__Competitor_A_eBay_ID__c && PDI_Repricing.Repricing.eBayGetRelist(response[2]) != 'NA'){
    			repricing_info.PDI_Repricing__Competitor_A_eBay_ID__c = PDI_Repricing.Repricing.eBayGetRelist(response[2]);
    		}
    		
    		if (PDI_Repricing.Repricing.eBayGetRelist(response[3]) != repricing_info.PDI_Repricing__Competitor_B_eBay_ID__c && PDI_Repricing.Repricing.eBayGetRelist(response[3]) != 'NA'){
    			repricing_info.PDI_Repricing__Competitor_B_eBay_ID__c = PDI_Repricing.Repricing.eBayGetRelist(response[3]);
    		}
    		
    		if (PDI_Repricing.Repricing.eBayGetRelist(response[4]) != repricing_info.PDI_Repricing__Competitor_C_eBay_ID__c && PDI_Repricing.Repricing.eBayGetRelist(response[4]) != 'NA'){
    			repricing_info.PDI_Repricing__Competitor_C_eBay_ID__c = PDI_Repricing.Repricing.eBayGetRelist(response[4]);
    		}
    	}
    	
    	update scope;
    	
    	try {
    	update b2c_products;
    	} catch (System.DmlException e){
    		System.debug(e);
    	}
    }
    
    global void finish(Database.BatchableContext BC){
    }
}