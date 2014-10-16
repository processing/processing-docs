<?php

require_once('../config.php');
require('lib/Translation.class.php');

$benchmark_start = microtime_float();

// make overview page
$source = CONTENTDIR."api_en/environment/";
$path = REFERENCEDIR . "/environment/";

make_necessary_directories($path."images/file");

$page = new Page("Environment (IDE)", "Environment", "Environment", '../../');
$page->content(file_get_contents($source."index.html"));
$page->language("en");

writeFile('reference/environment/index.html', $page->out());

copydirr($source.'/images', $path.'/images');

$benchmark_end = microtime_float();
$execution_time = round($benchmark_end - $benchmark_start, 4);

?>

<h2>Environment page generation Successful</h2>
<p>Generated files in <?=$execution_time?> seconds.</p>
