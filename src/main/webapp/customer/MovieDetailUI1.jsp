<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cineman.model.Movie1,com.cineman.model.Account1,java.text.SimpleDateFormat,java.text.NumberFormat,java.util.Locale" %>
<%
    Account1 currentAccount = (Account1) session.getAttribute("currentAccount");
    if (currentAccount == null) { response.sendRedirect(request.getContextPath() + "/LoginUI1.jsp"); return; }
    String displayName = (currentAccount.getFullName() != null && !currentAccount.getFullName().trim().isEmpty())
                          ? currentAccount.getFullName() : currentAccount.getUsername();
    Movie1 movie = (Movie1) request.getAttribute("movie");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết phim — CineMan</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="cm-card">
    <div class="cm-header">
        <span class="cm-logo">CineMan</span>
        <span class="cm-sep">|</span>
        <h2>Chi tiết phim</h2>
        <div class="cm-spacer"></div>
        <span class="cm-user-name"><%= displayName %></span>
    </div>

    <div class="cm-body">
        <% if (movie != null) {
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            NumberFormat nf = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
            String releaseDateStr = movie.getReleaseDate() != null ? sdf.format(movie.getReleaseDate()) : "Đang cập nhật";
            String priceStr = nf.format((long) movie.getBaseTicketPrice()) + " đ";
        %>
        <div class="detail-layout">
            <!-- Ảnh bìa -->
            <div>
                <div class="poster-box" id="outPoster">
                    <% if (movie.getPoster() != null && !movie.getPoster().isEmpty()) { %>
                        <img src="${pageContext.request.contextPath}/<%= movie.getPoster() %>"
                             alt="<%= movie.getMovieName() %>">
                    <% } else { %>
                        <div class="poster-label">Chưa có ảnh bìa</div>
                    <% } %>
                </div>
                <div style="text-align:center;margin-top:10px;">
                    <span class="badge <%= "Đang chiếu".equals(movie.getStatus()) || "Dang chieu".equals(movie.getStatus()) ? "badge-green" : "badge-orange" %>">
                        <%= movie.getStatus() %>
                    </span>
                </div>
            </div>

            <!-- Thông tin phim -->
            <div class="info-list">
                <div class="info-row">
                    <span class="info-label">Tên phim:</span>
                    <span class="info-value" id="outMovieName"><strong><%= movie.getMovieName() %></strong></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Thể loại:</span>
                    <span class="info-value" id="outGenre"><%= movie.getGenre() %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Đạo diễn:</span>
                    <span class="info-value" id="outDirector"><%= movie.getDirector() %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Diễn viên:</span>
                    <span class="info-value" id="outActors"><%= movie.getActors() %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Thời lượng:</span>
                    <span class="info-value" id="outDuration"><%= movie.getDuration() %> phút</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Nội dung:</span>
                    <span class="info-value" id="outDescription"><%= movie.getDescription() %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Khởi chiếu:</span>
                    <span class="info-value" id="outReleaseDate"><%= releaseDateStr %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Ngôn ngữ:</span>
                    <span class="info-value" id="outLanguage"><%= movie.getLanguage() %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Giá vé:</span>
                    <span class="info-value" style="color:var(--blue);font-weight:700;"><%= priceStr %></span>
                </div>
            </div>
        </div>
        <% } else { %>
            <div class="alert alert-warning">Không tìm thấy thông tin chi tiết phim!</div>
        <% } %>
    </div>

    <div class="cm-footer-bar">
        <a href="javascript:history.back()" id="linkBack" class="link-back">Quay lại</a>
    </div>
</div>
</body>
</html>
