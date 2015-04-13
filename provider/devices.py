from db import db
import datetime

def add_device(device_token):
	row = db(db.devices.id==device_token).select()
	row = row.first() if row else None
	if row is None:
		db.devices.insert(id=device_token)
	else:
		db(db.devices.id==device_token).update(last_seen=datetime.datetime.now())

	row = db(db.devices.id==device_token).select().first()
	return row.as_dict()