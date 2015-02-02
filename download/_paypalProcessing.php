<?php

require_once('./paypal/paypal.php');
require_once('./paypal/httprequest.php');

//Use this form for production server 
//$r = new PayPal(true);

//Use this form for sandbox tests
$r = new PayPal();

$amount = (float) $_POST['amount'];
$ret = ($r->doExpressCheckout($amount, 'Donation to the Processing Foundation'));

//An error occured. The auxiliary information is in the $ret array

echo 'Error:';

print_r($ret);

?>