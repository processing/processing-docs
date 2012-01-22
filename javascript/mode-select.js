/*
	Handle switching on/off specific API for modes on index pages.
	fjenett - 2012-01
*/


$(document).ready(function(){
	$('.ref-top').show();
	$('.ref-top a').each(function(i,e){
		var mode = $(e).attr('mode');
		$(e).bind('click',function(evt){
			activateItems($('a.ref-link'));
			disableItems( $('.no-'+mode) );
			activateItems( $('.'+mode+'-only').show() );
			$('#ref-mode-switch a.is-selected').removeClass('is-selected');
			$(this).addClass('is-selected');
		},false);
	});
	var showMode = "java";
	if ( document.location.href.indexOf('mode=') >= 0 )
		showMode = document.location.href.replace(/.+\?.*mode=([a-z]+)&?.*/,"$1");
	$('.ref-top a[mode='+showMode+']').click();
});

function disableItems ( items ) {
	items.addClass("is-disabled");
	items.bind('click',function(){return false;},false);
	items.attr('title','These items are not available in the current mode.');
}

function activateItems ( items ) {
	items.removeClass("is-disabled");
	items.unbind('click');
	items.attr('title','');
}