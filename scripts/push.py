#!/usr/bin/python

#    0c43fb33e4f4d1436905844876d3e04d0af2e565d0d09d3a97d7a07388bd39c4


import time
from apns import APNs, Frame, Payload
from db import db, dbselect

apns = APNs(use_sandbox=True, cert_file='/opt/certs/twatch.crt', key_file='/opt/certs/twatch.pem')

def send_push_to_all(notice):
	# Send a notification
	#token_hex = '0c43fb33e4f4d1436905844876d3e04d0af2e565d0d09d3a97d7a07388bd39c4'
	payload = Payload(alert=notice, sound="default", badge=1)
	tokens = dbselect(db, 'SELECT id FROM devices')
	
	for token in tokens:
		apns.gateway_server.send_notification(token['id'], payload)

	# Send multiple notifications in a single transmission
	#frame = Frame()
	#identifier = 1
	#expiry = time.time()+3600
	#priority = 10
	#frame.add_item('0c43fb33e4f4d1436905844876d3e04d0af2e565d0d09d3a97d7a07388bd39c4', payload, identifier, expiry, priority)
	#apns.gateway_server.send_notification_multiple(frame)
