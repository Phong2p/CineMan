<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.cineman.model.Movie1,com.cineman.model.Account1" %>
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
    <title>Chọn phim — CineMan</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="cm-card">
    <div class="cm-header">
        <span class="cm-logo">CineMan</span>
        <span class="cm-sep">|</span>
        <h2>Chọn Phim</h2>
        <div class="cm-spacer"></div>
        <span class="cm-user-name"><%= displayName %></span>
    </div>

    <div class="cm-body">
        <% 
            String outScreeningDate = (String) request.getAttribute("outScreeningDate");
            String outTimeSlot = (String) request.getAttribute("outTimeSlot");
            String outSelectedRoom = (String) request.getAttribute("outSelectedRoom");
            String today = LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        %>

        <div class="screening-summary">
            <div class="summary-item">Ngày chiếu: <strong id="outScreeningDate"><%= outScreeningDate != null ? outScreeningDate : today %></strong></div>
            <div class="summary-item">Khung giờ: <strong id="outTimeSlot"><%= outTimeSlot != null ? outTimeSlot : "09:00 - 11:00" %></strong></div>
            <div class="summary-item">Phòng: <strong id="outSelectedRoom"><%= outSelectedRoom != null ? outSelectedRoom : "Phòng 1" %></strong></div>
        </div>

        <% 
            @SuppressWarnings("unchecked")
            List<Movie1> listMovie = (List<Movie1>) request.getAttribute("listMovie");
            if (listMovie != null && !listMovie.isEmpty()) {
        %>
            <div class="cm-table-wrap">
            <table class="cm-table" id="tblMovieList">
                <thead>
                    <tr>
                        <th style="width: 15%;" class="td-center">STT</th>
                        <th style="width: 55%;">Tên phim</th>
                        <th style="width: 30%;" class="td-center">Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        int index = 1;
                        for (Movie1 movie : listMovie) { 
                    %>
                    <tr>
                        <td class="td-center"><%= index++ %></td>
                        <td>
                            <%= movie.getMovieName() %>
                            <span style="font-size: 13px; color: #6c757d; font-weight: normal;">
                                (<%= movie.getDuration() %> phút)
                            </span>
                        </td>
                        <td class="td-center">
                            <form action="${pageContext.request.contextPath}/screening" method="POST" style="display: inline;">
                                <input type="hidden" name="action" value="selectMovie">
                                <input type="hidden" name="movieId" value="<%= movie.getId() %>">
                                <button type="submit" 
                                        id="btnSelectMovie_<%= movie.getId() %>" 
                                        name="subSelectMovie" 
                                        class="btn btn-primary btn-sm">
                                    Chọn
                                </button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            </div>
        <% } else { %>
            <div class="alert alert-warning">
                Hiện tại không có phim nào đang chiếu để lựa chọn!
            </div>
        <% } %>
    </div>

    <div class="cm-footer-bar">
        <a href="javascript:history.back()" id="linkBack" class="link-back">Quay lại</a>
    </div>
</div>

</body>
</html>
