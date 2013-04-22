#! /usr/bin/python

import sys
from lxml import etree
from StringIO import StringIO
from weasyprint import HTML

if len(sys.argv) < 3:
  print("Must give two arguments.")
  sys.exit()

try:
  print('Reading XSLT file ' + sys.argv[1])
  transform = etree.XSLT(etree.parse(sys.argv[1]))
  
  print('Reading XML file ' + sys.argv[2])
  doc = etree.parse(sys.argv[2])
  
  result_tree = transform(doc)
  
  result_file = open("result.html", 'w')
  result_file.write(str(result_tree))
  result_file.close()
  
  HTML('result.html').write_pdf('result.pdf')

except IOError as e:
  print "I/O error({0}): {1}".format(e.errno, e.strerror)
except ValueError as e:
  print "Value error"
except:
  print "Unexpected error:", sys.exc_info()[0]
  raise
