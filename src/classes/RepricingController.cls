/*
	Developed by: Konnor McDowell
	mcdowellkonnor@gmail.com
*/

public class RepricingController { 

   	public List<PDI_Repricing__Repricing_Info__c> repricing_objects {get;set;}
   	public List<ECS__Product__c> missing_repricing {get;set;}
   	public String missing_repricing_header {get;set;}
   	public Boolean show_reschedule {get;set;}
   	public id batch {get;set;}
   	public id batch2 {get;set;}
   	public String batch_status {get;set;}
   	public Boolean batch_is_completed {get;set;}
   	public Boolean made_repricing {get;set;}
   	public Boolean need_to_make_repricing {get;set;}
   	public Boolean running_batch {get;set;}
   	public String url_parameters {get;set;}

    public static PDI_Repricing__Repricing_Settings__c settings = [SELECT PDI_Repricing__Competitor_A_eBay_Store__c, PDI_Repricing__Competitor_A_Label__c,
     PDI_Repricing__Competitor_B_eBay_Store__c, PDI_Repricing__Competitor_B_Label__c, PDI_Repricing__Cost_Field__c, PDI_Repricing__eBay_App_ID__c,
     PDI_Repricing__Uzooka_Store_Label__c, PDI_Repricing__Partslink_Field__c, PDI_Repricing__Uzooka_Price_Master_Field__c, PDI_Repricing__Website_Price_Field__c,
     PDI_Repricing__Inbound_Freight_Field__c, PDI_Repricing__Depot_Price_Master_Field__c, PDI_Repricing__HeadlightsDepot_Store_Label__c, 
     PDI_Repricing__F_Fee_Field__c, PDI_Repricing__I_Freight_Field__c, PDI_Repricing__O_Ship_Field__c, PDI_Repricing__P_Cost_Field__c, PDI_Repricing__Direct_Cost_Field__c
     FROM PDI_Repricing__Repricing_Settings__c LIMIT 1];
     
    public RepricingController(){
    	this.repricing_objects = get_repricing_info();
    	this.missing_repricing = get_missing_repricing();
    	if (missing_repricing.size() > 0){
    		this.missing_repricing_header = 'The following b2c products were selected, but do not have repricing information:';
    	}
    	Filetype = '';
        wrapr = new List<wrap>();
        header = 'Product ID, Direct Cost, P Cost, I Freight, O Ship, F Fee, Min Sale Price, Amazon, AZ Price Change, Uzooka, Uzooka Price Change, Depot,'+
        ' Depot Price Change, Website, Website Price Change, ' + (String)settings.get('PDI_Repricing__Competitor_A_Label__c') + '\'s eBay Price, ' + (String)settings.get('PDI_Repricing__Competitor_B_Label__c') + 
        '\'s eBay Price, Lowest eBay Price, ' + (String)settings.get('PDI_Repricing__Competitor_A_Label__c')+ '\'s Amazon Price, '+
        (String)settings.get('PDI_Repricing__Competitor_B_Label__c') + '\'s Amazon Price, Lowest Amazon Price\r\n';
        
        this.show_reschedule = true;
        this.batch_is_completed = false;
        this.made_repricing = false;
        this.running_batch = false;
    }
    
    public List<id> url_ids {
    	get {
    		List<id> ids = new List<id>();
		
			String[] vals = new String[]{'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};
			Integer cycle = 1;
			Integer iteration = 0;
		
			while (true){
				try {
					Id id_to_add = (id)ApexPages.currentPage().getParameters().get((vals[iteration] + cycle));
					url_parameters += vals[iteration] + cycle + '=' + id_to_add;
					if (vals[iteration].equals('z')){
						cycle++;
					}
					iteration++;
					if (iteration == 26){
						iteration = 0;
					}
				
					if (id_to_add != null){
						ids.add(id_to_add);
					} else {
						break;
					}
				} catch (System.ListException e){
					break;
				}
			}
			
			System.debug('The ID list is currently: ' + ids);
			// Add the child products if the product is a mother
			Integer q = 0;
			List<ECS__Associated_Product__c> associated_child_products = [SELECT Id, Name, ECS__Master_SKU__c, ECS__Simple_Product__c FROM ECS__Associated_Product__c WHERE ECS__Master_SKU__c IN: ids OR ECS__Simple_Product__c IN: ids];
			List<id> associated_ids = new List<id>();
			for (ECS__Associated_Product__c o : associated_child_products){
				if (!((String)o.Name).contains('service')){
					associated_ids.add(o.ECS__Master_SKU__c);
				associated_ids.add(o.ECS__Simple_Product__c);
				}
			}
			
			List<ECS__Associated_Product__c> associated_products = [SELECT Id, Name, ECS__Master_SKU__c, ECS__Simple_Product__c FROM ECS__Associated_Product__c WHERE ECS__Master_SKU__c IN: associated_ids OR ECS__Simple_Product__c IN: associated_ids];
			
			System.debug('Linked products to pull: ' + associated_products);
			for (ECS__Associated_Product__c o : associated_products){
				boolean already_contains_product = false;
				for (id x : ids){
					if (x == o.ECS__Simple_Product__c){
						System.debug(x + ' is equal to ' + o.ECS__Simple_Product__c + ', so we are not adding it.');
						already_contains_product = true;
					}
				}
				if (!already_contains_product){
					System.debug('Adding the id: ' + o.ECS__Simple_Product__c);
					ids.add(o.ECS__Simple_Product__c);
					ids.add(o.ECS__Master_SKU__c);
				}
			}
			q++;
			
		
			System.debug('The ID list is now: ' + ids);
			
			// Remove repetitive products
			Boolean repeat = true;
			while (repeat){
				repeat = false;
				for (Integer i = 0; i < ids.size(); i++){
					for (Integer y = 0; y < ids.size(); y++){
						if (ids[y] == ids[i] && y != i){
							repeat = true;
							ids.remove(i);
						}
					}
				}
			}
			
			return ids;
    	}
    	set;
    }
	
	public List<PDI_Repricing__Repricing_Info__c> get_repricing_info (){
		System.debug('url_ids are : ' + url_ids);
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
			String query = 'SELECT ' + to_select + ' FROM PDI_Repricing__Repricing_Info__c WHERE PDI_Repricing__Linked_Product__c IN: url_ids';
			List<PDI_Repricing__Repricing_Info__c> objects = Database.query(query);
			System.debug('list of repricing info: ' + objects);
			
			for (Integer i = 0; i < objects.size(); i++){
				for (Integer y = 0; y < objects.size(); y++){
					if (objects[y].PDI_Repricing__Linked_Product__r.Name == objects[i].PDI_Repricing__Linked_Product__r.Name && y != i){
						objects.remove(y);
					}
				}
			}
			return objects;
	}
	
	public List<ECS__Product__c> get_missing_repricing(){
		List<id> b2c_from_repricing = new List<id>();
		for (PDI_Repricing__Repricing_Info__c o : repricing_objects){
			b2c_from_repricing.add((id)o.PDI_Repricing__Linked_Product__c);
		}
		
		List<ECS__Product__c> all_products = [SELECT PDI_Repricing__Linked_Repricing__c, Name FROM ECS__Product__c WHERE id IN: url_ids AND id NOT IN: b2c_from_repricing];
		List<ECS__Product__c> missing_repricing_info = new List<ECS__Product__c>();
		for (ECS__Product__c o : all_products){
			if (o.PDI_Repricing__Linked_Repricing__c == null){
				missing_repricing_info.add(o);
			}
		}
		
		return missing_repricing_info;
	}
	
	public PageReference updateAll() {
		System.debug('UPDATING: ');
		for (PDI_Repricing__Repricing_Info__c o : repricing_objects){
			System.debug(o.Our_Amazon_ID__c);
		}
		update this.repricing_objects;
		return null;
	}
	
	public PageReference downloadCSV(){
		return null;
	}
	
	public void runBatch(){
		System.debug('Running batch...');
		this.running_batch = true; 
		if(!Test.isRunningTest()){
			this.batch = Database.executeBatch(new PDI_Repricing.RepricingEbayBatch(), 100);
			this.batch2 = Database.executeBatch(new PDI_Repricing.RepricingAmazonBatch(), 100);
		}
	}
	
	public string Filetype {get;set;}
    public string header{get;set;}	
    public List<wrap> wrapr {get;set;}
    
    public class wrap{
        public string ProductID {get;set;}
        public string DirectCost{get;set;}
        public String PCost {get;set;}
        public String IFreight{get;set;}
        public String OShip{get;set;}
        public String FFee {get;set;}
        public String MinSalePrice{get;set;}
        public String AmazonPrice{get;set;}
        public String AZPriceChange{get;set;}
        public String UzookaPrice{get;set;}
        public String UzookaPriceChange{get;set;}
        public String DepotPrice{get;set;}
        public String DepotPriceChange{get;set;}
        public String WebsitePrice{get;set;}
        public String WebsitePriceChange{get;set;}
        public String CompAeBayPrice{get;set;}
        public String CompBeBayPrice{get;set;}
        public String CompCeBayPrice{get;set;}
        public String CompAAZPrice{get;set;}
        public String CompBAZPrice{get;set;}
        public String CompCAZPrice{get;set;}
    }
    
    public void do_export(){
        for (PDI_Repricing__Repricing_Info__c o : repricing_objects){
        	
        	String p_cost;
        	if ((String)o.PDI_Repricing__Linked_Product__r.get((String)settings.get('PDI_Repricing__P_Cost_Field__c')) == null || (String)o.PDI_Repricing__Linked_Product__r.get((String)settings.get('PDI_Repricing__P_Cost_Field__c')) == ''){
        		p_cost = '$0.00';
        	} else {
        		p_cost = (String)o.PDI_Repricing__Linked_Product__r.get((String)settings.get('PDI_Repricing__P_Cost_Field__c'));
        	}
        	
        	String i_freight;
        	if ((String)o.PDI_Repricing__Linked_Product__r.get((String)settings.get('PDI_Repricing__I_Freight_Field__c')) == null || (String)o.PDI_Repricing__Linked_Product__r.get((String)settings.get('PDI_Repricing__I_Freight_Field__c')) == ''){
        		i_freight = '$0.00';
        	} else {
        		i_freight = (String)o.PDI_Repricing__Linked_Product__r.get((String)settings.get('PDI_Repricing__I_Freight_Field__c'));
        	}
        	
        	String o_ship;
        	if ((String)o.PDI_Repricing__Linked_Product__r.get((String)settings.get('PDI_Repricing__O_Ship_Field__c')) == null || (String)o.PDI_Repricing__Linked_Product__r.get((String)settings.get('PDI_Repricing__O_Ship_Field__c')) == ''){
        		o_ship = '$0.00';
        	} else {
        		o_ship = (String)o.PDI_Repricing__Linked_Product__r.get((String)settings.get('PDI_Repricing__O_Ship_Field__c'));
        	}
        	
        	String f_fee;
        	if ((String)o.PDI_Repricing__Linked_Product__r.get((String)settings.get('PDI_Repricing__F_Fee_Field__c')) == null || (String)o.PDI_Repricing__Linked_Product__r.get((String)settings.get('PDI_Repricing__F_Fee_Field__c')) == ''){
        		f_fee = '$0.00';
        	} else {
        		f_fee = (String)o.PDI_Repricing__Linked_Product__r.get((String)settings.get('PDI_Repricing__F_Fee_Field__c'));
        	}
        	
        	String website_price;
        	if ((String)o.PDI_Repricing__Linked_Product__r.get((String)settings.get('PDI_Repricing__Website_Price_Field__c')) == null || (String)o.PDI_Repricing__Linked_Product__r.get((String)settings.get('PDI_Repricing__Website_Price_Field__c')) == ''){
        		website_price = 'NA';
        	} else {
        		website_price = (String)o.PDI_Repricing__Linked_Product__r.get((String)settings.get('PDI_Repricing__Website_Price_Field__c'));
        	}
        	
        	String direct_cost;
        	if ((String)o.PDI_Repricing__Linked_Product__r.get((String)settings.get('PDI_Repricing__Direct_Cost_Field__c')) == null || (String)o.PDI_Repricing__Linked_Product__r.get((String)settings.get('PDI_Repricing__Direct_Cost_Field__c')) == ''){
        		direct_cost = '$0.00';
        	} else {
        		direct_cost = (String)o.PDI_Repricing__Linked_Product__r.get((String)settings.get('PDI_Repricing__Direct_Cost_Field__c'));
        	}
        	
            wrap w = new wrap();
            
			w.ProductID = o.PDI_Repricing__Linked_Product__r.Name;
			w.DirectCost = direct_cost ;
			w.PCost = p_cost;
			w.IFreight = i_freight;
			w.OShip = o_ship;
			w.FFee = f_fee;
			w.MinSalePrice = '';
			w.AmazonPrice = o.PDI_Repricing__Our_Amazon_Price__c;
			w.AZPriceChange = '';
			w.UzookaPrice = o.PDI_Repricing__Our_eBay_Price_Uzooka__c; //repricing.PDI_Repricing__Linked_Product__r[$Setup.PDI_Repricing__Repricing_Settings__c.PDI_Repricing__Uzooka_Price_Master_Field__c];
			w.DepotPrice = o.PDI_Repricing__Our_eBay_Price_Depot__c;
			w.DepotPriceChange =  '';
			w.WebsitePrice = website_price; // repricing.PDI_Repricing__Linked_Product__r[$Setup.PDI_Repricing__Repricing_Settings__c.PDI_Repricing__Website_Price_Field__c];
			w.WebsitePriceChange = '';
			w.CompAeBayPrice = o.PDI_Repricing__Competitor_A_eBay_Raw_Price__c;
			w.CompBeBayPrice = o.PDI_Repricing__Competitor_B_eBay_Raw_Price__c;
			w.CompCeBayPrice = o.PDI_Repricing__Competitor_C_eBay_Raw_Price__c;
			w.CompAAZPrice = o.PDI_Repricing__Competitor_A_Amazon_Price__c;
			w.CompBAZPrice = o.PDI_Repricing__Competitor_B_Amazon_Price__c;
			w.CompCAZPrice = o.PDI_Repricing__Competitor_C_Amazon_Price__c;

            wrapr.add(w);
        }
    }
    
    public String getUrlValue(){
        String url = ApexPages.currentPage().getUrl();
        url = url.substring(30);
        return url;
    }
    
    public PageReference makeRepricing(){ 
    	System.debug('Running make Repricing command');
    	List<PDI_Repricing__Repricing_Info__c> new_repricings = new List<PDI_Repricing__Repricing_Info__c>();
    	try {   	
    		System.debug('Missing repricing info: ' + missing_repricing);
    	for (ECS__Product__c o : missing_repricing){
    		PDI_Repricing__Repricing_Info__c new_repricing = new PDI_Repricing__Repricing_Info__c(Name = (String)o.Id, PDI_Repricing__Linked_Product__c = o.Id, PDI_Repricing__External_ID__c = (String)o.Name);
    		new_repricings.add(new_repricing);
    		System.debug('Made a new repricing info: ' + new_repricing);
    	}
    	
    	try {
    		insert new_repricings;
    	} catch (System.DmlException e){
    		System.debug(e);
    	}
    	
    	for (Integer i = 0; i < new_repricings.size(); i++){
    		missing_repricing[i].PDI_Repricing__Linked_Repricing__c = new_repricings[i].id;
    	}
    	
    	missing_repricing_header = 'Please reopen this page.';
    	
    	try {
    	update missing_repricing;
    	} catch (System.DmlException e){
    		System.debug(e);
    	}
    	System.debug('Updated ' + missing_repricing);
    	
    	missing_repricing = get_missing_repricing();
    	} catch (Exception e){
    		System.debug('Error: ' + e);
    	}
    	made_repricing = true;
    	return null;
    }
    
    public PageReference runSchedule(){
    	try {
    		System.abortJob('Repricing Lookup');
    	} catch (Exception e){}
    	id batch = Database.executeBatch(new PDI_Repricing.RepricingScheduleable());
    	this.show_reschedule = false;
    	return null;
    }
    
    public boolean getbatchRunningCheck(){
    	
    	// Future Konnor: Works if you're idle, works if you click the button, but then stops working
    	if (batch2 != null){
	    	AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
		        	TotalJobItems, CreatedBy.Email, ExtendedStatus
		        	from AsyncApexJob where Id =: batch2];
		    this.batch_status = (String)a.Status;
		    if (batch_status == 'Completed'){
		    	batch_is_completed = true;
		    }
    	}
    	return true;
    	/*if (batch2 != null && batch_status != 'Completed'){
	    	AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
	        	TotalJobItems, CreatedBy.Email, ExtendedStatus
	        	from AsyncApexJob where Id =: batch2]; 
	       	if (a.Status == 'Completed'){
	       		this.batch_status = (String)a.Status;
	       		return ;
	       	} else {
	       		this.batch_status = (String)a.Status;
	       		return true;
	       	}
    	} else {
    		return true;
    	}*/
    }
}