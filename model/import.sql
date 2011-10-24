SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP SCHEMA IF EXISTS `subhdb` ;
CREATE SCHEMA IF NOT EXISTS `subhdb` DEFAULT CHARACTER SET utf8 ;
USE `subhdb` ;

-- -----------------------------------------------------
-- Table `subhdb`.`keys`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `subhdb`.`keys` (
  `idkeys` BIGINT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(1024) NULL ,
  PRIMARY KEY (`idkeys`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `subhdb`.`document`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `subhdb`.`document` (
  `iddocument` BIGINT NOT NULL AUTO_INCREMENT ,
  `url` TEXT NULL ,
  `key_id` BIGINT NOT NULL ,
  PRIMARY KEY (`iddocument`) ,
  INDEX `fk_document_keys` (`key_id` ASC) ,
  CONSTRAINT `fk_document_keys`
    FOREIGN KEY (`key_id` )
    REFERENCES `subhdb`.`keys` (`idkeys` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `subhdb`.`attributes`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `subhdb`.`attributes` (
  `idattributes` BIGINT NOT NULL AUTO_INCREMENT ,
  `value` TEXT NULL ,
  `key_id` BIGINT NOT NULL ,
  `doc_id` BIGINT NOT NULL ,
  PRIMARY KEY (`idattributes`) ,
  INDEX `fk_attributes_keys1` (`key_id` ASC) ,
  INDEX `fk_attributes_document1` (`doc_id` ASC) ,
  CONSTRAINT `fk_attributes_keys1`
    FOREIGN KEY (`key_id` )
    REFERENCES `subhdb`.`keys` (`idkeys` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_attributes_document1`
    FOREIGN KEY (`doc_id` )
    REFERENCES `subhdb`.`document` (`iddocument` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
