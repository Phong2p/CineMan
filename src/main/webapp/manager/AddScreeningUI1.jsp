<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cineman.model.Account1" %>
<%
    Account1 currentAccount = (Account1) session.getAttribute("currentAccount");
    if (currentAccount == null) { response.sendRedirect(request.getContextPath() + "/LoginUI1.jsp"); return; }
    if (!currentAccount.isManager()) { response.sendRedirect(request.getContextPath() + "/MainUI1.jsp"); return; }
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
        <% String msg = (String) request.getAttribute("outMessage");
           if (msg != null && !msg.isEmpty()) { %>
            <div class="alert alert-warning" id="outMessage"><%= msg %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/screening" method="POST">
            <input type="hidden" name="action" value="createScreening">
            <div class="screening-form">
                <div class="form-group">
                    <label for="inScreeningDate">Ngày chiếu</label>
                    <input type="date" id="inScreeningDate" name="inScreeningDate"
                           required>
                </div>
                <div class="form-group">
                    <label for="inStartTime">Giờ bắt đầu (HH:mm)</label>
                    <input type="text" id="inStartTime" name="inStartTime"
                           placeholder="09:00" required>
                </div>
                <div class="form-group">
                    <label for="inEndTime">Giờ kết thúc (HH:mm)</label>
                    <input type="text" id="inEndTime" name="inEndTime"
                           placeholder="11:00" required>
                </div>
                <div class="form-actions">
                    <button type="submit" id="btnFindRoom" name="subFindRoom"
                            class="btn btn-primary" style="padding:10px 32px;">
                        Tìm phòng trống
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
