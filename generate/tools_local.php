<?

require_once('../config.php');
require_once('lib/Translation.class.php');

$benchmark_start = microtime_float();


$tools_dir = DISTDIR.'tools';

// Create Tools index
$index = CONTENTDIR."api_en/tools/index.html";
$page = new LocalPage('Tools', 'Tools', 'Tools', '../');
$page->content(file_get_contents($index));
writeFile('distribution/tools/index.html', $page->out());

// Create folder for images and copy them over
if (is_dir(DISTDIR.'tools/images')) { 
	rmdir(DISTDIR.'tools/images');
}
mkdir(DISTDIR.'tools/images', 0755); 
copydirr(CONTENTDIR.'api_en/tools/images', DISTDIR.'tools/images');

// Copy file for the contributed Tools
require_once('./contributions.php');
copy(CONTENTDIR."static/tools.html", DISTDIR.'tools/tools.html');


$benchmark_end = microtime_float();
$execution_time = round($benchmark_end - $benchmark_start, 4);

?>

<h2>Local tool generation successful!</h2>
<p>Generated files in <?=$execution_time?> seconds.</p>
