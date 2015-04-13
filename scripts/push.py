#!/usr/bin/python

#    0c43fb33e4f4d1436905844876d3e04d0af2e565d0d09d3a97d7a07388bd39c4


import time
from apns import APNs, Frame, Payload
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

apns = APNs(use_sandbox=True, cert_file='/opt/certs/twatch.crt', key_file='/opt/certs/twatch.pem')

def send_push_to_all(notice):
	# Send a notification
	#token_hex = '0c43fb33e4f4d1436905844876d3e04d0af2e565d0d09d3a97d7a07388bd39c4'
	payload = Payload(alert=notice, sound="default", badge=1)
	tokens = dbselect(db, 'SELECT id FROM devices')
	
	for token in tokens:
		print ("sending to %s", token['id'])
		apns.gateway_server.send_notification(token['id'], payload)

	# Send multiple notifications in a single transmission
	#frame = Frame()
	#identifier = 1
	#expiry = time.time()+3600
	#priority = 10
	#frame.add_item('0c43fb33e4f4d1436905844876d3e04d0af2e565d0d09d3a97d7a07388bd39c4', payload, identifier, expiry, priority)
	#apns.gateway_server.send_notification_multiple(frame)
