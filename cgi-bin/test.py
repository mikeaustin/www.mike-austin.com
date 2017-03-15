#!/usr/local/bin/python

import os
import _mysql

print 'Content-type: text/plain\n'
print 'This is Python, Byotch!\n'

for key in os.environ.keys():
  value = os.environ.get( key )
  print key + ':', value


