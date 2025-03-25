import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import DoctorDashboard from './pages/DoctorDashboard';
import PatientDashboard from './pages/PatientDashboard';
import AdminDashboard from './pages/AdminDashboard';
import NotFound from './pages/NotFound';
import Navbar from './components/Navbar';
import LoginPage from './pages/LoginPage';

const App = () => {
  // Get the user type from localStorage
  const [userType, setUserType] = useState(null);

  useEffect(() => {
    const user = JSON.parse(localStorage.getItem('user'));
    if (user) {
      setUserType(user.Role); // Set the user type (Doctor, Patient, Admin)
    }
  }, []);

  return (
    <Router>
      <Navbar />
      <Routes>
        <Route path="/login" element={<LoginPage />} />
        {userType === 'Doctor' && <Route path="/" element={<DoctorDashboard />} />}
        {userType === 'Patient' && <Route path="/" element={<PatientDashboard />} />}
        {userType === 'Admin' && <Route path="/" element={<AdminDashboard />} />}
        <Route path="*" element={<NotFound />} />
      </Routes>
    </Router>
  );
};

export default App;
