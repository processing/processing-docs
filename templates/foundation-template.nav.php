<?php

$pages = array(

    'Overview'           => array('/', 0),

    'Mission'         => array('/mission/', 1), 
    
    'Projects'        => array('/projects/', 2), 
    'People'          => array('/people/', 3),  
    'Fellowships'      => array('/fellowships/', 4),  
    'Reports'       	  => array('/reports/', 5),
    'Patrons'       	  => array('/patrons/', 6),
    //'Donate'       	  => array('/donate/', 7),
        
    //'Download'        => array('/download/', 0),
    
    );


function navigation($section = '')
{  
    global $lang;
    global $translation;
    //$tr = $translation->navigation;  // Removed 22 Sep 2011  --CR

   // $abo = array('About', 'Overview', 'People', 'Foundation');
    //$ref = array('Reference', 'Language', 'A-Z', 'Libraries', 'Tools', 'Environment');
    //$learn = array('Learning', 'Tutorials', 'Basics', 'Topics', '3D', 'Library', 'Books');
    //$found = array('Overview', 'Mission', 'Projects', 'People', 'Fellowships', 'Reports', 'Patrons', 'Donate');
    $found = array('Overview', 'Mission', 'Projects', 'People', 'Fellowships', 'Reports', 'Patrons');

    $html = "\t\t\t".'<div id="navigation">'."\n";

    $id = (in_array($section, $ref) || in_array($section, $learn) || 
           in_array($section, $abo)) ? 'mainnav' : 'mainnav_noSub';   
            
    $html .= "\t\t\t\t".'<div class="navBar" id="mainnav">'."\n";
    
	    $html .= "\t\t\t\t\t" . l('Overview', $section == '') . "<br>\n";
	    $html .= "\t\t\t\t\t" . l('Mission', $section == 'Mission') . "<br>\n";
	    $html .= "\t\t\t\t\t" . l('Projects', $section == 'Projects') . "<br>\n";
	    $html .= "\t\t\t\t\t" . l('People', $section == 'People') . "<br>\n";
	    $html .= "\t\t\t\t\t" . l('Fellowships', $section == 'Fellowships') . "<br>\n";
	    $html .= "\t\t\t\t\t" . l('Reports', $section == 'Reports') . "<br>\n";
	    $html .= "\t\t\t\t\t" . l('Patrons', $section == 'Patrons') . "<br><br>\n";

	    //$html .= "\t\t\t\t\t" . l('Donate', $section == 'Donate') . "<br><br>\n";
	       
        $html .= "\t\t\t\t\t" . "<a href=\"https://twitter.com/processingOrg\"" . 'class="outward"' . "><span>&raquo;</span>Twitter</a><br> \n";
        $html .= "\t\t\t\t\t" . "<a href=\"https://www.facebook.com/page.processing\"" . 'class="outward"' . "><span>&raquo;</span>Facebook</a><br> \n";
    
    $html .= "\t\t\t\t</div>\n";

    return $html . "\t\t\t</div>\n";
}

function l($s, $c)
{
    global $pages;
    return "<a href=\"{$pages[$s][0]}\"" . ($c ? ' class="active"' : '') . ">$s</a>";
}

?>
