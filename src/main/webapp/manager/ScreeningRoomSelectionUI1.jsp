<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List,com.cineman.model.ScreeningRoom1,com.cineman.model.Account1" %>
<%
    Account1 currentAccount = (Account1) session.getAttribute("currentAccount");
    if (currentAccount == null) { response.sendRedirect(request.getContextPath() + "/LoginUI1.jsp"); return; }
    if (!currentAccount.isManager()) { response.sendRedirect(request.getContextPath() + "/MainUI1.jsp"); return; }
    String displayName = (currentAccount.getFullName() != null && !currentAccount.getFullName().trim().isEmpty())
                          ? currentAccount.getFullName() : currentAccount.getUsername();
    List<ScreeningRoom1> listRooms = (List<ScreeningRoom1>) request.getAttribute("listAvailableRooms");
    String outDate = (String) request.getAttribute("outScreeningDate");
    String outSlot = (String) request.getAttribute("outTimeSlot");
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
        <span>Ngày chiếu: <strong id="outScreeningDate"><%= outDate %></strong></span>
        &nbsp;|&nbsp;
        <span>Khung giờ: <strong id="outTimeSlot"><%= outSlot %></strong></span>
    </div>

    <div class="cm-body">
        <% String msg = (String) request.getAttribute("outMessage");
           if (msg != null && !msg.isEmpty()) { %>
            <div class="alert alert-warning" id="outMessage"><%= msg %></div>
        <% } %>

        <% if (listRooms != null && !listRooms.isEmpty()) { %>
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
                    <% for (ScreeningRoom1 room : listRooms) { %>
                    <tr>
                        <td><strong><%= room.getRoomName() %></strong></td>
                        <td class="td-center"><span class="badge badge-blue"><%= room.getCapacity() %> chỗ</span></td>
                        <td style="font-size:13px;color:var(--text-muted);"><%= room.getDescription() != null ? room.getDescription() : "" %></td>
                        <td class="td-center">
                            <form action="${pageContext.request.contextPath}/screening" method="POST" style="margin:0;">
                                <input type="hidden" name="action" value="selectRoom">
                                <input type="hidden" name="roomId" value="<%= room.getId() %>">
                                <button type="submit" id="btnSelectRoom_<%= room.getId() %>" name="subSelectRoom"
                                        class="btn btn-primary btn-sm">Chọn</button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        <% } else if (msg == null) { %>
            <div class="alert alert-warning">Không có phòng trống trong khung giờ này!</div>
        <% } %>
    </div>

    <div class="cm-footer-bar">
        <a href="${pageContext.request.contextPath}/screening?action=showAddScreeningForm" id="linkBack" class="link-back">Quay lại</a>
    </div>
</div>
</body>
</html>
