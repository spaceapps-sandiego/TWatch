from pydal import DAL, Field
import sys

db = None

try:
	db = DAL('mysql://trans:transFTW!@localhost/trans', entity_quoting=True, fake_migrate=True, folder='./tables') #mdb.connect('localhost', 'trans', 'transFTW!', 'trans', cursorclass=mdb.cursors.DictCursor)
except Exception as e:
	print 'Error %s' % (e,)
	sys.exit(1)

db.define_table('transients',
	Field('name', 'string', notnull=True),
  	Field('type', 'string'),
	Field('ra', 'double', notnull=True),
	Field('dec', 'double', notnull=True)
)

# db.executesql('ALTER TABLE transients ADD INDEX (name)')

db.define_table('intensities',
  Field('intensity', 'double', notnull=True),
  Field('error', 'double', notnull=True),
  Field('sigma', 'double', notnull=True),
  Field('trans_id', 'reference transients', notnull=True),
  Field('detected_time', 'integer', notnull=True)
)

db.define_table('devices',
  Field('id', 'string', notnull=True),
  Field('last_seen', 'datetime'),
  Field('first_seen', 'datetime'),
  primarykey=['id']
)