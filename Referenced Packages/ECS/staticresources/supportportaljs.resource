		// Needed to prevent conflicts with Visualforce javascript
		$j = jQuery.noConflict();
		
		// Cases data initialization
		var cases;
		var currentCaseNumber
		var currentCaseSubmitButton;
		var currentCaseEmailFilter;
		var currentCaseStatusFilter;
		
		$j(document).ready(function () {
			// Parse case data
			currentCaseEmailFilter = '*';
			currentCaseStatusFilter = '*';
			refreshCases();
			
			$j('#filter-all-tickets').click(function() { filterTicketsOwner('*'); });
			$j('#filter-my-tickets').click(function() { filterTicketsOwner(currentUser); });
			$j('#filter-open-tickets').click(function() { filterTicketsStatus('open'); });
			
			// Click listeners for case list
			$j('#case-list-wrapper').on('click', 'tr', function(event) {
				currentCaseNumber = $j(this).data('case');
				currentCaseSubmitButton = $j(this).find('td.submit-comment-button').get(0);
				refreshMessageThread();
			});
		});
		
		function submitTicket(e) {
			$j('#submit-ticket-button input').addClass('disabled');
		}
		
		function finishTicketSubmit() {
			$j('#submit-ticket input[type=text], #submit-ticket textarea').val('');
			$j('#submit-ticket select').val($j(this).find('option:first').val());
			$j('#submit-ticket-button input').removeClass('disabled');
			refreshCases();
			$j('#submit-ticket').modal('toggle');
		}
		
		function submitComment() {
			$j(currentCaseSubmitButton).find('input.btn').click(); 
			$j('#message-response-submit').addClass('disabled');
		}
		
		function finishCommentSubmit() {
			$j('#message-thread textarea').val('');
			$j('#message-response-submit').removeClass('disabled');
			refreshCases();
		}
		
		// Prettify date
		function prettifyDate() {
			var d = parseDate(this.CreatedDate);
			return d.getMonth() + '/' + d.getDate() + '/' + d.getFullYear() + ' ' + 
				d.getHours() + ':' + d.getMinutes();
		}
		
		function parseDate(dateString) {
			var reg = /(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})\.\d{3}\+\d{4}/;
			var s = reg.exec(dateString);
			return new Date(parseInt(s[1], 10), parseInt(s[2], 10), parseInt(s[3], 10), parseInt(s[4], 10), parseInt(s[5], 10), 0, 0);
		}
		
		function refreshCompletionPercentage() {
			// Progress
			var setupCompletion = parseInt($j('#completion-percentage').html(), 10);
			$j('#progressbar').progressbar({value: setupCompletion});
			$j('#setup-status').html('Setup of Salesforce for Magento is ' + setupCompletion + '% complete.');
		}
		
		function refreshMessageThread() {
			if (typeof currentCaseNumber === undefined || currentCaseNumber == null) return null;
			var curCase = _.find(cases, function(e) { return e.CaseNumber == currentCaseNumber; });
			$j('#message-thread-header').html('Case #' + curCase.CaseNumber);
			var messageTemplate = $j('#message-thread-template').html();
			$j('#message-thread-container').html(Mustache.render(messageTemplate, curCase));
		}
		
		// Refresh case data
		function refreshCases() {
			cases = JSON.parse($j('#cases-json').html());
			_.each(cases, function (e) {
				_.each(e.OpenActivities.records, function (a) { a.prettifyDate = prettifyDate; });
				e.escalated = (e.Status == 'Escalated');
			});
			$j('.close-case-button input').click(function (e) { e.stopPropagation(); });
			$j('.submit-comment-button').click(function (e) { e.stopPropagation(); });
			filterTicketsOwner(currentCaseEmailFilter);
			filterTicketsStatus(currentCaseStatusFilter);
			refreshMessageThread();
		}
		
		// Filter tickets by email
		function filterTicketsOwner(email) {
			currentCaseEmailFilter = email;
			if (email == '*') $j('#case-list tr').css('display', 'table-row');
			else {
				_.each($j('#case-list tbody tr'), function (e) {
					var caseNum = $j(e).data('case');
					var activities = _.find(cases, function (c) { return caseNum == c.CaseNumber; }).OpenActivities.records;
					if (_.any(activities, function (a) { return a.Author_Email == currentUser; })) $j(e).css('display', 'table-row');
					else $j(e).css('display', 'none');
				});
			}
		}
		
		// Filter tickets by status
		function filterTicketsStatus(status) {
			currentCaseStatusFilter = status;
			if (status == '*') $j('#case-list tr').css('display', 'table-row');
			else {
				_.each($j('#case-list tbody tr'), function (e) {
					var caseNum = $j(e).data('case');
					var curCase = _.find(cases, function (c) { return caseNum == c.CaseNumber; });
					if (status == 'open' && curCase.Status != 'Closed') $j(e).css('display', 'table-row');
					else if (status == 'closed' && curCase.Status == 'Closed') $j(e).css('display', 'table-row');
					else $j(e).css('display', 'none');
				});
			}
		}
		