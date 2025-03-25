import React, { useState, useEffect } from "react";
import axios from "axios";

const Appointments = () => {
  const [appointments, setAppointments] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchAppointments = async () => {
      try {
        const res = await axios.get("http://localhost:5000/api/appointments");
        setAppointments(res.data);
      } catch (err) {
        setError("Failed to load appointments.");
      } finally {
        setLoading(false);
      }
    };

    fetchAppointments();
  }, []);

  return (
    <div className="appointments-container">
      <h2>Appointments</h2>

      {loading && <p>Loading appointments...</p>}
      {error && <p style={{ color: "red" }}>{error}</p>}

      {/* Displaying the appointments table */}
      {!loading && !error && appointments.length === 0 && (
        <p>No appointments found.</p>
      )}

      <table>
        <thead>
          <tr>
            <th>Appointment ID</th>
            <th>Patient</th>
            <th>Doctor</th>
            <th>Appointment Date</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          {appointments.map((appointment) => (
            <tr key={appointment.AppointmentID}>
              <td>{appointment.AppointmentID}</td>
              <td>{appointment.PatientName}</td>
              <td>{appointment.DoctorName}</td>
              <td>{appointment.DateTime}</td>
              <td>{appointment.Status}</td>
            </tr>
          ))}
        </tbody>
      </table>

      {/* Optionally add functionality for adding, editing, or deleting appointments */}
    </div>
  );
};

export default Appointments;
