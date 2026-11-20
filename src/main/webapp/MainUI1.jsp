<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cineman.model.Account1" %>
<%
    Account1 currentAccount = (Account1) session.getAttribute("currentAccount");
    if (currentAccount == null) {
        response.sendRedirect(request.getContextPath() + "/LoginUI1.jsp");
        return;
    }
    String displayName = (currentAccount.getFullName() != null && !currentAccount.getFullName().trim().isEmpty())
                          ? currentAccount.getFullName() : currentAccount.getUsername();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ — CineMan</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="cm-card">
    <!-- App Bar -->
    <div class="cm-header">
        <span class="cm-logo">CineMan</span>
        <span class="cm-sep">|</span>
        <h2>Trang Chủ</h2>
        <div class="cm-spacer"></div>
        <span class="cm-user-name"><%= displayName %></span>
        <a id="btnLogout" name="btnLogout" class="btn cm-logout-button"
           href="${pageContext.request.contextPath}/account?action=logout">Đăng xuất</a>
    </div>

    <div class="cm-body">
        <div class="cm-center">
            <div class="cm-role-cards">
                <% if (currentAccount.isCustomer()) { %>
                    <a href="${pageContext.request.contextPath}/movie?action=showSearchForm"
                       id="linkSearchMovie" name="linkSearchMovie" class="cm-role-card">
                        <span class="title">Tìm kiếm phim</span>
                    </a>
                <% } else if (currentAccount.isManager()) { %>
                    <a href="${pageContext.request.contextPath}/screening?action=listScreenings"
                       id="linkManageScreening" name="linkManageScreening" class="cm-role-card">
                        <span class="title">Quản lý lịch chiếu</span>
                    </a>
                <% } %>
            </div>
        </div>
    </div>
</div>
</body>
</html>
