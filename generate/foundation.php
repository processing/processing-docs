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

//`cd $where && /usr/bin/svn update`;

// Switch from SVN to GIT, 14 FEB 2013
`cd $path && /usr/bin/git pull https://github.com/processing/processing-docs/`;

// make troubleshooting page
$source = CONTENTDIR."static/foundation/";

$page = new Page("Overview", "Overview");
$page->content(file_get_contents($source."overview.html"));
writeFile('overview/index.html', $page->out());
#copydirr($source.'/images', $path.'/images');

$page = new Page("Mission", "Mission");
$page->content(file_get_contents($source."mission.html"));
writeFile('mission/index.html', $page->out());

$page = new Page("Projects", "Projects");
$page->content(file_get_contents($source."projects.html"));
writeFile('projects/index.html', $page->out());

$page = new Page("People", "People");
$page->content(file_get_contents($source."people.html"));
writeFile('people/index.html', $page->out());

$page = new Page("Fellowships", "Fellowships");
$page->content(file_get_contents($source."fellowships.html"));
writeFile('fellowships/index.html', $page->out());

$page = new Page("Reports", "Reports");
$page->content(file_get_contents($source."reports.html"));
writeFile('reports/index.html', $page->out());

$page = new Page("Patrons", "Patrons");
$page->content(file_get_contents($source."patrons.html"));
writeFile('patrons/index.html', $page->out());

$page = new Page("Donate", "Donate");
$page->content(file_get_contents($source."donate.html"));
writeFile('donate/index.html', $page->out());

// Copy over the errata file for Processing: A Programming Handbook...
copy($source.'processing-errata.txt', $path.'books/processing-errata.txt');
// Copy over the media.zip file for Getting Started with Processing...
copy($source.'media.zip', $path.'books/media.zip');

// Copy over the images for the shop index
if (!is_dir($path.'shop')) { 
	mkdir($path.'shop', 0757);
}

if (!is_dir($path.'shop/imgs')) { 
	mkdir($path.'shop/imgs', 0757); 
}

if (is_dir($path.'shop/imgs')) { 
	copydirr($source.'shop/imgs', $path.'shop/imgs', null, 0757, false);
}

$page = new Page("Shop", "Shop");
$page->content(file_get_contents($source.'shop/'."index.html"));
writeFile('shop/index.html', $page->out());

$benchmark_end = microtime_float();
$execution_time = round($benchmark_end - $benchmark_start, 4);

?>

<h2>Static page generation Successful</h2>
<p>Generated files in <?=$execution_time?> seconds.</p>