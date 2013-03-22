<h1 class="large-header"><span class="black">Download Processing.</span> Please consider making a donation to the Processing Foundation before downloading the software.</h1>

<div class="donate-box">

	<h1 class="large-header">$<?=$amount?> will be donated to the Processing Foundation</h1>
	
	<div class="messages"><?=$dinky?></div>

	<form action="/download/" method="POST" id="donateForm">
		<input type="hidden" name="form" value="2" />
		<input type="hidden" name="amount" value="<?=$amount?>">
		
		<div class="genInfo">
			<div class="form-row"><label>First Name</label> <input type="text" name="first-name" required></div>
			<div class="form-row"><label>Last Name</label> <input type="text" name="last-name" required></div>
			<div class="form-row"><label>Email</label> <input type="email" name="email" required></div>
		</div>

		<div class="payType">
			<label><input type="radio" value="stripe" name="type" checked> Pay with credit card</label>
			<span class="or">or</span>
			<label><input type="radio" value="paypal" name="type"> Pay with PayPal</label>
		</div>

		<div class="ccInfo">
			<div class="form-row">
				<label>Card Number</label>
				<input type="text" autocomplete="off" class="card-number text" value="4242424242424242">
			</div>

			<div class="form-row">
				<label>Security Code (CVV)</label> 
				<input type="text" autocomplete="off" class="card-cvc text" value="123">
			</div>

			<div class="form-row">
				<label>Card Expiration</label>
				<select class="card-expiry-month text">
					<? $months = array('January','February','March','April','May','June','July ','August','September','October','November','December');
					for ($i = 1; $i <= count($months); $i++) {
						$selected = $i == 1 ? 'selected' : '';
						$zero = $i < 10 ? '0' : '';
						echo '<option value="'.$zero.$i.'"'.$selected.'>'.$months[$i-1].'</option>';
					}
					?>
				</select>
				<select class="card-expiry-year text">
					<?  $current_year = date("Y");
						for($i = 0; $i <= 12; $i++) {
							$selected = $i == 3 ? 'selected' : '';
							echo '<option value="'.$current_year.'"'.$selected.'>'.$current_year.'</option>';
							$current_year++;
						} 
					?>
				</select>
			</div>
		</div>
			
		<input type="submit" class="submit-button" value="Complete Donation">
	</form>

</div>