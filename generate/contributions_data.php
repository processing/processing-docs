<?php

//
// This script pulls in the latest changes from the repo
// and then runs the Python script that regenerates the
// contributions file(s).
//
// Yet Processing 2.0 and Processing 3.0 now reference
// different contributions files:
//
//    2.x   contributions.txt
//    3.x   contribs.txt
//
// …so this script now takes an optional argument in the
// query string, 'v', which tells it which version of
// the file to generate.  For example:
//
//    contributions_data.php?v=2
//
// …will generate *only* the "contributions.txt" for 2.x.
//
// If 'v' is missing, then both 2.x/3.x files are generated.
//

require_once('../config.php');

$benchmark_start = microtime_float();

$path = BASEDIR;  //define('BASEDIR',       dirname(__FILE__).'/');

// Pull from GitHub
`cd $path && /usr/bin/git pull https://github.com/processing/processing-docs/`;

$referencepath = $path . "contrib_generate/";

//Check the URL query string to see if a version is specified
$version = $_GET['v'];

if ($version == 2) {

	echo '<p>Generating "contributions.txt" for Processing 2.x...</p>';

	// Generate "contributions.txt" for Processing 2.x
	//`cd $referencepath && python build_listing.py sources.conf contributions.txt 216 227`;
	`cd $referencepath && python build_listing_legacy.py`;

} elseif ($version == 3) {

	echo '<p>Generating "contribs.txt" for Processing 3.x...</p>';
	
	// Generate "contribs.txt" for Processing 3.x
	`cd $referencepath && python build_listing.py`;

} else {

	echo '<p>No version value specified, so I will generate for both 2.x and 3.x.</p>';

	echo '<p>Generating "contributions.txt" for Processing 2.x...</p>';

	// Generate "contributions.txt" for Processing 2.x
	//`cd $referencepath && python build_listing.py sources.conf contributions.txt 216 227`;
	`cd $referencepath && python build_listing_legacy.py`;

	echo '<p>Generating "contribs.txt" for Processing 3.x...</p>';
	
	// Generate "contribs.txt" for Processing 3.x
	`cd $referencepath && python build_listing.py`;
}

$benchmark_end = microtime_float();
$execution_time = round($benchmark_end - $benchmark_start, 4);

?>


<p>Generated files in <?=$execution_time?> seconds.</p>