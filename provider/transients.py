import MySQLdb as mdb
from db import db

def find_transients(name=None):
	query = 'SELECT * FROM transients'
	if name is not None:
		query += ' WHERE name = %s'

	cur = db.cursor()
	if name is not None:
		cur.execute(query, (name,))
	else:
		cur.execute(query)
	rows = cur.fetchall()
	cur.close()

	return rows

def find_transient_by_id(id):
	query = 'SELECT * FROM transients WHERE id = %s'
	cur = db.cursor()
	cur.execute(query, (id,))
	row = cur.fetchone()
	cur.close()

	return row