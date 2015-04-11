var sql = require('sql');
var db = require('./db');

var trans = sql.define({
	name: 'transients',
	columns: ['id', 'name', 'ra', 'dec']
})

function findTransients(opts, cb) {
	var query;

	if (opts.name !== undefined) {
		query = trans
			.select(trans.star()) 			// SELECT * 
			.from(trans) 		  			// FROM transient
			.where(trans.name.equals(name)) // WHERE name = <NAME>;
			.toQuery();
	} else {
		query = trans.select(trans.star()).from(trans).toQuery();
	}

	db.query(query, cb);
}

function findTransientById(id, cb) {
	var query = trans
		.select(trans.star())		// SELECT *
		.from(trans)				// FROM transient
		.where(trans.id.equals(id)) // WHERE id = <ID>
		.limit(1)					// LIMIT 1;
		.toQuery();

	db.query(query, cb);
}