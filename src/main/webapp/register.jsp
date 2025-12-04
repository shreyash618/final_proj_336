<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.techbarn.webapp.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Tech Barn Register</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
<style>
  * { 
    margin: 0; 
    padding: 0; 
    box-sizing: border-box; 
    font-family: 'Inter', sans-serif; 
  }
  
  body, html {
    height: 100%; 
    width: 100%;
    background: url('Images/devices4.jpg') no-repeat center center/cover;
    background-attachment: fixed;
    display: flex; 
    justify-content: center; 
    align-items: center; 
    position: relative;
    overflow: hidden;
  }
  .required { color: red; }
  
  .form-box {
    position: relative; 
    z-index: 1;
    width: 100%; 
    max-width: 450px;
    background: #ffffff;
    border-radius: 20px;
    padding: 3rem 2.5rem;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3); 
    text-align: center;
    transition: all 0.3s ease;
  }
  
  .form-box:hover {
    box-shadow: 0 25px 70px rgba(0, 0, 0, 0.35);
  }
  
  h1 { 
    margin-bottom: 0.5rem; 
    color: #2d3748; 
    font-weight: 700; 
    font-size: 2rem;
    letter-spacing: -0.5px;
  }
  
  .form-container {
    width: 100%;
  }
  
  .form-input {
    width: 100%; 
    padding: 14px 18px; 
    margin: 10px 0;
    border: 2px solid #e2e8f0;
    border-radius: 10px;
    font-size: 1rem; 
    outline: none; 
    transition: all 0.3s ease;
    background: #f7fafc;
    color: #2d3748;
  }
  
  .form-input::placeholder {
    color: #a0aec0;
  }
  
  .form-input:focus { 
    border-color: #667eea; 
    background: #ffffff;
    box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
    transform: translateY(-1px);
  }
  
  .submit-button {
    width: 100%; 
    padding: 14px; 
    margin-top: 20px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: #fff; 
    font-size: 1rem; 
    font-weight: 600;
    border: none; 
    border-radius: 10px;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
  }
  
  .submit-button:hover { 
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(102, 126, 234, 0.5);
  }
  
  .submit-button:active {
    transform: translateY(0);
  }
  
  .switch-link { 
    margin-top: 20px; 
    font-size: 0.9rem; 
    color: #667eea; 
    cursor: pointer; 
    font-weight: 500;
    transition: color 0.2s ease;
  }
  
  .switch-link:hover { 
    color: #764ba2;
    text-decoration: underline; 
  }
  
  .message {
    margin-top: 15px;
    padding: 12px;
    border-radius: 8px;
    font-size: 0.9rem;
    font-weight: 500;
  }
  
  .message.success {
    background: #c6f6d5;
    color: #22543d;
    border: 1px solid #9ae6b4;
  }
  
  .message.error {
    background: #fed7d7;
    color: #742a2a;
    border: 1px solid #fc8181;
  }
  
  .fade-in { 
    animation: fadeIn 0.5s forwards; 
  }
  
  .fade-out { 
    animation: fadeOut 0.5s forwards; 
  }
  
  @keyframes fadeIn { 
    from {
      opacity: 0; 
      transform: translateY(20px);
    } 
    to {
      opacity: 1; 
      transform: translateY(0);
    } 
  }
  
  @keyframes fadeOut { 
    from {
      opacity: 1; 
      transform: translateY(0);
    } 
    to {
      opacity: 0; 
      transform: translateY(-20px);
    } 
  }
  
  .hidden { 
    display: none !important; 
  }
  
  @media(max-width: 480px){ 
    .form-box { 
      padding: 2rem 1.5rem; 
      margin: 1rem;
      border-radius: 15px;
    } 
    h1 {
      font-size: 1.75rem;
    }
    .form-input, .submit-button { 
      font-size: 0.95rem; 
      padding: 12px 16px;
    } 
  }
</style>
</head>
<body>
  <div class="form-box">
    <div class="form-container fade-in" id="register-form">

      <form action="register" method="post">
        <h1>Tech Barn Registration</h1>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="message error"><%= request.getAttribute("errorMessage") %></div>
        <% } %>

        <input type="text" id="register-first-name" name="firstName" placeholder="First Name *" required class="form-input">

        <input type="text" id="register-last-name" name="lastName" placeholder="Last Name *" required class="form-input">

        <input type="email" id="register-email" name="email" placeholder="Email *" required class="form-input">

        <input type="date" id="register-dob" name="dob" placeholder="Date of Birth" class="form-input">
        <input type="tel" id="register-phone" name="tel" placeholder="Phone" class="form-input">
        <input type="text" id="register-username" name="username" placeholder="Username *" required class="form-input">

        <input type="password" id="register-password" name="password" placeholder="Password *" required class="form-input">

        
        <button id="register-btn" class="submit-button">Register</button>

        <a class="switch-link" href="login">Already have an account? Login</a>
      </form>

    </div>
  </div>
</body>

</html>
