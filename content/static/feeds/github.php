<?php

//cache the json file and only call again if interval exceeded
error_reporting(0);

$version = curl_version();
    $ssl_supported= ($version['features'] & CURL_VERSION_SSL);
    echo $ssl_supported == CURL_VERSION_SSL;

function get_json($url){
  $base = "https://api.github.com/";
  $curl = curl_init();
  curl_setopt($curl, CURLOPT_USERAGENT,'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.13) Gecko/20080311 Firefox/2.0.0.13');
  curl_setopt($curl, CURLOPT_URL, $base . $url);
  curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);

  $content = curl_exec($curl);
  curl_close($curl);
  return $content;
}

$feed = "repos/processing/processing/commits";
$cache_file = dirname(__FILE__).'/cache/'.'github-cache';
$modified = filemtime( $cache_file );
$now = time();
$interval = 600; // ten minutes
 
if ( !$modified || ( ( $now - $modified ) > $interval ) ) {
  //$json = get_json($feed);
  
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