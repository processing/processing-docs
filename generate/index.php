<? require('../config.php'); ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
     "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">

<head>
  <meta http-equiv="content-type" content="text/html;charset=UTF-8" />
 	<title>Processing.org Generator</title>
    <script language="javascript" type="text/javascript" src="/javascript/prototype.js"></script>
    <script language="javascript" type="text/javascript">

function remote_link(href, params)
{
    return new Ajax.Updater('status', href, {asynchronous: true, onLoading: showloading, parameters: params});
}

function showloading()
{
    $('status-container').style.display = 'block';
    $('status').innerHTML = 'Loading...';
}
    </script>
    
    <style type="text/css">
    body { margin: 0 auto; font-family: Verdana, Geneva, Arial, Helvetica, sans-serif; font-size: 12px; }

h1 { margin: 0; width: 900px; background: #000; }

#header {
	width: 900px;
	height: 106px;
	margin-bottom: 7px;
	overflow: hidden;
	background: #0c2033 url(../img/processing-web.png) center center no-repeat;
	background-size: 900px 106px;	
	position:relative;
}

#header .processing-logo {
	width: 206px;
	height: 38px;
	margin: 20px 0 0 30px;
	background: transparent url(../img/processing-logo.png) center center no-repeat;
	background-image: -webkit-linear-gradient(transparent, transparent), url(../img/processing-logo.svg);
	background-image: -moz-linear-gradient(transparent, transparent), url(../img/processing-logo.svg);
	background-image: linear-gradient(transparent, transparent), url(../img/processing-logo.svg);
}

#body { margin-left: 34px; width: 900px; }

ul, li { margin: 0; padding: 0; list-style: none; }
li { margin-bottom: 1em; }

#status-container { display: none; background: #efefff; border: 1px solid #c8c8ff; padding: 5px; width: 820px; overflow-x: hidden; margin-bottom: 34px; }
#status-container h3 { margin: 0; }
#status { font-size: 12px; }

.inline { display: inline; }
    </style>
</head>

<body>
	<div id="header">
		<div class="processing-logo" alt="Processing cover"></div>
	</div>

<div id="body">

<p>&nbsp;</p>

<strong>Generate Site Files</strong>

<p>	
	Filip: <a href="#" onclick="remote_link('exhibition.php'); return false;">Exhibition and archives</a><br />
	<br />
	Dan: <a href="#" onclick="remote_link('tutorials.php'); return false;">Tutorials</a><br />
	<br />
	Elie: <a href="#" onclick="remote_link('libraries.php', 'lang=en'); return false;">Libraries</a> 
			(<a href="/contrib_generate/build.log">view log</a> | <a href="#" onclick="remote_link('libraries_log_delete.php', 'lang=en'); return false;">delete log</a>) \ 
		  <a href="#" onclick="remote_link('tools.php', 'lang=en'); return false;">Tools</a> \ 
		  <a href="#" onclick="remote_link('contributions_data.php', 'lang=en'); return false;">Contributions Data</a> \ 
		  Modes (to come...)<br />
	<br />
	Scott: <a href="#" onclick="remote_link('cover.php');return false;">Cover</a> \ 
		<a href="#" onclick="remote_link('environment.php'); return false;">Environment</a> \ 
		<a href="#" onclick="remote_link('examples.php'); return false;">Examples</a> \ 
		<a href="#" onclick="remote_link('staticpages.php'); return false;">Static Pages</a> \ 
		<a href="#" onclick="remote_link('reference.php');return false;">Reference</a> (REFERENCE!!!)
</p>
	
<p>&nbsp;</p>


<div id="status-container">
    <h3>Status</h3>
    <div id="status"></div>
</div>

</div>

</body>
</html>