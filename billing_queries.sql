-- Retrieve all billing information for a specific patient
SELECT b.BillID, b.Amount, b.PaymentStatus, b.InsuranceProvider, b.BillingDate,
       a.DateTime AS AppointmentDate, a.Reason AS AppointmentReason,
       d.FirstName AS DoctorFirstName, d.LastName AS DoctorLastName
FROM billing b
JOIN appointment a ON b.AppointmentID = a.AppointmentID
JOIN doctor d ON a.DoctorID = d.DoctorID
WHERE b.PatientID = ?
ORDER BY b.BillingDate DESC;

-- Update payment status
UPDATE billing
SET PaymentStatus = ?
WHERE BillID = ?;

-- Generate invoice summary
SELECT p.FirstName, p.LastName, p.Address, p.Email,
       b.BillID, b.Amount, b.PaymentStatus, b.InsuranceProvider, b.BillingDate,
       a.DateTime, a.Reason,
       d.FirstName AS DoctorFirstName, d.LastName AS DoctorLastName
FROM billing b
JOIN patient p ON b.PatientID = p.PatientID
JOIN appointment a ON b.AppointmentID = a.AppointmentID
JOIN doctor d ON a.DoctorID = d.DoctorID
WHERE b.BillID = ?; 