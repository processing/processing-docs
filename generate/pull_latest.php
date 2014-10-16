<?php

//
// This script, unlike others in this directory,
// only pulls in the latest files from the repo.
// It doesn't build or generate anything new.
//
// This could be nice for updating just the
// generate page itself, for example. :)
//
// - Scott
//

require_once('../config.php');

$benchmark_start = microtime_float();

$path = BASEDIR;  //define('BASEDIR',       dirname(__FILE__).'/');

echo "<p>Pulling in latest changes from GitHub master repository...</p>";

// Pull from GitHub
`cd $path && /usr/bin/git pull https://github.com/processing/processing-docs/`;

$benchmark_end = microtime_float();
$execution_time = round($benchmark_end - $benchmark_start, 4);

?>


<p>Generated files in <?=$execution_time?> seconds.</p>