/*
	Developed by: Konnor McDowell
	mcdowellkonnor@gmail.com
*/

@isTest(seeAllData=true)
public with sharing class RepricingTest {
	
	public static PDI_Repricing__Repricing_Settings__c settings = [SELECT PDI_Repricing__Competitor_A_eBay_Store__c, PDI_Repricing__Competitor_A_Label__c,
     PDI_Repricing__Competitor_B_eBay_Store__c, PDI_Repricing__Competitor_B_Label__c, PDI_Repricing__Cost_Field__c, PDI_Repricing__eBay_App_ID__c,
     PDI_Repricing__Uzooka_Store_Label__c, PDI_Repricing__Partslink_Field__c, PDI_Repricing__Uzooka_Price_Master_Field__c, PDI_Repricing__Website_Price_Field__c,
     PDI_Repricing__Inbound_Freight_Field__c, PDI_Repricing__Depot_Price_Master_Field__c, PDI_Repricing__HeadlightsDepot_Store_Label__c, 
     PDI_Repricing__F_Fee_Field__c, PDI_Repricing__I_Freight_Field__c, PDI_Repricing__O_Ship_Field__c, PDI_Repricing__P_Cost_Field__c, PDI_Repricing__Direct_Cost_Field__c
     FROM PDI_Repricing__Repricing_Settings__c LIMIT 1];
	
    testMethod static void eBayItem(){
    	List<String> item_ids = new List<String>{'19299292'};
    	String user_token = null;
    	String app_id = '9999999';
    	
    	Test.startTest();
    	PDI_Repricing.Repricing.eBayGetItem(item_ids, user_token, app_id);
    	
    	user_token = '<Test>ThisisATest</Test>';
    	
    	PDI_Repricing.Repricing.eBayGetItem(item_ids, user_token, app_id);
    	
    	user_token = '';
    	item_ids = new List<String>{'NONE'};
    	
    	PDI_Repricing.Repricing.eBayGetItem(item_ids, user_token, app_id);
    	
    	Test.stopTest();
    }

    testMethod static void eBayExtraction(){
    	String raw = '<ShippingServiceCostcurrencyID="USD">1299</ShippingServiceCost>';
    	
    	Test.startTest();
    	PDI_Repricing.Repricing.eBayGetShipping(raw);
    	
    	raw = '<CurrentPricecurrencyID="USD">1999</CurrentPrice>';
    	
    	PDI_Repricing.Repricing.eBayGetPrice(raw);
    	
    	raw = '<RelistedItemID>19999</RelistItemID>';
    	
    	PDI_Repricing.Repricing.eBayGetRelist(raw);
    	
    	raw = '<ShippingServiceCostcurrencyID="USD">';
    	
    	PDI_Repricing.Repricing.eBayGetShipping(raw);
    	
    	raw = '<CurrentPricecurrencyID="USD">';
    	
    	PDI_Repricing.Repricing.eBayGetPrice(raw);
    	
    	raw = '<RelistedItemID>';
    	
    	PDI_Repricing.Repricing.eBayGetRelist(raw);
    	Test.stopTest();
    }
    
    testMethod static void AmazonItem(){
    	String secret_key = 'Test';
    	String associate_id = 'Test';
    	String access_key_id = 'Test';
    	String market_id = 'Test';
    	
    	Test.startTest();
    	List<String> item_ids = new List<String>{'NONE'};
    	
    	PDI_Repricing.Repricing.AmazonGetItemInformation(item_ids, secret_key, associate_id, access_key_id, market_id);
    	
    	item_ids = new List<String>{'1231231'};

    	PDI_Repricing.Repricing.AmazonGetItemInformation(item_ids, secret_key, associate_id, access_key_id, market_id);
    	
    	secret_key = '>SignatureDoesNotMatch<';
    	
    	PDI_Repricing.Repricing.AmazonGetItemInformation(item_ids, secret_key, associate_id, access_key_id, market_id);
    	
    	associate_id = '>SignatureDoesNotMatch<';
    	
    	PDI_Repricing.Repricing.AmazonGetItemInformation(item_ids, secret_key, associate_id, access_key_id, market_id);
    	
    	Test.stopTest();
    }
    
    testMethod static void AmazonGetPrice(){
    	String raw_response = '<ListingPrice><TEST><TEST><TEST><TEST><TEST><TEST><TEST><TEST></ListingPrice>';
    	
    	Test.startTest();
    	PDI_Repricing.Repricing.AmazonGetPrice(raw_response);
    	
    	raw_response = '<ListingPrice></ListingPrice>';
    	
    	PDI_Repricing.Repricing.AmazonGetPrice(raw_response);
    	
    	raw_response = '<Shipping><TEST><TEST><TEST><TEST><TEST><TEST><TEST><TEST></Shipping>';
    	
    	PDI_Repricing.Repricing.AmazonGetShipping(raw_response);
    	
    	raw_response = '<Shipping></Shipping>';
    	
    	PDI_Repricing.Repricing.AmazonGetShipping(raw_response);
    	Test.stopTest();
    }
    
    testMethod static void testPage(){
    	sObject b2c_product = [SELECT Id FROM ECS__Product__c LIMIT 1];
    	String id_b2c = (String)b2c_product.get('Id');
    	
    	
    	PageReference pageref = Page.Repricing;
    	Test.setCurrentPage(pageref);
    	ApexPages.currentPage().getParameters().put('a1',id_b2c);
    	
    	String linked_product_cost = 'PDI_Repricing__Linked_Product__r.' + (String)settings.get('PDI_Repricing__Cost_Field__c');
		String linked_inbound_freight = 'PDI_Repricing__Linked_Product__r.' + (String)settings.get('PDI_Repricing__Inbound_Freight_Field__c');
		String linked_partslink = 'PDI_Repricing__Linked_Product__r.' + (String)settings.get('PDI_Repricing__Partslink_Field__c');
		String linked_uzooka_price = 'PDI_Repricing__Linked_Product__r.' + (String)settings.get('PDI_Repricing__Uzooka_Price_Master_Field__c');
		String linked_website_price = 'PDI_Repricing__Linked_Product__r.' + (String)settings.get('PDI_Repricing__Website_Price_Field__c');
		
		String p_cost = 'PDI_Repricing__Linked_Product__r.' + (String)settings.get('PDI_Repricing__P_Cost_Field__c');
		String i_freight = 'PDI_Repricing__Linked_Product__r.' + (String)settings.get('PDI_Repricing__I_Freight_Field__c');
		String o_ship = 'PDI_Repricing__Linked_Product__r.' + (String)settings.get('PDI_Repricing__O_Ship_Field__c');
		String f_fee = 'PDI_Repricing__Linked_Product__r.' + (String)settings.get('PDI_Repricing__F_Fee_Field__c');
		String direct_cost = 'PDI_Repricing__Linked_Product__r.' + (String)settings.get('PDI_Repricing__Direct_Cost_Field__c');
		
		String to_select = linked_product_cost + ', ' + linked_inbound_freight + ', ' + linked_partslink + ', ' + linked_uzooka_price +
		', ' + linked_website_price +  ', ' + p_cost + ', ' + i_freight + ', ' + o_ship + ', ' + f_fee + ', ' + direct_cost +
		', PDI_Repricing__Linked_Product__r.Name, PDI_Repricing__Competitor_C_eBay_Raw_Price__c, PDI_Repricing__Competitor_A_eBay_ID__c, PDI_Repricing__Competitor_B_eBay_ID__c, ' + 
		'PDI_Repricing__Competitor_C_eBay_ID__c, PDI_Repricing__Our_eBay_Raw_Price_Depot__c, PDI_Repricing__Competitor_A_eBay_Price__c, PDI_Repricing__Competitor_A_eBay_Raw_Price__c, ' + 
		'PDI_Repricing__Competitor_B_eBay_Price__c, PDI_Repricing__Competitor_C_eBay_Price__c, PDI_Repricing__Competitor_B_eBay_Raw_Price__c, ' + 
		'PDI_Repricing__Competitor_A_eBay_Shipping__c, PDI_Repricing__Competitor_B_eBay_Shipping__c, PDI_Repricing__Competitor_C_eBay_Shipping__c, ' +
		'PDI_Repricing__Our_eBay_Price_Depot__c, PDI_Repricing__Our_eBay_Price_Uzooka__c, PDI_Repricing__Linked_Product__c, PDI_Repricing__Competitor_A_Amazon_ID__c, ' +
		'PDI_Repricing__Competitor_B_Amazon_ID__c, PDI_Repricing__Competitor_C_Amazon_ID__c, PDI_Repricing__Competitor_A_Amazon_Price__c, ' +
		'PDI_Repricing__Competitor_B_Amazon_Price__c, PDI_Repricing__Competitor_C_Amazon_Price__c, PDI_Repricing__Our_Amazon_Price__c, '+
		'PDI_Repricing__Our_Amazon_Shipping__c, PDI_Repricing__Competitor_A_Amazon_Shipping__c, PDI_Repricing__Competitor_B_Amazon_Shipping__c, ' +
		'PDI_Repricing__Competitor_C_Amazon_Shipping__c, PDI_Repricing__Our_Amazon_ID__c, PDI_Repricing__Our_eBay_ID_Depot__c,' + 
		' PDI_Repricing__Our_eBay_ID_Uzooka__c, PDI_Repricing__Our_eBay_Shipping_Depot__c, PDI_Repricing__Our_eBay_Shipping_Uzooka__c, PDI_Repricing__Our_eBay_Raw_Price_Uzooka__c, ' +
		'PDI_Repricing__As_Amazon_Raw_Price__c, PDI_Repricing__Bs_Amazon_Raw_Price__c, PDI_Repricing__Cs_Amazon_Raw_Price__c, PDI_Repricing__Our_Amazon_Raw_Price__c';
		String query = 'SELECT ' + to_select + ' FROM PDI_Repricing__Repricing_Info__c  LIMIT 2';
	
		List<PDI_Repricing__Repricing_Info__c> repricing_objects = Database.query(query);
    	
    	RepricingController controller = new RepricingController();
    	Test.startTest();
    	controller.repricing_objects = repricing_objects;
    	controller.getUrlValue();
    	controller.makeRepricing();
    	controller.runBatch();
    	controller.downloadCSV();
    	controller.updateAll();
    	RepricingController.wrap wrap = new RepricingController.wrap();
    	controller.do_export();
    	controller.runSchedule();
    	controller.getbatchRunningCheck();
    	
    	Test.stopTest();
    }
    
    testMethod static void testBatchA(){
    	Test.startTest();
    	id batch2 = Database.executeBatch(new PDI_Repricing.RepricingAmazonBatch());
    	Test.stopTest();
    }
    
    testMethod static void testBatchB(){
    	Test.startTest();
    	id batch = Database.executeBatch(new PDI_Repricing.RepricingEbayBatch());
    	Test.stopTest();
    }
    
    testMethod static void testScheduleable(){
    	Test.startTest();
    	id batch = Database.executeBatch(new PDI_Repricing.RepricingScheduleable());
    	Test.stopTest();
    }
}