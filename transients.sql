CREATE DATABASE IF NOT EXISTS trans;

GRANT USAGE ON *.* TO trans@localhost;
DROP USER trans@localhost;
CREATE USER trans@localhost IDENTIFIED BY 'transFTW!';
GRANT ALL ON trans.* TO trans@localhost;

USE trans;

DROP TABLE IF EXISTS transients;
CREATE TABLE transients (
	id INT NOT NULL AUTO_INCREMENT,
	seq_id VARCHAR(128) NOT NULL,
	name VARCHAR(256) NOT NULL,
	ra VARCHAR(256) NOT NULL,
	`dec` VARCHAR(256) NOT NULL,
	PRIMARY KEY(ID)
) ENGINE=InnoDB;
