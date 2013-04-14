$(function(){
	$(window).scroll(function(){
		if($(this).scrollTop() > 114){
			$('.navBar').addClass('stuck')
		} else {
			$('.navBar').removeClass('stuck')
		}
	})
})