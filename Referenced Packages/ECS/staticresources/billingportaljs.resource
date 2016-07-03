		// Needed to prevent conflicts with Visualforce javascript
		$j = jQuery.noConflict();
		
		// Pull the Salesforce instance out of the page URL
		var instance_patt = /na[0-9]{1,2}/;
		var sf_instance = instance_patt.exec(window.location);
		
		$j(document).ready(function () {
			// Buy button handlers
			$j('#buy-light').click(function (e) { switchScreen('Configure Order'); $j('#light-order-line input').val('2'); refreshOrderTotals(); });
			$j('#buy-professional').click(function (e) { switchScreen('Configure Order'); $j('#professional-order-line input').val('2'); refreshOrderTotals(); });
			$j('#buy-enterprise').click(function (e) { switchScreen('Configure Order'); $j('#enterprise-order-line input').val('2'); refreshOrderTotals(); });
			
			// Credit card number field
			$j('#cc-number-input input').on('keyup', function (e) {
				var fieldVal = $j(this).val();
				if (fieldVal.charAt(fieldVal.length-1) == '-') fieldVal = fieldVal.slice(0, fieldVal.length-1);
				if (!/^\d*$/.test(fieldVal)) fieldVal = fieldVal.replace(/[^0-9-]/g, '');
				// Delete key
				if (e.keyCode != 8)
					if (fieldVal.length == 4 || fieldVal.length == 9 ||	
						fieldVal.length == 14) fieldVal = fieldVal + '-';
				$j(this).val(fieldVal);
			});

			// Checkout flow buttons
			$j('#order-extras-button a').click( function (e) { 
				if (!validateCcInfo()) return false;
				switchScreen('Configure Extras');
			});
			$j('#confirm-order-button a').click( function (e) { 
				switchScreen('Confirm Order');
			});
			
			// Edit order buttons
			$j('.edit-order-button').click(function (e) { switchScreen('Configure Order'); });
			
			// Order calculation listeners
			$j('#order-table').delegate('input', 'keyup', function(e) {
				// Only allow digits
				if (!/^\d*$/.test($j(this).val())) $j(this).val($j(this).val().replace(/\D/g, ''));
				refreshOrderTotals();
			});
			
			$j('#agree-tos').on('change', function (e) {
				if ($j(this).prop('checked')) {
					$j('#submit-order-button').show();
					$j('#fake-submit-order-button').hide();
					$j('#tos-links').css('background-color', '#FFF');
				}
				else {
					$j('#submit-order-button').hide();
					$j('#fake-submit-order-button').show();
				}
			});
			
			$j('#fake-submit-order-button').click(function (e) {
				$j('#tos-links').css('background-color', '#FBB');
			});
			
			$j('#submit-order-button').click(function (e) {
				$j('#submit-order-button input').addClass('disabled');
			});
		});
		
		// Switch screens in checkout modal
		function switchScreen(screenName) {
			if (screenName == 'Configure Order') {
				$j('#order-extras').hide(); 
				$j('#confirm-order').hide();
				$j('#confirm-order-button').hide();
				$j('#fake-submit-order-button').hide();
				$j('#submit-order-button').hide();
				$j('#configure-order').show();
				$j('#order-extras-button').show();
			}
			if (screenName == 'Configure Extras') {
				$j('#configure-order').hide(); 
				$j('#confirm-order').hide();
				$j('#order-extras-button').hide();
				$j('#fake-submit-order-button').hide();
				$j('#submit-order-button').hide();
				$j('#order-extras').show();
				$j('#confirm-order-button').show();
			}
			if (screenName == 'Confirm Order') {
				$j('#configure-order').hide(); 
				$j('#order-extras').hide();
				$j('#order-extras-button').hide();
				$j('#confirm-order-button').hide();
				$j('#confirm-order').show();
				refreshOrderConfirmation();
			}
		}
		
		// Validate credit card fields
		function validateCcInfo() {
			var valid = true;
			if (!validateField($j('#cc-name-input input'), function (val) {
				if (val == '') return false;
				return true;
			})) valid = false;
			if (!validateField($j('#cc-number-input input'), function (val) {
				if (val == '') return false;
				if (val.replace(/[^0-9]/g, '').length != 16) return false;
				return true;
			})) valid = false;
			if (!validateField($j('#cc-cvc-input input'), function (val) {
				if (val == '') return false;
				if (val.replace(/[^0-9]/g, '').length != 3 && val.replace(/[^0-9]/g, '').length != 4) return false;
				return true;
			})) valid = false;
			return valid;
		}
		
		// Helper for validating a field
		function validateField(field, func) {
			var errorColor = '#FBB';
			var validColor = '#FFF';
			if (func($j(field).val())) {
				$j(field).css('background-color', validColor);
				return true;
			}
			else {
				$j(field).css('background-color', errorColor);
				return false;
			}
		}
		
		// Calculate order total 
		function refreshOrderTotals() {
			var lightPrice = $j('#light-order-line input').val() * 30;
			var professionalPrice = $j('#professional-order-line input').val() * 70;
			var enterprisePrice = $j('#enterprise-order-line input').val() * 99;
			$j('#light-order-total').html('$' + lightPrice);
			$j('#professional-order-total').html('$' + professionalPrice);
			$j('#enterprise-order-total').html('$' + enterprisePrice);
			$j('#grand-total').html('$' + (lightPrice + professionalPrice + enterprisePrice));		
		}
		
		// Copy order details to confirmation page
		function refreshOrderConfirmation() {
			$j('#light-license-quantity').html($j('#light-order-line input').val());
			$j('#professional-license-quantity').html($j('#professional-order-line input').val());
			$j('#enterprise-license-quantity').html($j('#enterprise-order-line input').val());
			
			var lightTotal = dollars($j('#light-order-total').html());
			var professionalTotal = dollars($j('#professional-order-total').html());
			var enterpriseTotal = dollars($j('#enterprise-order-total').html());
			var recurringTotal = lightTotal + professionalTotal + enterpriseTotal;
			var servicesTotal = 0;
			
			if ($j('#annual-subscription-check input').prop("checked")) {
				lightTotal *= 12;
				professionalTotal *= 12;
				enterpriseTotal *= 12;
				recurringTotal = (lightTotal + professionalTotal + enterpriseTotal) * 0.9;
			}
			
			$j('#light-license-total').html('$' + lightTotal.toFixed(2));
			$j('#professional-license-total').html('$' + professionalTotal.toFixed(2));
			$j('#enterprise-license-total').html('$' + enterpriseTotal.toFixed(2));
			
			if ($j('#gold-quickstart-check input').prop("checked")) {
				servicesTotal = 1000;
				$j('#quickstart-type').html('Gold');
				$j('#quickstart-price').html('$1000');
				$j('#quickstart-total').html('$1000.00');
				$j('#quick-start-input input').val('Gold');
			}
			else if ($j('#silver-quickstart-check input').prop("checked")) {
				servicesTotal = 500;
				$j('#quickstart-type').html('Silver');
				$j('#quickstart-price').html('$500');
				$j('#quickstart-total').html('$500.00');
				$j('#quick-start-input input').val('Silver');
			}
			else {
				$j('#quickstart-type').html('None');
				$j('#quickstart-price').html('$0');
				$j('#quickstart-total').html('$0.00');
				$j('#quick-start-input input').val('');
			}
			
			if ($j('#annual-subscription-check input').prop("checked")) {
				$j('#annual-subscription-discount').html('-$' + ((lightTotal + professionalTotal + enterpriseTotal) * 0.1).toFixed(2));
				$j('#subscription-length-input input').val('Year');
			}
			else {
				$j('#annual-subscription-discount').html('$0.00');
				$j('#subscription-length-input input').val('Month');
			}
			
			$j('#recurring-total-input input').val(recurringTotal);
			$j('#initial-total-input input').val(servicesTotal);
			
			$j('#order-line-total').html('$' + (lightTotal + professionalTotal + enterpriseTotal + 
					dollars($j('#quickstart-total').html()) - 
					dollars($j('#annual-subscription-discount').html())).toFixed(2));
					
			$j('#cc-name').html('Name: ' + $j('#cc-name-input input').val());
			$j('#cc-number').html('Number: &times;&times;&times;&times;-&times;&times;&times;&times;-&times;&times;&times;&times;-' + 
					$j('#cc-number-input input').val().replace(/[^0-9]/g, '').slice(12));
			$j('#cc-expr').html('Expiration: ' + $j('#cc-month-input option:selected').val() + '-' + $j('#cc-year-input option:selected').val());
			
			// Show fake/real submit button based on TOS
			if($j('#agree-tos').prop("checked")) {
				$j('#submit-order-button').show();
				$j('#fake-submit-order-button').hide();
			}
			else {
				$j('#submit-order-button').hide();
				$j('#fake-submit-order-button').show();
			}
		}
		
		function finishOrderSubmit() {
			$j('#submit-order-button input').removeClass('disabled');
			$j('#payment-details input[type=text]').val('');
			$j('#submit-order').modal('hide');
		}
		
		function dollars(dollarStr) {
			if (dollarStr == '') return 0;
			return parseFloat(dollarStr.replace('$', '').replace(',', '').replace('-', ''));
		}
		
		
		
		
		
		