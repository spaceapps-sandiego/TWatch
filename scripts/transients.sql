-- CREATE DATABASE IF NOT EXISTS trans;

-- GRANT USAGE ON *.* TO trans@localhost;
-- DROP USER trans@localhost;
-- CREATE USER trans@localhost IDENTIFIED BY 'transFTW!';
-- GRANT ALL ON trans.* TO trans@localhost;

-- USE trans;

-- DROP TABLE IF EXISTS intensities;
-- DROP TABLE IF EXISTS transients;
DROP TABLE IF EXISTS devices;

-- CREATE TABLE transients (
-- 	id INT NOT NULL AUTO_INCREMENT,
-- 	name VARCHAR(256) NOT NULL,
--   type VARCHAR(256),
-- 	ra VARCHAR(256) NOT NULL,
-- 	`dec` VARCHAR(256) NOT NULL,
-- 	PRIMARY KEY(ID),
--   FULLTEXT (name)
-- ) ENGINE=InnoDB;

-- CREATE  TABLE intensities (
--   id INT NOT NULL AUTO_INCREMENT,
--   intensity DOUBLE NOT NULL,
--   error DOUBLE NOT NULL,
--   sigma DOUBLE NOT NULL,
--   trans_id INT NOT NULL,
--   detected_time INT NOT NULL,
--   PRIMARY KEY (id),
--   INDEX trans_id_idx (trans_id ASC),
--   CONSTRAINT trans_id
--     FOREIGN KEY (trans_id)
--     REFERENCES transients (id)
--     ON DELETE NO ACTION
--     ON UPDATE NO ACTION
-- ) ENGINE=InnoDB;

CREATE TABLE devices (
  id VARCHAR(64) NOT NULL,
  last_seen TIMESTAMP,
  first_seen TIMESTAMP,
  PRIMARY KEY (id)
) ENGINE=InnoDB;