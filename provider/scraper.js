var $ = require('cheerio');
var request = require('request');
var async = require('async');
var SWIFT_NASA = 'http://swift.gsfc.nasa.gov/results/transients/BAT_current.html';
var SWIFT_LC_NASA = 'http://swift.gsfc.nasa.gov/results/transients/%s.lc.txt'

function scrapeSwift(cb) {
	request.get(SWIFT_NASA, function(err, res) {
		var html = res.body;
		var $html = $(html);
		var $table = $html.find('table');
		var $rows = $table.find('tr:not(:first-child)');

		async.map(
			$rows,
			function(i, asyncCb) {
				var $row = $($rows[i]).find('td');
				var newRow = {
					id: $($row[0]).text().trim(),
					sourceName: $($row[1]).text().trim(),
					ra: $($row[2]).text().trim(),
					dec: $($row[3]).text().trim(),
					alt: $($row[4]).text().trim(),
					sourceType: $($row[5]).text().trim(),
					today: $($row[6]).text().trim(),
					yesterday: $($row[7]).text().trim(),
					tenday: $($row[8]).text().trim(),
					mean: $($row[9]).text().trim(),
					peak: $($row[10]).text().trim(),
					days: $($row[11]).text().trim(),
					lastDay: $($row[12]).text().trim()
				};

				asyncCb(null, newRow);
			},
			function(err, rows) {
				cb(null, rows);
			}
		);
	});
}

exports.scrapeSwift = scrapeSwift;