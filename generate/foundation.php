<?php

require('../config-f.php');
//require_once(TEMPLATEDIR.'foundation-template.php');
$benchmark_start = microtime_float();

$source = CONTENTDIR."static/foundation-site";
$path = BASEDIR;

$where = CONTENTDIR . 'static/foundation-site';
putenv('HOME=' . CONTENTDIR);

$source = CONTENTDIR."static/foundation-site/";
$dest = $path."foundation-site/";
//$dest = FOUNDDIR; 

$page = new Page("Foundation Overview", "Foundation Overview");
$page->content(file_get_contents($source."overviewf.html"));
writeFile($dest."index.html", $page->out());
//copydirr($source.'/imgs', $dest.'/images');

//echo("hey");
//echo($dest);

$page = new Page("Mission", "Mission");
$page->content(file_get_contents($source."mission.html"));
writeFile($dest."mission/index.html", $page->out());

$page = new Page("Projects", "Projects");
$page->content(file_get_contents($source."projects.html"));
writeFile($dest."projects/index.html", $page->out());

$page = new Page("Foundation People", "Foundation People");
$page->content(file_get_contents($source."peoplef.html"));
writeFile($dest."people/index.html", $page->out());

$page = new Page("Fellowships", "Fellowships");
$page->content(file_get_contents($source."fellowships.html"));
writeFile($dest."fellowships/index.html", $page->out());

$page = new Page("Reports", "Reports");
$page->content(file_get_contents($source."reports.html"));
writeFile($dest."reports/index.html", $page->out());

$page = new Page("Patrons", "Patrons");
$page->content(file_get_contents($source."patrons.html"));
writeFile($dest."patrons/index.html", $page->out());

//$page = new Page("Donate", "Donate");
//$page->content(file_get_contents($source."donate.html"));
//writeFile($dest."donate/index.html", $page->out());

// After the pages are created, copy them to the Foundation subdomain
//cp ../../img/processing-web.png ../../distribution/img/

`cp ../processing-site/* /var/www/foundation/`;


$benchmark_end = microtime_float();
$execution_time = round($benchmark_end - $benchmark_start, 4);

?>

<h2>Static page generation Successful</h2>
<p>Generated files in <?=$execution_time?> seconds.</p>