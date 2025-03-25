# Appointment and Referral System

This is an Appointment and Referral System designed to allow patients to book, update, and manage appointments with doctors, while also supporting the referral process between doctors.

## Installation

### Prerequisites

- Node.js (version 14 or above)
- MySQL database

### 1. Install dependencies (Front-end)

```bash
cd client
npm install
```

### 2. Install dependencies (Back-end)

```bash
cd server
npm install
```

### 3. Set up the database

- Create a new MySQL database named `appointment_referral_db`.
- Import the database schema from `schema.sql`.


### 4. Set up environment variables

Create a `.env` file in the root directory and add the following environment variables:

```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=yourpassword
DB_NAME=appointment_referral_db
JWT_SECRET=your_jwt_secret
```

### 5. Run the server

```bash
cd server
npm start
```

The backend server should now be running at `http://localhost:5000`.

### 6. Running Frontend (React)

In a separate terminal window, navigate to the `client` directory:

```bash
cd client
npm start
```

The React application will now be running at `http://localhost:5173`.

---

## Technologies Used

- **Backend**: Node.js, Express.js, MySQL
- **Frontend**: React, Axios, Tailwind CSS
- **Authentication**: JWT (JSON Web Token)
- **Database**: MySQL

---

## NOTE:

USe the following endpoints to get started:

### Register a new Doctor 

`http://localhost:5000/api/auth/register`

```bash
{
  "userType": "Doctor",
  "Name": "Dr. John Doe",
  "PhoneNumber": "1234567890",
  "Email": "john1.doe@example.com",
  "DateOfBirth": "1980-01-01",
  "Address": "123 Main St",
  "Specialization": "Cardiologist",
  "WorkSchedule": "Mon:Fri_09:00;17:00",
  "OfficeID": "001",
  "Password": "securepassword123"
}

```
 - ### Note that the WorkSchedule format is `Mon:Fri_09:00;17:00`. The separators `':'`,`'_'` and `';'` are used.  `':'` is being used to showing day range while `'_'` is separating days and time, whereas `';'` is showing the time range

### Register a new patient

`http://localhost:5000/api/auth/register`

```bash
{
  "userType": "Patient",
  "Name": "Jane Doe",
  "PhoneNumber": "1234567890",
  "Email": "jane.doe@example.com",
  "DateOfBirth": "1980-01-01",
  "Address": "123 Main St",
  "Password": "password123"
}
```

- To login use the endpoint `/login` on your browser and ensure that your server and client are running and also if you are using xampp or wampp ensure that they are running to avoid connection error. 

---

## License

This project is licensed under the MIT License.

---
