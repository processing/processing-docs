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

$page = new Page("Overview", "Overview2");
$page->content(file_get_contents($source."overview.html"));
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

$page = new Page("People", "People2");
$page->content(file_get_contents($source."people.html"));
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

echo("Starting to copy the site...");
`cd $path && cp -r foundation-site/* /var/www/foundation/`;
echo("done!");

echo("Starting to copy the CSS...");
`cd $path && rm -rf /var/www/foundation/css/ && mkdir /var/www/foundation/css/ && cp -r css/* /var/www/foundation/css/`;
echo("done!");

echo("Starting to copy the JavaScript...");
`cd $path && rm -rf /var/www/foundation/javascript/ && mkdir /var/www/foundation/javascript/ && cp -r javascript/* /var/www/foundation/javascript/`;
echo("done!");

echo("Starting to copy the images...");
`cd $path && rm -rf /var/www/foundation/images/ && mkdir /var/www/foundation/images/ && cp -r content/static/foundation-site/imgs/* /var/www/foundation/images/`;
echo("done!");

$benchmark_end = microtime_float();
$execution_time = round($benchmark_end - $benchmark_start, 4);

?>

<h2>Static page generation Successful</h2>
<p>Generated files in <?=$execution_time?> seconds.</p>