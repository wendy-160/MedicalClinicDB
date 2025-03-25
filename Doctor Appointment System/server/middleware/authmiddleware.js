const jwt = require('jsonwebtoken');
require('dotenv').config();

// Authentication Middleware
exports.authenticateToken = (req, res, next) => {
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) return res.status(401).json({ message: 'No token provided. Access denied.' });

    jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
        if (err) return res.status(403).json({ message: 'Invalid token. Access forbidden.' });
        req.user = user;
        next();
    });
};

// Authorization Middleware
exports.authorize = (...roles) => {
    return (req, res, next) => {
        if (!req.user || !roles.includes(req.user.role)) {
            return res.status(403).json({ message: 'Access denied. You do not have permission to access this resource.' });
        }
        next();
    };
};
