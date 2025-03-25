-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 24, 2025 at 09:52 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `appointment_system`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `check_doctor_availability` (IN `doctor_id` VARCHAR(6), IN `appointment_date` DATE, IN `appointment_time` TIME)   BEGIN
    DECLARE availability_count INT;
    DECLARE work_schedule TEXT;
    DECLARE start_hour TIME;
    DECLARE end_hour TIME;
    DECLARE day_of_week_index INT;
    DECLARE day_name VARCHAR(9);
    DECLARE day_range VARCHAR(20);
    DECLARE time_range VARCHAR(20);
    DECLARE start_day VARCHAR(3);
    DECLARE end_day VARCHAR(3);
    DECLARE day_index_start INT;
    DECLARE day_index_end INT;
    DECLARE is_working_day BOOLEAN DEFAULT FALSE;
    DECLARE duration INT DEFAULT 60;

    -- Define weekday index variables
    DECLARE sunday INT DEFAULT 1;
    DECLARE monday INT DEFAULT 2;
    DECLARE tuesday INT DEFAULT 3;
    DECLARE wednesday INT DEFAULT 4;
    DECLARE thursday INT DEFAULT 5;
    DECLARE friday INT DEFAULT 6;
    DECLARE saturday INT DEFAULT 7;

    -- Get the weekday index for the requested appointment date
    SET day_of_week_index = DAYOFWEEK(appointment_date);

    -- Retrieve the doctor's work schedule
    SELECT WorkSchedule INTO work_schedule
    FROM doctors
    WHERE DoctorID = doctor_id;

    -- If work schedule is not found, return unavailable
    IF work_schedule IS NULL THEN
        SELECT 'Doctor is not available at the specified time.' AS Availability;
    ELSE
        -- Split work schedule into day and time parts
        SET day_range = SUBSTRING_INDEX(work_schedule, '_', 1);
        SET time_range = SUBSTRING_INDEX(work_schedule, '_', -1);

        -- Split day range into start and end days
        IF day_range LIKE '%:%' THEN
            SET start_day = SUBSTRING_INDEX(day_range, ':', 1);
            SET end_day = SUBSTRING_INDEX(day_range, ':', -1);
        ELSE
            SET start_day = day_range;
            SET end_day = day_range;
        END IF;

        -- Map day abbreviations to weekday indices
        SET day_index_start = 
            CASE start_day
                WHEN 'Mon' THEN monday
                WHEN 'Tue' THEN tuesday
                WHEN 'Wed' THEN wednesday
                WHEN 'Thu' THEN thursday
                WHEN 'Fri' THEN friday
                WHEN 'Sat' THEN saturday
                WHEN 'Sun' THEN sunday
                ELSE NULL
            END;

        SET day_index_end = 
            CASE end_day
                WHEN 'Mon' THEN monday
                WHEN 'Tue' THEN tuesday
                WHEN 'Wed' THEN wednesday
                WHEN 'Thu' THEN thursday
                WHEN 'Fri' THEN friday
                WHEN 'Sat' THEN saturday
                WHEN 'Sun' THEN sunday
                ELSE NULL
            END;

        -- Check if the appointment day falls within the working days
        IF day_index_start IS NOT NULL AND day_index_end IS NOT NULL AND 
           day_of_week_index BETWEEN day_index_start AND day_index_end THEN
            SET is_working_day = TRUE;
        END IF;

        IF NOT is_working_day THEN
            SELECT 'Doctor does not work on this day.' AS Availability;
        ELSE
            -- Extract working hours
            SET start_hour = TIME(SUBSTRING_INDEX(time_range, ';', 1));
            SET end_hour = TIME(SUBSTRING_INDEX(time_range, ';', -1));

            -- Check if appointment time is within working hours
            IF appointment_time < start_hour OR ADDTIME(appointment_time, SEC_TO_TIME(duration * 60)) > end_hour THEN
                SELECT CONCAT('Doctor is only available between ', 
                              TIME_FORMAT(start_hour, '%H:%i'), ' and ', 
                              TIME_FORMAT(end_hour, '%H:%i')) AS Availability;
            ELSE
                -- Check for conflicting appointments
                SELECT COUNT(*) INTO availability_count
                FROM `appointment`
                WHERE `DoctorID` = doctor_id
                  AND `AppointmentDate` = appointment_date
                  AND (
                      (appointment_time BETWEEN `AppointmentTime` AND ADDTIME(`AppointmentTime`, SEC_TO_TIME(`Duration` * 60)))
                      OR (`AppointmentTime` BETWEEN appointment_time AND ADDTIME(appointment_time, SEC_TO_TIME(duration * 60)))
                  );

                IF availability_count > 0 THEN
                    SELECT 'Doctor has a conflicting appointment at this time.' AS Availability;
                ELSE
                    SELECT 'Doctor is available at the specified time.' AS Availability;
                END IF;
            END IF;
        END IF;
    END IF;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `generate_unique_key` () RETURNS VARCHAR(6) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
    DECLARE key_value VARCHAR(6);
    SET key_value = CONCAT(
        CHAR(FLOOR(RAND() * 26) + 65),     -- Random uppercase letter
        CHAR(FLOOR(RAND() * 26) + 65),     -- Random uppercase letter
        LPAD(FLOOR(RAND() * 1000), 3, '0'),-- Random 3-digit number
        CHAR(FLOOR(RAND() * 26) + 65)      -- Random uppercase letter
    );
    RETURN key_value;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `appointment`
--

CREATE TABLE `appointment` (
  `AppointmentID` varchar(6) NOT NULL,
  `PatientID` varchar(6) NOT NULL,
  `DoctorID` varchar(6) NOT NULL,
  `OfficeID` int(11) DEFAULT NULL,
  `AppointmentDate` date NOT NULL,
  `AppointmentTime` time NOT NULL,
  `Duration` int(11) DEFAULT 60,
  `Status` varchar(20) DEFAULT 'pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `appointment`
--
DELIMITER $$
CREATE TRIGGER `prevent_double_booking` BEFORE INSERT ON `appointment` FOR EACH ROW BEGIN
    DECLARE conflicting_appointments INT;
    SELECT COUNT(*) INTO conflicting_appointments
    FROM `appointment`
    WHERE `DoctorID` = NEW.`DoctorID`
      AND `AppointmentDate` = NEW.`AppointmentDate`
      AND (NEW.`AppointmentTime` BETWEEN `AppointmentTime` AND ADDTIME(`AppointmentTime`, SEC_TO_TIME(`Duration` * 60)));

    IF conflicting_appointments > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Double booking is not allowed for this doctor at the given time.';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `doctors`
--

CREATE TABLE `doctors` (
  `DoctorID` varchar(6) NOT NULL,
  `Name` varchar(100) DEFAULT NULL,
  `Specialization` varchar(100) DEFAULT NULL,
  `WorkSchedule` text DEFAULT NULL,
  `PhoneNumber` varchar(20) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `OfficeID` int(11) DEFAULT NULL,
  `Password` varchar(255) NOT NULL,
  `Role` varchar(10) DEFAULT 'Doctor'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `medical_records`
--

CREATE TABLE `medical_records` (
  `RecordID` int(11) NOT NULL,
  `AppointmentID` varchar(6) NOT NULL,
  `PatientID` varchar(6) NOT NULL,
  `DoctorID` varchar(6) NOT NULL,
  `Diagnosis` text DEFAULT NULL,
  `Prescriptions` text DEFAULT NULL,
  `Notes` text DEFAULT NULL,
  `RecordDate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `medical_records`
--
DELIMITER $$
CREATE TRIGGER `update_status_after_medical_record` AFTER INSERT ON `medical_records` FOR EACH ROW BEGIN
    UPDATE `appointment`
    SET `Status` = 'complete'
    WHERE `AppointmentID` = NEW.`AppointmentID`;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `patients`
--

CREATE TABLE `patients` (
  `PatientID` varchar(6) NOT NULL,
  `Name` varchar(100) DEFAULT NULL,
  `PhoneNumber` varchar(20) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `DateOfBirth` date DEFAULT NULL,
  `Address` text DEFAULT NULL,
  `Password` varchar(255) NOT NULL,
  `Role` varchar(10) DEFAULT 'Patient'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `referrals`
--

CREATE TABLE `referrals` (
  `ReferralID` int(11) NOT NULL,
  `AppointmentID` varchar(6) NOT NULL,
  `ReferredByDoctorID` varchar(6) NOT NULL,
  `ReferredToDoctorID` varchar(6) NOT NULL,
  `ReferralDate` date NOT NULL,
  `Status` varchar(20) DEFAULT 'pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `appointment`
--
ALTER TABLE `appointment`
  ADD PRIMARY KEY (`AppointmentID`),
  ADD KEY `PatientID` (`PatientID`),
  ADD KEY `DoctorID` (`DoctorID`);

--
-- Indexes for table `doctors`
--
ALTER TABLE `doctors`
  ADD PRIMARY KEY (`DoctorID`);

--
-- Indexes for table `medical_records`
--
ALTER TABLE `medical_records`
  ADD PRIMARY KEY (`RecordID`),
  ADD KEY `AppointmentID` (`AppointmentID`),
  ADD KEY `PatientID` (`PatientID`),
  ADD KEY `DoctorID` (`DoctorID`);

--
-- Indexes for table `patients`
--
ALTER TABLE `patients`
  ADD PRIMARY KEY (`PatientID`);

--
-- Indexes for table `referrals`
--
ALTER TABLE `referrals`
  ADD PRIMARY KEY (`ReferralID`),
  ADD KEY `AppointmentID` (`AppointmentID`),
  ADD KEY `ReferredByDoctorID` (`ReferredByDoctorID`),
  ADD KEY `ReferredToDoctorID` (`ReferredToDoctorID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `medical_records`
--
ALTER TABLE `medical_records`
  MODIFY `RecordID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `referrals`
--
ALTER TABLE `referrals`
  MODIFY `ReferralID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `appointment`
--
ALTER TABLE `appointment`
  ADD CONSTRAINT `appointment_ibfk_1` FOREIGN KEY (`PatientID`) REFERENCES `patients` (`PatientID`),
  ADD CONSTRAINT `appointment_ibfk_2` FOREIGN KEY (`DoctorID`) REFERENCES `doctors` (`DoctorID`);

--
-- Constraints for table `medical_records`
--
ALTER TABLE `medical_records`
  ADD CONSTRAINT `medical_records_ibfk_1` FOREIGN KEY (`AppointmentID`) REFERENCES `appointment` (`AppointmentID`),
  ADD CONSTRAINT `medical_records_ibfk_2` FOREIGN KEY (`PatientID`) REFERENCES `patients` (`PatientID`),
  ADD CONSTRAINT `medical_records_ibfk_3` FOREIGN KEY (`DoctorID`) REFERENCES `doctors` (`DoctorID`);

--
-- Constraints for table `referrals`
--
ALTER TABLE `referrals`
  ADD CONSTRAINT `referrals_ibfk_1` FOREIGN KEY (`AppointmentID`) REFERENCES `appointment` (`AppointmentID`),
  ADD CONSTRAINT `referrals_ibfk_2` FOREIGN KEY (`ReferredByDoctorID`) REFERENCES `doctors` (`DoctorID`),
  ADD CONSTRAINT `referrals_ibfk_3` FOREIGN KEY (`ReferredToDoctorID`) REFERENCES `doctors` (`DoctorID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
