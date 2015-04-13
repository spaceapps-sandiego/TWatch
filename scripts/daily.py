from scrape import *
from push import send_push_to_all

def run():
	# get master data from Swift/BAT and update the database
	table = get_master_table()
	num_updated = update_master(table)
	print num_updated

	if (num_updated>0):
		sendstr = "There have been %n new events today", (num_updated)
		send_push_to_all(sendstr)

	
	knowns = get_knowns('150411')

	results = xref_master_daily(table, knowns)
	insert_knowns(results)

if __name__ == '__main__':
	run()