<h1 class="large-header"><span class="black">Download Processing.</span> Please consider making a donation to the Processing Foundation before downloading the software.</h1>

<noscript>
	<p>JavaScript is required for the donation process. Please click <a href="/download/?processing">here</a> to go directly to Downloads...</p>
	<style type="text/css">
		.donate-box { display: none; }
	</style>
</noscript>

<div class="donate-box">

	<p>Processing is open source, free software. All donations fund the <a href="/about/foundation/">Processing Foundation</a>, a nonprofit organization devoted to advancing the role of programming within the visual arts through developing Processing.</p>

	<div class="messages"></div>

	
	<form method="post" action="/download/" id="selectForm">
		<input type="hidden" name="form" value="1" />
		<input type="hidden" name="radioChecked" value="0" />

		<div class="select-amount">
			<label><input type="radio" name="selectAmount" value="0"> No Donation</label>
			<label><input type="radio" name="selectAmount" value="10"> $10</label>
			<label><input type="radio" name="selectAmount" value="50"> $50</label>
			<label><input type="radio" name="selectAmount" value="100"> $100</label>
			<label><input type="radio" name="selectAmount" value="other" id="wildcard"> $ <input type="text" value="" id="otra" onkeyup="if (/\D/g.test(this.value)) this.value = this.value.replace(/\D/g,'')"></label>
		</div>

		<input type="submit" name="submit" value="Donate & Download">
	</form>

</div>