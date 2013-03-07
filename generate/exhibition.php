<?
define('CURATED_PER_PAGE', 12);
define('NETWORK_FIRST_PAGE', 25);
define('NETWORK_PER_PAGE', 90);

if (!defined('SUBMIT')) {
	require('../config.php');
}

require(GENERATEDIR.'lib/Curated.class.php');

// update the files on the server via SVN
// look for the .subversion folder somewhere else
// otherwise will go looking for /home/root/.subversion or some other user
$source = CONTENTDIR;
$path = BASEDIR;
$where = CONTENTDIR;
$there = CONTENTDIR;

putenv('HOME=' . CONTENTDIR);

//`cd $there && /usr/bin/svn update curated.xml`;
//`cd $there && /usr/bin/svn update curated_images/`;

// Switch from SVN to GIT, 14 FEB 2013
`cd $path && /usr/bin/git pull https://github.com/processing/processing-web/`;

// Copy over the images for the tutorials index
if (!is_dir($path.'exhibition/images')) { 
	mkdir($path.'exhibition/images', '0757'); 
}

if (is_dir($path.'exhibition/images')) { 
	copydirr($source.'curated_images', $path.'exhibition/images', null, 0757, true);
}

/******************************************** CURATED ***/

function get_curated($curated, $start = 0, $num = 12)
{
    // output html
    $html = '<table width="448" cellspacing="0" cellpadding="0" border="0">';
    $j = 0;
    for ($i = $start; $i < $start+$num; $i++) {
    	if ($curated[$i]) {
    
   	if ($j % 2 == 0) $html .= '<tr>';
            $html .= '<td>' . $curated[$i]->display() . '</td>';
            if ($j % 2 != 0) $html .= '</tr>';
            $j++;
        }
    }
    if ($j % 2 != 0) $html .= '<td>&nbsp;</td></tr>';
    return $html . '</table>';
}

function get_curated_one($curated, $start = 0, $num = 12)
{
	// output html
	$html = '<table width="224" cellspacing="0" cellpadding="0" border="0">';
	$j = 0;
	for ($i = $start; $i < $start+$num; $i++) {
		if ($curated[$i]) {
			$html .= '<tr>';

			$html .= '<td>' . $curated[$i]->display() . '</td>';
			$html .= '</tr>';
			$j++;
		}
	}

   // if ($j % 2 != 0) $html .= '<td>&nbsp;</td></tr>';

   return $html . '</table>';
}

// function get_curated_three($curated, $start = 0, $num = 12)
// {
//   // output html

//   $html = '<table width="687" cellspacing="0" cellpadding="0" border="0">';
//   $j = 0;

//   for ($i = $start; $i < $start+$num; $i++) {
//     if ($curated[$i]) {
//       if ($j % 3 == 0) $html .= '<tr>';
//       $html .= '<td>' . $curated[$i]->display() . '</td>';
//       if ($j % 3 == 2) $html .= '</tr>';
//       $j++;
//     }
//   }

//   if ($j % 3 == 1) $html .= '<td>&nbsp;</td></tr>';

//   if ($j % 3 == 2) $html .= '<td>&nbsp;</td><td>&nbsp;</td></tr>';

//   return $html . '</table>';
// }

function get_curated_three($curated, $start = 0, $num = 12)
{
  // output html

  $html = '<table width="687" cellspacing="0" cellpadding="0" border="0">';
  $j = 0;

  for ($i = $start; $i < $start+$num; $i++) {
    if ($curated[$i]) {
      if ($j % 3 == 0) $html .= '<tr>';
      $html .= '<td>' . $curated[$i]->display() . '</td>';
      if ($j % 3 == 2) $html .= '</tr>';
      $j++;
    }
  }

  if ($j % 3 == 1) $html .= '<td>&nbsp;</td></tr>';

  if ($j % 3 == 2) $html .= '<td>&nbsp;</td><td>&nbsp;</td></tr>';

  return $html . '</table>';
}

function get_curated_short()
{
    $curated = curated_xml(4);
    
    // output html
    foreach ($curated as $c) {
        $html .= $c->display_short_home();
    }
    return $html;
}


function curated_xml($num)
{
    // open and parse curated.xml
    $xml =& openXML('curated.xml');
    
    // get software nodes
    $softwares = $xml->getElementsByTagName('software');
    $softwares = $softwares->toArray();
    
    // create curated objects
    $i = 1;
    foreach ($softwares as $software) {
        $curated[] = new Curated($software);
        if ($i >= $num && $num != 'all') { break; }
        $i++;
    }
       
    return $curated;
}

if (!defined('COVER')) {

    $benchmark_start = microtime_float();
	 // get xml
    $curated = curated_xml('all');
    // count number of items
    $ctotal = count($curated);
    // count number of pages needed
    $cnum_pages = ceil($ctotal / CURATED_PER_PAGE);
    
    // create and write the other pages

    for ($i = 0; $i <= $cnum_pages; $i++) {
        $page = new Page('Exhibition Archives', 'Exhibition');
        $page->subtemplate('template.curated.archive.html');
        $page->set('curated_nav', curated_nav($cnum_pages, $i+1));
        $page->set('exhibition', get_curated_three($curated, CURATED_PER_PAGE*$i, CURATED_PER_PAGE));
        //$pagename = sprintf("curated_page_%d.html", $i+1);
        if ($i == 0 ) {
          $pagename = sprintf("index.html");
        } else {
          $pagename = sprintf("curated_page_%d.html", $cnum_pages-$i);
        }
        writeFile("exhibition/".$pagename, $page->out());
    }

    $benchmark_end = microtime_float();
    $execution_time = round($benchmark_end - $benchmark_start, 4);
    
    if (!defined('SUBMIT')) {
    
    }
    
}

function curated_nav($num, $current)
{
    $html = '<p class="exhibition-nav">';

    for ($i = $num; $i > 0; $i--) {
    	if ($i == $num) {
    	  if (($num-$i+1) == $current) {
    	    $links[] = sprintf("Page: %d", $i);
    	  } else {
    	    $links[] = sprintf("Page: <a href=\"./\">%d</a>", $i);
    	  }
    	} else {
          $links[] = (($num-$i+1) == $current) ? $i : sprintf("<a href=\"curated_page_%d.html\">%d</a>", $i, $i);
    	}
    }

    $html .= implode(' \\ ', $links);
    $html .= '</p>&nbsp;';
    return $html;
}

?>