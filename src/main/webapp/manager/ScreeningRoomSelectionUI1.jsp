<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List,com.cineman.model.Screening1,com.cineman.model.ScreeningRoom1,com.cineman.model.Account1" %>
<%
    Account1 currentAccount = (Account1) session.getAttribute("currentAccount");
    if (currentAccount == null) { response.sendRedirect(request.getContextPath() + "/LoginUI1.jsp"); return; }
    if (!currentAccount.isManager()) { response.sendRedirect(request.getContextPath() + "/MainUI1.jsp"); return; }

    // Thuộc tính của lớp ScreeningRoomSelectionUI1 theo biểu đồ thiết kế
    Screening1 screening = (Screening1) session.getAttribute("pendingScreening");
    String outScreeningDate = (String) request.getAttribute("outScreeningDate");
    String outTimeSlot = (String) request.getAttribute("outTimeSlot");
    @SuppressWarnings("unchecked")
    List<ScreeningRoom1> listAvailableRooms = (List<ScreeningRoom1>) request.getAttribute("listAvailableRooms");
    String outMessage = (String) request.getAttribute("outMessage");

    String displayName = (currentAccount.getFullName() != null && !currentAccount.getFullName().trim().isEmpty())
                          ? currentAccount.getFullName() : currentAccount.getUsername();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chọn phòng chiếu — CineMan</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="cm-card">
    <div class="cm-header">
        <span class="cm-logo">CineMan</span>
        <span class="cm-sep">|</span>
        <h2>Chọn Phòng Chiếu</h2>
        <div class="cm-spacer"></div>
        <span class="cm-user-name"><%= displayName %></span>
    </div>

    <!-- Thông tin ngày/giờ đã chọn -->
    <div class="cm-subbar">
        <span>Ngày chiếu: <strong id="outScreeningDate"><%= outScreeningDate %></strong></span>
        &nbsp;|&nbsp;
        <span>Khung giờ: <strong id="outTimeSlot"><%= outTimeSlot %></strong></span>
    </div>

    <div class="cm-body">
        <% if (outMessage != null && !outMessage.isEmpty()) { %>
            <div class="alert alert-warning" id="outMessage"><%= outMessage %></div>
        <% } %>

        <% if (listAvailableRooms != null && !listAvailableRooms.isEmpty()) { %>
        <div class="cm-table-wrap">
            <table class="cm-table" id="tblAvailableRoomList">
                <thead>
                    <tr>
                        <th style="width:35%">Phòng chiếu</th>
                        <th style="width:20%" class="td-center">Sức chứa</th>
                        <th style="width:30%">Mô tả</th>
                        <th style="width:15%" class="td-center">Chọn</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (ScreeningRoom1 room : listAvailableRooms) { %>
                    <tr>
                        <td><strong><%= room.getRoomName() %></strong></td>
                        <td class="td-center"><%= room.getCapacity() %> chỗ</td>
                        <td><%= room.getDescription() != null ? room.getDescription() : "" %></td>
                        <td class="td-center">
                            <form action="${pageContext.request.contextPath}/screening" method="POST" style="margin:0;">
                                <input type="hidden" name="action" value="selectRoom">
                                <input type="hidden" name="roomId" value="<%= room.getId() %>">
                                <button type="submit" id="btnSelectRoom_<%= room.getId() %>" name="btnSelectRoom"
                                        class="btn btn-primary btn-sm">Chọn phòng</button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        <% } else if (outMessage == null || outMessage.isEmpty()) { %>
            <div class="alert alert-warning" id="outMessage">Không có phòng chiếu nào còn trống trong khung giờ này!</div>
        <% } %>
    </div>

    <div class="cm-footer-bar">
        <a href="${pageContext.request.contextPath}/screening?action=showAddScreeningForm" id="linkBack" class="link-back">Quay lại</a>
    </div>
</div>
</body>
</html>
