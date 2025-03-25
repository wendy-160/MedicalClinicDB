// src/pages/NotFound.jsx
import React from 'react';

const NotFound = () => {
  return (
    <div className="flex flex-col items-center justify-center h-screen text-center">
      <h1 className="text-4xl font-bold text-red-600 mb-4">404 - Page Not Found</h1>
      <p className="text-lg text-gray-600">Oops! The page you're looking for does not exist.</p>
      <a href="/" className="mt-4 text-blue-500 hover:underline">
        Go back to Home
      </a>
    </div>
  );
};

export default NotFound;
