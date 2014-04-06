<?

require('../config.php');
$benchmark_start = microtime_float();

// make troubleshooting page
$source = CONTENTDIR."static";
$path = BASEDIR;


// update the files on the server via SVN

// look for the .subversion folder somewhere else
// otherwise will go looking for /home/root/.subversion or some other user
$where = CONTENTDIR . 'static';
putenv('HOME=' . CONTENTDIR);


`cd $where && /usr/bin/svn update`;

// make troubleshooting page
$source = CONTENTDIR."static/";
#$path = BASEDIR;

$page = new Page("Overview", "Overview");
$page->content(file_get_contents($source."overview.html"));
writeFile('overview/index.html', $page->out());
#copydirr($source.'/images', $path.'/images');

$page = new Page("Foundation", "Foundation");
$page->content(file_get_contents($source."foundation.html"));
writeFile('foundation/index.html', $page->out());

$page = new Page("People", "People");
$page->content(file_get_contents($source."people.html"));
writeFile('people/index.html', $page->out());


$benchmark_end = microtime_float();
$execution_time = round($benchmark_end - $benchmark_start, 4);

?>

<h2>About page generation Successful</h2>
<p>Generated files in <?=$execution_time?> seconds.</p>
<!--<p>Page put here: <?=$source."faq.html"?></p>-->
<!--<p>Page put here: <?=$path.'faq.html'?></p>-->