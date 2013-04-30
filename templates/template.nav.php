<?

$pages = array(

    'Cover'           => array('/', 0),

    'Exhibition'      => array('/exhibition/', 1), 
    
    'Learning'        => array('/learning/', 1), 
    	'Tutorials'   => array('/learning/', 2),  
    	'Examples'      => array('/learning/examples/', 2),  
     #   '3D'          => array('/learning/3d/', 2),  
     #   'Library'     => array('/learning/library/', 2),  
    'Books'       	  => array('/learning/books/', 2),
            
    'Reference'       => array('/reference/', 1),
        'Language'    => array('/reference/', 2),
        'A-Z'         => array('/reference/alpha.html', 2),
        'Libraries'   => array('/reference/libraries/', 2),
        'Tools'       => array('/reference/tools/', 2),
        'Environment' => array('/reference/environment/', 2), 
        
    'Download'        => array('/download/', 1),
    
    'Shop'            => array('/shop/', 1),
        
    'About'           => array('/overview/', 1),
        'Overview'    => array('/overview/', 2),
        'People'      => array('/people/', 2),
        'Foundation'     => array('/foundation/', 2),
    
    'FAQ'             => array('http://wiki.processing.org/w/FAQ', 1),
    
    );


function navigation($section = '')
{  
    global $lang;
    global $translation;
    //$tr = $translation->navigation;  // Removed 22 Sep 2011  --CR

    $abo = array('About', 'Overview', 'People', 'Foundation');
    $ref = array('Reference', 'Language', 'A-Z', 'Libraries', 'Tools', 'Environment');
    $learn = array('Learning', 'Tutorials', 'Basics', 'Topics', '3D', 'Library', 'Books');

    $html = "\t\t\t".'<div id="navigation">'."\n";

    $id = (in_array($section, $ref) || in_array($section, $learn) || 
           in_array($section, $abo)) ? 'mainnav' : 'mainnav_noSub';   
            
    $html .= "\t\t\t\t".'<div class="navBar" id="'.$id.'">'."\n";
    
	    $html .= "\t\t\t\t\t" . l('Cover', $section == 'Cover') . "<br><br>\n";

	    $html .= "\t\t\t\t\t" . l('Download', $section == 'Download') . "<br><br>\n";

	    $html .= "\t\t\t\t\t" . l('Exhibition', $section == 'Exhibition') . "<br><br>\n";

	    $html .= "\t\t\t\t\t" . l('Reference', $section == 'Reference') . "<br>\n";
	    $html .= "\t\t\t\t\t" . l('Libraries', $section == 'Libraries') . "<br>\n";
	    $html .= "\t\t\t\t\t" . l('Tools', $section == 'Tools') . "<br>\n";
	    $html .= "\t\t\t\t\t" . l('Environment', $section == 'Environment') . "<br><br>\n";

	    $html .= "\t\t\t\t\t" . l('Tutorials', $section == 'Tutorials') . "<br>\n";
	    $html .= "\t\t\t\t\t" . l('Examples', $section == 'Examples') . "<br>\n";
	    $html .= "\t\t\t\t\t" . l('Books', $section == 'Books') . "<br><br>\n";
	    
	    $html .= "\t\t\t\t\t" . l('Overview', $section == 'About') . "<br> \n";
	    $html .= "\t\t\t\t\t" . l('People', $section == 'People') . "<br>\n";
	    $html .= "\t\t\t\t\t" . l('Foundation', $section == 'Foundation') . "<br><br>\n";

	    $html .= "\t\t\t\t\t" . l('Shop', $section == 'Shop') . "<br><br>\n";
	       
	    $html .= "\t\t\t\t\t" . "<a href=\"https://twitter.com/processingOrg\"" . 'class="outward"' . "><span>&raquo;</span>Twitter</a><br> \n";
	    $html .= "\t\t\t\t\t" . "<a href=\"http://forum.processing.org\"" . 'class="outward"' . "><span>&raquo;</span>Forum</a><br> \n";
	    $html .= "\t\t\t\t\t" . "<a href=\"http://wiki.processing.org\"" . 'class="outward"' . "><span>&raquo;</span>Wiki</a><br> \n";
	    $html .= "\t\t\t\t\t" . "<a href=\"https://github.com/processing/processing-web/issues?state=open\"" . 'class="outward"' . "><span>&raquo;</span>Issues</a><br> \n";
	    $html .= "\t\t\t\t\t" . "<a href=\"https://github.com/processing\"" . 'class="outward"' . "><span>&raquo;</span>Source</a><br> \n";
    
    $html .= "\t\t\t\t</div>\n";

    return $html . "\t\t\t</div>\n";
}

function l($s, $c)
{
    global $pages;
    return "<a href=\"{$pages[$s][0]}\"" . ($c ? ' class="active"' : '') . ">$s</a>";
}

function short_nav($section)
{
    $html  = "\t\t\t".'<div id="navigation">'."\n";
    $html .= "\t\t\t\t".'<div class="navBar" id="mainnav_noSub">'."\n";
    
    $html .= "\t\t\t\t\t<a href=\"http://processing.org/\"" . ($section == 'Cover' ? ' class="active"' : '') . ">Cover</a> \\ \n";
    $html .= "\t\t\t\t\t<a href=\"/reference/index.html\"" . ($section == 'Language' ? ' class="active"' : '') . ">Language</a> \\ \n";
    $html .= "\t\t\t\t\t<a href=\"/reference/libraries/index.html\"" . ($section == 'Libraries' ? ' class="active"' : '') . ">Libraries</a> \\ \n";
    $html .= "\t\t\t\t\t<a href=\"/reference/tools/index.html\"" . ($section == 'Tools' ? ' class="active"' : '') . ">Tools</a> \\ \n";
    $html .= "\t\t\t\t\t<a href=\"/reference/environment/index.html\"" . ($section == 'Environment' ? ' class="active"' : '') . ">Environment</a>\n";
       
    $html .= "\t\t\t\t</div>\n";
    $html .= "\t\t\t</div>\n";
    
    return $html;
}

function local_nav($section, $rel_path='')
{
    $html  = "\t\t\t".'<div id="navigation">'."\n";
    $html .= "\t\t\t\t".'<div class="navBar" id="mainnav">'."\n";

    $html .= "\t\t\t\t\t<a href=\"{$rel_path}index.html\"" . ($section == 'Language' ? ' class="active"' : '') . ">Language</a> (";
    $html .= "<a href=\"{$rel_path}alpha.html\"" . ($section == 'A-Z' ? ' class="active"' : '') . ">A-Z</a>)<br> \n";
    $html .= "\t\t\t\t\t<a href=\"{$rel_path}libraries/index.html\"" . ($section == 'Libraries' ? ' class="active"' : '') . ">Libraries</a><br> \n";
    $html .= "\t\t\t\t\t<a href=\"{$rel_path}tools/index.html\"" . ($section == 'Tools' ? ' class="active"' : '') . ">Tools</a><br> \n";
    $html .= "\t\t\t\t\t<a href=\"{$rel_path}environment/index.html\"" . ($section == 'Environment' ? ' class="active"' : '') . ">Environment</a>\n";
    
    $html .= "\t\t\t\t</div>\n";
    $html .= "\t\t\t</div>\n";
    
    return $html;    
}


// Removed 22 Sep 2011  --CR

/**

function reference_nav($current = '')
{
    global $lang;
    global $translation;
    global $LANGUAGES;
    $tr = $translation->navigation;
    
    $html = "<a href=\"index.html\">$tr[abridged]</a>";
    if ($LANGUAGES[$lang][2]) {
        $html .= " (<a href=\"index_alpha.html\">$tr[az]</a>)";
    }
    $html .= " \ <a href=\"index_ext.html\">$tr[complete]</a>";
    if ($LANGUAGES[$lang][2]) {
        $html .= " (<a href=\"index_alpha_ext.html\">$tr[az]</a>)";
    }
    $html .= " \ <a href=\"changes.html\">$tr[changes]</a>";
    return $html;
}

*/

function language_nav($current)
{
    global $LANGUAGES;
    global $FINISHED;
    if (count($FINISHED) < 2) { return ''; }
    
    $html = "\t".'Language: <select name="nav" size="1" class="refnav" onChange="javascript:gogo(this)">'."\n";
    foreach ($FINISHED as $code) {
        if ($LANGUAGES[$code][3] != '' ) {
            $sel = ($current == $code) ? ' selected="selected"' : '';
            $html .= "\t\t<option value=\"{$LANGUAGES[$code][3]}\"$sel>{$LANGUAGES[$code][0]}</option>\n";
        }
    }
    $html .= "\t</select>\n";
    return $html;
}



function library_nav($current=null)
{
    $html = "\n\t<span class=\"lib-nav\">\n";
    $html .= "\t\t<a href=\"../index.html\">Libraries</a>\n";
    if ($current) {
        $html .= "\t\t \ <a href=\"index.html\">".ucfirst($current)."</a>\n";
    }
    $html .= "\t</span>\n";
    return $html;
}

function examples_nav($current) {
    // $html = "\n\t<div id=\"examples-nav\">\n";
}



?>
