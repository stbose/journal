#!/usr/bin/env python 

"""
auto generate an index 
page from a list of files 
in the directory 
stb
""" 

import sys 
import os 
from datetime import datetime
from subprocess import call

class Entry(object): 
  time_stamp = None
  title      = "" 
  file       = ""

  def __init__(self,time_stamp,title,file):
    self.time_stamp = time_stamp
    self.title      = title 
    self.file       = file

f = open('index.md', 'w') 
f.write("Table of contents\n") 
f.write("=================\n")


# now parse the entries ... 
n_entries = 0 
entries   = []

for file in os.listdir("."): 
  if (file.endswith(".md") and file != "index.md"):
    print file
    n_entries = n_entries + 1 

# extract the data and title from 
# the metadata thats in the file list.. 
    g     = open(file, 'r') 
    nline = 0
    date  = None 
    title = None
    ts    = None 
    for line in g: 

       tmp   = line.replace('<!--', '') 
       tmp   = tmp.replace('-->', '') 
       tmp = tmp.lstrip() 
       tmp = tmp.rstrip() 
       
       if ( nline == 0 ) : 
         title= tmp
       elif ( nline == 1): 
         date= tmp
         ts  = datetime.strptime(tmp, '%m/%d/%Y') 
       else:
         break
       
#print line,
#print tmp
       nline = nline + 1 
    g.close() 
    ff = file.replace('.md', '') 
    e  = Entry(ts, title, ff) 
    entries.append(e)
    call(["make", ff +".html"]) 
    




# now sort the entries based on their timestamp .. 
entries.sort(key = lambda x: x.time_stamp) 

#now write the index file..
for e in entries:
  url  = e.file + ".html" 
  date = e.time_stamp.strftime("%B-%d-%Y") 
  str  = "[%s %s](%s)\n" % (date,e.title,url) 
  f.write(str) 



f.close() 
print " > Finished building index... %d entries" % (n_entries)

# 
# and rebuild the index page .. 
#
print " > Making index.html ... " 
call(["make", "index.html"])

