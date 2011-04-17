<?

class Example
{
    var $name;
    var $cat;
    var $file;
    var $applet;
    var $doc;
    var $code;
    var $sub;
    var $width;
    var $height;
    
    function Example($name, $cat, $sub)
    {
        $this->name = $name;
        $this->cat = $cat;
        $this->sub = $sub;

        #$this->file = file_get_contents(CONTENTDIR.'examples/'.$cat.'/'.$name.'/'.$name.'.pde');
	# use the .pde from the applet folder
	$applet_dir = 
	  CONTENTDIR . 'examples/' . $cat . '/' . $name . '/applet/';
	$this->file = file_get_contents($applet_dir . $name.'.pde');
        $this->applet = $applet_dir . $name . '.jar';
#	$this->file = 
#	  file_get_contents(CONTENTDIR . 'examples/' . $cat . '/' .
#			    $name . '/applet/' . $name.'.pde');
#        $this->applet = (CONTENTDIR . 'examples/' . $cat . '/' . 
#			 $name . '/applet/' . $name . '.jar';
        
#        if ($handle = opendir(CONTENTDIR.'examples/'.$cat.'/'.$name)) {
        if ($handle = opendir($applet_dir)) {
          while (false !== ($newfile = readdir($handle))) {
            //if ($file != "." && $file != "..") {
            if (preg_match("/pde/", $newfile)) {
              //echo " $newfile\n";
              if (strcmp($name.'.pde', $newfile) != 0) {
		$this->file .= "\n\n\n";
		#$this->file .= file_get_contents(CONTENTDIR.'examples/'.$cat.'/'.$name.'/'.$newfile); 
		$this->file .= file_get_contents($applet_dir . $newfile); 
              }
            }
          }
          closedir($handle);
        }
        
        preg_match("/(^|\s|;)size\s*\(\s*(\d+)\s*,\s*(\d+),?\s*([^\)]*)\s*\)/", $this->file, $matches);
        $this->width = $matches[2];
        $this->height = $matches[3];
        
        $this->split_file();
    }
    
    function split_file()
    {
        $lines = explode("\n", $this->file);
        $doc_lines = array();
        $code_lines = array();
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
            }
        }
        $this->doc = implode(" ", $doc_lines);
        $this->code = implode("\n", $code_lines);
    }
    
    function display()
    {
        $html = "\n<div class=\"example\">";
        if (file_exists($this->applet)) {
	    $html .= "\n<div class=\"applet\">\n\t";

	    # for newer browsers, use the deployment script 
	    # which will let us use loading.gif instead of the coffee cup
	    $html .= '<script type="text/javascript" src="http://www.java.com/js/deployJava.js"></script>';
	    $html .= '<script type="text/javascript">' . "\n";
	    $html .= '/* <![CDATA[ */' . "\n";
	    $html .= "var attributes = {\n";
	    $html .= "  code: '" . $this->name . ".class',\n";
	    $html .= "  archive: 'media/" . $this->name . ".jar,media/core.jar',\n";
	    $html .= "  width: '" . $this->width . "',\n";
	    $html .= "  height: '" . $this->height . "',\n";
	    $html .= "  image: 'media/loading.gif'\n";
	    $html .= "};\n";
	    $html .= "deployJava.runApplet(attributes, { }, '1.5');\n";
	    $html .= "/* ]]> */\n";
	    $html .= "</script>\n\n";

	    # fallback for the oldschool folks
	    $html .= "<noscript>\n";
            $html .= '<applet code="' . $this->name . '"' .
	      ' archive="media/' . $this->name.'.jar,media/core.jar"' .
	      ' width="' . $this->width.'"' .
	      ' height="' . $this->height.'"' .
	      '></applet>';
            $html .= "\n";
	    $html .= "</noscript>\n";
	    $html .= "</div>\n";

            if ($this->width > 200) {                
              $html .= "\n<p class=\"doc\">";
            
            } else {
              $html .= "\n<p class=\"doc-float\">";
            }

        } else {
            $html .= "\n<p class=\"doc\">";
        }

        $html .= nl2br($this->doc);
        #$html .= $this->doc;
        $html .= "</p>\n";
        
        $html .= "\n<pre class=\"code\">\n";
        $html .= $this->code;
        $html .= "</pre>\n\n";
        
        $html .= "\n</div>\n";
        return $html;
    }
    
    function output_file(&$menu_array)
    {
        $page = new Page($this->name . ' \ Learning', $this->sub);
        $page->subtemplate('template.example.html');
        $page->content($this->display());
        $page->set('examples_nav', $this->make_nav($menu_array));
        writeFile("learning/".strtolower($this->sub)."/".strtolower($this->name).".html", $page->out());
        $this->copy_media();
        echo $this->name . '<br/>';
        #echo "learning/examples/".strtolower($this->sub)."/".strtolower($this->name).".html\n";
    }
    
    function make_nav(&$array) {
        
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
                <img src="/img/back_off.gif" alt="'.$prev[1].'" /></a></td>';
        } else {
            $html .= '<td width="48">&nbsp;</td>';
        }
        
        $html .= '<td>'.$select.'</td>';
        
        if (count($next) > 0) {
            $html .= '<td><a class="next" href="'.strtolower($next[0]) .'">
                <img src="/img/next_off.gif" alt="'.$next[1].'" /></a></td>';
        }
        return $html . '</tr></table></td><tr></table></div>';
    }
    
    function copy_media()
    {
        if (file_exists($this->applet)) {
            make_necessary_directories(EXAMPLESDIR.strtolower($this->sub).'/media/include');
            if (!copy($this->applet, EXAMPLESDIR.strtolower($this->sub).'/media/'.$this->name.'.jar')) {
                echo "Could not copy {$this->applet} to . <br/>";
            }
	    #echo EXAMPLESDIR.strtolower($this->sub).'/media/'.$this->name.'.jar';
        #} else {
	  #echo " | ";
        }            
    }
}

?>