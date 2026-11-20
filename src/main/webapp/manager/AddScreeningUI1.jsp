<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cineman.model.Account1" %>
<%
    Account1 currentAccount = (Account1) session.getAttribute("currentAccount");
    if (currentAccount == null) { response.sendRedirect(request.getContextPath() + "/LoginUI1.jsp"); return; }
    if (!currentAccount.isManager()) { response.sendRedirect(request.getContextPath() + "/MainUI1.jsp"); return; }

    // Thuộc tính của lớp AddScreeningUI1 theo biểu đồ thiết kế
    String inScreeningDate = (String) request.getAttribute("inScreeningDate");
    String inStartTime = (String) request.getAttribute("inStartTime");
    String inEndTime = (String) request.getAttribute("inEndTime");
    String outMessage = (String) request.getAttribute("outMessage");

    String displayName = (currentAccount.getFullName() != null && !currentAccount.getFullName().trim().isEmpty())
                          ? currentAccount.getFullName() : currentAccount.getUsername();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm lịch chiếu — CineMan</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="cm-card">
    <div class="cm-header">
        <span class="cm-logo">CineMan</span>
        <span class="cm-sep">|</span>
        <h2>Thêm Lịch Chiếu</h2>
        <div class="cm-spacer"></div>
        <span class="cm-user-name"><%= displayName %></span>
    </div>

    <div class="cm-body">
        <% if (outMessage != null && !outMessage.isEmpty()) { %>
            <div class="alert alert-warning" id="outMessage"><%= outMessage %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/screening" method="POST">
            <input type="hidden" name="action" value="createScreening">
            <div class="screening-form">
                <div class="form-group">
                    <label for="inScreeningDate">Ngày chiếu</label>
                    <input type="date" id="inScreeningDate" name="inScreeningDate"
                           value="<%= inScreeningDate != null ? inScreeningDate : "" %>"
                           required>
                </div>
                <div class="form-group">
                    <label for="inStartTime">Giờ bắt đầu (HH:mm)</label>
                    <input type="text" id="inStartTime" name="inStartTime"
                           value="<%= inStartTime != null ? inStartTime : "" %>"
                           placeholder="09:00" required>
                </div>
                <div class="form-group">
                    <label for="inEndTime">Giờ kết thúc (HH:mm)</label>
                    <input type="text" id="inEndTime" name="inEndTime"
                           value="<%= inEndTime != null ? inEndTime : "" %>"
                           placeholder="11:00" required>
                </div>
                <div class="form-group" style="align-self: flex-end;">
                    <button type="submit" id="btnFindRoom" name="btnFindRoom" class="btn btn-primary" style="width:100%;">
                        Tìm phòng chiếu
                    </button>
                </div>
            </div>
        </form>
    </div>

    <div class="cm-footer-bar">
        <a href="${pageContext.request.contextPath}/screening?action=listScreenings" id="linkBack" class="link-back">Quay lại</a>
    </div>
</div>
</body>
</html>
