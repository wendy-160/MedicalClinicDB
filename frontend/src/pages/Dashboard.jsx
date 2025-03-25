import React from 'react';
import { useAuth } from '../context/AuthContext';  

const Dashboard = () => {
  const { user } = useAuth();  

  return (
    <div>
      <h2>Welcome to Your Dashboard</h2>
      {user ? (
        <div>
          <p>Hello, {user.username}</p>
          <p>Your role: {user.role}</p>
          <p>Here's some information based on your role:</p>
          {/* Add specific content based on role */}
          {user.role === 'admin' && <p>Admin-specific content here.</p>}
          {user.role === 'doctor' && <p>Doctor-specific content here.</p>}
          {user.role === 'patient' && <p>Patient-specific content here.</p>}
        </div>
      ) : (
        <p>You need to log in to see your dashboard.</p>
      )}
    </div>
  );
};

export default Dashboard;
