-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: localhost    Database: medicalclinic
-- ------------------------------------------------------
-- Server version	8.0.34

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
-- Table structure for table `appointment`
--

DROP TABLE IF EXISTS `appointment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointment` (
  `AppointmentID` int NOT NULL,
  `PatientID` int DEFAULT NULL,
  `DoctorID` int DEFAULT NULL,
  `OfficeID` int DEFAULT NULL,
  `DateTime` datetime DEFAULT NULL,
  `Reason` text,
  `Status` enum('Scheduled','Completed','Canceled') DEFAULT NULL,
  `ScheduledVia` enum('Scheduled','Completed','Canceled') DEFAULT NULL,
  PRIMARY KEY (`AppointmentID`),
  KEY `fk_appointment_patient` (`PatientID`),
  KEY `fk_appointment_doctor` (`DoctorID`),
  KEY `fk_appointment_office` (`OfficeID`),
  CONSTRAINT `appointment_chk_1` CHECK ((`Status` in (_utf8mb4'pending',_utf8mb4'scheduled',_utf8mb4'cancelled',_utf8mb4'completed'))),
  CONSTRAINT `appointment_chk_2` CHECK ((`ScheduledVia` in (_utf8mb4'phone',_utf8mb4'web portal')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointment`
--

LOCK TABLES `appointment` WRITE;
/*!40000 ALTER TABLE `appointment` DISABLE KEYS */;
/*!40000 ALTER TABLE `appointment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `billing`
--

DROP TABLE IF EXISTS `billing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `billing` (
  `BillID` int NOT NULL,
  `AppointmentID` int DEFAULT NULL,
  `PatientID` int DEFAULT NULL,
  `Amount` decimal(10,2) DEFAULT NULL,
  `PaymentStatus` enum('Pending','Paid','Canceled') DEFAULT NULL,
  `InsuranceProvider` varchar(50) DEFAULT NULL,
  `BillingDate` date DEFAULT NULL,
  PRIMARY KEY (`BillID`),
  UNIQUE KEY `AppointmentID` (`AppointmentID`),
  CONSTRAINT `fk_billing_appointment` FOREIGN KEY (`AppointmentID`) REFERENCES `appointment` (`AppointmentID`) ON DELETE CASCADE,
  CONSTRAINT `billing_chk_1` CHECK ((`PaymentStatus` in (_utf8mb4'Paid',_utf8mb4'Pending',_utf8mb4'Overdue')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `billing`
--

LOCK TABLES `billing` WRITE;
/*!40000 ALTER TABLE `billing` DISABLE KEYS */;
/*!40000 ALTER TABLE `billing` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctor`
--

DROP TABLE IF EXISTS `doctor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctor` (
  `DoctorID` int NOT NULL,
  `FirstName` varchar(50) DEFAULT NULL,
  `LastName` varchar(50) DEFAULT NULL,
  `WorkSchedule` text,
  `PhoneNumber` varchar(15) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `Specialization` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`DoctorID`),
  UNIQUE KEY `Email_UNIQUE` (`Email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctor`
--

LOCK TABLES `doctor` WRITE;
/*!40000 ALTER TABLE `doctor` DISABLE KEYS */;
/*!40000 ALTER TABLE `doctor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctor_office`
--

DROP TABLE IF EXISTS `doctor_office`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctor_office` (
  `DoctorID` int NOT NULL,
  `OfficeID` int NOT NULL,
  `WorkDays` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`DoctorID`,`OfficeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctor_office`
--

LOCK TABLES `doctor_office` WRITE;
/*!40000 ALTER TABLE `doctor_office` DISABLE KEYS */;
/*!40000 ALTER TABLE `doctor_office` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login`
--

DROP TABLE IF EXISTS `login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `login` (
  `UserID` int NOT NULL,
  `username` varchar(40) NOT NULL,
  `password` varchar(40) NOT NULL,
  `email` varchar(40) DEFAULT NULL,
  `role` enum('Patient','Doctor','Admin') DEFAULT NULL,
  PRIMARY KEY (`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login`
--

LOCK TABLES `login` WRITE;
/*!40000 ALTER TABLE `login` DISABLE KEYS */;
/*!40000 ALTER TABLE `login` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medicalrecord`
--

DROP TABLE IF EXISTS `medicalrecord`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medicalrecord` (
  `MedicalRecordID` int NOT NULL,
  `PatientID` int DEFAULT NULL,
  `AppointmentID` int DEFAULT NULL,
  `DoctorID` int DEFAULT NULL,
  `VisitDate` datetime DEFAULT NULL,
  `Diagnosis` text,
  `TreatmentPlan` text,
  `Notes` text,
  PRIMARY KEY (`MedicalRecordID`),
  KEY `fk_medicalrecord_patient` (`PatientID`),
  KEY `fk_medicalrecord_doctor` (`DoctorID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medicalrecord`
--

LOCK TABLES `medicalrecord` WRITE;
/*!40000 ALTER TABLE `medicalrecord` DISABLE KEYS */;
/*!40000 ALTER TABLE `medicalrecord` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medicaltest`
--

DROP TABLE IF EXISTS `medicaltest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medicaltest` (
  `TestID` int NOT NULL,
  `PatientID` int DEFAULT NULL,
  `DoctorID` int DEFAULT NULL,
  `OfficeID` int DEFAULT NULL,
  `TestName` varchar(50) DEFAULT NULL,
  `TestType` varchar(50) DEFAULT NULL,
  `TestDesc` text,
  `TestDate` datetime DEFAULT NULL,
  `TestResult` text,
  `ReferenceRange` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`TestID`),
  KEY `fk_medicaltest_patient` (`PatientID`),
  KEY `fk_medicaltest_doctor` (`DoctorID`),
  KEY `fk_medicaltest_office` (`OfficeID`),
  CONSTRAINT `fk_medicaltest_doctor` FOREIGN KEY (`DoctorID`) REFERENCES `doctor` (`DoctorID`) ON DELETE CASCADE,
  CONSTRAINT `fk_medicaltest_office` FOREIGN KEY (`OfficeID`) REFERENCES `office` (`OfficeID`) ON DELETE CASCADE,
  CONSTRAINT `fk_medicaltest_patient` FOREIGN KEY (`PatientID`) REFERENCES `patient` (`PatientID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medicaltest`
--

LOCK TABLES `medicaltest` WRITE;
/*!40000 ALTER TABLE `medicaltest` DISABLE KEYS */;
/*!40000 ALTER TABLE `medicaltest` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `office`
--

DROP TABLE IF EXISTS `office`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `office` (
  `OfficeID` int NOT NULL,
  `OfficeName` varchar(100) DEFAULT NULL,
  `Address` text,
  `PhoneNumber` varchar(15) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `OperatingHours` text,
  `State` varchar(50) DEFAULT NULL,
  `Zipcode` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`OfficeID`),
  UNIQUE KEY `Email_UNIQUE` (`Email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `office`
--

LOCK TABLES `office` WRITE;
/*!40000 ALTER TABLE `office` DISABLE KEYS */;
/*!40000 ALTER TABLE `office` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patient`
--

DROP TABLE IF EXISTS `patient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient` (
  `PatientID` int NOT NULL,
  `FirstName` varchar(50) DEFAULT NULL,
  `LastName` varchar(50) DEFAULT NULL,
  `MRN` varchar(50) DEFAULT NULL,
  `Ethnicity` smallint DEFAULT NULL,
  `Race` smallint DEFAULT NULL,
  `Gender` smallint DEFAULT NULL,
  `DOB` date DEFAULT NULL,
  `Address` text,
  `PhoneNumber` varchar(15) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`PatientID`),
  UNIQUE KEY `Email_UNIQUE` (`Email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient`
--

LOCK TABLES `patient` WRITE;
/*!40000 ALTER TABLE `patient` DISABLE KEYS */;
/*!40000 ALTER TABLE `patient` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patient_doctor_assignment`
--

DROP TABLE IF EXISTS `patient_doctor_assignment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient_doctor_assignment` (
  `PatientID` int NOT NULL,
  `DoctorID` int NOT NULL,
  `AssignmentDate` date DEFAULT NULL,
  `PrimaryPhysicianFlag` tinyint DEFAULT NULL,
  PRIMARY KEY (`PatientID`,`DoctorID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient_doctor_assignment`
--

LOCK TABLES `patient_doctor_assignment` WRITE;
/*!40000 ALTER TABLE `patient_doctor_assignment` DISABLE KEYS */;
/*!40000 ALTER TABLE `patient_doctor_assignment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prescription`
--

DROP TABLE IF EXISTS `prescription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prescription` (
  `PrescriptionID` int NOT NULL,
  `PatientID` int DEFAULT NULL,
  `MedicalRecordID` int DEFAULT NULL,
  `DoctorID` int DEFAULT NULL,
  `AppointmentID` int DEFAULT NULL,
  `MedicationName` varchar(100) DEFAULT NULL,
  `Dosage` varchar(50) DEFAULT NULL,
  `Frequency` varchar(50) DEFAULT NULL,
  `DatePrescribed` date DEFAULT NULL,
  `Duration` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`PrescriptionID`),
  KEY `fk_prescription_patient` (`PatientID`),
  KEY `fk_prescription_medicalrecord` (`MedicalRecordID`),
  KEY `fk_prescription_doctor` (`DoctorID`),
  KEY `fk_prescription_appointment` (`AppointmentID`),
  CONSTRAINT `fk_prescription_appointment` FOREIGN KEY (`AppointmentID`) REFERENCES `appointment` (`AppointmentID`) ON DELETE CASCADE,
  CONSTRAINT `fk_prescription_doctor` FOREIGN KEY (`DoctorID`) REFERENCES `doctor` (`DoctorID`) ON DELETE CASCADE,
  CONSTRAINT `fk_prescription_medicalrecord` FOREIGN KEY (`MedicalRecordID`) REFERENCES `medicalrecord` (`MedicalRecordID`) ON DELETE CASCADE,
  CONSTRAINT `fk_prescription_patient` FOREIGN KEY (`PatientID`) REFERENCES `patient` (`PatientID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prescription`
--

LOCK TABLES `prescription` WRITE;
/*!40000 ALTER TABLE `prescription` DISABLE KEYS */;
/*!40000 ALTER TABLE `prescription` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `referral`
--

DROP TABLE IF EXISTS `referral`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `referral` (
  `ReferralID` int NOT NULL,
  `PatientID` int DEFAULT NULL,
  `ReferralDoctorrID` int DEFAULT NULL,
  `ReferringDoctorID` int DEFAULT NULL,
  `AppointmentID` int DEFAULT NULL,
  `RefStatus` text,
  `RefReason` text,
  `Date_requested` datetime DEFAULT NULL,
  `Date_approved` datetime DEFAULT NULL,
  PRIMARY KEY (`ReferralID`),
  KEY `fk_referral_patient` (`PatientID`),
  KEY `fk_referral_doctor` (`ReferralDoctorrID`),
  CONSTRAINT `fk_referral_doctor` FOREIGN KEY (`ReferralDoctorrID`) REFERENCES `doctor` (`DoctorID`) ON DELETE CASCADE,
  CONSTRAINT `fk_referral_patient` FOREIGN KEY (`PatientID`) REFERENCES `patient` (`PatientID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `referral`
--

LOCK TABLES `referral` WRITE;
/*!40000 ALTER TABLE `referral` DISABLE KEYS */;
/*!40000 ALTER TABLE `referral` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `test_order`
--

DROP TABLE IF EXISTS `test_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_order` (
  `OrderID` int NOT NULL,
  `DoctorID` int DEFAULT NULL,
  `PatientID` int DEFAULT NULL,
  `TestID` int DEFAULT NULL,
  `OrderDate` datetime DEFAULT NULL,
  `Status` enum('Pending','Completed','Canceled') DEFAULT NULL,
  PRIMARY KEY (`OrderID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `test_order`
--

LOCK TABLES `test_order` WRITE;
/*!40000 ALTER TABLE `test_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `test_order` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-03-15 16:14:34
