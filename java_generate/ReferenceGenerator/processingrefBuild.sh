#!/bin/sh

#remove everything old
rm -rf ../tmp
mkdir ../tmp
rm -rf ../../distribution
mkdir ../../distribution

#generate everything anew
javadoc -doclet ProcessingWeblet \
        -docletpath bin/ \
        -public \
	-webref ../tmp/web \
	-localref ../../distribution \
	-templatedir ../templates \
	-examplesdir ../../content/api_en \
	-includedir ../../content/api_en/include \
	-imagedir images \
	-corepackage processing.xml \
	-rootclass PConstants \
	-noisy \
	../../../processing/java/libraries/net/src/processing/net/*.java \
	../../../processing/java/libraries/serial/src/processing/serial/*.java \
	../../../processing/java/libraries/video/src/processing/video/*.java \
	../../../processing/core/src/processing/core/*.java

# manage web reference
cp -R ../../css	 ../tmp/web
mkdir -p ../tmp/web/images
cp -R ../../content/api_media/*.jpg ../tmp/web/images/
cp -R ../../content/api_media/*.gif ../tmp/web/images/
cp -R ../../content/api_media/*.png ../tmp/web/images/

# manage local reference
cp -R ../../css	 ../../distribution/
mkdir -p ../../distribution/images
cp -R ../../content/api_media/*.jpg ../../distribution/images/
cp -R ../../content/api_media/*.gif ../../distribution/images/
cp -R ../../content/api_media/*.png ../../distribution/images/

# copy images for local reference
mkdir -p ../../distribution/img
mkdir -p ../../distribution/img/about/
cp ../../favicon.ico ../../distribution/img/
cp ../../img/processing_cover.gif ../../distribution/img/
cp ../../img/about/people-header.gif ../../distribution/img/about/
cp ../../content/api_en/images/header.gif ../../distribution/img/

# run local reference creations files
cd ../../generate/
php staticpages_local.php
php tools_local.php
php libraries_local.php
php environment_local.php