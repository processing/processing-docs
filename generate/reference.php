<?php

require_once('../config.php');

function out($output) {
	$htmlOutput = str_replace("\n", "<br />", $output);
	echo "<p>$htmlOutput</p>";
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

$mainRepoPath = "{$path}../processing";
$shell_output = shell_exec("cd $mainRepoPath && /usr/bin/git pull https://github.com/processing/processing/ 2>&1");

out($shell_output);
out("---------------");



// Pull latest processing/processing-sound from GitHub
// Note that the Reference generate script needs this,
// just in case someone changed anything in the .java source files.
out("Pulling in latest changes from processing/processing-sound/...");

$soundRepoPath = "{$path}../processing-sound";
//$shell_output = shell_exec("cd $soundRepoPath && /usr/bin/git pull https://github.com/processing/processing-sound/ 2>&1");
// clone new processing-sound library from work-in-progress repository instead
$shell_output = shell_exec("rm -rf $soundRepoPath && mkdir $soundRepoPath && cd $soundRepoPath && /usr/bin/git clone https://github.com/processing/processing-sound.git . 2>&1");

out($shell_output);
out("---------------");



// Pull latest processing/processing-docs from GitHub
// Disabled for now, so we can test generate scripts without pulling latest from repo. -SM
//out("<p>Pulling in latest changes from processing/processing-docs/...</p>");
//$docsRepoPath = "{$path}../processing-docs";
//$shell_output = shell_exec("cd $docsRepoPath && /usr/bin/git pull https://github.com/processing/processing-docs/ 2>&1");
//out($shell_output);
//out("---------------");



//Build reference files
out("Rebuilding reference files...");
$referencepath = $path . "java_generate/ReferenceGenerator/";
$shell_output = shell_exec("cd $referencepath && ./processingrefBuild.sh 2>&1");
out($shell_output);



// Compress distribution into a ZIP, so it can be rolled into an IDE build.
// processing/processing/java/
out("Compressing distribution directory...");
shell_exec("rm $mainRepoPath/build/shared/reference.zip 2>&1");
//shell_exec("rm $mainRepoPath/java/reference.zip 2>&1");  // Add 10 Nov 2016 - CR
$docsRepoPath = "{$path}../processing-docs";
$shell_output = shell_exec("cd $docsRepoPath && cp -r distribution/ $mainRepoPath/build/shared/reference/ 2>&1");
//$shell_output = shell_exec("cd $docsRepoPath && cp -r distribution/ $mainRepoPath/java/reference/ 2>&1");  // Add 10 Nov 2016 - CR
out($shell_output);
$shell_output = shell_exec("cd $mainRepoPath/build/shared/ && zip -r reference.zip reference/ 2>&1");
//$shell_output = shell_exec("cd $mainRepoPath/java/ && zip -r reference.zip reference/ 2>&1");  // Add 10 Nov 2016 - CR
out($shell_output);
shell_exec("rm -r $mainRepoPath/build/shared/reference/ 2>&1");
//shell_exec("rm -r $mainRepoPath/java/reference/ 2>&1");  // Add 10 Nov 2016 - CR
out("Done compressing!");


$benchmark_end = microtime_float();
$execution_time = round($benchmark_end - $benchmark_start, 4);

out("Generated files in $execution_time seconds.");
?>
