<?php

//cache the json file and only call again if interval exceeded
error_reporting(0);

$feed = "https://api.github.com/repos/processing/processing/commits?sha=master";
function getSslPage($url) {
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
    curl_setopt($ch, CURLOPT_HEADER, false);
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_REFERER, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
    $result = curl_exec($ch);
    curl_close($ch);
    return $result;
}
echo getSslPage($feed);
 

$cache_file = dirname(__FILE__).'/cache/'.'github-cache';
$modified = filemtime( $cache_file );
$now = time();
$interval = 600; // ten minutes
 
if ( !$modified || ( ( $now - $modified ) > $interval ) ) {
  $json = file_get_contents( $feed );
  
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