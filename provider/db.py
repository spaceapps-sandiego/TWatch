import MySQLdb as mdb
import MySQLdb.cursors
import sys

db = None

try:
	db = mdb.connect('localhost', 'trans', 'transFTW!', 'trans', cursorclass=mdb.cursors.DictCursor)
except mdb.Error, e:
	print 'Error %d: %s' % (e.args[0], e.args[1])
	sys.exit(1)
