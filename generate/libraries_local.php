<?

require_once('../config.php');
require_once('lib/Ref.class.php');
require_once('lib/Translation.class.php');
require_once('./contributions.php');

$benchmark_start = microtime_float();


$libraries = array('net', 'serial', 'video', 'dxf', 'pdf');
$lib_dir = DISTDIR.'libraries';


// Create Library index
$index = CONTENTDIR."api_en/libraries/index.html";
$page = new LocalPage('Libraries', 'Libraries', 'Libraries', '../');
$page->content(file_get_contents($index));
writeFile('distribution/libraries/index.html', $page->out());

// For each Library
foreach ($libraries as $lib)
{
	$source = "api_en/LIB_$lib";
	$destination = "libraries/$lib";
	//make_necessary_directories(DISTDIR.$destination.'/images/include');
	
    $index = CONTENTDIR.$source.'/index.html';
    $page = new LocalPage(ucfirst($lib) . ' \\ Libraries', 'Libraries', 'Libraries', '../../');
    $page->content(file_get_contents($index));
    writeFile('distribution/'.$destination.'/index.html', $page->out());
}

if (is_dir(DISTDIR.'libraries/images')) { 
  rmdir(DISTDIR.'libraries/images');
}
mkdir(DISTDIR.'libraries/images', 0755); 
copydirr(CONTENTDIR."api_en/libraries/images", DISTDIR.'libraries/images');


$benchmark_end = microtime_float();
$execution_time = round($benchmark_end - $benchmark_start, 4);

?>

<h2>Local library generation successful!</h2>
<p>Generated files in <?=$execution_time?> seconds.</p>