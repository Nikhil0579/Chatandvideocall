<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html><body>
<h2>Login</h2>
<form action="/login" method="post">
    Username: <input name="username"><br>
    Password: <input type="password" name="password"><br>
    <button type="submit">Login</button>
</form>
<c:if test="${error != null}">
    <p style="color:red">${error}</p>
</c:if>
</body></html>
