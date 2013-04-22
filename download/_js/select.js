$(function(){

	var $selectForm = $('#selectForm')
	var $radio = $selectForm.find('input[type="radio"]')
	var $wildCard = $selectForm.find('input[type="radio"]#wildcard')
	var $otherAmount = $selectForm.find('input#otra')
	var $radioChecked = $selectForm.find('input[name="radioChecked"]')
	var $submit = $selectForm.find('input[type="submit"]')

	if($('input[name=selectAmount]:checked').val() == 0)
		$submit.val('Download')
	
	$radio.on('change', function(){
		$radioChecked.val(1)
		if($(this).val()==0)
			$submit.val('Download')
		else
			$submit.val('Donate & Download')
	})

	$otherAmount.on('change', function(){
		$wildCard.val($(this).val())
	})

	$selectForm.on('submit',function(){
		
		if($radioChecked.val() <= 0){
			$('.messages').html('Please select a donation amount')
			return false
		}

		if($('input[name=selectAmount]:checked').val() == 'other' && $('#otra').val() == ''){
			$('.messages').html('Please enter a donation amount')
			return false
		}

		if($('input[name=selectAmount]:checked').val() == 0){
			window.location = '/download/?processing'
			return false
		}

	})

})