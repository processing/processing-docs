#!/usr/bin/python

# Part of the Processing project - http://processing.org
# 
#   Copyright (c) 2004-11 Ben Fry and Casey Reas
#   Copyright (c) 2001-04 Massachusetts Institute of Technology
# 
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License version 2
#   as published by the Free Software Foundation.
# 
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
# 
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software Foundation,
#   Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

"""
Reads a configuration file listing direct links to libraries grouped by
category. The config file is formatted using the following style:

    # A comment. Everything after the hash is ignored
    [Library : Sound] # Type of software : category name.
    # A url of a library in the sound category
    http://example.com/libs/soundlib1.zip
    # Another url of a library in the sound category
    http://example.org/libs/soundlib2.zip 

    [Library : Vision] # Another category
    http://example.net/libs/visionlib.zip

    [Library Compilation : Compilation] # Library compilations are zip files
                                        # containing multiple libraries
    http://example.net/libs/awesomelibs.zip

After parsing the config file, information on each library is retreived from
text files assumed to be at the same address as the library, but with a txt
file ending rather than zip.  For example, visionlib in the example above
would be found at http://example.com/libs/visionlib.txt

This script takes two arguments
  Arg 1: The name of a config file to read from
  Arg 2: The name of an xml file to write to. This file will be overwritten
         if it already exists
"""

from sys import argv
from urllib2 import *
from xml.etree.ElementTree import *
import re

LIBRARY = 'library'
LIBRARY_COMPILATION = 'librarycompilation'
TOOL = 'tool'
MODE = 'mode'
ENCODING = 'UTF-8'
#ENCODING = 'us-ascii'

def get_exports(f):
  """
  Reads a library's export.txt file and returns a dictionary of
  attributes and values.
  """
  export_table = {}
  for line in f.readlines():
    hash = line.find('#')
    line = line.strip() if hash == -1 else line[:hash]
    if len(line) == 0:
      continue

    equals = line.find('=')
    if equals == -1:
      continue
    attr = unicode(line[:equals].strip(), ENCODING)
    val = unicode(line[equals+1:].strip(), ENCODING)
    export_table[attr] = val
  return export_table


def autoindent(elem, level=0, is_last=True):
  """
  Appends whitespace before and after each XML element to make the printed
  XML more readable
  """

  if len(elem) and not elem.text:
    elem.text = '\n'  + (level + 1) * ' '

  if not elem.tail or not elem.tail.strip():
    if is_last:
      elem.tail = '\n' + (level - 1) * ' '
    else:
      elem.tail = '\n' + level * ' '

  for next_elem in elem:
    is_last = next_elem == elem[-1]
    autoindent(next_elem, level + 1, is_last)


def is_valid(exports):
  """
  Returns True if the dictionary 'exports' contains all required fields
  for a library, False otherwise
  """

  required = ['name', 'authorList', 'url', 'sentence', 'version']

  for attr in required:
    if not exports.has_key(attr) or len(exports[attr]) == 0:
      return False

  return True

def create_common_element(exports, tag, url):
  """
  Creates an XML element for a contribution using a dictionary containing
  attributes from its export file and a url that's a direct-link to
  download it
  """
  libelement = Element(tag)
  libelement.set('name', exports['name'])
  libelement.set('url', exports['url'])

  description = Element('description')
  description.set('authorList', exports['authorList'])
  description.set('sentence', exports['sentence'])
  if exports.has_key('paragraph'):
    description.set('paragraph', exports['paragraph'])
  libelement.append(description)

  version = Element('version')
  version_id = exports['version']
  version.set('id', version_id)
  if exports.has_key('prettyVersion'):
    version.set('pretty', exports['prettyVersion'])
  else:
    version.set('pretty', version_id)

  libelement.append(version)

  location = Element('location')
  location.set('url', url)
  libelement.append(location)

  return libelement

def get_lib_locations(f):
  """
  Reads a config file and returns a dictionary with categories as keys and
  lists of tuples as values, each containing (software_type, download_url).
  """
  software_type = None
  category = None
  url_by_category = {}
  for line in f.readlines():
    hash = line.find('#')
    line = line.strip() if hash == -1 else line[:hash]
    if len(line) == 0:
      continue

    if line[0] == '[' and line[-1] == ']':
      contents = line[1:-1]
      contents = contents.split(':')
      if len(contents) == 2:
        software_type = contents[0].strip()
        software_type = ''.join(software_type.split()).lower()
        category = contents[1].strip()
    else:
      if category == None:
        print "Ignoring library without catgory"
        continue
      if not url_by_category.has_key(category):
        url_by_category[category] = []
      url_by_category[category].append((software_type, line))

  return url_by_category


if __name__ == "__main__":
  if len(argv) != 3:
    print "Usage is [Input Configutation File] [Output XML file]"
    exit()

  script, conf, xmlout = argv
  f = open(conf)
  url_by_category = get_lib_locations(f);
  f.close()

  software = Element('software')

  for cat in url_by_category:
    category = Element('category')
    category.set('name', cat)
    software.append(category)
    urls = url_by_category[cat]
    for url in urls:
      software_type, url = url
      exports_url = url[:url.rfind('.')] + '.txt'
      try:
        element = None
        exports = get_exports(urlopen(exports_url))

        if software_type == LIBRARY:
          element = create_common_element(exports, 'library', url)
        elif software_type == LIBRARY_COMPILATION:
          element = create_common_element(exports, 'librarycompilation', url)
        elif software_type == TOOL:
          element = create_common_element(exports, 'tool', url)
        elif software_type == MODE:
          element = create_common_element(exports, 'mode', url)

        if element != None:
          category.append(element)
      except IOError as inst:
        print 'Error reading', exports_url
        print inst

  software_tree = ElementTree()
  autoindent(software)
  software_tree._setroot(software)
  software_tree.write(xmlout, ENCODING, True)

