<?php

require_once('../config.php');

//Start time
$benchmark_start = microtime_float();

//Base path
$path = BASEDIR;





//Path where build.log lives
$path = $path . 'contrib_generate';

//Go to there and delete it
`cd $path && rm build.log`;





//Timers
$benchmark_end = microtime_float();
$execution_time = round($benchmark_end - $benchmark_start, 4);

?>

<h2>Log Deletion Successful</h2>
<p><?=$path . '/build.log'?> no longer exists.</p>
<p>Complete in <?=$execution_time?> seconds.</p>