<?

require('../config.php');

$benchmark_start = microtime_float();

$source = CONTENTDIR."static/tutorials/";
$path = BASEDIR;

$where = CONTENTDIR . 'static/tutorials';
putenv('HOME=' . CONTENTDIR);

// Switch from SVN to GIT, 14 FEB 2013
`cd $path && /usr/bin/git pull https://github.com/processing/processing-web/`;

// Copy over the images for the tutorials index
if (!is_dir($path.'tutorials/imgs')) {
	mkdir($path.'tutorials/imgs', 0757); 
}

if (is_dir($path.'tutorials/imgs')) { 
	copydirr($source.'imgs', $path.'tutorials/imgs', null, 0757, true);
}

// Index page
$page = new Page("Tutorials", "Tutorials", "Tutorials", "../");
$page->content(file_get_contents($source."index.html"));
writeFile('tutorials/index.html', $page->out());

// Start making the individual tutorial pages

if( ! $xml = simplexml_load_file($source.'tutorials.xml') ) 
{
	echo 'XML file missing'; 
} 
else 
{

	foreach( $xml as $tutorial ) 
  {
		$title = $tutorial->title;
		$directory = $tutorial->directory;
		$imgs = $tutorial->imgs;
		$code = $tutorial->code;
		echo 'About to generate tutorial '.$title.' in directory '.$directory.', imgs dir = '.$imgs.', code dir = '.$code.'<br \>';
		echo 'Copying '.$source.$directory.'/index.html to ' . 'tutorials/'.$directory.'/index.html<br \>';
		$page = new Page($title, "Tutorials", "Tutorials", "../../");
		$page->content(file_get_contents($source.$directory.'/index.html'));
		writeFile('tutorials/'.$directory.'/index.html', $page->out());
		if ($imgs == 'true') {
			$newpath = $path.'tutorials/'.$directory.'/imgs';
			if (!is_dir($newpath)) {
				mkdir($newpath, 0757);
			}
			if (is_dir($newpath)) {
				copydirr($source.$directory.'/imgs', $newpath, null, 0757, true);
			}
		}
		if ($code == 'true') {
			$newpath = $path.'tutorials/'.$directory.'/code';
			if (!is_dir($newpath)) {
				mkdir($newpath, 0757);
			}
			if (is_dir($newpath)) {
				copydirr($source.$directory.'/code', $newpath, null, 0757, true);
			}
		}
	}
} 


$benchmark_end = microtime_float();
$execution_time = round($benchmark_end - $benchmark_start, 4);

?>

<h2>Static page generation Successful</h2>
<h2>Updated <?=$where?> </h2>
<p>Generated files in <?=$execution_time?> seconds.</p>