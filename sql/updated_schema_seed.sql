-- MySQL dump 10.13  Distrib 8.0.44, for macos15 (arm64)
--
-- Host: 127.0.0.1    Database: tech_barn
-- ------------------------------------------------------
-- Server version	8.0.44

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Account`
--

DROP TABLE IF EXISTS `Account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Account` (
  `account_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `account_name` varchar(50) DEFAULT NULL,
  `routing_number` char(9) NOT NULL,
  `account_number` varchar(20) NOT NULL,
  PRIMARY KEY (`account_id`),
  KEY `fk_account_user` (`user_id`),
  CONSTRAINT `fk_account_user` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Account`
--

LOCK TABLES `Account` WRITE;
/*!40000 ALTER TABLE `Account` DISABLE KEYS */;
INSERT INTO `Account` VALUES (1,1,'Alex Martinez Checking','110000000','000123456789'),(2,5,'Morgan Walker Checking','111000025','002345678901'),(3,7,'Avery Allen Savings','124003116','003456789012'),(4,9,'Cameron King Checking','125000105','004567890123'),(5,11,'Sage Lopez Savings','122105278','005678901234'),(6,13,'River Scott Checking','111000038','006789012345'),(7,15,'Skyler Adams Savings','122400724','007890123456'),(8,19,'Reese Mitchell Savings','111000025','009012345678'),(9,21,'Parker Roberts Checking','124003116','010123456789'),(10,23,'Drew Phillips Savings','125000105','011234567890'),(11,27,'Harper Edwards Savings','121000248','013456789012'),(12,29,'Kai Stewart Checking','111000038','014567890123');
/*!40000 ALTER TABLE `Account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Address`
--

DROP TABLE IF EXISTS `Address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Address` (
  `address_id` int NOT NULL AUTO_INCREMENT,
  `street_name` varchar(100) NOT NULL,
  `apt_no` varchar(10) DEFAULT NULL,
  `city` varchar(20) NOT NULL,
  `state` varchar(20) NOT NULL,
  `zip` varchar(10) NOT NULL,
  PRIMARY KEY (`address_id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Address`
--

LOCK TABLES `Address` WRITE;
/*!40000 ALTER TABLE `Address` DISABLE KEYS */;
INSERT INTO `Address` VALUES (1,'123 Main Street','Apt 4B','New York','NY','10001'),(2,'456 Oak Avenue','Suite 200','Los Angeles','CA','90001'),(3,'789 Pine Road',NULL,'Chicago','IL','60601'),(4,'321 Elm Drive','Apt 12','Houston','TX','77001'),(5,'654 Maple Lane','Unit 5','Phoenix','AZ','85001'),(6,'987 Cedar Street',NULL,'Philadelphia','PA','19101'),(7,'147 Birch Court','Apt 8','San Antonio','TX','78201'),(8,'258 Spruce Way','Suite 101','San Diego','CA','92101'),(9,'369 Willow Avenue',NULL,'Dallas','TX','75201'),(10,'741 Ash Boulevard','Apt 3C','San Jose','CA','95101'),(11,'852 Redwood Circle','Unit 7','Austin','TX','78701'),(12,'963 Cypress Drive',NULL,'Jacksonville','FL','32201'),(13,'159 Sequoia Road','Apt 9','Fort Worth','TX','76101'),(14,'357 Poplar Street','Suite 15','Columbus','OH','43201'),(15,'468 Sycamore Lane',NULL,'Charlotte','NC','28201'),(16,'579 Magnolia Avenue','Apt 2A','San Francisco','CA','94101'),(17,'681 Dogwood Court','Unit 11','Indianapolis','IN','46201'),(18,'792 Hickory Way',NULL,'Seattle','WA','98101'),(19,'813 Chestnut Drive','Apt 6','Denver','CO','80201'),(20,'924 Walnut Street','Suite 20','Boston','MA','02101'),(21,'135 Cherry Lane',NULL,'Nashville','TN','37201'),(22,'246 Apple Avenue','Apt 10','Detroit','MI','48201'),(23,'357 Peach Circle','Unit 4','Portland','OR','97201'),(24,'468 Orange Drive',NULL,'Oklahoma City','OK','73101'),(25,'579 Lemon Street','Apt 5B','Las Vegas','NV','89101'),(26,'680 Lime Road','Suite 30','Memphis','TN','38101'),(27,'791 Grape Court',NULL,'Louisville','KY','40201'),(28,'802 Berry Way','Apt 7','Baltimore','MD','21201'),(29,'913 Plum Lane','Unit 9','Milwaukee','WI','53201'),(30,'124 Banana Avenue',NULL,'Albuquerque','NM','87101');
/*!40000 ALTER TABLE `Address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Admin`
--

DROP TABLE IF EXISTS `Admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Admin` (
  `admin_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(20) NOT NULL,
  `last_name` varchar(20) NOT NULL,
  `username` varchar(50) NOT NULL,
  `salary` int DEFAULT NULL,
  `password` varchar(20) NOT NULL,
  `email` varchar(50) NOT NULL,
  `phone_no` char(10) DEFAULT NULL,
  PRIMARY KEY (`admin_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Admin`
--

LOCK TABLES `Admin` WRITE;
/*!40000 ALTER TABLE `Admin` DISABLE KEYS */;
INSERT INTO `Admin` VALUES (1,'Michael','Scott','admin',100000,'password','michaelscott@theoffice.com','1234567890');
/*!40000 ALTER TABLE `Admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Alert`
--

DROP TABLE IF EXISTS `Alert`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Alert` (
  `alert_id` int NOT NULL AUTO_INCREMENT,
  `min_price` decimal(10,2) DEFAULT NULL,
  `max_price` decimal(10,2) NOT NULL,
  `keyword` varchar(10) DEFAULT NULL,
  `active` varchar(20) NOT NULL,
  `user_id` int NOT NULL,
  `item_id` int NOT NULL,
  PRIMARY KEY (`alert_id`),
  KEY `fk_alert_user` (`user_id`),
  KEY `fk_alert_item` (`item_id`),
  CONSTRAINT `fk_alert_item` FOREIGN KEY (`item_id`) REFERENCES `Item` (`item_id`),
  CONSTRAINT `fk_alert_user` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Alert`
--

LOCK TABLES `Alert` WRITE;
/*!40000 ALTER TABLE `Alert` DISABLE KEYS */;
INSERT INTO `Alert` VALUES (1,400.00,700.00,'iPhone','Yes',2,1),(2,500.00,800.00,'Samsung','Yes',4,3),(3,300.00,500.00,'Google','Yes',6,5),(4,800.00,1200.00,'TV','Yes',8,11),(5,900.00,1300.00,'OLED','Yes',10,12),(6,200.00,400.00,'Headphone','Yes',12,21),(7,150.00,300.00,'AirPods','Yes',14,22),(8,800.00,1200.00,'Sony','Yes',16,23),(9,1000.00,1500.00,'QLED','Yes',18,16),(10,500.00,800.00,'OnePlus','Yes',20,7),(11,400.00,600.00,'Pixel','Yes',22,6),(12,250.00,450.00,'Bose','Yes',24,27),(13,600.00,900.00,'iPhone','No',26,2),(14,1200.00,1800.00,'Samsung','No',28,3),(15,200.00,350.00,'Sony','Yes',30,21),(16,350.00,550.00,'Samsung','Yes',2,4),(17,850.00,1100.00,'LG','Yes',4,17),(18,150.00,250.00,'Apple','Yes',6,34),(19,1000.00,1400.00,'Sony','Yes',8,18),(20,200.00,400.00,'Beats','Yes',10,29);
/*!40000 ALTER TABLE `Alert` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Auction`
--

DROP TABLE IF EXISTS `Auction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Auction` (
  `auction_id` int NOT NULL AUTO_INCREMENT,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `increment` decimal(10,2) NOT NULL,
  `status` varchar(20) NOT NULL,
  `minimum_price` decimal(10,2) NOT NULL,
  `starting_price` decimal(10,2) NOT NULL,
  `seller_id` int NOT NULL,
  `item_id` int NOT NULL,
  PRIMARY KEY (`auction_id`),
  KEY `fk_auction_seller` (`seller_id`),
  KEY `fk_auction_item` (`item_id`),
  CONSTRAINT `fk_auction_item` FOREIGN KEY (`item_id`) REFERENCES `Item` (`item_id`),
  CONSTRAINT `fk_auction_seller` FOREIGN KEY (`seller_id`) REFERENCES `User` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Auction`
--

LOCK TABLES `Auction` WRITE;
/*!40000 ALTER TABLE `Auction` DISABLE KEYS */;
INSERT INTO `Auction` VALUES (1,'2024-08-01 09:00:00','2024-08-10 18:00:00',10.00,'ACTIVE',500.00,600.00,1,1),(2,'2024-08-02 10:00:00','2024-08-11 20:00:00',15.00,'ACTIVE',450.00,550.00,3,2),(3,'2024-08-03 11:00:00','2024-08-12 18:00:00',25.00,'ACTIVE',800.00,1000.00,5,3),(4,'2024-08-04 12:00:00','2024-08-13 19:00:00',20.00,'ACTIVE',400.00,500.00,7,4),(5,'2024-08-05 09:00:00','2024-08-14 17:00:00',30.00,'ACTIVE',700.00,850.00,9,5),(6,'2024-08-06 10:00:00','2024-08-15 18:00:00',12.00,'ACTIVE',350.00,450.00,11,6),(7,'2024-08-07 11:00:00','2024-08-16 20:00:00',40.00,'ACTIVE',600.00,750.00,13,7),(8,'2024-08-08 12:00:00','2024-08-17 19:00:00',18.00,'ACTIVE',550.00,650.00,15,8),(9,'2024-08-01 14:00:00','2024-08-08 18:00:00',10.00,'CLOSED_SOLD',300.00,400.00,17,9),(10,'2024-08-02 15:00:00','2024-08-09 20:00:00',15.00,'CLOSED_PRICE_NOT_MET',450.00,550.00,19,10),(11,'2024-08-09 09:00:00','2024-08-18 18:00:00',50.00,'ACTIVE',1000.00,1200.00,21,11),(12,'2024-08-10 10:00:00','2024-08-19 19:00:00',45.00,'ACTIVE',900.00,1100.00,23,12),(13,'2024-08-11 11:00:00','2024-08-20 20:00:00',60.00,'ACTIVE',1500.00,1800.00,25,13),(14,'2024-08-12 12:00:00','2024-08-21 18:00:00',25.00,'ACTIVE',400.00,500.00,27,14),(15,'2024-08-13 09:00:00','2024-08-22 17:00:00',20.00,'ACTIVE',350.00,450.00,29,15),(16,'2024-08-14 10:00:00','2024-08-23 19:00:00',55.00,'ACTIVE',950.00,1150.00,1,16),(17,'2024-08-15 11:00:00','2024-08-24 20:00:00',50.00,'ACTIVE',1100.00,1300.00,3,17),(18,'2024-08-16 12:00:00','2024-08-25 18:00:00',70.00,'ACTIVE',2000.00,2400.00,5,18),(19,'2024-08-17 09:00:00','2024-08-26 17:00:00',35.00,'ACTIVE',650.00,800.00,7,19),(20,'2024-08-18 10:00:00','2024-08-27 19:00:00',40.00,'ACTIVE',750.00,900.00,9,20),(21,'2024-08-19 11:00:00','2024-08-28 20:00:00',15.00,'ACTIVE',300.00,350.00,11,21),(22,'2024-08-20 12:00:00','2024-08-29 18:00:00',12.00,'REMOVED',200.00,250.00,13,22),(23,'2024-08-03 14:00:00','2024-08-10 20:00:00',18.00,'CLOSED_SOLD',250.00,300.00,15,23),(24,'2024-08-04 15:00:00','2024-08-11 19:00:00',20.00,'ACTIVE',150.00,200.00,17,24),(25,'2024-08-21 09:00:00','2024-08-30 17:00:00',10.00,'ACTIVE',180.00,220.00,19,25),(26,'2024-08-22 10:00:00','2024-08-31 18:00:00',25.00,'ACTIVE',400.00,500.00,21,26),(27,'2024-08-23 11:00:00','2024-09-01 19:00:00',12.00,'ACTIVE',220.00,270.00,23,27),(28,'2024-08-24 12:00:00','2024-09-02 20:00:00',15.00,'ACTIVE',120.00,150.00,25,28),(29,'2024-08-25 09:00:00','2024-09-03 18:00:00',10.00,'ACTIVE',200.00,250.00,27,29),(30,'2024-08-26 10:00:00','2024-09-04 17:00:00',20.00,'ACTIVE',300.00,350.00,29,30),(31,'2024-08-05 14:00:00','2024-08-12 19:00:00',15.00,'CLOSED_PRICE_NOT_MET',180.00,230.00,1,31),(32,'2024-08-27 11:00:00','2024-09-05 20:00:00',12.00,'ACTIVE',250.00,300.00,3,32),(33,'2024-08-28 12:00:00','2024-09-06 18:00:00',18.00,'ACTIVE',280.00,330.00,5,33),(34,'2024-08-29 09:00:00','2024-09-07 17:00:00',10.00,'REMOVED',150.00,180.00,7,34),(35,'2024-08-30 10:00:00','2024-09-08 19:00:00',15.00,'ACTIVE',100.00,130.00,9,35);
/*!40000 ALTER TABLE `Auction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Bid`
--

DROP TABLE IF EXISTS `Bid`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Bid` (
  `bid_no` int NOT NULL AUTO_INCREMENT,
  `auction_id` int NOT NULL,
  `status` varchar(20) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `bid_time` datetime NOT NULL,
  `auto_bid` tinyint(1) NOT NULL DEFAULT '0',
  `max_bid` decimal(10,2) DEFAULT NULL,
  `buyer_id` int NOT NULL,
  `rep_id` int DEFAULT NULL,
  `reason` varchar(100) DEFAULT NULL,
  `remove_date` datetime DEFAULT NULL,
  PRIMARY KEY (`bid_no`,`auction_id`),
  KEY `fk_bid_auction` (`auction_id`),
  KEY `fk_bid_buyer` (`buyer_id`),
  KEY `fk_bid_rep` (`rep_id`),
  CONSTRAINT `fk_bid_auction` FOREIGN KEY (`auction_id`) REFERENCES `Auction` (`auction_id`),
  CONSTRAINT `fk_bid_buyer` FOREIGN KEY (`buyer_id`) REFERENCES `User` (`user_id`),
  CONSTRAINT `fk_bid_rep` FOREIGN KEY (`rep_id`) REFERENCES `Cust_Rep` (`rep_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Bid`
--

LOCK TABLES `Bid` WRITE;
/*!40000 ALTER TABLE `Bid` DISABLE KEYS */;
INSERT INTO `Bid` VALUES (1,1,'ACTIVE',610.00,'2024-08-01 14:30:00',0,NULL,2,NULL,NULL,NULL),(1,2,'ACTIVE',565.00,'2024-08-02 15:45:00',0,NULL,8,NULL,NULL,NULL),(1,3,'ACTIVE',1025.00,'2024-08-03 13:00:00',0,NULL,12,NULL,NULL,NULL),(1,4,'ACTIVE',520.00,'2024-08-04 14:20:00',0,NULL,16,NULL,NULL,NULL),(1,5,'ACTIVE',880.00,'2024-08-05 10:30:00',0,NULL,18,NULL,NULL,NULL),(1,9,'LOST',410.00,'2024-08-02 15:30:00',0,NULL,4,NULL,NULL,NULL),(1,11,'REMOVED',1250.00,'2024-08-09 12:30:00',0,NULL,2,1,'Suspicious activity detected','2024-08-09 13:00:00'),(1,12,'REMOVED',1150.00,'2024-08-10 14:20:00',0,NULL,4,2,'Invalid payment method','2024-08-10 15:00:00'),(1,13,'ACTIVE',1860.00,'2024-08-11 16:45:00',1,2000.00,6,NULL,NULL,NULL),(1,14,'ACTIVE',525.00,'2024-08-12 11:15:00',0,NULL,8,NULL,NULL,NULL),(1,15,'ACTIVE',470.00,'2024-08-13 13:30:00',0,NULL,10,NULL,NULL,NULL),(1,16,'ACTIVE',1205.00,'2024-08-14 15:00:00',0,NULL,12,NULL,NULL,NULL),(1,17,'ACTIVE',1350.00,'2024-08-15 10:45:00',1,1500.00,14,NULL,NULL,NULL),(1,18,'ACTIVE',2470.00,'2024-08-16 17:20:00',0,NULL,16,NULL,NULL,NULL),(1,19,'ACTIVE',835.00,'2024-08-17 12:10:00',0,NULL,18,NULL,NULL,NULL),(1,20,'ACTIVE',940.00,'2024-08-18 14:30:00',1,1100.00,20,NULL,NULL,NULL),(1,21,'ACTIVE',365.00,'2024-08-19 11:45:00',0,NULL,22,NULL,NULL,NULL),(1,22,'ACTIVE',262.00,'2024-08-20 13:20:00',0,NULL,24,NULL,NULL,NULL),(1,23,'LOST',310.00,'2024-08-05 16:15:00',0,NULL,10,NULL,NULL,NULL),(1,24,'ACTIVE',220.00,'2024-08-04 16:30:00',0,NULL,26,NULL,NULL,NULL),(1,25,'ACTIVE',240.00,'2024-08-21 10:15:00',0,NULL,28,NULL,NULL,NULL),(1,26,'ACTIVE',525.00,'2024-08-22 12:45:00',1,600.00,30,NULL,NULL,NULL),(1,27,'ACTIVE',282.00,'2024-08-23 14:00:00',0,NULL,2,NULL,NULL,NULL),(1,28,'ACTIVE',165.00,'2024-08-24 15:30:00',0,NULL,4,NULL,NULL,NULL),(1,29,'ACTIVE',270.00,'2024-08-25 11:20:00',0,NULL,6,NULL,NULL,NULL),(1,30,'ACTIVE',370.00,'2024-08-26 13:45:00',1,450.00,8,NULL,NULL,NULL),(1,32,'ACTIVE',312.00,'2024-08-27 16:10:00',0,NULL,10,NULL,NULL,NULL),(1,33,'ACTIVE',348.00,'2024-08-28 12:25:00',0,NULL,14,NULL,NULL,NULL),(1,34,'ACTIVE',190.00,'2024-08-29 14:40:00',0,NULL,16,NULL,NULL,NULL),(1,35,'ACTIVE',145.00,'2024-08-30 10:55:00',0,NULL,18,NULL,NULL,NULL),(2,1,'ACTIVE',630.00,'2024-08-02 10:15:00',0,NULL,4,NULL,NULL,NULL),(2,2,'ACTIVE',580.00,'2024-08-03 11:30:00',1,650.00,10,NULL,NULL,NULL),(2,3,'ACTIVE',1050.00,'2024-08-04 09:45:00',1,1200.00,14,NULL,NULL,NULL),(2,5,'ACTIVE',910.00,'2024-08-06 15:10:00',1,1000.00,20,NULL,NULL,NULL),(2,9,'WON',420.00,'2024-08-03 16:00:00',0,NULL,2,NULL,NULL,NULL),(2,23,'WON',320.00,'2024-08-06 18:45:00',0,NULL,8,NULL,NULL,NULL),(3,1,'ACTIVE',650.00,'2024-08-03 16:20:00',1,750.00,6,NULL,NULL,NULL);
/*!40000 ALTER TABLE `Bid` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Card`
--

DROP TABLE IF EXISTS `Card`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Card` (
  `card_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `card_name` varchar(50) NOT NULL,
  `card_no` char(16) NOT NULL,
  `exp_date` date NOT NULL,
  `cvc` char(3) NOT NULL,
  `bill_add_id` int NOT NULL,
  PRIMARY KEY (`card_id`),
  KEY `fk_card_user` (`user_id`),
  KEY `fk_card_address` (`bill_add_id`),
  CONSTRAINT `fk_card_address` FOREIGN KEY (`bill_add_id`) REFERENCES `Address` (`address_id`),
  CONSTRAINT `fk_card_user` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Card`
--

LOCK TABLES `Card` WRITE;
/*!40000 ALTER TABLE `Card` DISABLE KEYS */;
INSERT INTO `Card` VALUES (1,1,'Alex Martinez','4532015112830366','2026-12-31','123',1),(2,2,'Taylor Garcia','5555555555554444','2027-06-30','456',2),(3,3,'Jordan Rodriguez','4111111111111111','2028-03-31','789',3),(4,4,'Casey Lewis','5105105105105100','2026-09-30','321',4),(5,5,'Morgan Walker','4000000000000002','2027-11-30','654',5),(6,6,'Riley Hall','4242424242424242','2028-01-31','987',6),(7,7,'Avery Allen','5200828282828210','2026-08-31','147',7),(8,8,'Quinn Young','371449635398431','2027-04-30','258',8),(9,9,'Cameron King','6011111111111117','2028-07-31','369',9),(10,10,'Dakota Wright','6011000990139424','2026-10-31','741',10),(11,11,'Sage Lopez','30569309025904','2027-12-31','852',11),(12,12,'Blake Hill','38520000023237','2028-02-28','963',12),(13,13,'River Scott','378282246310005','2026-11-30','159',13),(14,14,'Phoenix Green','378734493671000','2027-05-31','357',14),(15,15,'Skyler Adams','4000000000000010','2028-09-30','468',15),(16,16,'Rowan Baker','4242424242424242','2026-07-31','579',16),(17,17,'Finley Nelson','5555555555554444','2027-03-31','680',17),(18,18,'Hayden Carter','5105105105105100','2028-06-30','791',18),(19,19,'Reese Mitchell','4111111111111111','2026-04-30','802',19),(20,20,'Jamie Perez','4532015112830366','2027-10-31','913',20);
/*!40000 ALTER TABLE `Card` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Cust_Rep`
--

DROP TABLE IF EXISTS `Cust_Rep`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Cust_Rep` (
  `rep_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(20) NOT NULL,
  `last_name` varchar(20) NOT NULL,
  `username` varchar(50) NOT NULL,
  `salary` int DEFAULT NULL,
  `password` varchar(20) NOT NULL,
  `email` varchar(50) NOT NULL,
  `phone_no` char(10) DEFAULT NULL,
  `region` varchar(50) DEFAULT NULL,
  `admin_id` int NOT NULL,
  PRIMARY KEY (`rep_id`),
  KEY `fk_custrep_admin` (`admin_id`),
  CONSTRAINT `fk_custrep_admin` FOREIGN KEY (`admin_id`) REFERENCES `Admin` (`admin_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Cust_Rep`
--

LOCK TABLES `Cust_Rep` WRITE;
/*!40000 ALTER TABLE `Cust_Rep` DISABLE KEYS */;
INSERT INTO `Cust_Rep` VALUES (1,'Jim','Halpert','jimHalpert',60000,'ilovepam','jimhalpert@theoffice.com','2353467890','Northeast',1),(2,'Pam','Beesly','pamBeesly',55000,'ilovejim','pambeesly@theoffice.com','3454567890','Northeast',1),(3,'Dwight','Schrute','dwightSchrute',65000,'bearsBears','dwightSchrute@theoffice.com','4565678901','Northeast',1);
/*!40000 ALTER TABLE `Cust_Rep` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Headphones`
--

DROP TABLE IF EXISTS `Headphones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Headphones` (
  `item_id` int NOT NULL,
  `isWireless` tinyint(1) NOT NULL DEFAULT '0',
  `hasMicrophone` tinyint(1) NOT NULL DEFAULT '0',
  `hasNoiseCancellation` tinyint(1) NOT NULL DEFAULT '0',
  `cable_type` varchar(10) NOT NULL,
  `headphone_battery_life` int DEFAULT NULL,
  PRIMARY KEY (`item_id`),
  CONSTRAINT `fk_headphones_item` FOREIGN KEY (`item_id`) REFERENCES `Item` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Headphones`
--

LOCK TABLES `Headphones` WRITE;
/*!40000 ALTER TABLE `Headphones` DISABLE KEYS */;
INSERT INTO `Headphones` VALUES (21,1,1,1,'USB-C',36),(22,1,1,1,'Lightning',12),(23,1,1,1,'USB-C',36),(24,0,0,0,'3.5mm',0),(25,1,1,1,'USB-C',12),(26,1,1,1,'Lightning',22),(27,0,1,1,'USB-C',0),(28,1,0,1,'USB-C',12),(29,1,0,0,'USB-C',22),(30,0,1,0,'3.5mm',0),(31,0,0,0,'3.5mm',0),(32,1,1,1,'USB-C',24),(33,0,0,0,'3.5mm',0),(34,0,0,0,'Lightning',0),(35,1,1,0,'USB-C',24);
/*!40000 ALTER TABLE `Headphones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Item`
--

DROP TABLE IF EXISTS `Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Item` (
  `item_id` int NOT NULL AUTO_INCREMENT,
  `brand` varchar(20) NOT NULL,
  `condition` varchar(20) NOT NULL,
  `title` varchar(20) NOT NULL,
  `category_id` tinyint(1) NOT NULL,
  `color` varchar(20) DEFAULT NULL,
  `in_stock` tinyint(1) NOT NULL DEFAULT '1',
  `image_path` varchar(255) DEFAULT NULL,
  `description` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Item`
--

LOCK TABLES `Item` WRITE;
/*!40000 ALTER TABLE `Item` DISABLE KEYS */;
INSERT INTO `Item` VALUES (1,'Apple','New','iPhone 15 Pro',1,'Pink',1,'Images/item_photos/phones/iphone_pink.jpg',NULL),(2,'Apple','Like New','iPhone 14',1,'Red',1,'Images/item_photos/phones/iphone_red.png',NULL),(3,'Samsung','New','Galaxy S24 Ultra',1,'Titanium Gray',1,'Images/item_photos/phones/samsung_titanium_gray.jpg',NULL),(4,'Samsung','Good','Galaxy S23',1,'Phantom Black',1,'Images/item_photos/phones/samsung_phantom_black.jpeg',NULL),(5,'Google','New','Pixel 8 Pro',1,'Obsidian',1,'Images/item_photos/phones/google_obsidian.jpeg',NULL),(6,'Google','Like New','Pixel 7',1,'Snow',1,'Images/item_photos/phones/google_pixel_snow.jpg',NULL),(7,'OnePlus','New','OnePlus 12',1,'Pink',1,'Images/item_photos/phones/oneplus_pink.jpg',NULL),(8,'OnePlus','Good','OnePlus 11',1,'Titan Black',1,'Images/item_photos/phones/oneplus_titan_black.jpg',NULL),(9,'Apple','Fair','iPhone 13',1,'Blue',1,'Images/item_photos/phones/iphone_blue.jpg',NULL),(10,'Samsung','Like New','Galaxy S22',1,'Orange',1,'Images/item_photos/phones/samsung_orange.png',NULL),(11,'Samsung','New','Samsung QLED 65\"',2,'Black',1,'Images/item_photos/tvs/samsung_qled.jpg',NULL),(12,'LG','New','LG OLED 55\"',2,'Black',1,'Images/item_photos/tvs/lg_tv.jpeg',NULL),(13,'Sony','Like New','Sony Bravia 75\"',2,'Silver',1,'Images/item_photos/tvs/sony_tv.jpg',NULL),(14,'TCL','New','TCL Roku TV 50\"',2,'Black',1,'Images/item_photos/tvs/tcl_tv.png',NULL),(15,'Vizio','Good','Vizio Smart TV 43\"',2,'Black',1,'Images/item_photos/tvs/vizio_tv.png',NULL),(16,'Samsung','New','Samsung QLED 55\"',2,'Titanium',1,'Images/item_photos/tvs/samsung_qled.jpg',NULL),(17,'LG','Like New','LG OLED 65\"',2,'Silver',1,'Images/item_photos/tvs/lg_tv.jpeg',NULL),(18,'Sony','New','Sony X90L 85\"',2,'Black',1,'Images/item_photos/tvs/sony_tv.jpg',NULL),(19,'Hisense','Good','Hisense ULED 58\"',2,'Gray',1,'Images/item_photos/tvs/hisense_tv.jpg',NULL),(20,'Panasonic','New','Panasonic OLED 48\"',2,'Black',1,'Images/item_photos/tvs/panasonic_tv.jpg',NULL),(21,'Sony','New','Sony WH-1000XM5',3,'Blue',1,'Images/item_photos/headphones/sony_wireless_blue.jpg',NULL),(22,'Apple','New','AirPods 2',3,'White',1,'Images/item_photos/headphones/apple_wireless_white.jpeg',NULL),(23,'Bose','Like New','Bose QuietComfort 45',3,'Black',1,'Images/item_photos/headphones/bose_wireless_black.jpg',NULL),(24,'Sennheiser','New','Sennheiser HD 660S',3,'Black',1,'Images/item_photos/headphones/seinheisser_wired_black.jpg',NULL),(25,'Sony','Good','Sony WF-1000XM5',3,'Black',1,'Images/item_photos/headphones/sony_wireless_black.jpeg',NULL),(26,'Apple','Like New','AirPods Max',3,'Starlight',1,'Images/item_photos/headphones/apple_wireless_max.jpg',NULL),(27,'Bose','New','Bose 700',3,'Black',1,'Images/item_photos/headphones/bose_wired_black.jpg',NULL),(28,'JBL','New','JBL Tune 770NC',3,'Red',1,'Images/item_photos/headphones/jbl_wireless_red.jpg',NULL),(29,'Beats','Good','Beats Studio Pro',3,'Purple',1,'Images/item_photos/headphones/beats_wireless_purple.jpg',NULL),(30,'Sony','Like New','Sony WH-1000XM4',3,'Black',1,'Images/item_photos/headphones/sony_wired_black.jpg',NULL),(31,'Audio-Technica','New','ATH-M50xBT2',3,'Black',1,'Images/item_photos/headphones/audio_technica_wired_blue.jpg',NULL),(32,'Sennheiser','Good','Momentum 4',3,'White',1,'Images/item_photos/headphones/sennheiser_wireless_white.jpg',NULL),(33,'Sony','New','Sony WH-XB910N',3,'Blue',1,'Images/item_photos/headphones/sony_wired_blue.jpg',NULL),(34,'Apple','New','EarPods',3,'White',1,'Images/item_photos/headphones/apple_wired_white.jpg',NULL),(35,'Bose','Like New','Bose Sport Earbuds',3,'Black',1,'Images/item_photos/headphones/bose_wireless_black2.jpg',NULL);
/*!40000 ALTER TABLE `Item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Phone`
--

DROP TABLE IF EXISTS `Phone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Phone` (
  `item_id` int NOT NULL,
  `os` varchar(10) NOT NULL,
  `storage_gb` int NOT NULL,
  `ram_gb` int NOT NULL,
  `phone_screen_size` float NOT NULL,
  `rear_camera_mp` int NOT NULL,
  `front_camera_mp` int NOT NULL,
  `isUnlocked` tinyint(1) NOT NULL DEFAULT '0',
  `phone_battery_life` int NOT NULL,
  `is5G` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`item_id`),
  CONSTRAINT `fk_phone_item` FOREIGN KEY (`item_id`) REFERENCES `Item` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Phone`
--

LOCK TABLES `Phone` WRITE;
/*!40000 ALTER TABLE `Phone` DISABLE KEYS */;
INSERT INTO `Phone` VALUES (1,'iOS',256,8,6.1,48,12,1,23,1),(2,'iOS',128,6,6.1,12,12,0,20,0),(3,'Android',512,12,6.8,200,12,1,25,1),(4,'Android',256,8,6.1,50,12,0,22,0),(5,'Android',128,12,6.7,50,11,1,24,1),(6,'Android',128,8,6.3,50,11,1,24,0),(7,'Android',256,16,6.82,50,32,1,27,1),(8,'Android',256,16,6.7,50,16,1,25,1),(9,'iOS',128,4,6.1,12,12,0,19,0),(10,'Android',128,8,6.1,50,10,0,23,0);
/*!40000 ALTER TABLE `Phone` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Question`
--

DROP TABLE IF EXISTS `Question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Question` (
  `question_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(20) NOT NULL,
  `contents` varchar(50) NOT NULL,
  `status` varchar(20) NOT NULL,
  `date_asked` datetime NOT NULL,
  `user_id` int NOT NULL,
  `reply` varchar(100) DEFAULT NULL,
  `rep_id` int DEFAULT NULL,
  PRIMARY KEY (`question_id`),
  KEY `fk_question_user` (`user_id`),
  KEY `fk_question_rep` (`rep_id`),
  CONSTRAINT `fk_question_rep` FOREIGN KEY (`rep_id`) REFERENCES `Cust_Rep` (`rep_id`),
  CONSTRAINT `fk_question_user` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Question`
--

LOCK TABLES `Question` WRITE;
/*!40000 ALTER TABLE `Question` DISABLE KEYS */;
INSERT INTO `Question` VALUES (21,'Shipping Time?','How long does shipping usually take?','Answered','2024-08-01 10:00:00',2,'Standard shipping is 5-7 business days. Express shipping available.',1),(22,'Return Policy','What is your return policy for items?','Answered','2024-08-02 11:30:00',4,'Items can be returned within 30 days of purchase.',2),(23,'Payment Method','Can I use PayPal for payment?','Pending','2024-08-03 14:20:00',6,NULL,NULL),(24,'Warranty Info','Do items come with warranty?','Answered','2024-08-04 09:15:00',8,'New items come with manufacturer warranty. Used items vary.',3),(25,'Bid Cancellation','How do I cancel a bid?','Answered','2024-08-05 16:45:00',10,'You can cancel bids before the auction ends. Contact support if needed.',1),(26,'Item Condition','What does \"Like New\" condition mean?','Answered','2024-08-06 12:30:00',12,'Like New means item is in excellent condition with minimal wear.',2),(27,'Auction Extension','Can auction end time be extended?','Pending','2024-08-07 13:00:00',14,NULL,NULL),(28,'Multiple Bids','Can I place multiple bids on same item?','Answered','2024-08-08 15:20:00',16,'Yes, you can place multiple bids. Highest bid wins.',3),(29,'Shipping Cost','How much is shipping?','Answered','2024-08-09 10:45:00',18,'Shipping costs vary by item size and location. Calculated at checkout.',2),(30,'Item Authenticity','How do you verify item authenticity?','Answered','2024-08-10 11:30:00',20,'All items are verified by our authentication team before listing.',3),(31,'Payment Issues','My payment was declined, what should I do?','Answered','2024-08-11 14:15:00',22,'Please check your payment method and billing address. Contact bank if issue persists.',1),(32,'Refund Time','How long do refunds take?','Answered','2024-08-12 09:30:00',24,'Refunds are processed within 5-10 business days after item return.',2),(33,'Auction Rules','What are the bidding rules?','Answered','2024-08-13 16:00:00',26,'Minimum bid increments are set per auction. Auto-bid available.',3),(34,'Item Description','Item received doesn\'t match description','Pending','2024-08-14 12:45:00',28,NULL,NULL),(35,'Account Suspension','Why was my account suspended?','Answered','2024-08-15 10:20:00',30,'Please contact support for details about account status.',1),(36,'Buyer Protection','What buyer protection do you offer?','Answered','2024-08-16 13:30:00',2,'We offer full buyer protection with money-back guarantee.',2),(37,'Seller Fees','What fees do sellers pay?','Answered','2024-08-17 15:45:00',3,'Seller fees are 10% of final sale price plus listing fee.',3),(38,'Item Availability','Is item still available?','Answered','2024-08-18 11:15:00',5,'Item availability is shown in real-time. Check auction status.',2),(39,'Bid Retraction','Can I retract a bid?','Pending','2024-08-19 14:30:00',7,NULL,NULL),(40,'Contact Seller','How can I contact the seller?','Answered','2024-08-20 10:00:00',9,'Use the question system or contact support to reach sellers.',3);
/*!40000 ALTER TABLE `Question` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Transaction`
--

DROP TABLE IF EXISTS `Transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Transaction` (
  `trans_id` int NOT NULL AUTO_INCREMENT,
  `auction_id` int NOT NULL,
  `buyer_id` int NOT NULL,
  `trans_time` datetime NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'COMPLETED',
  PRIMARY KEY (`trans_id`),
  UNIQUE KEY `uq_transaction_auction` (`auction_id`),
  KEY `fk_trans_buyer` (`buyer_id`),
  CONSTRAINT `fk_trans_auction` FOREIGN KEY (`auction_id`) REFERENCES `Auction` (`auction_id`),
  CONSTRAINT `fk_trans_buyer` FOREIGN KEY (`buyer_id`) REFERENCES `User` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Transaction`
--

LOCK TABLES `Transaction` WRITE;
/*!40000 ALTER TABLE `Transaction` DISABLE KEYS */;
INSERT INTO `Transaction` VALUES (1,9,4,'2024-08-08 18:00:00','COMPLETED'),(2,23,8,'2024-08-10 19:15:00','COMPLETED');
/*!40000 ALTER TABLE `Transaction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TV`
--

DROP TABLE IF EXISTS `TV`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TV` (
  `item_id` int NOT NULL,
  `resolution` varchar(20) NOT NULL,
  `isHdr` tinyint(1) NOT NULL DEFAULT '0',
  `refresh_rate` int NOT NULL,
  `isSmartTv` tinyint(1) NOT NULL DEFAULT '0',
  `tv_screen_size` int NOT NULL,
  `panel_type` varchar(20) NOT NULL,
  PRIMARY KEY (`item_id`),
  CONSTRAINT `fk_tv_item` FOREIGN KEY (`item_id`) REFERENCES `Item` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TV`
--

LOCK TABLES `TV` WRITE;
/*!40000 ALTER TABLE `TV` DISABLE KEYS */;
INSERT INTO `TV` VALUES (11,'8K UHD',1,120,1,65,'QLED'),(12,'4K UHD',1,120,1,55,'OLED'),(13,'8K UHD',1,120,1,75,'LED'),(14,'Full HD',0,60,0,50,'QLED'),(15,'Full HD',0,60,1,43,'LED'),(16,'4K UHD',1,120,1,55,'QLED'),(17,'4K UHD',1,120,1,65,'OLED'),(18,'8K UHD',1,120,1,85,'LED'),(19,'4K UHD',0,60,1,58,'LED'),(20,'Full HD',0,60,0,48,'OLED');
/*!40000 ALTER TABLE `TV` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `User` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(20) NOT NULL,
  `last_name` varchar(20) NOT NULL,
  `created_at` date DEFAULT NULL,
  `email` varchar(50) NOT NULL,
  `phone_no` char(10) DEFAULT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(20) NOT NULL,
  `dob` date DEFAULT NULL,
  `address_id` int DEFAULT NULL,
  `isBuyer` tinyint(1) NOT NULL DEFAULT '0',
  `isSeller` tinyint(1) NOT NULL DEFAULT '0',
  `rating` float DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  KEY `fk_user_address` (`address_id`),
  CONSTRAINT `fk_user_address` FOREIGN KEY (`address_id`) REFERENCES `Address` (`address_id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
INSERT INTO `User` VALUES (1,'Alex','Martinez','2024-01-15','alex.martinez@email.com','5551001','amartinez','pass123','1990-05-20',1,1,1,4.8),(2,'Taylor','Garcia','2024-02-01','taylor.garcia@email.com','5551002','tgarcia','pass456','1988-09-12',2,1,0,NULL),(3,'Jordan','Rodriguez','2024-02-10','jordan.rodriguez@email.com','5551003','jrodriguez','pass789','1992-11-30',3,1,1,NULL),(4,'Casey','Lewis','2024-02-15','casey.lewis@email.com','5551004','clewis','pass321','1995-03-18',4,1,0,NULL),(5,'Morgan','Walker','2024-02-20','morgan.walker@email.com','5551005','mwalker','pass654','1987-07-25',5,1,1,3.2),(6,'Riley','Hall','2024-03-01','riley.hall@email.com','5551006','rhall','pass987','1993-12-05',6,1,0,NULL),(7,'Avery','Allen','2024-03-05','avery.allen@email.com','5551007','aallen','pass147','1991-04-22',7,1,1,4.8),(8,'Quinn','Young','2024-03-10','quinn.young@email.com','5551008','qyoung','pass258','1994-08-14',8,1,0,NULL),(9,'Cameron','King','2024-03-15','cameron.king@email.com','5551009','cking','pass369','1989-06-28',9,1,1,5),(10,'Dakota','Wright','2024-03-20','dakota.wright@email.com','5551010','dwright','pass741','1996-01-10',10,1,0,NULL),(11,'Sage','Lopez','2024-03-25','sage.lopez@email.com','5551011','slopez','pass852','1990-10-03',11,1,1,2.5),(12,'Blake','Hill','2024-04-01','blake.hill@email.com','5551012','bhill','pass963','1992-02-17',12,1,0,NULL),(13,'River','Scott','2024-04-05','river.scott@email.com','5551013','rscott','pass159','1988-09-21',13,1,1,4.6),(14,'Phoenix','Green','2024-04-10','phoenix.green@email.com','5551014','pgreen','pass357','1993-05-08',14,1,0,NULL),(15,'Skyler','Adams','2024-04-15','skyler.adams@email.com','5551015','sadams','pass468','1991-11-15',15,1,1,4.9),(16,'Rowan','Baker','2024-04-20','rowan.baker@email.com','5551016','rbaker','pass579','1994-07-27',16,1,0,NULL),(17,'Finley','Nelson','2024-04-25','finley.nelson@email.com','5551017','fnelson','pass680','1989-03-12',17,1,1,NULL),(18,'Hayden','Carter','2024-05-01','hayden.carter@email.com','5551018','hcarter','pass791','1995-12-04',18,1,0,NULL),(19,'Reese','Mitchell','2024-05-05','reese.mitchell@email.com','5551019','rmitchell','pass802','1992-08-19',19,1,1,1.8),(20,'Jamie','Perez','2024-05-10','jamie.perez@email.com','5551020','jperez','pass913','1990-04-26',20,1,0,NULL),(21,'Parker','Roberts','2024-05-15','parker.roberts@email.com','5551021','proberts','pass124','1993-10-11',21,1,1,4.2),(22,'Avery','Turner','2024-05-20','avery.turner@email.com','5551022','aturner','pass246','1996-06-23',22,1,0,NULL),(23,'Drew','Phillips','2024-05-25','drew.phillips@email.com','5551023','dphillips','pass357','1991-02-07',23,1,1,3.9),(24,'Emery','Campbell','2024-06-01','emery.campbell@email.com','5551024','ecampbell','pass468','1988-09-30',24,1,0,NULL),(25,'Hayden','Parker','2024-06-05','hayden.parker@email.com','5551025','hparker','pass579','1994-05-14',25,1,1,NULL),(26,'Ellis','Evans','2024-06-10','ellis.evans@email.com','5551026','eevans','pass680','1992-11-28',26,1,0,NULL),(27,'Harper','Edwards','2024-06-15','harper.edwards@email.com','5551027','hedwards','pass791','1990-07-09',27,1,1,4.7),(28,'Robin','Collins','2024-06-20','robin.collins@email.com','5551028','rcollins','pass802','1995-03-22',28,1,0,NULL),(29,'Kai','Stewart','2024-06-25','kai.stewart@email.com','5551029','kstewart','pass913','1993-12-16',29,1,1,2.1),(30,'Finley','Sanchez','2024-07-01','finley.sanchez@email.com','5551030','fsanchez','pass124','1991-08-02',30,1,0,NULL),(31,'Shreya','Shukla','2025-11-30','shreyashukla@gmail.com','1235349592','shreyashukla','Soccer^2026','2003-01-01',NULL,1,0,NULL),(32,'Will','Byers','2025-12-01','willbyers@hawkins.gmail.com','0110110011','willbyers','Byler4ever<#','1983-11-06',NULL,1,0,NULL);
/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-04 18:24:14
