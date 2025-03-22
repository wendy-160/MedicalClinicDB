const express = require("express");
const mysql = require("mysql");
const cors = require("cors");

const app = express();
app.use(express.json());
app.use(cors());

// Database Connection
const db = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "",
    database: "your_database_name",
});

// Get all medical tests
app.get("/api/medicaltests", (req, res) => {
    db.query("SELECT * FROM medicaltest", (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results);
    });
});

// Add a new medical test
app.post("/api/medicaltests", (req, res) => {
    const { test_type, patient_id } = req.body;
    db.query(
        "INSERT INTO medicaltest (test_type, patient_id, status) VALUES (?, ?, 'Ordered')",
        [test_type, patient_id],
        (err, result) => {
            if (err) return res.status(500).send(err);
            res.json({ message: "Test ordered successfully!" });
        }
    );
});

// Get all prescriptions
app.get("/api/prescriptions", (req, res) => {
    db.query("SELECT * FROM prescription", (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results);
    });
});

// Add a new prescription
app.post("/api/prescriptions", (req, res) => {
    const { medication_name, dosage, patient_id } = req.body;
    db.query(
        "INSERT INTO prescription (patient_id, medication_name, dosage, date_prescribed, status) VALUES (?, ?, ?, NOW(), 'Active')",
        [patient_id, medication_name, dosage],
        (err, result) => {
            if (err) return res.status(500).send(err);
            res.json({ message: "Prescription added successfully!" });
        }
    );
});

app.listen(5000, () => {
    console.log("Server running on port 5000");
});
