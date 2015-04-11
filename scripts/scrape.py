#!/usr/bin/python

from bs4 import BeautifulSoup
import MySQLdb as mdb
import MySQLdb.cursors
from urllib2 import urlopen

def makelist(table):
  result = []
  allrows = table.findAll('tr')
  for row in allrows[1:-1]:
    result.append([])
    allcols = row.findAll('td')
    for col in allcols:
      thestrings = [unicode(s) for s in col.findAll(text=True)]
      thetext = ''.join(thestrings).strip()
      result[-1].append(thetext)
    if not result[-1]:
      del(result[-1])
  return result

def scrape():
  u = urlopen('http://swift.gsfc.nasa.gov/results/transients/BAT_current.html')
  soup = BeautifulSoup(u)
  #print soup.prettify()
  table = soup.find('table')
  tableout = makelist(table)
  return tableout

def inject(table):
  db = mdb.connect(db="trans", host="localhost",user="trans", passwd="transFTW!", cursorclass=MySQLdb.cursors.DictCursor)
  for row in table:
    cur = db.cursor()
    cur.execute('SELECT id FROM transients WHERE name=%s',(row[1],))
    t = cur.fetchone()
    cur.close()
    if not t:
      cur = db.cursor()
      cur.execute("INSERT INTO transients VALUES(AUTO_INCREMET(),'1',%s,'10','10')",(row[1],))
      cur.close()
    
    cur = db.cursor()
    cur.execute('SELECT id FROM transients WHERE name=%s',(row[1],))
    t = cur.fetchone()
    cur.close()
    
    id = t['id']
    cur = db.cursor()
    cur.execute('INSERT INTO intensities (trans_id, val, detected_time) VALUES (%s, %s, NOW())', (id, row[6]))
    cur.close()
  
  db.commit()

if __name__ == '__main__':
  tableout = scrape()
  inject(tableout)
