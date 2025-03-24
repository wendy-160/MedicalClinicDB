-- 1. Appointments Report: Number of appointments per clinic per month
SELECT 
    o.OfficeName, 
    o.OfficeID,
    YEAR(a.DateTime) AS Year,
    MONTH(a.DateTime) AS Month,
    COUNT(*) AS AppointmentCount
FROM appointment a
JOIN office o ON a.OfficeID = o.OfficeID
WHERE a.DateTime BETWEEN ? AND ?
GROUP BY o.OfficeID, YEAR(a.DateTime), MONTH(a.DateTime)
ORDER BY o.OfficeName, Year, Month;

-- 2. Patient Medical Record Report
SELECT 
    p.PatientID, p.FirstName, p.LastName, p.MRN, p.DOB,
    mr.MedicalRecordID, mr.VisitDate, mr.Diagnosis, mr.Treatment, mr.Notes,
    d.FirstName AS DoctorFirstName, d.LastName AS DoctorLastName
FROM patient p
LEFT JOIN medicalrecord mr ON p.PatientID = mr.PatientID
LEFT JOIN doctor d ON mr.DoctorID = d.DoctorID
WHERE p.PatientID = ?
ORDER BY mr.VisitDate DESC;

-- Retrieve prescriptions for patient medical record
SELECT 
    pr.PrescriptionID, pr.MedicationName, pr.Dosage, pr.Frequency,
    pr.DatePrescribed, pr.Duration,
    d.FirstName AS DoctorFirstName, d.LastName AS DoctorLastName
FROM prescription pr
JOIN doctor d ON pr.DoctorID = d.DoctorID
WHERE pr.PatientID = ?
ORDER BY pr.DatePrescribed DESC;

-- Retrieve test orders for patient medical record
SELECT 
    t.OrderID, t.OrderDate, t.Status,
    d.FirstName AS DoctorFirstName, d.LastName AS DoctorLastName
FROM test_order t
JOIN doctor d ON t.DoctorID = d.DoctorID
WHERE t.PatientID = ?
ORDER BY t.OrderDate DESC;

-- 3. Doctor Workload Report
SELECT 
    d.DoctorID, d.FirstName, d.LastName, d.Specialization,
    COUNT(DISTINCT pda.PatientID) AS PatientCount
FROM doctor d
LEFT JOIN patient_doctor_assignment pda ON d.DoctorID = pda.DoctorID
GROUP BY d.DoctorID
ORDER BY PatientCount DESC;

-- Doctor's office schedule
SELECT 
    d.DoctorID, d.FirstName, d.LastName,
    o.OfficeName, o.Address AS OfficeAddress,
    do.WorkDays
FROM doctor d
JOIN doctor_office do ON d.DoctorID = do.DoctorID
JOIN office o ON do.OfficeID = o.OfficeID
WHERE d.DoctorID = ?;

-- Doctor's appointment count per month
SELECT 
    d.DoctorID, d.FirstName, d.LastName,
    YEAR(a.DateTime) AS Year,
    MONTH(a.DateTime) AS Month,
    COUNT(*) AS AppointmentCount
FROM doctor d
LEFT JOIN appointment a ON d.DoctorID = a.DoctorID
WHERE a.DateTime BETWEEN ? AND ?
GROUP BY d.DoctorID, YEAR(a.DateTime), MONTH(a.DateTime)
ORDER BY d.LastName, d.FirstName, Year, Month; 