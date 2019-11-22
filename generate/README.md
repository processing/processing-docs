These are the scripts that generate most of the the processing.org website and Reference that's included with the Processing software. The language Reference scripts are in the ../java_generate/ directory and that's a whole other thing...

The generator scripts are written in PHP using an old version of DOMIT: https://sourceforge.net/projects/domit-xmlparser/

The files that are appended with "local" generate alternate versions of those pages for the Reference that comes included with the Processing software.  

This directory also contains the files to generate the "keywords.txt" file that controls the syntax highlighting for the Processing Development Environment (PDE). The Perl script "keywords_create.cgi" generates this file by combining "keywords_base.txt" with the Reference XML files.

The data used to generate the site pages are in the ../content/ directory. 
