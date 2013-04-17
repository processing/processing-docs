<? 

//Let's get this payparty started
$showDonationForm = false;
$showPaymentForm  = false;
$showDownloadPage = false;
$thankYou 		  = false;
$type 			  = NULL;
$amount 		  = NULL;

$fPath = $_SERVER['HTTP_HOST']=='trunk.processing.org' ? '/../../www/cred/' : '/../../cred/';
require(__DIR__.$fPath.'config.php');

//Check what to show
if(isset($_POST['form'])){
	if($_POST['form'] == 1){ //if form equals 1, user has selected payment amount so show the payment form
		$showPaymentForm = true;	
		$amount = $_POST['selectAmount'];
	} elseif($_POST['form'] == 2){ //if form equals 2, check if payment was Stripe or PayPal
		$type = $_POST['type'];
		if($_POST['type'] == 'stripe'){ //if stripe, include Stripe processing	
			require('_stripeProcessing.php');
		} elseif($_POST['type'] == 'paypal'){ //if PayPal, include PayPal processing
			require('_paypalProcessing.php');
		}
	}
} else {
	if(isset($_GET['thankyou'])){ //if we have our thankyou query, show downloads
		if($_GET['thankyou'] == 'paypal') require('_ppEmailThanks.php');
		$showDownloadPage = true;
		$thankYou = true;
	} elseif(isset($_GET['processing'])){
		$showDownloadPage = true;
	} else { //show donation form
		$showDonationForm = true;
	}
} ?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
	<head>
		<title>Download \ Processing.org</title>
		
		<link rel="icon" href="/img/processing-1.ico" type="image/x-icon" />
		<link rel="shortcut icon" href="/img/processing-1.ico" type="image/x-icon" />
		
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="Author" content="Casey Reas &amp; Ben Fry" />
		<meta name="Publisher" content="Processing" />
		<meta name="Keywords" content="Processing, Processing, Interactive Media, Electronic Arts, Programming, Java, Ben Fry, Casey Reas" />
		<meta name="Description" content="Processing is an electronic sketchbook for developing ideas. It is a context for learning fundamentals of computer programming within the context of the electronic arts." />
		<meta name="Copyright" content="All contents copyright Ben Fry, Casey Reas, MIT Media Laboratory" />

		<script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
		<script src="/javascript/stickyNav.js" type="text/javascript"></script>
		<? if($showDonationForm): ?>
			<script type="text/javascript" src="_js/select.js"></script>
		<? endif; ?>
		<? if($showPaymentForm): ?>
			<script type="text/javascript" src="https://js.stripe.com/v1/"></script>
			<script type="text/javascript">Stripe.setPublishableKey('<?php echo $config['publishable-key'] ?>');</script>
			<script type="text/javascript" src="_js/jquery.validate.min.js"></script>
			<script type="text/javascript" src="_js/donate.js"></script>
		<? endif; ?>
	
		<link href="/css/style.css" rel="stylesheet" type="text/css" />
	</head>
	<body id="Download" onload="" >
		
		<!-- ==================================== PAGE ============================ --> 
		<div id="container">
	
			<!-- ==================================== HEADER ============================ --> 
			<div id="header">
				<a href="/" title="Back to the Processing cover."><div class="processing-logo no-cover" alt="Processing cover"></div></a>
				<form name="search" action="http://www.google.com/search" method="get">
				    <p><input type="hidden" name="as_sitesearch" value="processing.org" />
				    <input type="text" name="as_q" value="" size="20" class="text" /> 
					<input type="submit" value=" " /></p>
				</form>
			</div> 
			<a id="TOP" name="TOP"></a>
			
			<!-- ==================================== NAVIGATION ============================ -->
			<div id="navigation">
				<div class="navBar" id="mainnav_noSub">
					<a href="/">Cover</a><br><br>
					<a href="/download/" class="active">Download</a><br><br>
					<a href="/exhibition/">Exhibition</a><br><br>
					<a href="/reference/">Reference</a><br>
					<a href="/reference/libraries/">Libraries</a><br>
					<a href="/reference/tools/">Tools</a><br>
					<a href="/reference/environment/">Environment</a><br><br>
					<a href="/learning/">Tutorials</a><br>
					<a href="/learning/examples/">Examples</a><br>
					<a href="/learning/books/">Books</a><br><br>
					<a href="/about/">Overview</a><br> 
					<a href="/about/people/">People</a><br>
					<a href="/about/foundation/">Foundation</a><br><br>
					<a href="/shop/">Shop</a><br><br>
					<a href="https://twitter.com/processingOrg"class="outward"><span>&raquo;</span>Twitter</a><br> 
					<a href="http://forum.processing.org"class="outward"><span>&raquo;</span>Forum</a><br> 
					<a href="http://wiki.processing.org"class="outward"><span>&raquo;</span>Wiki</a><br> 
					<a href="https://github.com/processing/processing-web/issues?state=open"class="outward"><span>&raquo;</span>Issues</a><br> 
					<a href="https://github.com/processing"class="outward"><span>&raquo;</span>Source</a><br> 
				</div>
			</div>

			<!-- ==================================== CONTENT ============================ -->
			<div class="content">

			<? if($showDonationForm): ?>
				<? require('_selectForm.php'); ?>
			<? elseif($showPaymentForm): ?>
				<? require('_paymentForm.php'); ?>
			<? elseif($showDownloadPage): ?>
				<? require('_downloads.php'); ?>
			<? endif; ?>
      
			</div>

			<!-- ==================================== FOOTER ============================ --> 
  			<div id="footer">
    			<div id="copyright">Processing was initiated by <a href="http://benfry.com/">Ben Fry</a> and <a href="http://reas.com">Casey Reas</a>. It is developed by a <a href="/about/people/">small team of volunteers</a>.</div> 
    			<div id="colophon">
                    <a href="/copyright.html">&copy; Info</a> \ <span>Site hosted by <a href="http://www.mediatemple.net">Media Temple!</a></span>
                </div>
  			</div>
  			
		</div>
		<script type="text/javascript">

		 var _gaq = _gaq || [];
		 _gaq.push(['_setAccount', 'UA-40016511-1']);
		 _gaq.push(['_trackPageview']);

		 (function() {
		   var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
		   ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
		   var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
		 })();

		</script>
	</body>
</html>
