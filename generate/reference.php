<?php

require_once('../config.php');

function out($output) {
	echo "<p>$output</p>";
	error_log($output);
}

$JAVA_HOME = "/usr/local/jdk1.5.0_15";
$PATH = "$JAVA_HOME/bin:/usr/local/bin:/usr/bin:/bin";
putenv("JAVA_HOME=$JAVA_HOME");
putenv("PATH=$PATH");

$benchmark_start = microtime_float();

$path = BASEDIR;  //define('BASEDIR',       dirname(__FILE__).'/');

// Pull latest processing/processing from GitHub
// Note that the Reference generate script needs this,
// just in case someone changed anything in the .java source files.
out("Pulling in latest changes from processing/processing/...");

$mainRepoPath = $path . '../processing';
$shell_output = shell_exec("cd $mainRepoPath && /usr/bin/git pull https://github.com/processing/processing-docs/ 2>&1");

out($shell_output);

//exec("cd $mainRepoPath && /usr/bin/git pull https://github.com/processing/processing/");

// Pull latest processing/processing-docs from GitHub
echo '<p>Pulling in latest changes from processing/processing-docs/...</p>';
`cd $path && /usr/bin/git pull https://github.com/processing/processing-docs/`;

out("---------------");

$referencepath = $path . "java_generate/ReferenceGenerator/";

// 

out("Rebuilding reference files...");

$shell_output = shell_exec("cd $referencepath && ./processingrefBuild.sh 2>&1");

out($shell_output);

$benchmark_end = microtime_float();
$execution_time = round($benchmark_end - $benchmark_start, 4);


out("Generated files in $execution_time seconds.");
?>