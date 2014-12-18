<?php

/*
	This is just for testing purposes!
*/

require(realpath(__DIR__ . '/../../../cred/config.php'));

//Load PHPMailer Class
require_once('phpmailer/class.phpmailer.php');
require_once('phpmailer/class.smtp.php');


// Force https
if( $_SERVER["HTTPS"] != "on" && !$config['test-mode'] ) {
	header("HTTP/1.1 301 Moved Permanently");
	header("Location: https://" . $_SERVER["SERVER_NAME"] . $_SERVER["REQUEST_URI"]);
	exit();
}



$body = "This is a test message sent by %name%. Please let Scott know if you receive it. Thanks!<br/><br/>- Scott";
$name = "Scott Murray";
$email = "shm@alignedleft.com";

// Build and send the email *using PHPMailer
$mail = new PHPMailer();
$mail->IsSMTP(); 
$mail->SMTPDebug  = 3;  //0 is no debug output
$mail->SMTPAuth   = true;
$mail->SMTPSecure = 'tls';
$mail->Port       = 587;
$mail->Host       = $mailConfig['host'];
$mail->Username   = $mailConfig['user'];
$mail->Password   = $mailConfig['pass'];

$mail->SetFrom('foundation@processing.org', 'Processing Foundation');
$mail->AddBCC('foundation@processing.org', 'Processing Foundation');
$mail->AddAddress($email, $name);

$message = str_replace('%name%', $name , $body) . "\n\n";
$message .= "Email: " . $email . "<br />\n";

$mail->Subject = "Test message from Processing.org";
$mail->MsgHTML($message);
$result = $mail->Send();

echo("<p>mailed returned " . $result . "</p>");
echo("<p>ErrorInfo is " . $mail->ErrorInfo . "</p>");



exit;





?>