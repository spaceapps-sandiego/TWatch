var express = require('express');
var bodyParser = require('body-parser');
var trans = require('./transient');

// initialize database
require('./db');

var api = express();

api.use(bodyParser.json());
api.use(bodyParser.urlencoded({ extended: true }));

api.get('/api/v1/transients', function(req, res) {
	trans.findTransients({
		name: req.body.name
	}, function(err, rows) {
		res.json({ result: rows });
	});
});

api.get('/api/v1/transients/:id', function(req, res) {
	trans.findTransientById(
		req.params.id,
		function(err, rows) {
			res.json({ result: rows[0] });
		}
	);
});

// start up server
var PORT = process.env.PORT || 8008;
var server = api.listen(PORT, function() {
	console.log('Listening on ' + PORT);
});