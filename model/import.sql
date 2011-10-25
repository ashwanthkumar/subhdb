SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;

DROP SCHEMA IF EXISTS `subhdb` ;
CREATE SCHEMA IF NOT EXISTS `subhdb` DEFAULT CHARACTER SET utf8 ;
USE `subhdb` ;

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `subhdb`
--

-- --------------------------------------------------------

--
-- Table structure for table `attributes`
--

DROP TABLE IF EXISTS `attributes`;
CREATE TABLE IF NOT EXISTS `attributes` (
  `idattributes` bigint(20) NOT NULL AUTO_INCREMENT,
  `value` text,
  `key_id` bigint(20) NOT NULL,
  `doc_id` bigint(20) NOT NULL,
  `parent_id` bigint(20) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`idattributes`),
  KEY `fk_attributes_keys1` (`key_id`),
  KEY `fk_attributes_document1` (`doc_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `document`
--

DROP TABLE IF EXISTS `document`;
CREATE TABLE IF NOT EXISTS `document` (
  `iddocument` bigint(20) NOT NULL AUTO_INCREMENT,
  `url` text,
  `key_id` bigint(20) NOT NULL,
  PRIMARY KEY (`iddocument`),
  KEY `fk_document_keys` (`key_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `keys`
--

DROP TABLE IF EXISTS `keys`;
CREATE TABLE IF NOT EXISTS `keys` (
  `idkeys` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`idkeys`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `attributes`
--
ALTER TABLE `attributes`
  ADD CONSTRAINT `fk_attributes_document1` FOREIGN KEY (`doc_id`) REFERENCES `document` (`iddocument`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_attributes_keys1` FOREIGN KEY (`key_id`) REFERENCES `keys` (`idkeys`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `document`
--
ALTER TABLE `document`
  ADD CONSTRAINT `fk_document_keys` FOREIGN KEY (`key_id`) REFERENCES `keys` (`idkeys`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Add the primary ID key as the default parameter
INSERT INTO `keys` (`idkeys`, `name`) VALUES (NULL, 'id');