<?

require_once('../config.php');
require_once('lib/Ref.class.php');
require_once('lib/Translation.class.php');

$benchmark_start = microtime_float();

$path = BASEDIR;

// Update the files on the server
putenv('HOME=' . CONTENTDIR);
$where = CONTENTDIR . 'static/';

//`cd $where && /usr/bin/svn update libraries.html`;

// Switch from SVN to GIT, 14 FEB 2013
`cd $path && /usr/bin/git pull https://github.com/processing/processing-web/`;


$libraries = array('net', 'serial', 'video', 'dxf', 'pdf');
$lib_dir = REFERENCEDIR.'libraries/';

// Create Index
$index = CONTENTDIR."api_en/libraries/index.html";
$page = new Page('Libraries', 'Libraries');
$page->content(file_get_contents($index));
make_necessary_directories(BASEDIR.$lib_dir.'/images/include.php');
writeFile($lib_dir.'index.html', $page->out());

if (is_dir($lib_dir.'images')) { 
  rmdir($lib_dir.'images');
}
mkdir($lib_dir.'images', 0755); 
copydirr(CONTENTDIR."api_en/libraries/images", $lib_dir.'images');

// copy over the file for the contributed libraries
require_once('./contributions.php');
copy(CONTENTDIR."static/libraries.html", $lib_dir.'libraries.html');

// For each Library
foreach ($libraries as $lib) {
	$source = "api_en/LIB_$lib";
	$destination = "libraries/$lib";
	make_necessary_directories(REFERENCEDIR.$destination.'/images/include');

    // template and copy index
    $index = CONTENTDIR.$source.'/index.html';
    if($lib == 'pdf' || $lib == 'dxf') {
	  //$page = new Page(strtoupper($lib) . ' \\ Libraries', 'Libraries', 'Library-index');
	  $page = new Page(strtoupper($lib) . ' \\ Libraries', 'Libraries');
	} else {
	  //$page = new Page(ucfirst($lib) . ' \\ Libraries', 'Library-index');
	  $page = new Page(ucfirst($lib) . ' \\ Libraries', 'Libraries');
	}
	//$page->language("en");
    $page->content(file_get_contents($index));
    writeFile('reference/'.$destination.'/index.html', $page->out());
    
    // copy images directory
	//copydirr(CONTENTDIR.$source.'/images', REFERENCEDIR.$destination.'/images');
}

$benchmark_end = microtime_float();
$execution_time = round($benchmark_end - $benchmark_start, 4);

?>

<h2>Library Generation Successful</h2>
<p>Generated files in <?=$execution_time?> seconds.</p>