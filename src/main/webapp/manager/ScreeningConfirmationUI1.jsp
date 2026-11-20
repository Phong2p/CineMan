<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cineman.model.Screening1,com.cineman.model.Account1" %>
<%@ page import="java.time.LocalDate,java.time.format.DateTimeFormatter" %>
<%
    Account1 currentAccount = (Account1) session.getAttribute("currentAccount");
    if (currentAccount == null) { response.sendRedirect(request.getContextPath() + "/LoginUI1.jsp"); return; }
    if (!currentAccount.isManager()) { response.sendRedirect(request.getContextPath() + "/MainUI1.jsp"); return; }

    // Thuộc tính của lớp ScreeningConfirmationUI1 theo biểu đồ thiết kế
    Screening1 screening = (Screening1) session.getAttribute("pendingScreening");
    String outScreeningDate = (String) request.getAttribute("outScreeningDate");
    String outTimeSlot = (String) request.getAttribute("outTimeSlot");
    String outScreeningRoom = (String) request.getAttribute("outScreeningRoom");
    String outMovieName = (String) request.getAttribute("outMovieName");
    String outDuration = (String) request.getAttribute("outDuration");
    String outMessage = (String) request.getAttribute("outMessage");

    String today = LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
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
            if (outMessage != null && !outMessage.isEmpty()) { 
                boolean isSuccess = outMessage.toLowerCase().contains("thành công");
        %>
            <div class="alert <%= isSuccess ? "alert-success" : "alert-warning" %>" id="outMessage">
                <%= outMessage %>
            </div>
        <% } %>

        <!-- Thông tin lịch chiếu cần xác nhận -->
        <div class="confirm-box">
            <h3 style="margin-top:0; color:var(--text); border-bottom:1px solid var(--border); padding-bottom:10px;">
                Chi tiết lịch chiếu
            </h3>
            <div class="confirm-row">
                <span class="confirm-label">Phim:</span>
                <span class="confirm-value"><strong id="outMovieName"><%= outMovieName != null ? outMovieName : "" %></strong></span>
            </div>
            <div class="confirm-row">
                <span class="confirm-label">Thời lượng:</span>
                <span class="confirm-value" id="outDuration"><%= outDuration != null ? outDuration : "" %></span>
            </div>
            <div class="confirm-row">
                <span class="confirm-label">Ngày chiếu:</span>
                <span class="confirm-value" id="outScreeningDate"><%= outScreeningDate != null ? outScreeningDate : today %></span>
            </div>
            <div class="confirm-row">
                <span class="confirm-label">Khung giờ:</span>
                <span class="confirm-value" id="outTimeSlot"><%= outTimeSlot != null ? outTimeSlot : "" %></span>
            </div>
            <div class="confirm-row">
                <span class="confirm-label">Phòng chiếu:</span>
                <span class="confirm-value" id="outScreeningRoom"><%= outScreeningRoom != null ? outScreeningRoom : "" %></span>
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/screening" method="POST" style="margin-top:20px; text-align:center;">
            <input type="hidden" name="action" value="confirmScreening">
            <button type="submit" id="subConfirm" name="subConfirm" class="btn btn-primary" style="padding:10px 30px; font-size:16px;">
                Xác nhận lên lịch
            </button>
        </form>
    </div>

    <div class="cm-footer-bar">
        <a href="${pageContext.request.contextPath}/screening?action=showAddScreeningForm" id="linkBack" class="link-back">Quay lại</a>
    </div>
</div>

</body>
</html>
