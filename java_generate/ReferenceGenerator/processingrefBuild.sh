#!/bin/sh


# GENERATE REFERENCE ENTRIES AND INDEX THROUGH JAVADOC - BY DAVID WICKS

#remove everything old
rm -rf ../../reference
mkdir ../../reference
rm -rf ../../distribution
mkdir ../../distribution

#generate everything anew
javadoc -doclet ProcessingWeblet \
        -docletpath bin/ \
        -public \
	-webref ../../reference \
	-localref ../../distribution \
	-templatedir ../templates \
	-examplesdir ../../content/api_en \
	-includedir ../../content/api_en/include \
	-imagedir images \
	-corepackage processing.data \
	-corepackage processing.event \
	-corepackage processing.opengl \
	-rootclass PConstants \
	-noisy \
	../../../processing/java/libraries/net/src/processing/net/*.java \
	../../../processing/java/libraries/serial/src/processing/serial/*.java \
	../../../processing/java/libraries/video/src/processing/video/*.java \
	../../../processing/core/src/processing/core/*.java \
	../../../processing/core/src/processing/data/*.java \
	../../../processing/core/src/processing/event/*.java \
	../../../processing/core/src/processing/opengl/*.java


# COPY IMAGES FROM CONTENT FOLDER TO CORRECT FOLDERS

# manage web reference
cp -R ../../css	 ../../reference/
cp -R ../../javascript	 ../../reference/
mkdir -p ../../reference/images
cp -R ../../content/api_media/*.jpg ../../reference/images/
cp -R ../../content/api_media/*.gif ../../reference/images/
cp -R ../../content/api_media/*.png ../../reference/images/

# manage local reference
cp -R ../../css	 ../../distribution/
cp -R ../../javascript	 ../../distribution/
rm -rf ../../distribution/css/fonts/TheSerif_B4_Bold_.eot
rm -rf ../../distribution/css/fonts/TheSerif_B4_Bold_.woff
rm -rf ../../distribution/css/fonts/TheSerif_B4_Italic.eot
rm -rf ../../distribution/css/fonts/TheSerif_B4_Italic.woff
rm -rf ../../distribution/css/fonts/TheSerif_B4_Plain_.eot
rm -rf ../../distribution/css/fonts/TheSerif_B4_Plain_.woff
mkdir -p ../../distribution/images
cp -R ../../content/api_media/*.jpg ../../distribution/images/
cp -R ../../content/api_media/*.gif ../../distribution/images/
cp -R ../../content/api_media/*.png ../../distribution/images/


# COPY IMAGES

# copy images for web reference isn't needed because they are already on server

# copy images for local reference
mkdir -p ../../distribution/img
chmod 755 ../../distribution/img
mkdir -p ../../distribution/img/about/
cp ../../favicon.ico ../../distribution/img/
cp ../../img/processing-web.png ../../distribution/img/
cp ../../img/processing-logo.svg ../../distribution/img/
cp ../../img/processing-logo.png ../../distribution/img/
cp ../../img/search.png ../../distribution/img/
cp ../../img/search.svg ../../distribution/img/
cp ../../img/about/people-header.gif ../../distribution/img/about/
cp ../../content/api_en/images/header.gif ../../distribution/img/


# GENERATE OTHER REFERENCE CONTENT

# move to folder for generating other files
cd ../../generate/

# run web reference creations files
php staticpages.php
php tools.php
php libraries.php
php environment.php

# run local reference creations files
php staticpages_local.php
php tools_local.php
php libraries_local.php
php environment_local.php

# add the links to load in the libraries and tools lists online
cd ../reference/libraries/
ln -s index.html index.shtml
cd ../tools/
ln -s index.html index.shtml
