<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html><body>
<h2>Register</h2>
<form action="/register" method="post">
    Username: <input name="username"><br>
    Password: <input type="password" name="password"><br>
    <button type="submit">Register</button>
</form>
<a href="/login">Login</a>
</body></html>
