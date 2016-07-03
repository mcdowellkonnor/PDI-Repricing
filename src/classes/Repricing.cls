/*
	Developed by: Konnor McDowell
	mcdowellkonnor@gmail.com
*/

global with sharing class Repricing {
	
	// One of the main methods necessary to perform many of the other methods in this class
	WebService static List<String> eBayGetItem(List<String> item_ids, String user_token, String app_id){
		
		List<String> response = new List<String>();
		System.debug('eBayGetItem method got the following information: ' + item_ids);
				
		for (String o : item_ids){
			if (!o.equals('NONE')){
			String xml_soap = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:ebay:apis:eBLBaseComponents">'+
                    '<soapenv:Header><urn:RequesterCredentials><urn:eBayAuthToken>'+user_token+'</urn:eBayAuthToken>'+
                    '</urn:RequesterCredentials></soapenv:Header><soapenv:Body><urn:GetItemRequest><urn:DetailLevel>ItemReturnAttributes</urn:DetailLevel>'+
                    '<urn:ErrorLanguage>en_US</urn:ErrorLanguage><urn:Version>809</urn:Version><urn:ItemID>'+o+'</urn:ItemID>'+
                    '</urn:GetItemRequest></soapenv:Body></soapenv:Envelope>';
            
            String endpoint = 'https://api.ebay.com/wsapi?callname=GetItem&ItemID=' + o + '&siteid=3&appid=' + app_id + '&version=909&Routing=default';
            
           	Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('POST');
            req.setHeader('SOAPAction','');
            req.setHeader('Content-Type','application/soap+xml');
            //req.setHeader('X-EBAY-SOA-SERVICE-NAME','');
            req.setHeader('X-EBAY-SOA-OPERATION-NAME','GetItem');
            req.setHeader('X-EBAY-SOA-SECURITY-APPNAME',app_id);
            req.setHeader('X-EBAY-SOA-MESSAGE-PROTOCOL','SOAP12');
            req.setHeader('X-EBAY-SOA-GLOBAL-ID','EBAY-US');
            req.setHeader('X-EBAY-SOA-SERVICE-VERSION','1.0.0');
            req.setBody(xml_soap);
            req.setTimeout(60000);
            
            String resp;
            
            if (Test.isRunningTest()){
            	resp = user_token;
            } else {
            	try {
            		HttpResponse res = h.send(req);
            		resp = res.getBody();
            	} catch(System.CalloutException e){
           		}
            }
                                    	
            if (resp != null){
            	resp = resp.replace(' ', '');
            	resp = resp.replace('>', '> ');
            	resp = resp.replace('<', ' <');
            	response.add(resp);
            } else {
            	response.add('ERROR');
            }
			} else {
				response.add('NONE');
			}
		}
		
		return response;
	}
	
	// Parses an unchanged response [an unparsed / unedited response from the method above] and returns the parsed shipping cost
	public static String eBayGetShipping(String unchanged_response){
		String[] to_parse = unchanged_response.split(' ');
		String shipping_cost = 'NA';
		for (Integer i = 0; i < to_parse.size(); i++){ 
			try {
				if (to_parse[i].equals('<ShippingServiceCostcurrencyID="USD">')){
					shipping_cost = to_parse[i+1];
				}
			} catch (System.ListException e){
				shipping_cost = 'LIST EX ERROR';
			}
		}
		
		return shipping_cost;
	}
	
	// Parses an unchanged response and returns the parsed current price
	public static String eBayGetPrice(String unchanged_response){
		String[] to_parse = unchanged_response.split(' ');
		String price = 'NA';
		for (Integer i = 0; i < to_parse.size(); i++){
			try {
				if (to_parse[i].equals('<CurrentPricecurrencyID="USD">')){
					price = to_parse[i+1];
					System.debug('Found Price: ' + price);
					break;
                }
			} catch (System.ListException e){
				price = 'ListException Error';
			}
		}		
		return price;
	}
	
	// Parses an unchanged response and returns the parsed relist id
	public static String eBayGetRelist(String unchanged_response){
		String[] to_parse = unchanged_response.split(' ');
		String relist_id = 'NA';
		for (Integer i = 0; i < to_parse.size(); i++){
			try {
				if (to_parse[i].equals('<RelistedItemID>')){
					relist_id = to_parse[i+1];
				}
			} catch (System.ListException e){
				relist_id = 'ERROR';
			}
		}
		
		if (relist_id == ''){
			relist_id = 'NA';
		}
		
		return relist_id;
	}
	
	// Main method for getting information from amazon
	WebService static List<String> AmazonGetItem(List<String> item_ids, String secret_key, String seller_key, String access_key){
		List<String> response = new List<String>{'THIS METHOD IS DEPRECATED'};
		return response;
	}
	
	WebService static List<String> AmazonGetItemInformation(List<String> item_ids, String secret_key, String seller_key, String access_key, String market_id){
		List<String> response = new List<String>();
		
		System.debug('GOT A LIST OF IDS OF THE SIZE: ' + item_ids.size());
		
		for (String item_id : item_ids){
			if (item_id != 'NONE'){
				String resp = callToAmazon(item_id, market_id, seller_key, access_key, secret_key);
			
            
            Integer tries = 0;
            Boolean sign_error = checkForSignError(resp);
            if (sign_error){
            	while(tries < 2){
            		System.debug('Got a sign error, retrying... ');
            		
					resp = callToAmazon(item_id, market_id, seller_key, access_key, secret_key);

            		sign_error = checkForSignError(resp);
            		if (!sign_error){
            			System.debug('Fixed the sign error.');
            			break;
            		} else {
            			System.debug('The sign error was not resolved (try # ' + tries + ')');
            		}
            		tries++;
            	}
            }
            if (sign_error){
            	System.debug('A sign error existed and was not resolved, sending none as the response.');
            	resp = 'NONE';
            } else if (resp == null || resp == '' ){
            	System.debug('Did not get a response at all for ,' + item_id + ', adding none');
            	response.add('NONE');
            } else {
            	System.debug('ADDING TO RESPONSE: ' + resp);
            	response.add(resp);
            }
		} else {
			response.add('NONE');
		}
		}
		System.debug('SENDING THE BATCH A RESPONSE SIZE OF ' + response.size() + ' For item IDs: ' + item_ids);
		return response;
	}
	
	public static String callToAmazon(String item_id, String market_id, String seller_id, String access_key, String secret_key){
		// Prepare the endpoint for amazon
		String timestamp = datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
		String encoded_Timestamp = EncodingUtil.urlEncode(timestamp, 'UTF-8'); 
		       		
		String asin_tag = 'ASINList.ASIN.1=' + item_id;
		String aws_access_key_tag = 'AWSAccessKeyId=' + access_key;
		String action_tag = 'Action=GetCompetitivePricingForASIN';
		String market_id_tag = 'MarketplaceId=' + market_id;
		String seller_id_tag = 'SellerId=' + seller_id;
		String signature_method_tag = 'SignatureMethod=HmacSHA256';
		String signature_version_tag = 'SignatureVersion=2';
		String timestamp_tag = 'Timestamp=' + encoded_Timestamp;
		String version_tag = 'Version=2011-10-01';
		       		
		String signing_string = 'GET\n' + 'mws.amazonservices.com\n' + '/Products/2011-10-01\n';
		signing_string += asin_tag + '&' + aws_access_key_tag + '&' + action_tag + '&' /*+ mws_auth_token_tag + '&'*/ + 
		market_id_tag + '&' + seller_id_tag + '&' + signature_method_tag + '&' + signature_version_tag + '&' + timestamp_tag + 
		'&' + version_tag;
		       		
		// Sign the signing string and generate the endpoint
		//String signature = getAWSSignature(signing_string, secret_key, 'us-east-1', 'AWSECommerceService');
		String signature = EncodingUtil.urlEncode(EncodingUtil.base64Encode(Crypto.generateMac('HmacSHA256', blob.valueOf(signing_string), blob.valueOf(secret_key))), 'UTF-8');
					
		String endpoint = 'https://mws.amazonservices.com/Products/2011-10-01?' + asin_tag + '&' + aws_access_key_tag + '&' + action_tag + '&' + 
		market_id_tag + '&' + seller_id_tag + '&' + signature_method_tag + '&' + signature_version_tag + '&' + timestamp_tag + 
		'&' + version_tag + '&Signature=' + signature;
					
		// Typical constructor for webservice callouts
		Http h = new Http();
		HttpRequest req = new HttpRequest();
		req.setEndpoint(endpoint);
		req.setMethod('GET');
		                
		String resp = 'ERROR';
		            
		if (Test.isRunningTest()){
			resp = secret_key;
		} else {
			try {
				HttpResponse res = h.send(req);
				resp = res.getBody();
			} catch(System.CalloutException e){
			}
		}
            
		return resp;
	}
	
	// Checks the raw response for the string 'SignatureDoesNotMatch' which indicates a signature error, and returns a boolean based on that
	public static boolean checkForSignError(String raw_response){
		Boolean error = false;
		String response = raw_response.replace(' ', '');
		response = response.replace('>', '> ');
		response = response.replace('<', ' <');
		String[] split_response = response.split(' ');
		
		for (String o : split_response){
			if (o.equals('SignatureDoesNotMatch')){
				System.debug('Sign error exists');
				error = true;
				break;
			}
		}
		
		return error;
	}
	
	public static String AmazonGetPrice(String raw_response){
		String response = raw_response.replace(' ', '');
		response = response.replace('>', '> ');
		response = response.replace('<', ' <');
		String[] split_response = response.split(' ');
		
		String price;
		for (Integer i = 0; i < split_response.size(); i++){
			if (split_response[i].equals('<ListingPrice>')){
				
				try {
					price = split_response[i+7];
				} catch (System.ListException e){
					price = null;
				}
				
				Integer scrape = 1;
				Integer spot = i;
				if (price == null){
					while (spot < split_response.size()){
						try {
							price = split_response[i+scrape];
						} catch (System.ListException e){
							price = 'NA';
						}
						if (price == null){
							scrape++;
							spot++;
						} else {
							break;
						}
					}
				}
				break;
			}
		}
		
		if (price == null){
			System.debug('Could not find price, here is the raw response: ' + raw_response);
		}
		
		return price;
	}
	
	public static String AmazonGetShipping(String raw_response){
		String response = raw_response.replace(' ', '');
		response = response.replace('>', '> ');
		response = response.replace('<', ' <');
		String[] split_response = response.split(' ');
		
		String shipping;
		for (Integer i = 0; i < split_response.size(); i++){
			if (split_response[i].equals('<Shipping>')){
				
				try {
					shipping = split_response[i+7];
				} catch (System.ListException e){
					shipping = null;
				}
				
				Integer scrape = 1;
				Integer spot = i;
				if (shipping == null){
					while (spot < split_response.size()){
						try {
							shipping = split_response[i+scrape];
						} catch (System.ListException e){
							shipping = 'NA';
						}
						if (shipping == null){
							scrape++;
							spot++;
						} else {
							break;
						}
					}
				}
				break;
			}
		}
		
		if (shipping == null){
			System.debug('Could not find shipping, here is the raw response: ' + raw_response);
		}
		
		return shipping;
	}
}