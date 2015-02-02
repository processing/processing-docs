<?php
require_once('./paypal/paypal.php');
require_once('./paypal/httprequest.php');

//Load PHPMailer autoloader v5.2.9
require('phpmailer529/PHPMailerAutoload.php');


//Load Helpers for the ip address function
require_once('./_helpers.php');

//Use this form for production server 
//$r = new PayPal(true);

//Use this form for sandbox tests
$r = new PayPal();

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

	$mail->SMTPDebug  = 0;  //0 is no debug output, 3 is verbose

	$mail->IsSMTP(); 
	$mail->SMTPAuth   = true;
	$mail->SMTPSecure = 'tls';
	$mail->Port       = 25;
	$mail->Host       = $mailConfig['host'];
	$mail->Username   = $mailConfig['user'];
	$mail->Password   = $mailConfig['pass'];

	$mail->From 	  = 'foundation@processing.org';
	$mail->FromName   = 'Processing Foundation';
	$mail->addAddress($email, $name);
	$mail->addBCC('foundation@processing.org');

	// Build message from PayPal values. Find and replace from config email
	$message = str_replace('%name%', $name , $config['email-message']) . "\n\n";
	$message .= "Amount: $" . $amount . "<br />\n";
	$message .= "Email: " . $email . "<br />\n";
	$message .= "Date: " . date('M j, Y', $date) . "<br /><br />\n";
	$message .= "Best regards, and thanks again,<br />Ben Fry, Casey Reas, and Dan Shiffman";

	$mail->isHTML(true);
	$mail->Subject = $config['email-subject'];
	$mail->Body    = $message;
	
	$mail->Send();

	$log = __DIR__ . '/../../../cred/purchases.log';
	$cleanDate = date('Y-m-d', $date);
	$data = $cleanDate."\t".$amount."\t".'paypal'."\t".$name."\t".$email."\t".get_client_ip()."\n";
	file_put_contents($log, $data, FILE_APPEND | LOCK_EX);
	
	
}

?>