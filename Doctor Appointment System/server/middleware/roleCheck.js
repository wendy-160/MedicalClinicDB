// middleware/roleCheck.js
const db = require('../config/db.config');

// Middleware to check user role
const checkUserRole = async (req, res, next) => {
    const { userId } = req.headers;

    if (!userId) {
        return res.status(400).json({ message: 'User ID is required in headers.' });
    }

    try {
        const [patient] = await db.query('SELECT * FROM Patients WHERE PatientID = ?', [userId]);
        if (patient.length > 0) {
            req.role = 'Patient';
            return next();
        }

        const [doctor] = await db.query('SELECT * FROM Doctors WHERE DoctorID = ?', [userId]);
        if (doctor.length > 0) {
            req.role = 'Doctor';
            return next();
        }

        req.role = 'Admin';
        next();
    } catch (error) {
        res.status(500).json({ message: 'Error checking user role', error: error.message });
    }
};

module.exports = checkUserRole;
