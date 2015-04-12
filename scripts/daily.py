from .scrape import get_master_table, update_master, insert_knowns
from push import send_push_to_all

def run():
	# get master data from Swift/BAT and update the database
	table = get_master_table()
	num_updated = update_master(table)


	if (num_updated>0):
		send_push_to_all("There have been %n new events today", (num_updated))


	# get knowns
	insert_knowns()
