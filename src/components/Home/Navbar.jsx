import { Link } from "react-router-dom";
import './Navbar.css'

const Navbar = () => {
    return (
      <nav className="navbar">
        <h1 className="logo">UH ClinicHub</h1>
        <ul className="nav-links">
          <li><Link to="/">Home</Link></li>
          <li><Link to="/appointments">Appointments</Link></li>
          <li><Link to="/doctors">Doctors</Link></li>
          <li><Link to="/patients">Patients</Link></li>
        </ul>
        <div className = "buttons">
            <Link to="/login" className="btn login-btn">Login</Link>
            <Link to="/register" className="btn register-btn">Register</Link>
        </div>
      </nav>

    );
  };
  
  export default Navbar;