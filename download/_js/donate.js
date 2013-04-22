$(function(){

	var $donateForm = $('#donateForm')
	var $submit = $donateForm.find('input[type="submit"]')
	var stripe = true

	// if($('input[name=type]:checked').val() != 'stripe'){
	// 	stripe = false
	// 	$('.ccInfo').hide()
	// }

	$('input[name=type]').on('change', function(){
		if($(this).val()=='stripe'){
			stripe = true
			$('.ccInfo').show()
		} else if($(this).val()=='paypal'){
			stripe = false
			$('.ccInfo').hide()
		}
	})

	var stripeResponseHandler = function(status, response) {
		if (response.error) {
			$('.messages').html(response.error.message)
			$submit.prop('disabled', false).val('Complete Donation')
		} else {
			var token = response['id']
			$donateForm.append('<input type="hidden" name="stripeToken" value="' + token + '">')
			$donateForm.get(0).submit()
		}
	}

	// $donateForm.validate()
	$donateForm.on('submit',function(){
		$submit.prop('disabled', true).val('Processing...');

		if(stripe){
			Stripe.createToken({
				name: $('.first-name').val() + ' ' + $('.last-name').val(),
				number: $('.card-number').val(),
				cvc: $('.card-cvc').val(),
				exp_month: $('.card-expiry-month').val(),
				exp_year: $('.card-expiry-year').val()
			}, stripeResponseHandler);

			return false;
		}

		if(!stripe){
			
		}
	})

})