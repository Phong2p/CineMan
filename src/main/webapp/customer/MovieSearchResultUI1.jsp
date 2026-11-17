<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List,com.cineman.model.Movie1,com.cineman.model.Account1" %>
<%
    Account1 currentAccount = (Account1) session.getAttribute("currentAccount");
    if (currentAccount == null) { response.sendRedirect(request.getContextPath() + "/LoginUI1.jsp"); return; }
    String displayName = (currentAccount.getFullName() != null && !currentAccount.getFullName().trim().isEmpty())
                          ? currentAccount.getFullName() : currentAccount.getUsername();
    List<Movie1> listMovie = (List<Movie1>) request.getAttribute("listMovie");
    String keyword = (String) request.getAttribute("searchKeyword");
    if (keyword == null) keyword = "";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả tìm kiếm — CineMan</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="cm-card">
    <div class="cm-header">
        <span class="cm-logo">CineMan</span>
        <span class="cm-sep">|</span>
        <h2>Kết quả tìm kiếm</h2>
        <div class="cm-spacer"></div>
        <span class="cm-user-name"><%= displayName %></span>
    </div>

    <div class="cm-subbar">
        <span>Kết quả cho từ khóa: <strong>"<%= keyword %>"</strong></span>
        <% if (listMovie != null) { %>
            <span class="badge badge-blue"><%= listMovie.size() %> phim</span>
        <% } %>
    </div>

    <div class="cm-body">
        <% String msg = (String) request.getAttribute("outMessage");
           if (msg != null && !msg.isEmpty()) { %>
            <div class="alert alert-warning" id="outMessage"><%= msg %></div>
        <% } %>

        <% if (listMovie != null && !listMovie.isEmpty()) { %>
        <div class="cm-table-wrap">
            <table class="cm-table" id="outMovieList">
                <thead>
                    <tr>
                        <th style="width:8%">STT</th>
                        <th style="width:50%">Tên phim</th>
                        <th style="width:22%">Thể loại</th>
                        <th style="width:20%" class="td-center">Chi tiết</th>
                    </tr>
                </thead>
                <tbody>
                    <% int i = 1;
                       for (Movie1 m : listMovie) { %>
                    <tr>
                        <td class="td-center"><%= i++ %></td>
                        <td><strong><%= m.getMovieName() %></strong></td>
                        <td><%= m.getGenre() != null ? m.getGenre() : "" %></td>
                        <td class="td-center">
                            <a href="${pageContext.request.contextPath}/movie?action=showMovieDetail&movieId=<%= m.getId() %>"
                               id="linkSelectMovie_<%= m.getId() %>"
                               name="linkSelectMovie"
                               class="btn btn-outline btn-sm">Xem chi tiết</a>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>

    <div class="cm-footer-bar">
        <a href="${pageContext.request.contextPath}/movie?action=showSearchForm" id="linkBack" class="link-back">Tìm lại</a>
    </div>
</div>
</body>
</html>
