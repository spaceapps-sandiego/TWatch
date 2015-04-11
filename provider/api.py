from flask import Flask, request, jsonify
import os

# initialize database
from db import db
import transients as trans

api = Flask(__name__)

@api.route('/api/v1/transients', methods=['GET'])
def transients():
	name = request.values.get('name')
	rows = trans.find_transients(name)
	return jsonify({ 'result': rows })

@api.route('/api/v1/transients/<int:id>', methods=['GET'])
def transient_by_id(id):
	row = trans.find_transient_by_id(id)
	return jsonify({ 'result': row })

# start up server
PORT = os.getenv('PORT') or 8008
api.run(port=PORT, debug=True)