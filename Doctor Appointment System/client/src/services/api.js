import axios from 'axios';

const API_URL = 'http://localhost:5000/api'; // Your backend URL

// Register User
export const registerUser = async (userData) => {
    const response = await axios.post(`${API_URL}/auth/register`, userData);
    return response.data;
};

// Login User
export const loginUser = async (userData) => {
    const response = await axios.post(`${API_URL}/auth/login`, userData);
    return response.data;
};
