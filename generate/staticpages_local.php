<?

require('../config.php');
$benchmark_start = microtime_float();

// make troubleshooting page
$source = CONTENTDIR."static/";
#$path = BASEDIR;

$page = new LocalPage('Copyright', "Copyright", "Copyright", './');
$page->content(file_get_contents($source."copyright.html"));
writeFile('distribution/copyright.html', $page->out());

$page = new LocalPage('People', "People", "People", '../');
$page->content(file_get_contents($source."people.html"));
writeFile('distribution/people.html', $page->out());


$benchmark_end = microtime_float();
$execution_time = round($benchmark_end - $benchmark_start, 4);

?>

<h2>Local static pages generation successful!</h2>
<p>Generated files in <?=$execution_time?> seconds.</p>