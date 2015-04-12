import MySQLdb as mdb
from db import db, dbselectone, dbselect

INTENSITY_SELECT = 'SELECT * FROM intensities WHERE trans_id = %s'

def find_transients(name=None, lean=False):
	query = 'SELECT * FROM transients'
	if name is not None:
		query += ' WHERE name = %s'

	rows = dbselect(db, query, (name,) if name is not None else ())
	if not lean:
		for row in rows:
			row['events'] = dbselect(db, INTENSITY_SELECT, (row['id'],))
	return rows

def find_transient_by_id(id, lean=False):
	query = 'SELECT * FROM transients WHERE id = %s'
	row = dbselectone(db, query, (id,))
	if not lean:
		row['events'] = dbselect(db, INTENSITY_SELECT, (row['id'],))

	return row