$(document).ready(function() {
	
	// Check for hash value in URL					   
	var hash = window.location.hash.substr(1);
	var href = $('li.launch a').each(function(){
		var href = $(this).attr('href');
		if(hash==href.substr(0,href.length-5)){
			var toLoad = hash+'.html #support-center';
			$('#support-center').load(toLoad)
		}											
	});

	$('li.launch a').click(function(){
								  
		var toLoad = $(this).attr('href')+' #support-center';
		$('.kb-content').hide('fast',loadContent);
		$('#load').remove();
		$('.kb-head').append('<div id="load">LOADING...</div>');
		$('#load').fadeIn('normal');
		window.location.hash = $(this).attr('href').substr(0,$(this).attr('href').length-5);
		function loadContent() {
			$('.kb-content').load(toLoad,'',showNewContent())
		}
		function showNewContent() {
			$('.kb-content').show('normal',hideLoader());
		}
		function hideLoader() {
			$('#load').fadeOut('normal');
		}
		return false;
		
	});

});