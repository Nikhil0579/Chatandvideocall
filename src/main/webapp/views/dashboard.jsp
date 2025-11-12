<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
<title>Dashboard</title>
<style>
body { font-family: Arial; text-align: center; background: #f3f3f3; padding: 40px; }
.card { background: white; border-radius: 10px; width: 300px; margin: 15px auto; padding: 20px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
a.button { display: inline-block; padding: 8px 16px; border-radius: 6px; text-decoration: none; color: white; margin: 4px; }
.call { background: #28a745; }
.chat { background: #007bff; }
.logout { background: #dc3545; }
</style>
</head>
<body>

<h2>Welcome, ${user.username}</h2>
<h3>Contacts</h3>

<c:forEach var="c" items="${contacts}">
  <div class="card">
    <p><b>${c.username}</b></p>
    <a href="/chat/${c.username}" class="button chat">💬 Chat</a>
    <a href="/call/${c.username}" class="button call">📞 Call</a>
  </div>
</c:forEach>

<form action="/login" method="post">
    <button class="logout button" type="submit">Logout</button>
</form>

</body>
</html>
