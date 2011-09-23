<?

require_once('../config.php');
require_once('lib/Ref.class.php');
require_once('lib/Translation.class.php');

$benchmark_start = microtime_float();





$where = CONTENTDIR . 'static/';

putenv('HOME=' . CONTENTDIR);


// update the file on the server

`cd $where && /usr/bin/svn update libraries.html`;

// each lib
$libraries = array('net', 'serial', 'video', 'dxf', 'pdf');
$lib_dir = 'reference/libraries';

// Create Index
$index = CONTENTDIR."api_en/libraries/index.html";
$page = new Page('Libraries', 'Libraries');
$page->content(file_get_contents($index));
make_necessary_directories(BASEDIR.$lib_dir.'/images/include.php');
writeFile($lib_dir.'/index.html', $page->out());
copydirr(CONTENTDIR."api_en/libraries/images", BASEDIR.$lib_dir.'/images');

// copy over the file for the contributed libraries
copy(CONTENTDIR."static/libraries.html", BASEDIR.$lib_dir.'/libraries.html');

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