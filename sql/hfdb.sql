-- phpMyAdmin SQL Dump
-- version 3.3.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jun 14, 2011 at 04:07 PM
-- Server version: 5.1.54
-- PHP Version: 5.3.5-1ubuntu7.2

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `hfdb`
--
CREATE DATABASE `hfdb` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `hfdb`;

-- --------------------------------------------------------

--
-- Table structure for table `ActualYtd`
--

CREATE TABLE IF NOT EXISTS `ActualYtd` (
  `seriesID` varchar(3) NOT NULL,
  `date` date NOT NULL,
  `value` decimal(10,0) NOT NULL,
  PRIMARY KEY (`seriesID`,`date`,`value`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ActualYtd`
--

INSERT INTO `ActualYtd` (`seriesID`, `date`, `value`) VALUES
('001', '2011-06-17', '10000');

-- --------------------------------------------------------

--
-- Table structure for table `Client`
--

CREATE TABLE IF NOT EXISTS `Client` (
  `clientID` varchar(3) NOT NULL,
  `name` varchar(10) NOT NULL,
  PRIMARY KEY (`clientID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Client`
--

INSERT INTO `Client` (`clientID`, `name`) VALUES
('001', 'PA784-02');

-- --------------------------------------------------------

--
-- Table structure for table `Fund`
--

CREATE TABLE IF NOT EXISTS `Fund` (
  `fundID` varchar(3) NOT NULL,
  `name` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`fundID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Fund`
--

INSERT INTO `Fund` (`fundID`, `name`) VALUES
('001', 'test1'),
('002', 'test2');

-- --------------------------------------------------------

--
-- Table structure for table `MarketValue`
--

CREATE TABLE IF NOT EXISTS `MarketValue` (
  `seriesID` varchar(3) NOT NULL,
  `date` date NOT NULL,
  `value` decimal(10,0) NOT NULL,
  PRIMARY KEY (`seriesID`,`date`,`value`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `MarketValue`
--

INSERT INTO `MarketValue` (`seriesID`, `date`, `value`) VALUES
('001', '2011-06-14', '1000'),
('002', '2011-06-15', '40000');

-- --------------------------------------------------------

--
-- Table structure for table `ReturnYtd`
--

CREATE TABLE IF NOT EXISTS `ReturnYtd` (
  `fundID` varchar(3) NOT NULL,
  `date` date NOT NULL,
  `source` varchar(10) NOT NULL,
  `value` decimal(10,0) DEFAULT NULL,
  PRIMARY KEY (`fundID`,`date`,`source`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ReturnYtd`
--

INSERT INTO `ReturnYtd` (`fundID`, `date`, `source`, `value`) VALUES
('001', '2011-06-14', 'testSource', '1000');

-- --------------------------------------------------------

--
-- Table structure for table `Returns`
--

CREATE TABLE IF NOT EXISTS `Returns` (
  `fundID` varchar(3) NOT NULL,
  `date` date NOT NULL,
  `source` varchar(10) NOT NULL,
  `value` decimal(10,0) DEFAULT NULL,
  PRIMARY KEY (`fundID`,`date`,`source`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Returns`
--

INSERT INTO `Returns` (`fundID`, `date`, `source`, `value`) VALUES
('001', '2011-06-14', 'testSource', '1000');

-- --------------------------------------------------------

--
-- Table structure for table `Series`
--

CREATE TABLE IF NOT EXISTS `Series` (
  `seriesID` varchar(3) NOT NULL,
  `clientID` varchar(3) NOT NULL,
  `fundID` varchar(3) NOT NULL,
  `initialAmt` decimal(10,0) DEFAULT NULL,
  `trancheDate` date DEFAULT NULL,
  `axysShares` int(11) DEFAULT NULL,
  `axysSymbol` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`seriesID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Series`
--

INSERT INTO `Series` (`seriesID`, `clientID`, `fundID`, `initialAmt`, `trancheDate`, `axysShares`, `axysSymbol`) VALUES
('001', '001', '001', '100000', '2011-06-08', 500, 'ABCDE'),
('002', '001', '002', '1000', '2011-06-09', 100, 'BCDEF');
