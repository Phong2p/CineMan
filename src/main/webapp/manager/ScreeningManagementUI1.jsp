<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List,com.cineman.model.Screening1,com.cineman.model.Account1,java.text.SimpleDateFormat" %>
<%@ page import="java.time.DayOfWeek,java.time.LocalDate,java.time.format.DateTimeFormatter,java.time.temporal.TemporalAdjusters" %>
<%
    Account1 currentAccount = (Account1) session.getAttribute("currentAccount");
    if (currentAccount == null) { response.sendRedirect(request.getContextPath() + "/LoginUI1.jsp"); return; }
    if (!currentAccount.isManager()) { response.sendRedirect(request.getContextPath() + "/MainUI1.jsp"); return; }
    String displayName = (currentAccount.getFullName() != null && !currentAccount.getFullName().trim().isEmpty())
                          ? currentAccount.getFullName() : currentAccount.getUsername();

    int weekOffset = 0;
    if (request.getAttribute("weekOffset") != null) weekOffset = (Integer) request.getAttribute("weekOffset");
    String outCurrentWeek = (String) request.getAttribute("outCurrentWeek");
    if (outCurrentWeek == null) {
        LocalDate monday = LocalDate.now().with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        DateTimeFormatter weekFormat = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        outCurrentWeek = monday.format(weekFormat) + " - " + monday.plusDays(6).format(weekFormat);
    }
    List<Screening1> screenings = (List<Screening1>) request.getAttribute("listScreenings");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
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

    <div class="cm-body">
        <%-- Flash message thành công sau khi lưu lịch chiếu --%>
        <%
            String flashMsg = (String) request.getAttribute("outMessage");
            if (flashMsg != null && !flashMsg.isEmpty()) {
        %>
        <div class="alert alert-success" id="outMessage" style="margin-bottom:16px;">
            <%= flashMsg %>
        </div>
        <% } %>

        <!-- Thanh điều hướng tuần -->
        <div class="week-nav">
            <a href="${pageContext.request.contextPath}/screening?action=listScreenings&weekOffset=<%= weekOffset - 1 %>"
               id="btnPreviousWeek" name="subPreviousWeek" class="btn btn-outline btn-sm">Tuần trước</a>
            <span class="week-badge" id="outCurrentWeek"><%= outCurrentWeek %></span>
            <a href="${pageContext.request.contextPath}/screening?action=listScreenings&weekOffset=<%= weekOffset + 1 %>"
               id="btnNextWeek" name="subNextWeek" class="btn btn-outline btn-sm">Tuần sau</a>
            <a href="${pageContext.request.contextPath}/screening?action=showAddScreeningForm"
               id="btnAddScreening" name="subAddScreening" class="btn btn-primary btn-sm">Thêm lịch chiếu</a>
        </div>

        <!-- Bảng danh sách suất chiếu -->
        <div class="cm-table-wrap">
            <table class="cm-table" id="tblScreeningList">
                <thead>
                    <tr>
                        <th style="width:35%">Tên phim</th>
                        <th style="width:20%" class="td-center">Ngày chiếu</th>
                        <th style="width:25%" class="td-center">Giờ chiếu</th>
                        <th style="width:20%" class="td-center">Phòng</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (screenings != null && !screenings.isEmpty()) {
                           for (Screening1 s : screenings) {
                               String mName = s.getMovie() != null ? s.getMovie().getMovieName() : "Không rõ";
                               String sDate = s.getScreeningDate() != null ? sdf.format(s.getScreeningDate()) : "Không rõ";
                               String sTime = s.getTimeSlot();
                               String rName = s.getScreeningRoom() != null ? s.getScreeningRoom().getRoomName() : "Không rõ";
                    %>
                    <tr>
                        <td><strong><%= mName %></strong></td>
                        <td class="td-center"><%= sDate %></td>
                        <td class="td-center"><%= sTime %></td>
                        <td class="td-center"><span class="badge badge-blue"><%= rName %></span></td>
                    </tr>
                    <%     }
                       } else { %>
                    <tr>
                        <td colspan="4" class="td-center" style="padding:30px;color:var(--text-muted);">
                            Không có suất chiếu nào trong tuần này. Nhấn <strong>Thêm lịch chiếu</strong> để tạo mới.
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <div class="cm-footer-bar">
        <a href="${pageContext.request.contextPath}/MainUI1.jsp" id="linkBack" class="link-back">Trang chủ</a>
    </div>
</div>
</body>
</html>
