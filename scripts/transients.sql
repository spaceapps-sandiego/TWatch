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
DROP TABLE IF EXISTS intensities;
CREATE  TABLE `trans`.`intensities` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `val` VARCHAR(128) NOT NULL ,
  `trans_id` INT NOT NULL ,
  `detected_time` TIMESTAMP NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `trans_id_idx` (`trans_id` ASC) ,
  CONSTRAINT `trans_id`
    FOREIGN KEY (`trans_id` )
    REFERENCES `trans`.`transients` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

