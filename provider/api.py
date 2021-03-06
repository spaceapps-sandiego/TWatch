from flask import Flask, request, jsonify, make_response, abort
import os

NaN = float('nan')

# initialize database
from db import db #, dbinsert, dbselectone, dbupdate
import transients as trans
import devices
from utils import convert_from_j2000, create_api_token

API_TOKEN = '5fca162b8b3a50d7c853ae6ebf494ba2'
# TOKEN_PATH = os.path.join(os.path.dirname(__file__), 'api_token')
# try:
# 	f = open(TOKEN_PATH, 'r')
# 	API_TOKEN = f.read()
# 	f.close()
# except IOError as e:
# 	print 'No API token'
# 	try:
# 		f = open(TOKEN_PATH, 'w+')
# 		f.write(create_api_token())
# 		f.close()
# 	except IOError as e:
# 		print 'Could not generate API token'

api = Flask(__name__)

@api.route('/api/v1/transients', methods=['GET'])
def transients():
	name = request.values.get('name')
	lean = request.values.get('lean')
	rows = trans.find_transients(name, lean=lean)
	return jsonify({ 'result': rows })

@api.route('/api/v1/transients/<int:id>', methods=['GET'])
def transient_by_id(id):
	lean = request.values.get('lean')
	row = trans.find_transient_by_id(id, lean=lean)
	return jsonify({ 'result': row })

@api.route('/api/v1/apn', methods=['GET', 'POST'])
def apn():
	if request.method == 'POST':
		device_token = request.values.get('deviceToken')
		api_token = request.headers.get('X-API-Token')

		if API_TOKEN is None:
			return abort(404)

		if device_token is None:
			return make_response(jsonify({ 'error': '`deviceToken` is required' }), 400)

		if api_token == API_TOKEN:
			row = devices.add_device(device_token)
			return jsonify({ 'result': row })
		else:
			return make_response(jsonify({ 'error': 'Invalid API Token' }), 400)
	else:
		return abort(404)

@api.route('/api/v1/convert', methods=['GET', 'POST'])
def convert():
	from_type = request.values.get('from')
	ra = request.values.get('ra')
	dec = request.values.get('dec')

	if not (ra and dec):
		return jsonify({ 'error': '`ra` and `dec` are required' })

	if from_type == 'j2000' or from_type is None:
		ra, dec = convert_from_j2000(ra, dec)
	else:
		ra, dec = NaN, NaN

	return jsonify({'ra': ra, 'dec': dec })

if __name__ == '__main__':
	# start up server
	PORT = os.getenv('PORT') or 8008
	api.run(host='0.0.0.0', port=PORT, debug=True)