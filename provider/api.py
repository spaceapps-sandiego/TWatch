from flask import Flask, request, jsonify
import os

NaN = float('nan')

# initialize database
from db import db
import transients as trans
from utils import convert_from_j2000

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

@api.route('/api/v1/convert', methods=['GET', 'POST'])
def convert():
	from_type = request.values.get('from')
	ra = request.values.get('ra')
	dec = request.values.get('dec')

	if not (ra and dec):
		return jsonify({ 'error': '`ra` and `dec` are required' })

	if from_type == 'j2000':
		ra, dec = convert_from_j2000(ra, dec)
	else:
		ra, dec = NaN, NaN

	return jsonify({'ra': ra, 'dec': dec })


# start up server
PORT = os.getenv('PORT') or 8008
api.run(host='0.0.0.0', port=PORT, debug=True)