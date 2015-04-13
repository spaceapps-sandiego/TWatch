import sys
sys.path.insert(0, '/var/www/twatch')
from flask import make_response, jsonify
from provider.api import api

def application(environ, responder):
	try:
		api(environ, responder)
	except IOError as e:
		resp = make_response(jsonify({ 'error': 'Something went wrong'}), 500)
		return resp(environ, responder)