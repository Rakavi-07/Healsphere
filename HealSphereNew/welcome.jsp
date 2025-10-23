

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="jakarta.servlet.http.HttpSession" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("name") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String username = (String) sess.getAttribute("name");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HealSphere Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">

    <style>
    :root {
        --bg-dark: #0f172a;
        --card-bg: #1e293b;
        --button-bg: #334155;
        --text-primary: #e2e8f0;
        --text-secondary: #94a3b8;
        --accent-green: #34d399;
        --accent-red: #ef4444;
    }

    body {
        margin: 0;
        font-family: 'Poppins', sans-serif;
        background-color: var(--bg-dark);
        color: var(--text-primary);
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
    }

    .dashboard-card {
        display: flex;
        width: 95vw;
        max-width: 1200px;
        height: 90vh;
        max-height: 700px;
        background-color: var(--card-bg);
        border-radius: 24px;
        box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.4);
        overflow: hidden;
        border: 1px solid #334155;
    }

    .card-left {
        flex-basis: 40%;
        background: linear-gradient(160deg, #38bdf8, #3b82f6);
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .card-left img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .card-right {
        flex-basis: 60%;
        padding: 30px 40px;
        display: flex;
        flex-direction: column;
        justify-content: center;
    }
    
    .header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 25px;
    }

    .header .brand {
        font-size: 22px;
        font-weight: 700;
        color: var(--accent-green);
    }

    .header .nav a {
        text-decoration: none;
        color: var(--text-secondary);
        font-weight: 600;
        margin-left: 20px;
        font-size: 14px;
        transition: color 0.3s ease;
    }

    .header .nav a:hover,
    .header .nav a.active {
        color: var(--accent-green);
    }

    .welcome-text h1 {
        font-size: 32px;
        margin: 0 0 5px 0;
        color: #ffffff;
        font-weight: 700;
    }
    
    .welcome-text .username {
        color: var(--accent-green);
    }

    .welcome-text p {
        font-size: 16px;
        color: var(--text-secondary);
        margin-bottom: 30px;
    }
    
    .feature-grid {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 20px;
    }

    .feature-button {
        background-color: var(--button-bg);
        border: 1px solid #475569;
        border-radius: 16px;
        padding: 20px;
        text-decoration: none;
        color: var(--text-primary);
        transition: transform 0.2s ease, box-shadow 0.2s ease;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        gap: 10px;
        min-height: 120px;
    }

    .feature-button:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 15px rgba(0, 0, 0, 0.2);
    }

    .feature-button .icon {
        font-size: 48px; /* CHANGED - Made the emoji bigger */
    }

    .feature-button span {
        font-size: 18px; /* CHANGED - Made the text bigger */
        font-weight: 700; /* CHANGED - Made the text bolder */
    }

    .feature-button.refill,
    .feature-button.emergency {
        background-color: var(--accent-red);
        border-color: var(--accent-red);
    }
    /* ============================================= */
/* ===== MODAL POP-UP STYLES ===== */
/* ============================================= */

.modal-overlay {
    display: none; /* Make sure this is 'none' */
    position: fixed; 
    z-index: 1000; 
    left: 0; top: 0;
    width: 100%; height: 100%; 
    background-color: rgba(0,0,0,0.7); 
    /* These centering properties are okay, they just won't do anything until display becomes flex */
    justify-content: center;
    align-items: center;
}
.modal-content {
    background-color: var(--card-bg); /* #1e293b */
    color: var(--text-primary);
    padding: 30px 40px;
    border: 1px solid var(--button-bg);
    width: 80%;
    max-width: 450px; /* Width of the popup box */
    border-radius: 20px;
    position: relative;
    box-shadow: 0 10px 30px rgba(0,0,0,0.4);
}
.modal-content h1 {
    font-size: 26px; margin-top: 0; margin-bottom: 25px;
    text-align: center; color: var(--accent-green);
}
.modal-close-button {
    color: var(--text-secondary); float: right; font-size: 32px; font-weight: bold;
    position: absolute; top: 15px; right: 25px; cursor: pointer;
}
.modal-close-button:hover, .modal-close-button:focus { color: #fff; text-decoration: none; }
.modal-content .form-group { margin-bottom: 15px; }
.modal-content .form-group label {
    display: block; margin-bottom: 5px; font-weight: 600; 
    color: var(--text-secondary); font-size: 14px;
}
.modal-content input[type="text"], .modal-content input[type="time"],
.modal-content input[type="date"], .modal-content input[type="number"] {
    width: 100%; padding: 10px; border: 1px solid var(--button-bg);
    background-color: var(--bg-dark); border-radius: 8px; 
    color: var(--text-primary); font-size: 15px; box-sizing: border-box;
}
.modal-save-button {
    background-color: var(--accent-green); color: #000; font-weight: 700;
    font-size: 16px; padding: 12px 20px; border: none; border-radius: 10px;
    width: 100%; cursor: pointer; margin-top: 15px;
}
</style>

    
</head>
<body>

    <div class="dashboard-card">
        <div class="card-left">
            <img src="images/doctor.png" alt="Doctor Illustration">
        </div>
        <div class="card-right">
            <div class="header">
                <div class="brand">HealSphere</div>
                <nav class="nav">
                    <a href="#">Profile</a>
                    <a href="login.jsp" class="active">Logout</a>
                </nav>
            </div>
            
            <div class="welcome-text">
                <h1>Welcome Back, <span class="username"><%= username %> 👋</span></h1>
                <p>Your personal health assistant is ready.</p>
            </div>

            <div class="feature-grid">
                <button id="openReminderModal" class="feature-button">
                    <div class="icon">💊</div>
                    <span>Pill Tracker</span>
                </button>
                <a href="#" class="feature-button refill">
                    <div class="icon">🔔</div>
                    <span>Refill Alerts</span>
                </a>
                <a href="#" class="feature-button emergency">
                    <div class="icon">🆘</div>
                    <span>Emergency</span>
                </a>
                <a href="#" class="feature-button">
                    <div class="icon">👨‍👩‍👧‍👦</div>
                    <span>Caregiver</span>
                </a>
                <a href="#" class="feature-button">
                    <div class="icon">⚙</div>
                    <span>Settings</span>
                </a>
                 <a href="#" class="feature-button">
                    <div class="icon">📜</div>
                    <span>View Logs</span>
                </a>
            </div>
        </div>
    </div>
    <div id="reminderModal" class="modal-overlay">
    <div class="modal-content">
        <span class="modal-close-button">&times;</span>
        <h1>Add New Reminder</h1>
        
        <form action="AddReminderServlet" method="post">
            
            <div class="form-group">
                <label for="medicineName">Medicine Name</label>
                <input type="text" id="medicineName" name="medicineName" required>
            </div>

            <div class="form-group">
                <label for="dosage">Dosage (e.g., 500mg)</label>
                <input type="text" id="dosage" name="dosage" required>
            </div>

            <div class="form-group">
                <label for="reminderTime">Time to Take</label>
                <input type="time" id="reminderTime" name="reminderTime" required>
            </div>
            
            <div class="form-group">
                <label for="startDate">Start Date</label>
                <input type="date" id="startDate" name="startDate" required>
            </div>

            <div class="form-group">
                <label for="endDate">End Date</label>
                <input type="date" id="endDate" name="endDate" required>
            </div>
            
            <div class="form-group">
                <label for="totalStock">Total Pills/Stock</label>
                <input type="number" id="totalStock" name="totalStock" min="0" required>
            </div>

            <button type="submit" class="modal-save-button">Save Reminder</button>
        </form>
    </div>
</div>

<script>
    // Get the elements needed for the modal
    var modal = document.getElementById("reminderModal");
    var openBtn = document.getElementById("openReminderModal");
    var closeBtn = document.querySelector(".modal-close-button");

    // When the "Pill Tracker" button is clicked, show the modal
    openBtn.onclick = function() {
        modal.style.display = "flex"; // Use flex to show and center
    }

    // When the close button (x) is clicked, hide the modal
    closeBtn.onclick = function() {
        modal.style.display = "none";
    }

    // When the user clicks anywhere outside the modal box, hide it
    window.onclick = function(event) {
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }
</script>

</body>
</html>