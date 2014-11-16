#!/usr/bin/env python
# encoding: utf-8

import sys
import os
import re
from xml.dom import minidom

reload(sys)  
sys.setdefaultencoding('utf8')

linePrefix = "   *"
startString = linePrefix + " ( begin auto-generated from %s )"
endString = "%s ( end auto-generated )" % linePrefix

# the tag we're looking for to generate descriptions
shortString = "@generate"
xmlDirectory = "somwhere/"

# auto-generated reference will get hard returns after this many characters
maxCharsPerLine = 72

codeDir = "/Users/REAS/Documents/30-Code/processing/processing-docs/java_generate/ReferenceGenerator/test/core/"
xmlDir = "/Users/REAS/Documents/30-Code/processing/processing-docs/content/api_en/"

netCodeDir = "/Users/REAS/Documents/reas@processing.org/trunk/processing/java/libraries/net/src/processing/net/"
netXmlDir = "/Users/REAS/Documents/reas@processing.org/trunk/web/content/api_en/LIB_net/"

videoCodeDir = "/Users/REAS/Documents/reas@processing.org/trunk/processing/java/libraries/video/src/processing/video/"
videoXmlDir = "/Users/REAS/Documents/reas@processing.org/trunk/web/content/api_en/LIB_video/"

thisFile = ""


def main():
	#maker = DescriptionIntegrator( codeDirectory=sys.argv[1], xmlDirectory=sys.argv[2] )
	
	maker = DescriptionIntegrator( codeDirectory=codeDir, xmlDirectory=xmlDir )
	maker.run()

	#makerVideo = DescriptionIntegrator( codeDirectory=videoCodeDir, xmlDirectory=videoXmlDir )
	#makerVideo.run()
	
	#makerNet = DescriptionIntegrator( codeDirectory=netCodeDir, xmlDirectory=netXmlDir )
	#makerNet.run()


def prefixedString( input ):
	return "%s %s" % (linePrefix, input)

class DescriptionIntegrator:
	
	def __init__(self, xmlDirectory="", codeDirectory=""):
		self.xmlDirectory = xmlDirectory
		self.codeDirectory = codeDirectory
	
	def run(self):
		for root, dirs, files in os.walk( self.codeDirectory ):
				for name in files:
					if name[-4:] == "java":
						self.addDescriptionsToFile( os.path.join(root,name) )
	
	def addDescriptionsToFile(self, f):
	
		input = open(f,'r+')
		text = input.read()
		input.close()
		didEdit = False
		
		# split apart the source code by line
		portions = text.split("\n")
		for line in portions:
			#line = line.rstrip()
			#print "line is '%s'" % (line)
			if( line.find( shortString ) != -1):
				print line + " - full line"
				parts = line.split(" ")
				[xml] = [ p for p in parts if p[-3:] == "xml" ]
				description = self.getDescription(xml)
				index = portions.index(line)
				print xml + " - gen insert"
				portions.insert( index, startString % xml )
				endIndex = self.insertDescription(description, portions, index+1 )
				portions.insert( endIndex, endString )
				portions.remove( line )
				print " "
				didEdit = True
			elif( line.find("begin auto-generated") != -1 ):
				parts = line.split(" ")
				[xml] = [ p for p in parts if p[-3:] == "xml" ]
				description = self.getDescription(xml)
				index = portions.index(line) + 1
				print xml + " - auto remove"
				self.removeOldDescription(portions, index)
				print xml + " - auto insert"
				self.insertDescription( description, portions, index )
				print " "
				didEdit = True
		if( didEdit == True ):
			output = open(f, 'w')
			output.write( '\n'.join(portions) )
	
	def insertDescription(self, description, list, startIndex):
		parts = self.generateLines( description, maxCharsPerLine )
		for p in parts:
			# insert each comment line into the source code
			list.insert( startIndex, prefixedString(p).rstrip() )
			startIndex += 1
		return startIndex
	
	def generateLines( self, text, maxLength ):
		words = text.split(" ")
		lines = []
		txt = ""
		for word in words:
			# if we've hit a newline, break the line
			if( word.find("\n") != -1 ):
				pieces = word.split("\n")
				txt = txt + pieces[0]
				lines.append( txt )
				txt = ""
				if( pieces[1] != "" ):
					word = pieces[1]
				else:
					continue
			# if we're out of room, write the text
			if( len(txt) + len(word) > maxLength ):
				lines.append( txt )
				txt = word + " "
			else:
				# keep adding words
				txt = txt + word + " "
		# if there's text left over, append it now
		if( txt != "" ):
			lines.append( txt )
		lines.append( "" )
		return lines
	
	def removeOldDescription(self, list, startIndex):
		lastIndex = list.index( endString, startIndex )
		numIndices = lastIndex - startIndex
		for i in range(0, numIndices):
			list.pop( startIndex )
			
	def getDescription(self, xml):
		print xml 
		thisFile = xml
		doc = minidom.parse( self.xmlDirectory + xml )
		elements = doc.getElementsByTagName("description")		
		#return elements[0].firstChild.nodeValue
		#return " ".join( t.nodeValue for t in elements[0].childNodes )
		#return " ".join( t.nodeValue for t in elements[0].childNodes if t.nodeType == t.TEXT_NODE )
		return " ".join( t.nodeValue for t in elements[0].childNodes if t.nodeType == t.CDATA_SECTION_NODE)


if __name__ == '__main__':
	main()

