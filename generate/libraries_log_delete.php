<?

require_once('../config.php');

$benchmark_start = microtime_float();

$path = BASEDIR;

// Update the files on the server
putenv('HOME=' . CONTENTDIR);
$where = CONTENTDIR . 'static/';

//`cd $where && /usr/bin/svn update libraries.html`;


echo "$path is " . $path;
echo "$where is " . $where;

// Switch from SVN to GIT, 14 FEB 2013
//`cd $path && /usr/bin/git pull https://github.com/processing/processing-docs/`;
//`cd $referencepath && python build_listing.py`;





$benchmark_end = microtime_float();
$execution_time = round($benchmark_end - $benchmark_start, 4);

?>

<h2>Log Deletion Successful</h2>
<p>Complete in <?=$execution_time?> seconds.</p>