<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cineman.model.Account1" %>
<%@ page import="java.time.LocalDate,java.time.format.DateTimeFormatter" %>
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
    <title>Xác nhận lịch chiếu — CineMan</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="cm-card">
    <div class="cm-header">
        <span class="cm-logo">CineMan</span>
        <span class="cm-sep">|</span>
        <h2>Xác Nhận Lịch Chiếu</h2>
        <div class="cm-spacer"></div>
        <span class="cm-user-name"><%= displayName %></span>
    </div>

    <div class="cm-body">
        <% 
            String outMessage = (String) request.getAttribute("outMessage");
            if (outMessage != null && !outMessage.isEmpty()) { 
                boolean isSuccess = outMessage.toLowerCase().contains("thành công");
        %>
            <div class="alert <%= isSuccess ? "alert-success" : "alert-warning" %>" id="outMessage">
                <%= outMessage %>
            </div>
        <% } %>

        <% 
            String outScreeningDate = (String) request.getAttribute("outScreeningDate");
            String outTimeSlot = (String) request.getAttribute("outTimeSlot");
            String outScreeningRoom = (String) request.getAttribute("outScreeningRoom");
            String outMovieName = (String) request.getAttribute("outMovieName");
            String outDuration = (String) request.getAttribute("outDuration");
            String today = LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        %>

        <!-- Thông tin lịch chiếu cần xác nhận -->
        <div class="confirm-card">
            <div class="confirm-row">
                <span class="c-label">Ngày chiếu:</span>
                <strong id="outScreeningDate"><%= outScreeningDate != null ? outScreeningDate : today %></strong>
            </div>
            <div class="confirm-row">
                <span class="c-label">Khung giờ:</span>
                <strong id="outTimeSlot"><%= outTimeSlot != null ? outTimeSlot : "09:00-11:00" %></strong>
            </div>
            <div class="confirm-row">
                <span class="c-label">Phòng:</span>
                <strong id="outScreeningRoom"><%= outScreeningRoom != null ? outScreeningRoom : "Phòng 1" %></strong>
            </div>
            <div class="confirm-row">
                <span class="c-label">Phim:</span>
                <strong id="outMovieName"><%= outMovieName != null ? outMovieName : "Bleach" %></strong>
            </div>
            <% if (outDuration != null && !outDuration.isEmpty()) { %>
            <div class="confirm-row">
                <span class="c-label">Thời lượng:</span>
                <strong id="outDuration"><%= outDuration %></strong>
            </div>
            <% } %>

            <div class="confirm-btn-wrapper">
                <form action="${pageContext.request.contextPath}/screening" method="POST" style="margin: 0;">
                    <input type="hidden" name="action" value="confirmScreening">
                    <button type="submit" 
                            id="btnConfirm" 
                            name="subConfirm" 
                            class="btn btn-primary"
                            style="padding: 8px 26px;">
                        Xác nhận
                    </button>
                </form>
            </div>
        </div>
    </div>

    <div class="cm-footer-bar">
        <a href="javascript:history.back()" id="linkBack" class="link-back">Quay lại</a>
    </div>
</div>

</body>
</html>
