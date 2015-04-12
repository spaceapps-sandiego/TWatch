import MySQLdb as mdb
import MySQLdb.cursors
import sys

db = None

try:
	db = mdb.connect('localhost', 'trans', 'transFTW!', 'trans', cursorclass=mdb.cursors.DictCursor)
except mdb.Error, e:
	print 'Error %d: %s' % (e.args[0], e.args[1])
	sys.exit(1)

def dbinsert(db, *args):
	cur = db.cursor()
	cur.execute(*args)
	cur.close()

def dbselectone(db, *args):
	cur = db.cursor()
	cur.execute(*args)
	ret = cur.fetchone()
	cur.close()
	return ret

def dbselect(db, *args):
	cur = db.cursor()
	cur.execute(*args)
	ret = cur.fetchall()
	cur.close()
	return ret

def dbupdate(db, *args):
	cur = db.cursor()
	cur.execute(*args)
	cur.close()