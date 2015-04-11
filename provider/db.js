var sql = require('sql');
var mysql = require('mysql');

// create connection to DB
var conn = mysql.createConnection({
	host     : 'localhost',
	user     : 'me',
	password : 'secret'
});

conn.connect();

// listen for exit event
process.on('exit', function() {
	// close up the DB connection
	conn.end();
});

module.exports = conn;