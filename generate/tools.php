<?

require_once('../config.php');
require_once('lib/Translation.class.php');
require_once('./contributions.php');
$benchmark_start = microtime_float();


$tools_dir = 'reference/tools';

$index = CONTENTDIR."api_en/tools/index.html";
$page = new Page('Tools', 'Tools', 'Tools');
$page->content(file_get_contents($index));
//make_necessary_directories(BASEDIR.$tools_dir.'/images/include.php');
writeFile($tools_dir.'/index.html', $page->out());

if (!is_dir(BASEDIR.$tools_dir.'/images')) { 	
  mkdir(BASEDIR.$tools_dir.'/images', 0757); 
}
copydirr(CONTENTDIR."api_en/tools/images", BASEDIR.$tools_dir.'/images');

// copy over the files for the contributed libraries
copy(CONTENTDIR."static/tools.html", BASEDIR.$tools_dir.'/tools.html');
	
$benchmark_end = microtime_float();
$execution_time = round($benchmark_end - $benchmark_start, 4);

?>

<h2>Tool Generation Successful</h2>
<p>Generated files in <?=$execution_time?> seconds.</p>