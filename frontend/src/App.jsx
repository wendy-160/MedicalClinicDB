import React from 'react';
import { Routes, Route, Link } from 'react-router-dom';
import MedicalTests from '../medicaltests.jsx';
import Prescriptions from '../prescriptions.jsx';

export default function App() {
  return (
    <div>
      <h1>Medical Clinic App</h1>

      <nav>
        <Link to="/">Home</Link> | 
        <Link to="/tests">Medical Tests</Link> | 
        <Link to="/prescriptions">Prescriptions</Link>
      </nav>

      <Routes>
        <Route path="/" element={<h2>Welcome to the Clinic Homepage</h2>} />
        <Route path="/tests" element={<MedicalTests />} />
        <Route path="/prescriptions" element={<Prescriptions />} />
      </Routes>
    </div>
  );
}
