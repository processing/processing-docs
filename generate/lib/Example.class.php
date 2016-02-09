<?php

class Example
{
    var $name;
    var $cat;
    var $p5_file;
    var $pde_file;
    var $applet;
    var $data_dir;
    var $doc;
    var $pde_code; // CR -- I think SM left this out, needed based on his name changes
    var $p5_code;
    var $code_display;
    var $sub;
    var $width;
    var $height;
    
    function Example($name, $cat, $sub)
    {
        $this->name = $name;
        $this->cat = $cat;
        $this->sub = $sub;
		
        //Two directories; one for the p5 version, to be rendered on the page,
        //and one for the original PDE, whose text is displayed on the page.
        $p5_dir = EXAMPLESOURCEJSDIR . $cat . '/' . $name . '/';
		$pde_dir = EXAMPLESOURCEDIR . $cat . '/' . $name . '/';
		
        //p5 first
		$this->data_dir = $p5_dir . 'data/';
        $this->p5_file = file_get_contents($p5_dir . $name .'.js');

        if ($handle = opendir($p5_dir)) {
          while (false !== ($newfile = readdir($handle))) {
            if (preg_match("/js/", $newfile)) {
              if (strcmp($name.'.js', $newfile) != 0) {
                $this->p5_file .= "\n\n\n";
                $this->p5_file .= file_get_contents($p5_dir . $newfile); 
              }
            }
          }
          closedir($handle);
        }

        $this->p5_code = $this->p5_file;
        //$this->p5_code = implode("\n", $full_code_lines);
	
        //PDE second
		$this->pde_file = file_get_contents($pde_dir . $name .'.pde');

        if ($handle = opendir($pde_dir)) {
          while (false !== ($newfile = readdir($handle))) {
            //if ($file != "." && $file != "..") {
            if (preg_match("/pde/", $newfile)) {
              //echo " $newfile\n";
              if (strcmp($name.'.pde', $newfile) != 0) {
				$this->pde_file .= "\n\n\n";
				#$this->file .= file_get_contents(CONTENTDIR.'examples/'.$cat.'/'.$name.'/'.$newfile); 
				$this->pde_file .= file_get_contents($pde_dir . $newfile); 
              }
            }
          }
          closedir($handle);
        }


        /*
        //OLD CODE -- BACKUP
        if ($handle = opendir($pde_dir)) {
          while (false !== ($newfile = readdir($handle))) {
            //if ($file != "." && $file != "..") {
            if (preg_match("/pde/", $newfile)) {
              //echo " $newfile\n";
              if (strcmp($name.'.pde', $newfile) != 0) {
                $this->file .= "\n\n\n";
                #$this->file .= file_get_contents(CONTENTDIR.'examples/'.$cat.'/'.$name.'/'.$newfile); 
                $this->file .= file_get_contents($pde_dir . $newfile); 
              }
            }
          }
          closedir($handle);
        }
        */
        
        //preg_match("/(^|\s|;)size\s*\(\s*(\d+)\s*,\s*(\d+),?\s*([^\)]*)\s*\)/", $this->file, $matches);
        //$this->width = $matches[2];
        //$this->height = $matches[3];
        
        $this->split_file();
    }
    
    function split_file()
    {
        $lines = explode("\n", $this->pde_file);
        $doc_lines = array();
        $code_lines = array();
        $full_code_lines = array();
        $doc = true;
        foreach ($lines as $line) {
            # Change for new comment style - cr
            if (preg_match("/\*\//", $line) && $doc) {
              $doc = false;  # End the documentation
              #echo "$line\n";
              #break;
              continue;
            }
            if ($doc) {
	      # Change for new comment style - cr
	      if (!preg_match("/\/\*\*/", $line)) {
                  $line = str_replace(" * ", "", $line);
                  $line = trim($line);
                  if($line == "") {
                    $line = "\n\n";
                  }
                  $doc_lines[] = $line;
                }
            } else {
                $code_lines[] = htmlspecialchars($line);
                $full_code_lines[] = $line;
            }
        }
        $doc_lines[0] = "<strong>" . $doc_lines[0] . "</strong>";
        $this->doc = implode(" ", $doc_lines);
        //$this->p5_code = implode("\n", $full_code_lines);
        $this->pde_code = implode("\n", $code_lines);
    }
    
    function display()
    {
    	$html = "\n<div class=\"example\">";  // BEGIN example div
      
        // Insert the p5 version of the example into the page

        //Container for example
        $html .= "\n<div id=\"p5container\"></div>";
        //$html = "\n<div id=\"p5container\">";  // CR -- Change 8 Dec 2015

        //Script tag for example
        $html .= '<script type="text/javascript">';
		$html .= $this->p5_code;
		$html .= '</script>';
        
        //Description
		$html .= "\n<p class=\"doc\">";
      	$html .= nl2br($this->doc);
      	#$html .= $this->doc;
      	$html .= "</p>\n";
        
        //Raw code from Processing (not p5) version
      	$html .= "\n<pre class=\"code\">\n";
      	$html .= $this->pde_code;
      	$html .= "</pre>\n\n";
        
      	$html .= "\n</div>\n";  // END example div
      	return $html;
    }
    
    function output_file(&$menu_array, $rel_path = '/')
    {
        $page = new Page($this->name . ' \ Examples', $this->sub, "", "../");
        $page->subtemplate('template.example.html');
        $page->content($this->display());
        $page->set('examples_nav', $this->back_to_list());
        
        //writeFile("learning/".strtolower($this->sub)."/".strtolower($this->name).".html", $page->out());
        // Move 2 May 2013
        writeFile("examples/".strtolower($this->name).".html", $page->out());

        $this->copy_media();
        echo $this->name . '<br />';
        #echo "learning/examples/".strtolower($this->sub)."/".strtolower($this->name).".html\n";
    }

    function back_to_list(){
    	$nav = "\n<div class=\"examples-nav\">";
    	$nav .= '<a href="/examples/"><img src="/img/back_off.gif" alt="Back to List" /> <span class="back-to">Back To List</span></a>';
    	$nav .= "\n</div>";
    	return $nav;
    }
    
    function make_nav(&$array, $rel_path = '/') {
        
        $store = array();
        $prev = array();
        $next = array();
        $get_next = false;
        
        $html .= "\n<div class=\"examples-nav-div\">";
        $html .= "\n<table width=\"480\" border=\"0\"><tr><td align=\"left\"><table>\n<tr>";
        //$html = "\n<table id=\"examples-nav\" width=\"640\">\n<tr><td align=\"right\">";
        
        $select = "\n<select name=\"nav\" size=\"1\" class=\"inputnav\" onChange=\"javascript:gogo(this)\">\n";
        foreach ($array as $cat => $exs) {
            $select .= "\t<optgroup label=\"$cat\">\n";
            foreach ($exs as $file => $name) {
                if ($get_next) {
                    $next = array($file, $name);
                    $get_next = false;
                }
                if ($file == $this->name.'.html') {
                    $sel = ' selected="selected"';
                    $prev = $store;
                    $get_next = true;
                } else {
                    $sel = '';
                }
                $select .= "\t\t<option value=\"".strtolower($file)."\"$sel>$name</option>\n";
                $store = array($file, $name);
            }
            $select .= "\t</optgroup>\n";
        }
        $select .= "</select>\n\n";
        
        if (count($prev) > 0) {
            $html .= '<td><a href="'.strtolower($prev[0]) .'">
                <img src="'.$rel_path.'img/back_off.gif" alt="'.$prev[1].'" /></a></td>';
        } else {
            $html .= '<td width="48">&nbsp;</td>';
        }
        
        $html .= '<td>'.$select.'</td>';
        
        if (count($next) > 0) {
            $html .= '<td><a class="next" href="'.strtolower($next[0]) .'">
                <img src="'.$rel_path.'img/next_off.gif" alt="'.$next[1].'" /></a></td>';
        }
        return $html . '</tr></table></td><tr></table></div>';
    }
    
    function copy_media()
    {
        if (file_exists($this->data_dir)) {
            if (!copydirr($this->data_dir, EXAMPLESDIR.'/')) {
                echo "Could not copy" . EXAMPLESDIR.'/' . "<br />";
            }
        } else {
          //echo "No data here: " . $this->data_dir . "<br />";
        }
    }
}

?>