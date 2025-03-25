const db = require('../config/db.config');

// Create a new appointment
// exports.createAppointment = (req, res) => {
//     const { AppointmentID, PatientID, DoctorID, OfficeID, AppointmentDate, AppointmentTime, Duration } = req.body;

//     const query = `
//         INSERT INTO appointment (AppointmentID, PatientID, DoctorID, OfficeID, AppointmentDate, AppointmentTime, Duration) 
//         VALUES (?, ?, ?, ?, ?, ?, ?)
//     `;
//     db.query(query, [AppointmentID, PatientID, DoctorID, OfficeID, AppointmentDate, AppointmentTime, Duration], (err) => {
//         if (err) return res.status(500).json({ error: err.message });
//         res.status(201).json({ message: 'Appointment created successfully' });
//     });
// };

// Create a new appointment
exports.createAppointment = (req, res) => {
    const { AppointmentID, PatientID, DoctorID, OfficeID, AppointmentDate, AppointmentTime, Duration } = req.body;

    // Call the check_doctor_availability procedure
    const checkAvailabilityQuery = `
        CALL check_doctor_availability(?, ?, ?)
    `;

    db.query(checkAvailabilityQuery, [DoctorID, AppointmentDate, AppointmentTime], (err, availabilityResults) => {
        if (err) return res.status(500).json({ error: err.message });

        const availabilityMessage = availabilityResults[0][0]?.Availability;

        // Check if the message includes "Doctor is available" or a similar availability confirmation
        if (availabilityMessage && availabilityMessage.includes('available')) {
            // Proceed to create the appointment if the doctor is available
            const createQuery = `
                INSERT INTO appointment (AppointmentID, PatientID, DoctorID, OfficeID, AppointmentDate, AppointmentTime, Duration) 
                VALUES (?, ?, ?, ?, ?, ?, ?)
            `;

            db.query(createQuery, [AppointmentID, PatientID, DoctorID, OfficeID, AppointmentDate, AppointmentTime, Duration], (err) => {
                if (err) return res.status(500).json({ error: err.message });
                res.status(201).json({ message: 'Appointment created successfully' });
            });
        } else {
            // If the doctor is not available, return an error message
            return res.status(400).json({ message: availabilityMessage || 'Doctor is not available at the specified time.' });
        }
    });
};

// Get all appointments
exports.getAllAppointments = (req, res) => {
    const query = `SELECT * FROM appointment`;
    db.query(query, (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.status(200).json(results);
    });
};

// Get a single appointment by ID
exports.getAppointmentById = (req, res) => {
    const query = `SELECT * FROM appointment WHERE AppointmentID = ?`;
    db.query(query, [req.params.id], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        if (result.length === 0) return res.status(404).json({ error: 'Appointment not found' });
        res.status(200).json(result[0]);
    });
};

// Update an appointment
exports.updateAppointment = (req, res) => {
    const { AppointmentDate, AppointmentTime, Duration, Status } = req.body;
    const query = `
        UPDATE appointment 
        SET AppointmentDate = ?, AppointmentTime = ?, Duration = ?, Status = ?
        WHERE AppointmentID = ?
    `;
    db.query(query, [AppointmentDate, AppointmentTime, Duration, Status, req.params.id], (err) => {
        if (err) return res.status(500).json({ error: err.message });
        res.status(200).json({ message: 'Appointment updated successfully' });
    });
};

// Delete an appointment
exports.deleteAppointment = (req, res) => {
    const query = `DELETE FROM appointment WHERE AppointmentID = ?`;
    db.query(query, [req.params.id], (err) => {
        if (err) return res.status(500).json({ error: err.message });
        res.status(200).json({ message: 'Appointment deleted successfully' });
    });
};

// Fetch All Referrals for a Specific Appointment
exports.getReferralsByAppointment = (req, res) => {
    const { appointmentID } = req.params;

    const query = `SELECT * FROM referrals WHERE AppointmentID = ?`;
    connection.query(query, [appointmentID], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.status(200).json(results);
    });
};

exports.getAppointmentsByPatientId = (req, res) => {
    const { patientId } = req.params;

    const query = `SELECT * FROM appointment WHERE PatientID = ?`;
    db.query(query, [patientId], (err, results) => {
        if (err) return res.status(500).json({ message: 'Server error', error: err.message });
        
        if (results.length === 0) return res.status(404).json({ message: 'No appointments found for this patient' });

        res.status(200).json(results);
    });
};

// Get appointments by DoctorID (Doctor or Admin can view appointments)
exports.getAppointmentsByDoctorId = (req, res) => {
    const { doctorId } = req.params;
    const userRole = req.user.role; // assuming the role is available in the `req.user` object

    // Admin can see all appointments, Doctor can only see their own appointments
    let query = '';
    let params = [];

    if (userRole === 'Doctor') {
        // Doctor can only see their own appointments
        query = `SELECT * FROM appointment WHERE DoctorID = ?`;
        params = [doctorId];  // Use the doctorId from the URL param
    } else if (userRole === 'Admin') {
        // Admin can see all appointments
        query = `SELECT * FROM appointment`;
        // No parameters needed for admin
    } else {
        return res.status(403).json({ message: 'Forbidden access' });
    }

    db.query(query, params, (err, results) => {
        if (err) return res.status(500).json({ message: 'Server error', error: err.message });
        if (results.length === 0) return res.status(404).json({ message: 'No appointments found' });
        res.status(200).json(results);
    });
};

// Approve Appointment (Update Status to "approved")
exports.approveAppointment = (req, res) => {
    const { appointmentID } = req.params;

    const query = `UPDATE appointment SET Status = 'approved' WHERE AppointmentID = ? AND Status = 'pending'`;
    
    db.query(query, [appointmentID], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });

        if (result.affectedRows === 0) {
            return res.status(404).json({ message: 'Appointment not found or already approved.' });
        }

        res.status(200).json({ message: 'Appointment approved successfully' });
    });
};

// Refer Appointment (Change Doctor ID)
// Refer Appointment (Change Doctor ID)
exports.referAppointment = (req, res) => {
    const { appointmentID } = req.params;
    const { newDoctorID, updatedByDoctorID } = req.body; // new doctor ID and the doctor who is making the update

    // First, get the current doctor ID for the appointment
    const getDoctorQuery = `
        SELECT DoctorID FROM appointment WHERE AppointmentID = ?
    `;
    db.query(getDoctorQuery, [appointmentID], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });

        if (results.length === 0) {
            return res.status(404).json({ message: 'Appointment not found' });
        }

        const oldDoctorID = results[0].DoctorID; // Current doctor before the referral

        // Now update the doctor ID in the appointment
        const updateDoctorQuery = `
            UPDATE appointment 
            SET DoctorID = ? 
            WHERE AppointmentID = ?
        `;
        db.query(updateDoctorQuery, [newDoctorID, appointmentID], (err) => {
            if (err) return res.status(500).json({ error: err.message });

            // Insert a referral into the referral table
            const referralDate = new Date().toISOString().split('T')[0]; // Current date in YYYY-MM-DD format

            const insertReferralQuery = `
                INSERT INTO referrals 
                (AppointmentID, ReferredByDoctorID, ReferredToDoctorID, ReferralDate, Status)
                VALUES (?, ?, ?, ?, ?)
            `;
            db.query(insertReferralQuery, [appointmentID, oldDoctorID, newDoctorID, referralDate, 'pending'], (err) => {
                if (err) return res.status(500).json({ error: err.message });

                res.status(200).json({ message: `Appointment referred to doctor with ID: ${newDoctorID}` });
            });
        });
    });
};
exports.deleteAppointment = (req, res) => {
    const { id } = req.params; // Get the AppointmentID from the URL
  
    // Delete the appointment from the database
    db.query('DELETE FROM appointment WHERE AppointmentID = ?', [id], (err, result) => {
      if (err) {
        return res.status(500).json({ message: 'Error deleting appointment', error: err.message });
      }
  
      if (result.affectedRows === 0) {
        return res.status(404).json({ message: 'Appointment not found' });
      }
  
      res.status(200).json({ message: 'Appointment successfully deleted' });
    });
  };
  