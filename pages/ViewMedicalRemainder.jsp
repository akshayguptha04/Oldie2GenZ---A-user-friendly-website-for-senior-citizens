
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="java.text.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>

<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Medical Reminders</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link rel="stylesheet" href="style.css">

  <style>
    .controls span, .controls button {
      margin-right: 8px;
    }

    .add-btn {
      margin: 15px;
      padding: 10px 20px;
      font-size: var(--base-font-size);
      background: green;
      color: white;
      border: none;
      border-radius: 5px;
      cursor: pointer;
    }

    .remove-btn {
      padding: 5px 10px;
      font-size: var(--base-font-size);
      background: red;
      color: white;
      border: none;
      border-radius: 5px;
      cursor: pointer;
    }

    .submit-btn {
      margin: 20px;
      padding: 10px 20px;
      font-size: var(--base-font-size);
      background: blue;
      color: white;
      border: none;
      border-radius: 5px;
      cursor: pointer;
    }

    .table-container {
      margin: 20px auto;
      width: 95%;
    }

    table {
      width: 100%;
      border-collapse: collapse;
    }

    th, td {
      border: 1px solid #ccc;
      padding: 10px;
      text-align: center;
    }

    th {
      background-color: #f4f4f4;
    }

    input, select {
      width: 100%;
      font-size: var(--base-font-size);
      padding: 5px;
    }
  </style>

</head>

<body>
  <header class="header">
    <div class="home-icon" onclick="goHome()">🏠</div>
    <div class="logo" id="logo-text"><i>❀ Oldie2Genz</i></div>
    <div class="controls">
      <div>
        <span id="lang-label">Language:</span>
        <button class="lang-btn" onclick="changeLanguage('en')">English</button>
        <button class="lang-btn" onclick="changeLanguage('hi')">हिन्दी</button>
        <button class="lang-btn" onclick="changeLanguage('te')">తెలుగు</button>
      </div>
      <div>
        <span id="font-label">Font:</span>
        <button class="font-btn" onclick="adjustFontSize(1)">+</button>
        <button class="font-btn" onclick="adjustFontSize(-1)">-</button>
      </div>
    </div>
  </header>

  <h2 id="main-title">Medical Reminders</h2>



  <form id="medicine-form" method="POST" action="/SeniorCitizen/MedicalRemainderServlet">
    <div class="table-container">
      <table id="medicine-table">
        <thead>
          <tr>
            <th>Medicine Name</th>
            <th>Med Date</th>
            <th>No. of Days</th>
            <th>Breakfast Time</th>
            <th>Dosage</th>
            <th>Lunch Time</th>
            <th>Dosage</th>
            <th>Dinner Time</th>
            <th>Dosage</th>
            <th>Remove</th>
          </tr>
        </thead>
        
        <tbody>
        
        <%
        
        String URL = "jdbc:postgresql://localhost:5432/mydb";
      	String USER = "postgres";
        String PASSWORD = "Post1gre2";
        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            conn.setAutoCommit(false);

            // Set schema
            Statement schemaStmt = conn.createStatement();
            schemaStmt.execute("SET search_path TO \"SeniorCitizen\"");
            
            String selectSQL = "SELECT  \"Medical\".\"Med_name\", \"Medical\".\"Med_date\", \"Medical\".\"Med_days\", " +
                    "\"Medical\".\"Med_bftime\", \"Medical\".\"Med_bf_dosage\", \"Medical\".\"Med_lunchtime\", \"Medical\".\"Med_lunch_dosage\", " +
                    "\"Medical\".\"Med_dinnertime\", \"Medical\".\"Med_dinner_dosage\", \"Medical\".\"Med_seq\" " +
                    "FROM \"SeniorCitizen\".\"Medical\" where \"Medical\".\"SC_seq\" = ?  ORDER BY \"Medical\".\"Med_seq\" ";
            
            System.out.println(selectSQL);
            HttpSession sess = request.getSession(false);
            int scSeq = Integer.parseInt(sess.getAttribute("seq").toString());

            PreparedStatement pstmt = conn.prepareStatement(selectSQL);
            pstmt.setInt(1, scSeq);
            ResultSet rs = pstmt.executeQuery();
            
            while(rs.next())
            {
            	String name = rs.getString(1);
            	String date = rs.getString(2);
            	String days = rs.getString(3);
            	String bftime = rs.getString(4);
            	String bfdose = rs.getString(5);
            	String ltime = rs.getString(6);
            	String ldose = rs.getString(7);
            	String dtime = rs.getString(8);
            	String ddose = rs.getString(9);  
            	String medSeq = rs.getString(10);  
            	/*
            	SimpleDateFormat x =  new SimpleDateFormat ("dd-MM-yyyy");
            	//Date dt= new Date(date.substring(0, 3), date.substring(5, 6), date.substring(8, 9)); 
            	int year=Integer.parseInt(date.substring(0, 4));
            	int mon= Integer.parseInt(date.substring(5, 7));
            	int day = Integer.parseInt(date.substring(8, 10));
            	System.out.println(date+" "+year + " "+ mon +" "+day);
            	java.util.Date ndt = new Date(year, mon, day);
            	GregorianCalendar dt = new GregorianCalendar(year, mon, day);
            	//java.util.Date ndt = dt.getGregorianChange();
            	System.out.println("Gregorian: "+dt);
            	System.out.println("Date: "+ndt);
            	date = x.format(ndt); */

    	%>
        
        <tr>
	        <td><%= name %></td>
	        <td><%= date %></td>
	        <td><%= days %></td>
	        <td><%= bftime %></td>
	        <td><%= bfdose %></td>
	        <td><%= ltime %></td>
	        <td><%= ldose %></td>
	        <td><%= dtime %></td>
	        <td><%= ddose %></td>
	        <td><button class="remove-btn" type="button" onClick="window.location.href='/SeniorCitizen/DeleteMedical?Med_seq=<%= medSeq %>'"  >❌</button></td>
	        </tr>
	      <%
            }
            pstmt.close();
            conn.close();

	        } catch (Exception e) {
	            e.printStackTrace();
	            out.println("<p style='color:red;'>❌ Error: " + e.getMessage() + "</p>");
	        }
	        
	      %>
        </tbody>
      </table>
    </div>

```

```

  </form>

  <script>
    const translations = {
      en: {
        "Medical Reminders": "View Medical Reminders",
        "lang-label": "Language:",
        "font-label": "Font:",
        "add-btn": "â Add Medicine",
        headers: ["Medicine Name", "Med Date", "No. of Days", "Breakfast Time", "Dosage", "Lunch Time", "Dosage", "Dinner Time", "Dosage", "Remove"]
      },
      hi: {
          "Medical Reminders": "चिकित्सा अनुस्मारक",
          "lang-label": "भाषा:",
          "font-label": "फ़ॉन्ट:",
          "add-btn": "➕ दवा जोड़ें",
          headers: ["दवा का नाम", "तारीख", "दिनों की संख्या", "नाश्ते का समय", "खुराक", "दोपहर का समय", "खुराक", "रात का खाना", "खुराक", "हटाएं"]
        },
        te: {
          "Medical Reminders": "వైద్య గుర్తు",
          "lang-label": "భాష:",
          "font-label": "ఫాంట్:",
          "add-btn": "➕ మందు జోడించండి",
          headers: ["ఔషధం పేరు", "తేదీ", "రోజుల సంఖ్య", "ఉదయం సమయం", "డోసేజ్", "మధ్యాహ్నం సమయం", "డోసేజ్", "రాత్రి భోజనం", "డోసేజ్", "తొలగించు"]
        }
      };

    function goHome() {
      window.location.href = '/SeniorCitizen/pages/Remainders.html';
    }

    let medicineCount = 0;

    function addRow() {
      medicineCount++;
      const table = document.getElementById("medicine-table").getElementsByTagName("tbody")[0];
      const newRow = table.insertRow();
      newRow.innerHTML = `
        <td><input name="medicineName" type="text" placeholder="Name" required></td>
        <td><input name="medDate" type="date" required></td>
        <td><input name="days" type="number" min="1" required></td>
        <td><input name="bTime" type="time" required></td>
        <td><input name="bDosage" type="number" min="0" required></td>
        <td><input name="lTime" type="time" required></td>
        <td><input name="lDosage" type="number" min="0" required></td>
        <td><input name="dTime" type="time" required></td>
        <td><input name="dDosage" type="number" min="0" required></td>
        <td><button class="remove-btn" type="button" onclick="removeRow(this)">â</button></td>
      `;
    }

    function removeRow(button) {
      const row = button.closest("tr");
      row.remove();
      resetMedicineNames();
    }

    function resetMedicineNames() {
      const rows = document.querySelectorAll("#medicine-table tbody tr");
      medicineCount = 0;
      rows.forEach((row) => {
        const input = row.querySelector("td input[type='text']");
        if (input) {
          medicineCount++;
          input.value = `Medicine ${medicineCount}`;
        }
      });
    }

    function adjustFontSize(change) {
      const root = document.documentElement;
      const currentSize = parseFloat(getComputedStyle(root).getPropertyValue('--base-font-size') || 16);
      root.style.setProperty('--base-font-size', (currentSize + change) + 'px');
    }

    function changeLanguage(lang) {
      localStorage.setItem('selectedLang', lang);
      const t = translations[lang];
      if (!t) return;
      document.getElementById("main-title").textContent = t["Medical Reminders"];
      document.getElementById("lang-label").textContent = t["lang-label"];
      document.getElementById("font-label").textContent = t["font-label"];
      document.getElementById("add-btn").textContent = t["add-btn"];
      const headers = document.querySelectorAll("#medicine-table thead th");
      t.headers.forEach((text, i) => {
        if (headers[i]) headers[i].textContent = text;
      });
    }

    window.addEventListener('DOMContentLoaded', () => {
      const savedLang = localStorage.getItem('selectedLang') || 'en';
      changeLanguage(savedLang);
    });
  </script>

</body>
</html>
