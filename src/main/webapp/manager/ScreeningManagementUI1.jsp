<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List,com.cineman.model.Screening1,com.cineman.model.Account1,java.text.SimpleDateFormat" %>
<%@ page import="java.time.DayOfWeek,java.time.LocalDate,java.time.format.DateTimeFormatter,java.time.temporal.TemporalAdjusters" %>
<%
    Account1 currentAccount = (Account1) session.getAttribute("currentAccount");
    if (currentAccount == null) { response.sendRedirect(request.getContextPath() + "/LoginUI1.jsp"); return; }
    if (!currentAccount.isManager()) { response.sendRedirect(request.getContextPath() + "/MainUI1.jsp"); return; }

    // Thuộc tính của lớp ScreeningManagementUI1 theo biểu đồ thiết kế
    String outCurrentWeek = (String) request.getAttribute("outCurrentWeek");
    @SuppressWarnings("unchecked")
    List<Screening1> listScreenings = (List<Screening1>) request.getAttribute("listScreenings");
    String outMessage = (String) request.getAttribute("outMessage");

    int weekOffset = 0;
    if (request.getAttribute("weekOffset") != null) weekOffset = (Integer) request.getAttribute("weekOffset");
    if (outCurrentWeek == null) {
        LocalDate monday = LocalDate.now().with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        DateTimeFormatter weekFormat = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        outCurrentWeek = monday.format(weekFormat) + " - " + monday.plusDays(6).format(weekFormat);
    }
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    String displayName = (currentAccount.getFullName() != null && !currentAccount.getFullName().trim().isEmpty())
                          ? currentAccount.getFullName() : currentAccount.getUsername();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý lịch chiếu — CineMan</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="cm-card">
    <div class="cm-header">
        <span class="cm-logo">CineMan</span>
        <span class="cm-sep">|</span>
        <h2>Quản Lý Lịch Chiếu</h2>
        <div class="cm-spacer"></div>
        <span class="cm-user-name"><%= displayName %></span>
    </div>

    <!-- Toolbar: Điều hướng tuần + Nút thêm suất chiếu -->
    <div class="cm-toolbar">
        <div class="week-nav">
            <a href="${pageContext.request.contextPath}/screening?action=listScreenings&weekOffset=<%= weekOffset - 1 %>"
               id="btnPreviousWeek" name="btnPreviousWeek" class="btn btn-secondary btn-sm">&larr; Tuần trước</a>
            <span class="week-display">Tuần: <strong id="outCurrentWeek"><%= outCurrentWeek %></strong></span>
            <a href="${pageContext.request.contextPath}/screening?action=listScreenings&weekOffset=<%= weekOffset + 1 %>"
               id="btnNextWeek" name="btnNextWeek" class="btn btn-secondary btn-sm">Tuần sau &rarr;</a>
        </div>
        <a href="${pageContext.request.contextPath}/screening?action=showAddScreeningForm"
           id="btnAddScreening" name="btnAddScreening" class="btn btn-primary">+ Thêm lịch chiếu</a>
    </div>

    <div class="cm-body">
        <% if (outMessage != null && !outMessage.isEmpty()) { 
            boolean isSuccess = outMessage.toLowerCase().contains("thành công");
        %>
            <div class="alert <%= isSuccess ? "alert-success" : "alert-warning" %>" id="outMessage"><%= outMessage %></div>
        <% } %>

        <% if (listScreenings != null && !listScreenings.isEmpty()) { %>
        <div class="cm-table-wrap">
            <table class="cm-table" id="tblScreeningList">
                <thead>
                    <tr>
                        <th style="width:6%">STT</th>
                        <th style="width:30%">Tên phim</th>
                        <th style="width:16%">Ngày chiếu</th>
                        <th style="width:20%">Khung giờ</th>
                        <th style="width:18%">Phòng chiếu</th>
                        <th style="width:10%" class="td-center">Sức chứa</th>
                    </tr>
                </thead>
                <tbody>
                    <% int i = 1;
                       for (Screening1 sc : listScreenings) { %>
                    <tr>
                        <td class="td-center"><%= i++ %></td>
                        <td><strong><%= sc.getMovie() != null ? sc.getMovie().getMovieName() : "N/A" %></strong></td>
                        <td><%= sc.getScreeningDate() != null ? sdf.format(sc.getScreeningDate()) : "" %></td>
                        <td>
                            <%= (sc.getStartTime() != null ? sc.getStartTime().toString().substring(0, 5) : "") %>
                            &nbsp;-&nbsp;
                            <%= (sc.getEndTime() != null ? sc.getEndTime().toString().substring(0, 5) : "") %>
                        </td>
                        <td><%= sc.getScreeningRoom() != null ? sc.getScreeningRoom().getRoomName() : "N/A" %></td>
                        <td class="td-center"><%= sc.getScreeningRoom() != null ? sc.getScreeningRoom().getCapacity() : "" %></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        <% } else { %>
            <div class="empty-state">
                <p>Không có lịch chiếu nào trong tuần này.</p>
            </div>
        <% } %>
    </div>

    <div class="cm-footer-bar">
        <a href="${pageContext.request.contextPath}/MainUI1.jsp" id="linkBack" class="link-back">Quay lại</a>
    </div>
</div>
</body>
</html>
