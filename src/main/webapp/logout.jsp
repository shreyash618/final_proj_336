<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Logout</title>
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
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        display: flex; 
        justify-content: center; 
        align-items: center; 
        position: relative;
        overflow: hidden;
    }
    
    body::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: url('Images/devices4.jpg') no-repeat center center/cover;
        opacity: 0.25;
        z-index: 0;
        filter: blur(1px);
        transform: scale(1.05);
    }
    
    body::after {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: 
          radial-gradient(circle at 20% 50%, rgba(102, 126, 234, 0.3) 0%, transparent 50%),
          radial-gradient(circle at 80% 80%, rgba(118, 75, 162, 0.3) 0%, transparent 50%),
          linear-gradient(135deg, rgba(102, 126, 234, 0.4) 0%, rgba(118, 75, 162, 0.4) 100%);
        z-index: 0;
        animation: gradientShift 15s ease infinite;
    }
    
    @keyframes gradientShift {
        0%, 100% {
            opacity: 1;
        }
        50% {
            opacity: 0.8;
        }
    }
    
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
        margin-bottom: 1rem; 
        color: #2d3748; 
        font-weight: 700; 
        font-size: 2rem;
        letter-spacing: -0.5px;
    }
    
    p { 
        margin-bottom: 2rem; 
        color: #4a5568; 
        font-size: 1rem; 
        line-height: 1.6;
    }
    
    .form-container {
        width: 100%;
    }
    
    .submit-button {
        width: 100%; 
        padding: 14px; 
        margin-top: 10px;
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
    
    .icon {
        font-size: 4rem;
        margin-bottom: 1.5rem;
        color: #667eea;
        opacity: 0.8;
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
        .submit-button { 
            font-size: 0.95rem; 
            padding: 12px 16px;
        } 
    }
    </style>
    </head>
    <body>
        <div class="form-box">
            <!-- Logout Page -->
            <div class="form-container" id="logout-page">
                <div class="icon">&#10004;</div>
                <h1>You've Been Logged Out</h1>
                <p>Thank you for visiting Tech Barn. You have been successfully logged out.</p>
                <button id="login-btn" onclick="window.location.href ='login'" class="submit-button">Return to Login</button>
            </div>
        </div>
    </body>
</html>
