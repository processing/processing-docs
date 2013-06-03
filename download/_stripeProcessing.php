<?php

// Load Stripe library
require 'stripe/Stripe.php';

//Load PHPMailer Class
require_once('phpmailer/class.phpmailer.php');


// Force https
if( $_SERVER["HTTPS"] != "on" && !$config['test-mode'] ) {
	header("HTTP/1.1 301 Moved Permanently");
	header("Location: https://" . $_SERVER["SERVER_NAME"] . $_SERVER["REQUEST_URI"]);
	exit();
}

if ($_POST) {
	Stripe::setApiKey($config['secret-key']);

	// POSTed Variables
	$token 		= $_POST['stripeToken'];
	$first_name = $_POST['first-name'];
	$last_name 	= $_POST['last-name'];
	$name 		= $first_name . ' ' . $last_name;
	$email   	= $_POST['email'];
	$amount  	= (float) $_POST['amount'];

	try {
		if ( ! isset($_POST['stripeToken']) ) {
			throw new Exception("The Stripe Token was not generated correctly");
		}

		// Charge the card
		$donation = Stripe_Charge::create(array(
			'card' => $token,
			'description' => 'Donation by ' . $name . ' (' . $email . ')',
			'amount' => $amount * 100,
			'currency' => 'usd')
		);

		// Build and send the email *using PHPMailer
		$mail = new PHPMailer();
		$mail->IsSMTP(); 
		$mail->SMTPDebug  = 0;
		$mail->SMTPAuth   = true;
		$mail->Host       = $mailConfig['host'];
		$mail->Port       = 587;
		$mail->Username   = $mailConfig['user'];
		$mail->Password   = $mailConfig['pass'];
		$mail->SMTPSecure = 'tls';

		$mail->SetFrom('foundation@processing.org', 'Processing Foundation');
		$mail->AddBCC('foundation@processing.org', 'Processing Foundation');
		$mail->AddAddress($email, $name);

		// Build message from Stripe values. Find and replace from config email
		$message = str_replace('%name%', $name , $config['email-message']) . "\n\n";
		$message .= "Amount: $" . $amount . "<br />\n";
		$message .= "Email: " . $email . "<br />\n";
		$message .= "Date: " . date('M j, Y', $donation['created']) . "<br />\n";
		$message .= "Transaction ID: " . $donation['id'] . "<br /><br />\n\n\n";
		$message .= "Best regards, and thanks again,<br>Ben Fry, Casey Reas, and Dan Shiffman";

		$mail->Subject = $config['email-subject'];
		$mail->MsgHTML($message);
		$mail->Send();

		$log = __DIR__.$fPath.'purchases.log';
		$data = $email."\t".$name."\t$".$amount."\n";
		file_put_contents($log, $data, FILE_APPEND | LOCK_EX);

		// Forward to "Downloads" page
		header('Location: ' . $config['download']);
		exit;

	}
	catch (Stripe_Error $e) {
		$showPaymentForm = true;
		$dinky = $e->getJsonBody();
		$dinky = $dinky['error']['message'];
	}
	catch (Exception $e) {
		$error = $e->getMessage();
	}
}

?>