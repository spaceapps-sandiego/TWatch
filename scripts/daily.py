from .scrape import get_master_table, update_master, insert_knowns

def run():
	# get master data from Swift/BAT and update the database
	table = get_master_table()
	update_master(table)

	# get knowns
	insert_knowns()
