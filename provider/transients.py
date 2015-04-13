from db import db

def find_transients(name=None, lean=False):
	query = (db.transients.name==name) if name is not None else (db.transients.id>0)

	rows = db(query).select(db.transients.ALL).as_list()
	if not lean:
		for row in rows:
			row['events'] = db(db.intensities.trans_id==row['id']).select(db.intensities.ALL).as_list()

	return rows

def find_transient_by_id(id, lean=False):
	row = db.transients[id]
	if not lean:
		row['events'] = db(db.intensities.trans_id==row['id']).select(db.intensities.ALL)

	return row.as_dict()