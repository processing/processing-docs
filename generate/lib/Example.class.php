<?

class Example
{
    var $name;
    var $cat;
    var $file;
    var $applet;
    var $data_dir;
    var $doc;
    var $code;
    var $fullcode;
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
		#$applet_dir = CONTENTDIR . 'examples/' . $cat . '/' . $name . '/applet/';
		
		$pde_dir = EXAMPLESOURCEDIR . $cat . '/' . $name . '/';
		#$applet_dir = $pde_dir . '/applet/';
		
		$this->data_dir = $pde_dir . 'data/';
	
		$this->file = file_get_contents($pde_dir . $name.'.pde');
    	#$this->applet = $applet_dir . $name . '.jar';

#		$this->file = file_get_contents(CONTENTDIR . 'examples/' . $cat . '/' .
#		$name . '/applet/' . $name.'.pde');
#    	$this->applet = (CONTENTDIR . 'examples/' . $cat . '/' . 
#		$name . '/applet/' . $name . '.jar';
        
#      	if ($handle = opendir(CONTENTDIR.'examples/'.$cat.'/'.$name)) {

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
        $this->fullcode = implode("\n", $full_code_lines);
        $this->code = implode("\n", $code_lines);
    }
    
    function display()
    {
    	$html = "\n<div class=\"example\">";  // BEGIN example div
      
        // This code is the from the Processing.js export from Processing 200
      	/**
		  <div>
				<canvas id="Distance1D" data-processing-sources="Distance1D.pde" width="640" height="360">
                    
                    <p>Your browser does not support the canvas tag.</p>
					<!-- Note: you can put any alternative content here. -->
				</canvas>
				<noscript>
					<p>JavaScript is required to view the contents of this page.</p>
				</noscript>
	    	</div>
	    */
	    
	    // This code is my attempt to generalize the code from Processing 200
	    /**
	    $html .= '<div>';
	    $html .= '    <canvas id="' . $this->name . '" data-processing-sources="' . $this->name . '.pde"';
	    $html .= 'width="640" height="360">';
    	$html .= '        <p>Your browser does not support the canvas tag.</p>';
    	$html .= '    </canvas>';
    	$html .= '    <noscript>';
    	$html .= '      <p>JavaScript is required to view the contents of this page.</p>';
    	$html .= '    </noscript>';
    	$html .= '</div>';
        */
        
        // This code is based on the example style on ProcessingJS.org
        $html .= '<script type="application/processing">';
		$html .= $this->fullcode;
		$html .= '</script><canvas width="640" height="360"></canvas>';
        

      #if (file_exists($this->applet)) {
	    #$html .= "\n<div class=\"applet\">\n\t";

	    # for newer browsers, use the deployment script 
	    # which will let us use loading.gif instead of the coffee cup
	    #$html .= '<script type="text/javascript" src="http://www.java.com/js/deployJava.js"></script>';
	    #$html .= '<script type="text/javascript">' . "\n";
	    #$html .= '/* <![CDATA[ */' . "\n";
	    #$html .= "var attributes = {\n";
	    #$html .= "  code: '" . $this->name . ".class',\n";
	    #$html .= "  archive: 'media/" . $this->name . ".jar,media/core.jar',\n";
	    #$html .= "  width: '" . $this->width . "',\n";
	    #$html .= "  height: '" . $this->height . "',\n";
	    #$html .= "};\n";
	    #$html .= "var parameters = {\n";
	    #$html .= "  image: 'media/loading.gif',\n";
	    #$html .= "  centerimage: 'true'\n";
	    #$html .= "};\n";
	    #$html .= "deployJava.runApplet(attributes, parameters, '1.5');\n";
	    #$html .= "/* ]]> */\n";
	    #$html .= "</script>\n\n";

	    # fallback for the oldschool folks
	    #$html .= "<noscript>\n";
        #    $html .= '<applet code="' . $this->name . '"' .
	    #  ' archive="media/' . $this->name.'.jar,media/core.jar"' .
	    #  ' width="' . $this->width.'"' .
	    #  ' height="' . $this->height.'"' .
	    #  '></applet>';
        #    $html .= "\n";
	    #$html .= "</noscript>\n";
	    #$html .= "</div>\n";
		#
        #    if ($this->width > 200) {                
        #      $html .= "\n<p class=\"doc\">";
        #    
        #    } else {
        #      $html .= "\n<p class=\"doc-float\">";
        #    }
		#
        #} else {
        #    $html .= "\n<p class=\"doc\">";
        #}

		$html .= "\n<p class=\"doc\">";
      	$html .= nl2br($this->doc);
      	#$html .= $this->doc;
      	$html .= "</p>\n";
        
      	$html .= "\n<pre class=\"code\">\n";
      	$html .= $this->code;
      	$html .= "</pre>\n\n";
        
      	$html .= "\n</div>\n";  // END example div
      	return $html;
    }
    
    function output_file(&$menu_array, $rel_path = '/')
    {
        $page = new Page($this->name . ' \ Learning', $this->sub, "", "../../");
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
        /**
        if (file_exists($this->applet)) {
            make_necessary_directories(EXAMPLESDIR.strtolower($this->sub).'/media/include');
            if (!copy($this->applet, EXAMPLESDIR.strtolower($this->sub).'/media/'.$this->name.'.jar')) {
                echo "Could not copy {$this->applet} to . <br/>";
            }
	    	#echo EXAMPLESDIR.strtolower($this->sub).'/media/'.$this->name.'.jar';
        	#} else {
	  		#echo " | ";
        }
        */
        /**
        if (file_exists($this->applet)) {
            #make_necessary_directories(EXAMPLESDIR.strtolower($this->sub).'/media/include');
            if (!copy($this->applet, EXAMPLESDIR.strtolower($this->sub).'/media/'.$this->name.'.jar')) {
                echo "Could not copy {$this->applet} to . <br/>";
            }
        }
        */
        if (file_exists($this->data_dir)) {
            if (!copydirr($this->data_dir, EXAMPLESDIR.strtolower($this->sub).'/')) {
                echo "Could not copy" . EXAMPLESDIR.strtolower($this->sub).'/' . "<br />";
            }
        } else {
          //echo "No data here: " . $this->data_dir . "<br />";
        }
    }
}

?>