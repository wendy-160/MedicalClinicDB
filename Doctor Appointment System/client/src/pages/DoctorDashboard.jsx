import React, { useState, useEffect } from 'react';
import Card from '../components/Card';
import ModalForm from '../components/ModalForm';
import axios from 'axios';
import { FiPlus } from 'react-icons/fi';

const DoctorDashboard = () => {
  const [doctorAppointments, setDoctorAppointments] = useState([]);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const currentDoctorID = JSON.parse(localStorage.getItem('user'))?.DoctorID;

  useEffect(() => {
    const fetchAppointments = async () => {
      try {
        const token = localStorage.getItem('token');
        const response = await axios.get(`/api/appointments/doctor/${currentDoctorID}`, {
          headers: { Authorization: `Bearer ${token}` }
        });
        setDoctorAppointments(response.data);
      } catch (error) {
        console.error('Error fetching doctor appointments:', error);
      }
    };

    if (currentDoctorID) fetchAppointments();
  }, [currentDoctorID]);

  const handleSave = (formData) => {
    console.log('Saved Data:', formData); 
    setIsModalOpen(false);
  };

  return (
    <div>
      <div className="flex justify-between items-center">
        <h1 className="text-md text-center text-gray-700">Welcome back, {JSON.parse(localStorage.getItem('user'))?.Name}</h1>
        <button 
          onClick={() => setIsModalOpen(true)}
          className="text-gray-400 border-1 py-1 px-4 rounded-md m-4"
        >
          <FiPlus />
        </button>
      </div>
      <hr />

      <div className="flex flex-wrap justify-left gap-1 px-8 py-2">
        {doctorAppointments.length > 0 ? (
          doctorAppointments.map(appointment => (
            <Card key={appointment.AppointmentID} {...appointment} userType="Doctor" />
          ))
        ) : (
          <p>No appointments found for your account.</p>
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

export default DoctorDashboard;
