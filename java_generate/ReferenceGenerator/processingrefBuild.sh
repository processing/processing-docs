#!/bin/sh
#remove everything old
rm -rf ../tmp
mkdir ../tmp
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
	-rootclass PGraphics \
	-rootclass PConstants \
	-noisy \
	../../../processing/java/libraries/net/src/processing/net/*.java \
	../../../processing/java/libraries/serial/src/processing/serial/*.java \
	../../../processing/java/libraries/video/src/processing/video/*.java \
	../../../processing/core/src/processing/core/*.java


cp -R ../../css	 ../tmp/web
#cp -R ../../css	 ../../distribution/
mkdir -p ../tmp/web/images
#mkdir -p ../../distribution/images
cp -R ../../content/api_media/*.jpg ../tmp/web/images/
cp -R ../../content/api_media/*.gif ../tmp/web/images/
cp -R ../../content/api_media/*.png ../tmp/web/images/
cp -R ../../content/api_media/*.jpg ../../distribution/images/
cp -R ../../content/api_media/*.gif ../../distribution/images/
cp -R ../../content/api_media/*.png ../../distribution/images/