var sql = require('sql');
var db = require('./db');

var trans = sql.define({
	name: 'transients',
	columns: ['id', 'ra', 'dec']
})

function findTransients(cb) {
	var query = trans.select(trans.star()).from(trans).toQuery();
	db.query(query, cb);
}

function findTransientByName(name, cb) {
	var query = trans
		.select(trans.star()) 			// SELECT * 
		.from(trans) 		  			// FROM transient
		.where(trans.name.equals(name)) // WHERE name = <NAME>
		.limit(1)						// LIMIT 1;
		.toQuery();

	db.query(query, cb);
}