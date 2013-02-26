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
Reads a configuration file listing direct links to contributions grouped by
category. The config file is formatted using the following style:

    # A comment. Everything after the hash is ignored
    [Library : Sound] # Type of software : category name.
    # Contribution ID \ A url of a library in the sound category
    043 \ http://example.com/libs/soundlib1.txt
    # Contribution ID \ Another url of a library in the sound category
    074 \ http://example.org/libs/soundlib2.txt

    [Library : Vision] # Another category
    012 \ http://example.net/libs/visionlib.txt

    [Library Compilation : Compilation] # Library compilations are zip files
                                        # containing multiple libraries
    033 \ http://example.net/libs/awesomelibs.txt

After parsing the config file, information on each library is retrieved from
the text files, and the contribution is assumed to be hosted at the same
address as the txt, but with .zip.  For example, visionlib in the example above
would be found at http://example.com/libs/visionlib.zip

This script takes two arguments
  Arg 1: The name of a config file to read from
  Arg 2: The name of an file to write to. This file will be overwritten if it
         already exists
"""

from sys import argv
from urllib2 import *
import re
import shutil
import httplib

ENCODING = 'UTF-8'

def read_exports(f):
  """
  Reads a library's export.txt file and returns a dictionary.
  """
  lines = f.read().replace('\r\n', '\n').replace('\r', '\n')
  lines = lines.split('\n')
  export_table = {}
  for line in lines:
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

def write_exports(f, exports):
  """
  Writes the key-value pairs from the given dictionary to a file in the form
  key1=value1
  key2=value2
  """
  for key in exports:
    key = key.encode(ENCODING)
    value = exports[key].encode(ENCODING)
    f.write('%s=%s\n' % (key, value))

def get_lib_locations(f):
  """
  Reads a config file and returns a dictionary with categories as keys and
  lists of tuples as values, each containing
                          (software_type, contribution_name, download_url)
  """
  software_type = None
  category = None
  urls_by_category = {}
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
        software_type = None
        category = None
    else:
      if software_type == None or category == None:
        # XXX Error. Bad syntax for .conf file
        print "Ignoring contribution without type or category"
        continue

      contents = line.split('\\')
      if len(contents) != 2:
        print 'Lines for contributions must be of the form "Contribution Name : http://example.com/location.zip"'
        print contents
        continue

      name = contents[0].strip()
      url = contents[1].strip()

      if not urls_by_category.has_key(category):
        urls_by_category[category] = []
      urls_by_category[category].append((software_type, name, url))

  return urls_by_category

def missing_key(exports):
  keys = exports.keys()
  required_keys = ['name', 'authorList', 'url', 'category', 'sentence', 'version']
  for key in required_keys:
    if not keys.count(key):
      return key
  return None

if __name__ == "__main__":
  if len(argv) != 3:
    print "Usage is [Input Configuration File] [Output file]"
    exit()

  script, conf, fileout = argv
  f = open(conf)
  urls_by_category = get_lib_locations(f);
  f.close()

  tmpfile = fileout + '.tmp'
  f = open(tmpfile, 'w')

  for cat in urls_by_category:
    contribs = urls_by_category[cat]

    for contrib in contribs:
      software_type, contrib_id, prop_url = contrib
      download_url = prop_url[:prop_url.rfind('.')] + '.zip'
      try:
        exports = read_exports(urlopen(prop_url))

        exports['id'] = contrib_id
        # overwrite the category with what was in the .conf file
        exports['category'] = cat

        key = missing_key(exports)
        if key:
          print 'Error reading', prop_url
          print "  No value for '%s'. Maybe it's a 404 page" % key
          continue
        # if no download is explicitly provided, use the default download url
        m = re.compile('download.*')
        if len([x for x in exports if m.match(x)]) == 0:
          exports['download'] = download_url

        f.write('%s\n' % software_type)
        write_exports(f, exports)
        f.write('\n')

      except IOError as inst:
        print 'Error reading', prop_url
        print inst
        
      except UnicodeDecodeError as inst:
        print 'Error decoding', prop_url
        print inst
  
  f.close()
  shutil.move(tmpfile, fileout)

