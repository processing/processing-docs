<?php
require_once('./paypal/paypal.php');
require_once('./paypal/httprequest.php');

//Load PHPMailer Class
require_once('phpmailer/class.phpmailer.php');

//Load Helpers for the ip address function
require_once('./_helpers.php');

//Use this form for production server 
$r = new PayPal(true);

//Use this form for sandbox tests
// $r = new PayPal();

$final = $r->doPayment();

if ($final['ACK'] == 'Success') {
	$payment = $r->getCheckoutDetails($final['TOKEN']);

	//If payment from PayPal is successful, send out our thankyou email
	$first_name = $payment['FIRSTNAME'];
	$last_name 	= $payment['LASTNAME'];
	$name 		= $first_name . ' ' . $last_name;
	$email   	= $payment['EMAIL'];
	$amount  	= $payment['CUSTOM'];
		$amount = explode("|", $amount, 2);
		$amount = $amount[0];
	$date 		= $payment['TIMESTAMP'];
		$date   = strtotime($date);

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
	$message .= "Date: " . date('M j, Y', $date) . "<br /><br />\n";
	$message .= "Best regards, and thanks again,<br />Ben Fry, Casey Reas, and Dan Shiffman";

	$mail->Subject = $config['email-subject'];
	$mail->MsgHTML($message);
	$mail->Send();

	$log = __DIR__.$fPath.'purchases.log';
	//$data = $email."\t".$name."\t$".$amount."\n";
	$data = $date."\t".$amount."\t".'paypal'."\t".$name."\t".$email."\t".get_client_ip()."\n";
	file_put_contents($log, $data, FILE_APPEND | LOCK_EX);
	
	
} ?>