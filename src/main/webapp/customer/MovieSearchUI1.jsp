<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cineman.model.Account1" %>
<%
    Account1 currentAccount = (Account1) session.getAttribute("currentAccount");
    if (currentAccount == null) { response.sendRedirect(request.getContextPath() + "/LoginUI1.jsp"); return; }

    // Thuộc tính của lớp MovieSearchUI1 theo biểu đồ thiết kế
    String inMovieName = request.getParameter("inMovieName");
    if (inMovieName == null) inMovieName = "";
    String outMessage = (String) request.getAttribute("outMessage");

    String displayName = (currentAccount.getFullName() != null && !currentAccount.getFullName().trim().isEmpty())
                          ? currentAccount.getFullName() : currentAccount.getUsername();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tìm kiếm phim — CineMan</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="cm-card">
    <div class="cm-header">
        <span class="cm-logo">CineMan</span>
        <span class="cm-sep">|</span>
        <h2>Tìm kiếm phim</h2>
        <div class="cm-spacer"></div>
        <span class="cm-user-name"><%= displayName %></span>
    </div>

    <div class="cm-body">
        <% if (outMessage != null && !outMessage.isEmpty()) { %>
            <div class="alert alert-warning" id="outMessage"><%= outMessage %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/movie" method="GET" class="search-bar">
            <input type="hidden" name="action" value="searchMovie">
            <label for="inMovieName">Tên phim:</label>
            <input type="text" id="inMovieName" name="inMovieName"
                   value="<%= inMovieName %>"
                   placeholder="Nhập tên phim cần tìm..." required>
            <button type="submit" id="btnSearch" name="btnSearch" class="btn btn-primary">Tìm kiếm</button>
        </form>
    </div>

    <div class="cm-footer-bar">
        <a href="${pageContext.request.contextPath}/MainUI1.jsp" id="linkBack" class="link-back">Quay lại</a>
    </div>
</div>
</body>
</html>
