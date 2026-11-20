<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.cineman.model.Screening1,com.cineman.model.Movie1,com.cineman.model.Account1" %>
<%@ page import="java.time.LocalDate,java.time.format.DateTimeFormatter" %>
<%
    Account1 currentAccount = (Account1) session.getAttribute("currentAccount");
    if (currentAccount == null) { response.sendRedirect(request.getContextPath() + "/LoginUI1.jsp"); return; }
    if (!currentAccount.isManager()) { response.sendRedirect(request.getContextPath() + "/MainUI1.jsp"); return; }

    // Thuộc tính của lớp MovieSelectionUI1 theo biểu đồ thiết kế
    Screening1 screening = (Screening1) session.getAttribute("pendingScreening");
    String outScreeningDate = (String) request.getAttribute("outScreeningDate");
    String outTimeSlot = (String) request.getAttribute("outTimeSlot");
    String outSelectedRoom = (String) request.getAttribute("outSelectedRoom");
    @SuppressWarnings("unchecked")
    List<Movie1> listMovie = (List<Movie1>) request.getAttribute("listMovie");
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
        <div class="screening-summary">
            <div class="summary-item">Ngày chiếu: <strong id="outScreeningDate"><%= outScreeningDate != null ? outScreeningDate : today %></strong></div>
            <div class="summary-item">Khung giờ: <strong id="outTimeSlot"><%= outTimeSlot != null ? outTimeSlot : "09:00 - 11:00" %></strong></div>
            <div class="summary-item">Phòng: <strong id="outSelectedRoom"><%= outSelectedRoom != null ? outSelectedRoom : "Phòng 1" %></strong></div>
        </div>

        <% if (outMessage != null && !outMessage.isEmpty()) { %>
            <div class="alert alert-warning" id="outMessage"><%= outMessage %></div>
        <% } %>

        <% if (listMovie != null && !listMovie.isEmpty()) { %>
            <div class="cm-table-wrap">
                <table class="cm-table" id="tblMovieList">
                    <thead>
                        <tr>
                            <th style="width:8%">STT</th>
                            <th style="width:36%">Tên phim</th>
                            <th style="width:16%">Thời lượng</th>
                            <th style="width:20%">Thể loại</th>
                            <th style="width:20%" class="td-center">Chọn phim</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            int i = 1;
                            for (Movie1 movie : listMovie) { 
                        %>
                        <tr>
                            <td class="td-center"><%= i++ %></td>
                            <td><strong><%= movie.getMovieName() %></strong></td>
                            <td><%= movie.getDuration() %> phút</td>
                            <td><%= movie.getGenre() != null ? movie.getGenre() : "" %></td>
                            <td class="td-center">
                                <form action="${pageContext.request.contextPath}/screening" method="POST" style="margin:0;">
                                    <input type="hidden" name="action" value="selectMovie">
                                    <input type="hidden" name="movieId" value="<%= movie.getId() %>">
                                    <button type="submit" id="btnSelectMovie_<%= movie.getId() %>" name="btnSelectMovie"
                                            class="btn btn-primary btn-sm">Chọn phim</button>
                                </form>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } else if (outMessage == null || outMessage.isEmpty()) { %>
            <div class="alert alert-warning" id="outMessage">Không có phim nào đang sẵn sàng chiếu!</div>
        <% } %>
    </div>

    <div class="cm-footer-bar">
        <a href="${pageContext.request.contextPath}/screening?action=showAddScreeningForm" id="linkBack" class="link-back">Quay lại</a>
    </div>
</div>

</body>
</html>
