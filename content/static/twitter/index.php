<?php
 
error_reporting( 0 ); // don't let any php errors ruin the feed
 
$username = 'processingOrg';
$number_tweets = 4;
$feed = "http://api.twitter.com/1/statuses/user_timeline.json?screen_name={$username}&count={$number_tweets}&include_rts=1&callback=?";
$cache_file = dirname(__FILE__).'/cache/'.'twitter-cache';
$modified = filemtime( $cache_file );
$now = time();
$interval = 600; // ten minutes
 
// check the cache file
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