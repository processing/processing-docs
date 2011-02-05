#!/bin/sh
#remove everything old
rm -rf ../tmp
mkdir ../tmp
#generate everything anew
javadoc -doclet ProcessingWeblet \
        -docletpath bin/ \
        -public \
	-webref ../tmp/web \
	-localref ../tmp/local \
	-templatedir ../templates \
	-examplesdir ../api_examples \
	-includedir ../api_examples/include \
	-imagedir images \
	-corepackage processing.xml \
	-rootclass PGraphics \
	-rootclass PConstants \
        ../../../processing/core/src/processing/core/*.java \
        ../../../processing/core/src/processing/xml/*.java \
        ../../../processing/java/libraries/net/src/processing/net/*.java \
        ../../../processing/java/libraries/serial/src/processing/serial/*.java
    # ../../../processing/video/src/processing/video/*.java \

cp -R ../../css	 ../tmp/web
cp -R ../../css	 ../tmp/local
mkdir -p ../tmp/web/images
mkdir -p ../tmp/local/images
cp -R ../../content/api_media/*.jpg ../tmp/web/images/
cp -R ../../content/api_media/*.gif ../tmp/web/images/
cp -R ../../content/api_media/*.png ../tmp/web/images/
cp -R ../../content/api_media/*.jpg ../tmp/local/images/
cp -R ../../content/api_media/*.gif ../tmp/local/images/
cp -R ../../content/api_media/*.png ../tmp/local/images/