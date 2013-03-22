<?php
/**
 * Class  PayPal
 *
 * @version 1.0
 * @author Martin Maly - http://www.php-suit.com
 * @copyright (C) 2008 martin maly
 * @see  http://www.php-suit.com/paypal
 * 2.10.2008 20:30:40
 */
 
/*
* Copyright (c) 2008 Martin Maly - http://www.php-suit.com
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*     * Redistributions of source code must retain the above copyright
*       notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright
*       notice, this list of conditions and the following disclaimer in the
*       documentation and/or other materials provided with the distribution.
*     * Neither the name of the <organization> nor the
*       names of its contributors may be used to endorse or promote products
*       derived from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY MARTIN MALY ''AS IS'' AND ANY
* EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL MARTIN MALY BE LIABLE FOR ANY
* DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

class PayPal {

	//these constants you have to obtain from PayPal
	//Step-by-step manual is here: https://cms.paypal.com/us/cgi-bin/?cmd=_render-content&content_ID=developer/e_howto_api_NVPAPIBasics

	private $endpoint;
	private $host;
	private $gate;

	function __construct($real = false) {
		$this->endpoint = '/nvp';
		if ($real) {
			$this->host = "api-3t.paypal.com";
			$this->gate = 'https://www.paypal.com/cgi-bin/webscr?';
		} else {
			//sandbox
			$this->host = "api-3t.sandbox.paypal.com";
			$this->gate = 'https://www.sandbox.paypal.com/cgi-bin/webscr?';
		}
	}

	/**
	 * @return HTTPRequest
	 */
	private function response($data){
		$r = new HTTPRequest($this->host, $this->endpoint, 'POST', true);
		$result = $r->connect($data);
		if ($result<400) return $r;
		return false;
	}

	private function buildQuery($data = array()){
		$data['USER'] = API_USERNAME;
		$data['PWD'] = API_PASSWORD;
		$data['SIGNATURE'] = API_SIGNATURE;
		$data['VERSION'] = '52.0';
		$query = http_build_query($data);
		return $query;
	}

	
	/**
	 * Main payment function
	 * 
	 * If OK, the customer is redirected to PayPal gateway
	 * If error, the error info is returned
	 * 
	 * @param float $amount Amount (2 numbers after decimal point)
	 * @param string $desc Item description
	 * @param string $invoice Invoice number (can be omitted)
	 * @param string $currency 3-letter currency code (USD, GBP, CZK etc.)
	 * 
	 * @return array error info
	 */
	public function doExpressCheckout($amount, $desc, $invoice='', $currency='USD'){
		$data = array(
		'PAYMENTACTION' =>'Sale',
		'AMT' =>$amount,
		'RETURNURL' => PP_RETURN,
		'CANCELURL'  => PP_CANCEL,
		'DESC'=>$desc,
		'NOSHIPPING'=>"1",
		'ALLOWNOTE'=>"1",
		'CURRENCYCODE'=>$currency,
		'METHOD' =>'SetExpressCheckout');
		
		$data['CUSTOM'] = $amount.'|'.$currency.'|'.$invoice;
		if ($invoice) $data['INVNUM'] = $invoice;

		$query = $this->buildQuery($data);

		$result = $this->response($query);

		if (!$result) return false;
		$response = $result->getContent();
		$return = $this->responseParse($response);

		if ($return['ACK'] == 'Success') {
			header('Location: '.$this->gate.'cmd=_express-checkout&useraction=commit&token='.$return['TOKEN'].'');
			die();
		}
		return($return);
	}

	public function getCheckoutDetails($token){
		$data = array(
		'TOKEN' => $token,
		'METHOD' =>'GetExpressCheckoutDetails');
		$query = $this->buildQuery($data);

		$result = $this->response($query);

		if (!$result) return false;
		$response = $result->getContent();
		$return = $this->responseParse($response);
		return($return);
	}
	public function doPayment(){
		$token = $_GET['token'];
		$payer = $_GET['PayerID'];
		$details = $this->getCheckoutDetails($token);
		if (!$details) return false;
		list($amount,$currency,$invoice) = explode('|',$details['CUSTOM']);
		$data = array(
		'PAYMENTACTION' => 'Sale',
		'PAYERID' => $payer,
		'TOKEN' =>$token,
		'AMT' => $amount,
		'CURRENCYCODE'=>$currency,
		'METHOD' =>'DoExpressCheckoutPayment');
		$query = $this->buildQuery($data);

		$result = $this->response($query);

		if (!$result) return false;
		$response = $result->getContent();
		$return = $this->responseParse($response);

		/*
		 * [AMT] => 10.00
		 * [CURRENCYCODE] => USD
		 * [PAYMENTSTATUS] => Completed
		 * [PENDINGREASON] => None
		 * [REASONCODE] => None
		 */

		return($return);
	}

	private function getScheme() {
		$scheme = 'http';
		if (isset($_SERVER['HTTPS']) and $_SERVER['HTTPS'] == 'on') {
			$scheme .= 's';
		}
		return $scheme;
	}

	private function responseParse($resp){
		$a=explode("&", $resp);
		$out = array();
		foreach ($a as $v){
			$k = strpos($v, '=');
			if ($k) {
				$key = trim(substr($v,0,$k));
				$value = trim(substr($v,$k+1));
				if (!$key) continue;
				$out[$key] = urldecode($value);
			} else {
				$out[] = $v;
			}
		}
		return $out;
	}
}

?>