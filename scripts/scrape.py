#!/usr/bin/python

from bs4 import BeautifulSoup
import MySQLdb as mdb
import MySQLdb.cursors
from urllib2 import urlopen, HTTPError
from datetime import datetime
from astropy.time import Time
from j2000 import convert_to_j2000

ALL_TRANS_URL = 'http://swift.gsfc.nasa.gov/results/transients'
BAT_CURRENT_URL = 'http://swift.gsfc.nasa.gov/results/transients/BAT_current.html'
SWIFT_GRBS_URL = 'http://gcn.gsfc.nasa.gov/swift_grbs.html'
SWIFT_NOTICE_URL = 'http://gcn.gsfc.nasa.gov/other/%s.swift'
GCN_KNOWN_URL = 'http://gcn.gsfc.nasa.gov/sub_sub_archive/known_%s.txt' # date: YYMMDD
COLUMNS = ['delta_time', 'type_num', 'ser_num', 'tjd', 'sod', 'trigger_num', 'ra', 'dec', 'error', 'intensity', 'sigma']

INSERT_INTENSITY = 'INSERT INTO intensities \
			 (intensity, error, sigma, trans_id, detected_time) \
			 VALUES (%s, %s, %s, %s, %s);'

def makelist(table, start=1, end=-1, header=0):
	result = []
	allrows = table.findAll('tr')
	for row in allrows[start:end]:
		result.append([])
		allcols = row.findAll('td')
		for col in allcols:
			thestrings = [unicode(s) for s in col.findAll(text=True)]
			thetext = ''.join(thestrings).strip()
			result[-1].append(thetext)
		if not result[-1]:
			del(result[-1])

	hrow = allrows[header]
	fields = hrow.findAll('th')
	fields = [unicode(s) for col in fields for s in col.findAll(text=True)]

	return result, fields

def scrape_table(url, start=1, end=-1, header=0):
	try:
		u = urlopen(url)
	except HTTPError as err:
		return []

	soup = BeautifulSoup(u)
	table = soup.find('table')
	tableout = makelist(table, start, end, header)
	u.close()
	return tableout

def dbinsert(db, *args):
	cur = db.cursor()
	cur.execute(*args)
	cur.close()

def dbselectone(db, *args):
	cur = db.cursor()
	cur.execute(*args)
	ret = cur.fetchone()
	cur.close()
	return ret

def dbselect(db, *args):
	cur = db.cursor()
	cur.execute(*args)
	ret = cur.fetchall()
	cur.close()
	return ret

def connectdb():
	return mdb.connect(db="trans", host="localhost",
					 user="trans", passwd="transFTW!",
					 cursorclass=MySQLdb.cursors.DictCursor)

def update_master(table):
	db = connectdb()
	count = 0

	for row in table:
		name = row['Source Name']
		t = dbselectone(db, 'SELECT id FROM transients WHERE name = %s', (name,))
		if not t:
			ra = row['RA J2000 Degs']
			dec = row['Dec J2000 Degs']
			source_type = row['Source Type']
			if ra != '' and dec != '':
				try:
					ra = float(ra)
					dec = float(dec)
					dbinsert(db, "INSERT INTO transients (name, ra, `dec`, `type`) VALUES (%s,%s,%s,%s)", (name, ra, dec, source_type))
					count+=1
				except ValueError as e:
					continue

	db.commit()
	return count

def create_dict(row, fields):
	if len(row) < len(fields):
		for i in range(len(fields) - len(row)):
			row.append(u'')
	return { k: row[i] for i, k in enumerate(fields) }

def get_master_table():
	trans_table, trans_fields = scrape_table(ALL_TRANS_URL, header=0)
	trans_table = [create_dict(r, trans_fields) for r in trans_table]

	table = []
	for r in trans_table:
		ra = r['RA J2000 Degs']
		dec = r['Dec J2000 Degs']

		if not (ra != '' and dec != ''):
			continue

		r['RA J2000 Degs'] = float(ra)
		r['Dec J2000 Degs'] = float(dec)
		table.append(r)

	return table

def get_grbs_table():
	grbs_table, grbs_fields = scrape_table(SWIFT_GRBS_URL, start=2, header=1)
	return [create_dict(r, grbs_fields) for r in grbs_table]

def get_knowns(datestring):
	url = GCN_KNOWN_URL % (datestring)
	try:
		f = urlopen(url)
	except HTTPError as err:
		return []

	lines = [r.rstrip().split('\t') for r in f]
	f.close()

	knowns = [create_dict(l, COLUMNS) for l in lines]
	for k in knowns:
		ra, dec, tjd, sod = k['ra'], k['dec'], k['tjd'], k['sod']
		if not (ra != '' and dec != '' and tjd != '' and sod != ''):
			continue
		try:
			ra, dec, tjd, sod = float(ra), float(dec), float(tjd), float(sod)
			k['sigma'], k['error'], k['intensity'] = float(k['sigma']), float(k['error']), float(k['intensity'])
		except ValueError as e:
			continue

		mjd = (tjd + 40000 + (sod/36000.0))
		k['mjd'] = mjd

		ra, dec = convert_to_j2000(ra, dec, mjd)

		k['ra'], k['dec'] = ra, dec

	return knowns

def insert_knowns(results):
	db = connectdb()

	for name, data in results.items():
		t = dbselectone(db, 'SELECT id FROM transients WHERE name = %s', (name,))
		trans_id = t['id']
		for event in data['events']:
			intensity = event['intensity']
			sigma = event['sigma']
			detected_time = event['timestamp']
			error = event['error']
			dbinsert(db, INSERT_INTENSITY, (intensity, error, sigma, trans_id, detected_time))

	db.commit()

def cross_reference(trans_table, grbs_table):
	results = []
	for trans_row in trans_table:
		today = trans_row['Today#']
		if today and today != '-':
			try:
				today, sig = map(float, today[:-1].split('('))
				ra = trans_row['RA J2000 Degs']
				dec = trans_row['Dec J2000 Degs']

				if ra != '' and dec != '':
					ra = float(ra)
					dec = float(dec)
				else:
					continue

				for grbs_row in grbs_table:
					grbs_ra = grbs_row['BAT RA']
					grbs_dec = grbs_row['BAT Dec']
					grbs_err = grbs_row['BAT Error']

					if grbs_ra != '' and grbs_dec != '' and grbs_err != '':
						grbs_ra = float(grbs_ra)
						grbs_dec = float(grbs_dec)
						grbs_err = float(grbs_err)
					else:
						continue

					grbs_err /= 60.0

					if (grbs_ra - grbs_err) <= ra <= (grbs_ra + grbs_err):
						if (grbs_dec - grbs_err) <= dec <= (grbs_dec + grbs_err):
							date = grbs_row['Date yy/mm/dd']
							time = grbs_row['Time UT']
							
							try:
								dt = datetime.strptime(date + u' ' + time, '%y/%m/%d %H:%M:%S.%f')
							except:
								continue

							results.append({
								'source_name': trans_row['Source Name'],
								'source_type': trans_row['Source Type'],
								'ra': ra,
								'dec': dec,
								'intensity': today,
								'timestamp': long(dt.strftime('%s'))
							})
							break
			except ValueError as e:
				continue
	return results

def xref_master_daily(master, daily):
	results = {}
	trans_table = get_master_table
	for row in daily:
		ra, dec, err = row['ra'], row['dec'], row['error']

		for tr in trans_table:
			tr_ra  = tr['RA J2000 Degs']
			tr_dec  = tr['Dec J2000 Degs']

			if (ra - err <= tr_ra <= ra + err) and (dec - err <= tr_dec <= dec + err):
				t = Time(row['mjd'], format='mjd')
				name = tr['Source Name']
				data = {
					'intensity': row['intensity'],
					'sigma': row['sigma'],
					'error': row['error'],
					'timestamp': int(t.unix)
				}

				if name in results:
					results[name]['events'].append(data)
				else:
					results[name] = {
						'name': name,
						'type': tr['Source Type'],
						'ra': tr_ra,
						'dec': tr_dec,
						'events': [data]
					}

	return results


if __name__ == '__main__':
	trans_table = get_master_table()
	update_master(trans_table)
	knowns = get_knowns('150411')

	results = xref_master_daily(trans_table, knowns)
	insert_knowns(results)



