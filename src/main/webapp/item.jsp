<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.techbarn.webapp.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Tech Barn - Item</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <style>
        *   { 
            margin: 0; 
            padding: 0; 
            box-sizing: border-box; 
            font-family: 'Roboto', sans-serif; 
        }
        
        body, html {
            height: 100%;
            width: 100%;
            overflow-x: hidden;
        }
    </style>
</head>
<body>
    <%@ include file="navbar.jsp" %>
    <img src="pic_trulli.jpg" alt="Italian Trulli" height = 200 width=300>
    <h2>Item Name:****</h2>
    <h4>Brand<h4>
    <h4>Color<h4>
    <h4>Condition<h4>
    <h4>In Stock/Out of Stock<h4>
    <h4>Additional attributes (category-specific)<h4>
    <p>Description:...<p>
</body>
</html>
