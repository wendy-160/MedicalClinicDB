-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: MedicalClinic
-- ------------------------------------------------------
-- Server version	8.0.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
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
  `Date` date DEFAULT NULL,
  `Time` time DEFAULT NULL,
  `Reason` text,
  `Status` varchar(50) DEFAULT NULL,
  `ScheduledVia` varchar(50) DEFAULT NULL,
  `OfficeID` int DEFAULT NULL,
  PRIMARY KEY (`AppointmentID`),
  KEY `fk_appointment_patient` (`PatientID`),
  KEY `fk_appointment_doctor` (`DoctorID`),
  KEY `fk_appointment_office` (`OfficeID`),
  CONSTRAINT `fk_appointment_doctor` FOREIGN KEY (`DoctorID`) REFERENCES `doctor` (`DoctorID`) ON DELETE CASCADE,
  CONSTRAINT `fk_appointment_office` FOREIGN KEY (`OfficeID`) REFERENCES `office` (`OfficeID`) ON DELETE CASCADE,
  CONSTRAINT `fk_appointment_patient` FOREIGN KEY (`PatientID`) REFERENCES `patient` (`PatientID`) ON DELETE CASCADE,
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
  `Amount` decimal(10,2) DEFAULT NULL,
  `PaymentStatus` varchar(50) DEFAULT NULL,
  `InsuranceProvider` varchar(255) DEFAULT NULL,
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
  `Name` varchar(255) DEFAULT NULL,
  `WorkSchedule` text,
  `PhoneNumber` varchar(50) DEFAULT NULL,
  `Email` varchar(255) DEFAULT NULL,
  `Specialization` varchar(255) DEFAULT NULL,
  `OfficeID` int DEFAULT NULL,
  PRIMARY KEY (`DoctorID`),
  KEY `fk_office` (`OfficeID`),
  CONSTRAINT `fk_office` FOREIGN KEY (`OfficeID`) REFERENCES `office` (`OfficeID`) ON DELETE SET NULL
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
-- Table structure for table `medicalrecord`
--

DROP TABLE IF EXISTS `medicalrecord`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medicalrecord` (
  `MedicalRecordID` int NOT NULL,
  `AppointmentID` int DEFAULT NULL,
  `PatientID` int DEFAULT NULL,
  `DoctorID` int DEFAULT NULL,
  `VisitDate` date DEFAULT NULL,
  `Diagnosis` text,
  `TreatmentPlan` text,
  `Notes` text,
  PRIMARY KEY (`MedicalRecordID`),
  UNIQUE KEY `AppointmentID` (`AppointmentID`),
  KEY `fk_medicalrecord_patient` (`PatientID`),
  KEY `fk_medicalrecord_doctor` (`DoctorID`),
  CONSTRAINT `fk_medicalrecord_appointment` FOREIGN KEY (`AppointmentID`) REFERENCES `appointment` (`AppointmentID`) ON DELETE CASCADE,
  CONSTRAINT `fk_medicalrecord_doctor` FOREIGN KEY (`DoctorID`) REFERENCES `doctor` (`DoctorID`) ON DELETE CASCADE,
  CONSTRAINT `fk_medicalrecord_patient` FOREIGN KEY (`PatientID`) REFERENCES `patient` (`PatientID`) ON DELETE CASCADE
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
  `TestName` varchar(255) DEFAULT NULL,
  `TestType` varchar(255) DEFAULT NULL,
  `TestDesc` text,
  `TestDate` datetime DEFAULT NULL,
  `TestResult` varchar(255) DEFAULT NULL,
  `ReferenceRange` varchar(255) DEFAULT NULL,
  `OfficeID` int DEFAULT NULL,
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
  `Address` text,
  `PhoneNumber` varchar(50) DEFAULT NULL,
  `Email` varchar(255) DEFAULT NULL,
  `OperatingHours` text,
  `State` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`OfficeID`)
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
  `FirstName` varchar(255) DEFAULT NULL,
  `LastName` varchar(255) DEFAULT NULL,
  `MRN` varchar(255) DEFAULT NULL,
  `Ethnicity` varchar(255) DEFAULT NULL,
  `Race` varchar(255) DEFAULT NULL,
  `Gender` varchar(50) DEFAULT NULL,
  `DOB` date DEFAULT NULL,
  `Address` text,
  `PhoneNumber` varchar(50) DEFAULT NULL,
  `Email` varchar(255) DEFAULT NULL,
  `PrimaryPhysicianID` int DEFAULT NULL,
  PRIMARY KEY (`PatientID`),
  KEY `fk_primary_physician` (`PrimaryPhysicianID`),
  CONSTRAINT `fk_primary_physician` FOREIGN KEY (`PrimaryPhysicianID`) REFERENCES `doctor` (`DoctorID`) ON DELETE SET NULL
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
  `MedicationName` varchar(255) DEFAULT NULL,
  `Dosage` varchar(50) DEFAULT NULL,
  `Frequency` varchar(50) DEFAULT NULL,
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
  `DoctorID` int DEFAULT NULL,
  `RefStatus` text,
  `RefReason` text,
  `Date_requested` datetime DEFAULT NULL,
  `Date_approved` datetime DEFAULT NULL,
  PRIMARY KEY (`ReferralID`),
  KEY `fk_referral_patient` (`PatientID`),
  KEY `fk_referral_doctor` (`DoctorID`),
  CONSTRAINT `fk_referral_doctor` FOREIGN KEY (`DoctorID`) REFERENCES `doctor` (`DoctorID`) ON DELETE CASCADE,
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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-03-02 16:20:18
