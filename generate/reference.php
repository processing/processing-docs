<?php

require('../config.php');

$benchmark_start = microtime_float();

$path = BASEDIR;  //define('BASEDIR',       dirname(__FILE__).'/');

// Pull latest processing/processing from GitHub
// Note that the Reference generate script needs this,
// just in case someone changed anything in the .java source files.
echo '<p>Pulling in latest changes from processing/processing/...</p>';
$mainRepoPath = $path . '../processing';
`cd $mainRepoPath && /usr/bin/git pull https://github.com/processing/processing/`;

// Pull latest processing/processing-docs from GitHub
echo '<p>Pulling in latest changes from processing/processing-docs/...</p>';
`cd $path && /usr/bin/git pull https://github.com/processing/processing-docs/`;

$referencepath = $path . "java_generate/ReferenceGenerator/";

// 
echo '<p>Rebuilding reference files...</p>';
`cd $referencepath && ./processingrefBuild.sh`;

$benchmark_end = microtime_float();
$execution_time = round($benchmark_end - $benchmark_start, 4);

?>


<p>Generated files in <?=$execution_time?> seconds.</p>