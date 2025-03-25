const express = require('express');
const cors = require('cors');
const app = express();

const appointmentRoutes = require('./routes/appointmentRoutes');
const authRoutes = require('./routes/authRoutes');

app.use(cors());
app.use(express.json());

// Use Auth routes
app.use('/api/auth', authRoutes);

// Use Appointment routes
app.use('/api/appointments', appointmentRoutes);

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
