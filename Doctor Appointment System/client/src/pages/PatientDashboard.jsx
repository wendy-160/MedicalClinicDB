import React, { useState, useEffect } from 'react';
import Card from '../components/Card';
import ModalForm from '../components/ModalForm';
import axios from 'axios';
import { FiPlus } from 'react-icons/fi';

const PatientDashboard = () => {
  const [patientAppointments, setPatientAppointments] = useState([]);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const currentPatientID = JSON.parse(localStorage.getItem('user'))?.PatientID;

  useEffect(() => {
    const fetchAppointments = async () => {
      try {
        const token = localStorage.getItem('token');
        const response = await axios.get(`/api/appointments/patient/${currentPatientID}`, {
          headers: { Authorization: `Bearer ${token}` }
        });
        setPatientAppointments(response.data);
      } catch (error) {
        console.error('Error fetching patient appointments:', error);
      }
    };

    if (currentPatientID) fetchAppointments();
  }, [currentPatientID]);

  const handleSave = (formData) => {
    console.log('Saved Data:', formData); 
    setIsModalOpen(false);
  };

  return (
    <div>
      <div className="flex justify-between items-center">
        <h1 className="text-md text-center text-gray-700">Welcome back: {currentPatientID}</h1>
        <button 
          onClick={() => setIsModalOpen(true)}
          className="text-gray-400 border-1 py-1 px-4 rounded-md m-4"
        >
          <FiPlus />
        </button>
      </div>
      <hr />

      <div className="flex flex-wrap justify-left gap-1 px-8 py-2">
        {patientAppointments.length > 0 ? (
          patientAppointments.map(appointment => (
            <Card key={appointment.AppointmentID} {...appointment} userType="Patient" />
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

export default PatientDashboard;
