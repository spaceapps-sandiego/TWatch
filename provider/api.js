var express = require('express');
var bodyParser = require('body-parser');
var trans = require('./transient');

// initialize database
require('./db');

var api = express();

api.use(bodyParser.json());
api.use(bodyParser.urlencoded({ extended: true }));

api.get('/api/transients', function(req, res) {
	trans.findTransients(function(err, rows) {
		
	});
});

// start up server
var PORT = process.env.PORT || 8008;
var server = api.listen(PORT, function() {
	console.log('Listening on ' + PORT);
});