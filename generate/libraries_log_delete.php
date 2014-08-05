<?

require_once('../config.php');

$benchmark_start = microtime_float();

$path = BASEDIR;




// Switch from SVN to GIT, 14 FEB 2013
//`cd $path && /usr/bin/git pull https://github.com/processing/processing-docs/`;
//`cd $referencepath && python build_listing.py`;

$path = $path . 'contrib_generate';

`cd $path && rm build.log`;
//`pwd`;




$benchmark_end = microtime_float();
$execution_time = round($benchmark_end - $benchmark_start, 4);

?>

<h2>Log Deletion Successful</h2>
<p>Complete in <?=$execution_time?> seconds.</p>