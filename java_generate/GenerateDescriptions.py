#!/usr/bin/env python
# encoding: utf-8

import sys
import os
import re
from xml.dom import minidom

linePrefix = "   *"
startString = linePrefix + " ( begin auto-generated from %s )"
endString = "%s ( end auto-generated )" % linePrefix
shortString = "@generate"
xmlDirectory = "somwhere/"
codeDirectory = "/Users/REAS/Documents/reas\@processing.org/trunk/processing/core/src/processing/core/"
xmlDirectory = "/Users/REAS/Documents/reas\@processing.org/trunk/web/content/api_en/"

def main():
	#maker = DescriptionIntegrator( codeDirectory=sys.argv[1], xmlDirectory=sys.argv[2] )
	maker = DescriptionIntegrator( codeDirectory, xmlDirectory )
	# answer = raw_input("Replace descriptions in %s with those in %s? (Y/N): " % (codeDirectory, xmlDirectory))
	answer = "y"
	
	if( answer[0] == "Y" or answer[0] == "y" ):
		maker.run()

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

		portions = text.split("\n")
		for line in portions:
			if( line.find( shortString ) != -1):
				parts = line.split(" ")
				[xml] = [ p for p in parts if p[-3:] == "xml" ]
				description = self.getDescription(xml)
				
				index = portions.index(line)
				portions.insert( index, startString % xml )
				endIndex = self.insertDescription(description, portions, index+1 )
				portions.insert( endIndex, endString )
				portions.remove( line )
				didEdit = True
			elif( line.find("begin auto-generated") != -1 ):
				parts = line.split(" ")
				[xml] = [ p for p in parts if p[-3:] == "xml" ]
				description = self.getDescription(xml)
				index = portions.index(line) + 1
				self.removeOldDescription(portions, index)
				self.insertDescription( description, portions, index )
				didEdit = True
		if( didEdit == True ):
			output = open(f, 'w')
			output.write( '\n'.join(portions) )
	
	def insertDescription(self, description, list, startIndex):
		parts = description.split("\n")
		for p in parts:
			list.insert( startIndex, prefixedString(p) )
			startIndex += 1
		return startIndex
	
	def removeOldDescription(self, list, startIndex):
		lastIndex = list.index( endString, startIndex )
		numIndices = lastIndex - startIndex
		for i in range(0, numIndices):
			list.pop( startIndex )
			
	def getDescription(self, xml):
		print xml
		doc = minidom.parse( self.xmlDirectory + xml )
		elements = doc.getElementsByTagName("description")		
		return elements[0].firstChild.nodeValue
		#return " ".join(t.nodeValue for t in elements[0].childNodes)


if __name__ == '__main__':
	main()

