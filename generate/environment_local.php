<?
require('../config.php');
require('lib/Translation.class.php');

$benchmark_start = microtime_float();


$source = CONTENTDIR."/api_en/environment/";
$path = DISTDIR."/environment/";

$page = new LocalPage('Environment (IDE)', 'Environment', 'Environment', '../');
$page->content(file_get_contents($source.'index.html'));
$page->language($lang);
writeFile($path.'index.html', $page->out());

if (is_dir(DISTDIR.'environment/images')) { 
  rmdir(DISTDIR.'environment/images');
}
mkdir(DISTDIR.'environment/images', 0755); 
copydirr(CONTENTDIR."api_en/environment/images", DISTDIR.'environment/images');


$benchmark_end = microtime_float();
$execution_time = round($benchmark_end - $benchmark_start, 4);

?>

<h2>Environment page generation Successful</h2>
<p>Generated files in <?=$execution_time?> seconds.</p>
