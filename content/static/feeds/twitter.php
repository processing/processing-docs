<?php
 
//cache the json file and only call again if interval exceeded
error_reporting( 0 );
require_once('./TwitterAPIExchange.php');

//Twitter API Request Settings
$settings = array(
    'oauth_access_token' => "17499754-Mpzf4XM90W8266zEvJ7gsVUUDTWXpMBx3NRnNg",
    'oauth_access_token_secret' => "dNQehn22l7ocwbdgTCS7LIWxIiTMu3ngHVb29V0Lg",
    'consumer_key' => "KTGMvLZ6GDO0AZjNnhi18Q",
    'consumer_secret' => "xCz5KlPQQIn9eJjsBsewTRSkKhtLROumVwwiSa34aQ0"
);
$url = 'https://api.twitter.com/1.1/statuses/user_timeline.json';
$getfield = '?screen_name=processingOrg&count=4';
$requestMethod = 'GET';

//Cache Setup
$cache_file = dirname(__FILE__).'/cache/'.'twitter-cache';
$modified = filemtime( $cache_file );
$now = time();
$interval = 600; // ten minutes
 
//If it has been ten minutes since last grab, request tweets
if ( !$modified || ( ( $now - $modified ) > $interval ) ) {

	$twitter = new TwitterAPIExchange($settings);
	$json = $twitter->setGetfield($getfield)
	         ->buildOauth($url, $requestMethod)
	         ->performRequest();
  
	if ( $json ) {
		$cache_static = fopen( $cache_file, 'w' );
		fwrite( $cache_static, $json );
		fclose( $cache_static );
	}
}
 
header( 'Cache-Control: no-cache, must-revalidate' );
header( 'Expires: Mon, 26 Jul 1997 05:00:00 GMT' );
header( 'Content-type: application/json' );
 
$json = file_get_contents( $cache_file );
echo $json;

?>