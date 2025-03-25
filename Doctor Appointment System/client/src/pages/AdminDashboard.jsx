import React, { useState, useEffect } from 'react';
import Card from '../components/Card';
import ModalForm from '../components/ModalForm';
import axios from 'axios';

const AdminDashboard = () => {
  const [allAppointments, setAllAppointments] = useState([]);
  const [isModalOpen, setIsModalOpen] = useState(false);

  useEffect(() => {
    const fetchAppointments = async () => {
      try {
        const token = localStorage.getItem('token');
        const response = await axios.get('/api/appointments', {
          headers: { Authorization: `Bearer ${token}` }
        });
        setAllAppointments(response.data);
      } catch (error) {
        console.error('Error fetching appointments:', error);
      }
    };

    fetchAppointments();
  }, []);

  const handleSave = (formData) => {
    console.log('Saved Data:', formData); // Replace with actual backend saving logic
    setIsModalOpen(false);
  };

  return (
    <div>
      <button 
        onClick={() => setIsModalOpen(true)}
        className="bg-green-500 text-white py-1 px-4 rounded m-4"
      >
        New Appointment
      </button>

      <div className="flex flex-wrap justify-center">
        {allAppointments.length > 0 ? (
          allAppointments.map(appointment => (
            <Card key={appointment.AppointmentID} {...appointment} userType="admin" />
          ))
        ) : (
          <p>No appointments found.</p>
        )}
      </div>

      <ModalForm 
        isOpen={isModalOpen} 
        onClose={() => setIsModalOpen(false)} 
        onSave={handleSave}
      />
    </div>
  );
};

export default AdminDashboard;
