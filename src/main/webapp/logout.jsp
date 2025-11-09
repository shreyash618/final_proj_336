<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Logout</title>
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <style>
    * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Roboto', sans-serif; }
    body, html {
        height: 100%; width: 100%;
        background: url('IMG_0518.JPG') no-repeat center center/cover;
        display: flex; justify-content: center; align-items: center; position: relative;
    }
    .overlay {
        position: absolute; top:0; left:0; width:100%; height:100%;
        z-index:0;
        background: rgba(0, 0, 0, 0.4);
    }
    .container {
        position: relative; z-index:1;
        width: 100%; max-width: 400px;
        background: rgba(255,255,255,0.95);
        border-radius: 20px; padding: 2rem;
        box-shadow: 0 12px 30px rgba(0,0,0,0.2); text-align: center;
        transition: all 0.5s ease;
    }
    h1 { margin-bottom: 1.5rem; color: #333; }
    p { margin-bottom: 1.5rem; color: #666; font-size: 1rem; }
    input {
        width: 100%; padding: 12px; margin: 10px 0;
        border-radius: 12px; border: 1px solid #ccc;
        font-size: 1rem; outline: none; transition: 0.3s;
    }
    input:focus { border-color: #6b9080; }
    button {
        width: 100%; padding: 12px; margin-top: 15px;
        background: #6b9080; color: #fff; font-size: 1rem;
        border: none; border-radius: 12px; cursor: pointer;
        transition: background 0.3s ease, transform 0.2s;
    }
    button:hover { background: #3e6b5c; transform: scale(1.03); }
    .toggle { margin-top: 15px; font-size: 0.9rem; color: #555; cursor: pointer; }
    .toggle:hover { text-decoration: underline; }
    .fade-in { animation: fadeIn 0.5s forwards; }
    .fade-out { animation: fadeOut 0.5s forwards; }
    @keyframes fadeIn { from {opacity:0; transform: translateY(20px);} to {opacity:1; transform: translateY(0);} }
    @keyframes fadeOut { from {opacity:1; transform: translateY(0);} to {opacity:0; transform: translateY(-20px);} }
    .hidden { display: none !important; }
    @media(max-width: 450px){ .container { padding: 1.5rem; } input, button { font-size: 0.95rem; } }
    </style>
    </head>
    <body>
        <div class="overlay"></div>
        <div class="container">
            <!-- Logout Page -->
            <div class="form-container" id="logout-page">
                <h1>You've Been Logged Out</h1>
                <p>Thank you for visiting Baes Couture. You have been successfully logged out.</p>
                <button id="login-btn" onclick="window.location.href ='login.jsp'">Login</button>
            </div>
        </div>
    </body>
</html>