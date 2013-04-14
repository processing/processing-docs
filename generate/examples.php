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

# --------------------------------- Examples

$subdir = 'Examples';

$catBasics = get_examples_list('examples_basics.xml');
$dirBasics = EXAMPLESOURCEDIR .'Basics/';
// $break_after = array('Control', 'Math');

$catTopics = get_examples_list('examples_topics.xml');
$dirTopics = EXAMPLESOURCEDIR .'Topics/';
// $break_after = array('GUI', 'Textures');

//Create Basics files
$count = 0;
foreach ($catBasics as $cat => $array) {
    if ($dp = opendir($dirBasics.$cat)) {
        while ($fp = readdir($dp)) {
            if (substr($fp, 0, 1) != '.') {
                $ex = new Example($fp, "Basics/".$cat, $subdir);
                if (!$local) {
                  $ex->output_file($catBasics);
                } else {
                  $ex->output_file($catBasics, "../../");
                }
                $count++;
            }
        }
    }
}

//Create Topics files
$count = 0;
foreach ($catTopics as $cat => $array) {
    if ($dp = opendir($dirTopics.$cat)) {
        while ($fp = readdir($dp)) {
            if (substr($fp, 0, 1) != '.') {
                $ex = new Example($fp, "Topics/".$cat, $subdir);
                if (!$local) {
                  $ex->output_file($catTopics);
                } else {
                  $ex->output_file($catTopics, "../../");
                }
                $count++;
            }
        }
    }
}

//Create Examples page
$page = new Page('Examples', 'Examples', "", "../../");
$page->subtemplate('template.examples-main.html');

//Create Basics html
$html  = "<b>Basic Examples</b>. <i>Short prototypical programs exploring the basics of programming with Processing.</i><br /><br /><br />";
$html .= "<ul class=\"examples\">\n";
foreach ($catBasics as $cat => $array) {
    $html .= "<li><ul><li><b>$cat</b></li><br />";
    foreach ($array as $file => $name) {
        $thisfile = strtolower($file);
        $html .= "\t<li><a href=\"$thisfile\">$name</a></li>\n";
    }
    $html .= '</ul></li>';
}
$html .= "</ul>";

//Create Topics html
$html .= "<b>Topic Examples</b>. <i>Short programs related to animation, drawing, interaction, motion, simulation, and more...</i><br /><br /><br />";
$html .= "<ul class=\"examples\">\n";
foreach ($catTopics as $cat => $array) {
    $html .= "<li><ul><li><b>$cat</b></li><br />";
    foreach ($array as $file => $name) {
        $thisfile = strtolower($file);
        $html .= "\t<li><a href=\"$thisfile\">$name</a></li>\n";
    }
    $html .= '</ul></li>';
}
$html .= "</ul>";

$page->content($html);
writeFile('learning/'.strtolower($subdir).'/index.html', $page->out());

$benchmark_end = microtime_float();
$execution_time = round($benchmark_end - $benchmark_start, 4);

?>

<h2>Examples pages generation Successful</h2>
<p>Generated <?= $count+1 ?> files in <?=$execution_time?> seconds.</p>
<h2>Updated <?=$where?> </h2>


<?

function get_examples_list($exstr){
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

function removesymbols($str){
    return preg_replace("/\W/", "", $str);
}

?>