const db = require('../config/db.config');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

// Secret Key for JWT
const JWT_SECRET = process.env.JWT_SECRET;
;

// Register Controller
exports.register = async (req, res) => {
    const { userType, Name, PhoneNumber, Email, DateOfBirth, Address, Specialization, WorkSchedule, OfficeID, Password } = req.body;

    if (!Password) return res.status(400).json({ message: 'Password is required!' });

    const hashedPassword = await bcrypt.hash(Password, 10);

    if (userType === 'Patient') {
        const query = `INSERT INTO Patients (PatientID, Name, PhoneNumber, Email, DateOfBirth, Address, Password, Role) 
                       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`;
        const PatientID = generateID();

        db.query(query, [PatientID, Name, PhoneNumber, Email, DateOfBirth, Address, hashedPassword, 'Patient'], (err) => {
            if (err) return res.status(500).json({ error: err.message });
            res.status(201).json({ message: 'Patient registered successfully!' });
        });

    } else if (userType === 'Doctor') {
        const query = `INSERT INTO Doctors (DoctorID, Name, Specialization, WorkSchedule, PhoneNumber, Email, OfficeID, Password, Role) 
                       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`;
        const DoctorID = generateID();
        const Role = req.body.Role || 'Doctor';  // Role can be Doctor or Admin

        db.query(query, [DoctorID, Name, Specialization, WorkSchedule, PhoneNumber, Email, OfficeID, hashedPassword, Role], (err) => {
            if (err) return res.status(500).json({ error: err.message });
            res.status(201).json({ message: 'Doctor registered successfully!' });
        });
    } else {
        res.status(400).json({ message: 'Invalid user type!' });
    }
};

// Login Controller
exports.login = (req, res) => {
    const { Email, Password } = req.body;

    const patientQuery = `SELECT * FROM Patients WHERE Email = ?`;
    const doctorQuery = `SELECT * FROM Doctors WHERE Email = ?`;

    // Check in Patients table first
    db.query(patientQuery, [Email], async (err, patientResults) => {
        if (err) return res.status(500).json({ error: err.message });

        if (patientResults.length > 0) {
            const patient = patientResults[0];
            const isValidPassword = await bcrypt.compare(Password, patient.Password);

            if (!isValidPassword) return res.status(401).json({ message: 'Invalid credentials!' });

            const token = jwt.sign({ id: patient.PatientID, role: patient.Role }, JWT_SECRET, { expiresIn: '1h' });
            return res.status(200).json({ token, role: patient.Role, user: patient });
        }

        // Check in Doctors table if not found in Patients
        db.query(doctorQuery, [Email], async (err, doctorResults) => {
            if (err) return res.status(500).json({ error: err.message });

            if (doctorResults.length > 0) {
                const doctor = doctorResults[0];
                const isValidPassword = await bcrypt.compare(Password, doctor.Password);

                if (!isValidPassword) return res.status(401).json({ message: 'Invalid credentials!' });

                const token = jwt.sign({ id: doctor.DoctorID, role: doctor.Role }, JWT_SECRET, { expiresIn: '1h' });
                return res.status(200).json({ token, role: doctor.Role, user: doctor });
            }

            return res.status(404).json({ message: 'User not found!' });
        });
    });
};

// Generate Unique IDs
function generateID() {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const randomLetters = letters[Math.floor(Math.random() * letters.length)] + letters[Math.floor(Math.random() * letters.length)];
    const randomNumbers = Math.floor(100 + Math.random() * 900);
    const randomLetter = letters[Math.floor(Math.random() * letters.length)];
    return `${randomLetters}${randomNumbers}${randomLetter}`;
}
