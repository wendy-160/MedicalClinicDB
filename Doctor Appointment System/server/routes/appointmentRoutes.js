const express = require('express');
const appointmentController = require('../controllers/appointmentController');
const { authenticateToken, authorize } = require('../middleware/authmiddleware');
const router = express.Router();

// Appointment Routes
router.post('/', authenticateToken, authorize('Patient', 'Admin'), appointmentController.createAppointment);
router.get('/', authenticateToken, authorize('Admin'), appointmentController.getAllAppointments);
router.get('/:id', authenticateToken, appointmentController.getAppointmentById);
router.put('/:id', authenticateToken, authorize('Patient','Doctor', 'Admin'), appointmentController.updateAppointment);
router.delete('/:id', authenticateToken, authorize('Doctor', 'Admin'), appointmentController.deleteAppointment);
router.get('/patient/:patientId', authenticateToken, authorize('Patient'), appointmentController.getAppointmentsByPatientId);
router.get('/doctor/:doctorId', authenticateToken, authorize('Doctor', 'Admin'), appointmentController.getAppointmentsByDoctorId);

// Referral Routes
router.get('/referral/:appointmentID', authenticateToken, authorize('Doctor', 'Admin'), appointmentController.getReferralsByAppointment);

// Approve Appointment Route
router.post('/:appointmentID/approve', authenticateToken, authorize('Admin', 'Doctor'), appointmentController.approveAppointment);

// Refer Appointment Route
router.post('/:appointmentID/refer', authenticateToken, authorize('Doctor', 'Admin'), appointmentController.referAppointment);

module.exports = router;
