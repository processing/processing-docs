#!/bin/sh

echo "[REFERENCE GENERATOR] Booting up..."

# PROCESSING_SRC_PATH=./test
PROCESSING_SRC_PATH=../../../processing/core/src
PROCESSING_LIB_PATH=../../../processing/java/libraries
# GENERATE REFERENCE ENTRIES AND INDEX THROUGH JAVADOC - BY DAVID WICKS

echo "[REFERENCE GENERATOR] Source Path :: $PROCESSING_SRC_PATH"
echo "[REFERENCE GENERATOR] Library Path :: $PROCESSING_LIB_PATH"


echo "[REFERENCE GENERATOR] Removing previous version of the ref..."
rm -rf ../../reference
mkdir ../../reference
rm -rf ../../distribution
mkdir ../../distribution

echo "[REFERENCE GENERATOR] Generating new javadocs..."
javadoc -doclet ProcessingWeblet \
        -docletpath bin/ \
        -public \
	-webref ../../reference \
	-localref ../../distribution \
	-templatedir ../templates \
	-examplesdir ../../content/api_en \
	-includedir ../../content/api_en/include \
	-imagedir images \
	-encoding UTF-8 \
	-corepackage processing.data \
	-corepackage processing.event \
	-corepackage processing.opengl \
	-rootclass PConstants \
	$PROCESSING_SRC_PATH/processing/core/*.java \
	$PROCESSING_SRC_PATH/processing/data/*.java \
	$PROCESSING_SRC_PATH/processing/event/*.java \
	$PROCESSING_SRC_PATH/processing/opengl/*.java \
	$PROCESSING_LIB_PATH/io/src/processing/io/*.java \
	$PROCESSING_LIB_PATH/net/src/processing/net/*.java \
	$PROCESSING_LIB_PATH/serial/src/processing/serial/*.java \
	$PROCESSING_LIB_PATH/../../../processing-video/src/processing/video/*.java \
	$PROCESSING_LIB_PATH/../../../processing-sound/src/processing/sound/*.java \
	-noisy



echo "[REFERENCE GENERATOR] Copying images from content directory to the correct location..."

echo "[REFERENCE GENERATOR] Updating web paths..."
cp -R ../../css	 ../../reference/
cp -R ../../javascript	 ../../reference/
mkdir -p ../../reference/images
cp -R ../../content/api_media/*.jpg ../../reference/images/
cp -R ../../content/api_media/*.gif ../../reference/images/
cp -R ../../content/api_media/*.png ../../reference/images/

echo "[REFERENCE GENERATOR] Updating local reference paths..."
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
echo "[REFERENCE GENERATOR] Copying images to web reference..."
# copy images for web reference isn't needed because they are already on server

# copy images for local reference
echo "[REFERENCE GENERATOR] Copying images to local reference..."
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
echo "[REFERENCE GENERATOR] Running PHP to generate static files..."
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
echo "[REFERENCE GENERATOR] Generating symlinks for web libraries and tools..."
cd ../reference/libraries/
ln -s index.html index.shtml
cd ../tools/
ln -s index.html index.shtml
