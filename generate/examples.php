<? 

require('../config.php');
require('lib/Example.class.php');
$benchmark_start = microtime_float();

$local = false;

define('EXAMPLESOURCEDIR', '../../processing/java/examples/');

$path = BASEDIR;
$where = EXAMPLESOURCEDIR;
$there = CONTENTDIR;
putenv('HOME=' . CONTENTDIR);

//`cd $there && /usr/bin/svn update examples_basics.xml`;
//`cd $there && /usr/bin/svn update examples_topics.xml`;
//`cd $where && /usr/bin/svn update`;

// Switch from SVN to GIT, 14 FEB 2013
`cd $path && /usr/bin/git pull https://github.com/processing/processing-web/`;


# --------------------------------- Basics

$categories = get_examples_list('examples_basics.xml');
$break_after = array('Control', 'Math');
$subdir = 'Basics';
$dir = EXAMPLESOURCEDIR . $subdir.'/';

$count = 0;
foreach ($categories as $cat => $array) {
	echo $cat;
    if ($dp = opendir($dir.$cat)) {
        while ($fp = readdir($dp)) {
            if (substr($fp, 0, 1) != '.') {
                $ex = new Example($fp, $subdir."/".$cat, $subdir);
                //$ex = new Example($fp, $cat);
                if (!$local) {
                  $ex->output_file($categories);
                } else {
                  $ex->output_file($categories, "../../");
                }
                $count++;
            }
        }
    }
}

$page = new Page('Basics', 'Basics', "", "../../");
$page->subtemplate('template.examples-basics.html');

$html = "<div class=\"ref-col\">\n";
foreach ($categories as $cat => $array) {
    
    $html .= "<p><br /><b>$cat</b><br /><br />";
    foreach ($array as $file => $name) {
        $thisfile = strtolower($file);
        $html .= "\t<a href=\"$thisfile\">$name</a><br />\n";
    }
    #echo '</p>';
    $html .= '</p>';
    
    if (in_array($cat, $break_after)) {
        $html .= "</div><div class=\"ref-col\">";
    }
}
$html .= "</div>";

$page->content($html);
writeFile('learning/'.strtolower($subdir).'/index.html', $page->out());


# --------------------------------- Topics

$categories = get_examples_list('examples_topics.xml');
$break_after = array('GUI', 'Textures');
$subdir = 'Topics';
$dir = EXAMPLESOURCEDIR .$subdir.'/';

$count = 0;
foreach ($categories as $cat => $array) {
    if ($dp = opendir($dir.$cat)) {
        while ($fp = readdir($dp)) {
            if (substr($fp, 0, 1) != '.') {
                $ex = new Example($fp, $subdir."/".$cat, $subdir);
                //$ex = new Example($fp, $cat);
                if (!$local) {
                  $ex->output_file($categories);
                } else {
                  $ex->output_file($categories, "../../");
                }
                $count++;
            }
        }
    }
}

$page = new Page('Topics', 'Topics', "", "../../");
$page->subtemplate('template.examples-topics.html');

$html = "<div class=\"ref-col\">\n";
foreach ($categories as $cat => $array) {
    $html .= "<p><br /><b>$cat</b><br /><br />";
    foreach ($array as $file => $name) {
        $thisfile = strtolower($file);
        $html .= "\t<a href=\"$thisfile\">$name</a><br />\n";
    }
    #echo '</p>';
    $html .= '</p>';
    
    if (in_array($cat, $break_after)) {
        $html .= "</div><div class=\"ref-col\">";
    }
}
$html .= "</div>";

$page->content($html);
writeFile('learning/'.strtolower($subdir).'/index.html', $page->out());


$benchmark_end = microtime_float();
$execution_time = round($benchmark_end - $benchmark_start, 4);

?>

<h2>Examples pages generation Successful</h2>
<p>Generated <?= $count+1 ?> files in <?=$execution_time?> seconds.</p>
<h2>Updated <?=$where?> </h2>


<?

function get_examples_list($exstr)
{
    $xml = openXML($exstr);
    $my_cats = array();
    foreach ($xml->childNodes as $c) {
        $name = htmlspecialchars($c->getAttribute('label'));
    
        if ($c->childCount > 0) {
            foreach ($c->childNodes as $s) {
                if ($s->nodeType == 1) {
                    $my_cats[$name][$s->getAttribute('file')] = trim($s->firstChild->nodeValue);
                }
            }
        }
    }
    return $my_cats;
}

function removesymbols($str)
{
    return preg_replace("/\W/", "", $str);
}

?>