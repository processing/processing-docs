<?php

/*
	This is just for testing purposes!
*/

require(realpath(__DIR__ . '/../../../cred/config.php'));



//Load PHPMailer autoloader
require('phpmailer529/PHPMailerAutoload.php');



// Force https
/*
if( $_SERVER["HTTPS"] != "on" && !$config['test-mode'] ) {
	header("HTTP/1.1 301 Moved Permanently");
	header("Location: https://" . $_SERVER["SERVER_NAME"] . $_SERVER["REQUEST_URI"]);
	exit();
}
*/






$body = "This is a test message sent by %name%. Please let Scott know if you receive it. Thanks!<br/><br/>- Scott";
$name = "Scott Murray";
$email = "shm@alignedleft.com";



// Build and send the email *using PHPMailer

$mail = new PHPMailer();

$mail->SMTPDebug  = 3;  //0 is no debug output

$mail->IsSMTP(); 
$mail->SMTPAuth   = true;
$mail->SMTPSecure = 'tls';
$mail->Port       = 587;
$mail->Host       = $mailConfig['host'];
$mail->Username   = $mailConfig['user'];
$mail->Password   = $mailConfig['pass'];

$mail->From('foundation@processing.org');
$mail->FromName('Processing Foundation');
$mail->addAddress($email, $name);
$mail->addBCC('foundation@processing.org');

$message = str_replace('%name%', $name , $body) . "\n\n";
$message .= "Email: " . $email . "<br />\n";

$mail->isHTML(true);
$mail->Subject 	= "Test message from Processing.org";
$mail->Body 	= $message;

if(!$mail->send()) {
    echo 'Message could not be sent.';
    echo 'Mailer Error: ' . $mail->ErrorInfo;
} else {
    echo 'Message has been sent';
}


//echo("<p>mailed returned " . $result . "</p>");
//echo("<p>ErrorInfo is " . $mail->ErrorInfo . "</p>");





exit;

?>