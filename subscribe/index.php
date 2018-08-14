<?php
    // subscribe functionality. saves to a flat file.
    // built by Jamie Kosoy (@jkosoy, jamie@arbitrary.io)

    require_once('../config.php');
    require_once(BASEDIR . '/subscribe/AES.class.php');

    $error = false;

    if(empty($_POST['email'])) {
        $error = 'Sorry, you didn&rsquo;t fill out an email address. Please <a href="/">go back</a> and fill out your email address.';
    }
    else {
        $email = $_POST['email'];

        if(!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            $error = 'Sorry, your email address is invalid. Please <a href="/">go back</a> and enter a valid email address.';
        }
        else {
            // gets the aes key.
            $aesKeyFilePath = BASEDIR . '../mailinglist/aes-key.txt';
            $fh = fopen($aesKeyFilePath, 'r');
            $aesKey = fread($fh, filesize($aesKeyFilePath));
            fclose($fh);

            // set the aes block size.
            $aesBlockSize = 256;

            // encrypt the email address, cause Jamie is paranoid about privacy.
            $aes = new AES($email, $aesKey, $aesBlockSize);
            $encryptedEmail = $aes->encrypt();

            // where the mailing list text file is located.
            $listFilePath = BASEDIR . '../mailinglist/list.txt';

            // save.
            file_put_contents($listFilePath, $encryptedEmail . "\n", FILE_APPEND);
        }
    }
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
    <head>
        <title>Mailing List \ Processing.org</title>
        
        <link rel="icon" href="/favicon.ico" type="image/x-icon" />
        
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta name="Author" content="Casey Reas &amp; Ben Fry" />
        <meta name="Publisher" content="Processing" />
        <meta name="Keywords" content="Processing, Processing, Interactive Media, Electronic Arts, Programming, Java, Ben Fry, Casey Reas" />
        <meta name="Description" content="Processing is an electronic sketchbook for developing 
                ideas. It is a context for learning fundamentals of computer programming 
                within the context of the electronic arts." />
        <meta name="Copyright" content="All contents copyright Ben Fry, Casey Reas, MIT Media Laboratory" />
        
        <script src="/javascript/modernizr-2.6.2.touch.js" type="text/javascript"></script>
        <link href="/css/style.css" rel="stylesheet" type="text/css" />
    </head>
    <body id="List" onload="" >
        
        <!-- ==================================== PAGE ============================ --> 
        <div id="container">
    
            <!-- ==================================== HEADER ============================ --> 
            <div id="header">
                <a href="/" title="Back to the Processing cover."><div class="processing-logo no-cover" alt="Processing cover"></div></a>
                <form name="search" action="//www.google.com/search" method="get">
                <!--<label>Search processing.org</label>-->
                       <p><input type="hidden" name="as_sitesearch" value="processing.org" />
                       <input type="text" name="as_q" value="" size="20" class="text" /> 
                        <input type="submit" value=" " /></p>
                </form>
            </div> 
            <a id="TOP" name="TOP"></a>
            
            <!-- ==================================== NAVIGATION ============================ -->
                        <div id="navigation">
                <div class="navBar" id="mainnav">
                    <a href="/">Cover</a><br><br>
                    <a href="/download/">Download</a><br><br>
                    <a href="/exhibition/">Exhibition</a><br><br>
                    <a href="/reference/">Reference</a><br>
                    <a href="/reference/libraries/">Libraries</a><br>
                    <a href="/reference/tools/">Tools</a><br>
                    <a href="/reference/environment/">Environment</a><br><br>
                    <a href="/tutorials/">Tutorials</a><br>
                    <a href="/examples/">Examples</a><br>
                    <a href="/books/">Books</a><br><br>
                    <a href="/overview/">Overview</a><br> 
                    <a href="/people/" class="active">People</a><br>
                    <a href="/foundation/">Foundation</a><br><br>
                    <a href="/shop/">Shop</a><br><br>
                    <a href="http://forum.processing.org"class="outward"><span>&raquo;</span>Forum</a><br> 
                    <a href="https://github.com/processing"class="outward"><span>&raquo;</span>GitHub</a><br> 
                    <a href="https://github.com/processing/processing/wiki/Report-Bugs"class="outward"><span>&raquo;</span>Issues</a><br> 
                    <a href="https://github.com/processing/processing/wiki"class="outward"><span>&raquo;</span>Wiki</a><br> 
                    <a href="https://github.com/processing/processing/wiki/FAQ"class="outward"><span>&raquo;</span>FAQ</a><br> 
                    <a href="https://twitter.com/processingOrg"class="outward"><span>&raquo;</span>Twitter</a><br> 
                    <a href="https://www.facebook.com/page.processing"class="outward"><span>&raquo;</span>Facebook</a><br> 
                </div>
            </div>


            <!-- ==================================== CONTENT ============================ -->
            <div class="content">
            
             <h1 class="large-header"><span class="black">Mailing List.</span></h1>
    
<p>
<table width="656" border="0" cellpadding="0" cellspacing="0">
    <tr>
      <td>
      
    <p>
        <?php if($error): ?>
        <strong>Error</strong><br />
        <?php echo $error; ?>
        <?php else: ?>
        <strong>Success</strong><br />
        Thanks for joining! Stay tuned for more. <a href="/">Go back to the main page</a>.
        <?php endif; ?>
    </p>
  </td>
 </tr>
</table>

</p>

            
            </div>

            <!-- ==================================== FOOTER ============================ --> 
            <div id="footer">
                <div id="copyright">Processing was initiated by <a href="http://benfry.com/">Ben Fry</a> and <a href="http://reas.com">Casey Reas</a>. It is developed by a <a href="/people/">small team of volunteers</a>.</div> 
                <div id="colophon">

                    <a href="/copyright.html">&copy; Info</a>

                </div>
            </div>
            
        </div>
        <script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
        <script>window.jQuery || document.write('<script src="/javascript/jquery-1.9.1.min.js"><\/script>')</script>
        <script src="/javascript/processing.js" type="text/javascript"></script>
        <script src="/javascript/site.js" type="text/javascript"></script>

        <script type="text/javascript">

          var _gaq = _gaq || [];
          _gaq.push(['_setAccount', 'UA-40016511-1']);
          _gaq.push(['_setDomainName', 'processing.org']);
          _gaq.push(['_trackPageview']);

          (function() {
            var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
            ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
            var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
          })();

        </script>
    </body>
</html>