<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập — CineMan</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="page-centered">
<div class="cm-card-sm">
    <div class="cm-header">
        <span class="cm-logo">CineMan</span>
        <span class="cm-sep">|</span>
        <h2>Đăng nhập</h2>
    </div>

    <div class="cm-body">
        <div class="cm-center">
            <div class="cm-form">
                <% String msg = (String) request.getAttribute("outMessage");
                   if (msg != null && !msg.isEmpty()) { %>
                    <div class="alert alert-error"><%= msg %></div>
                <% } %>

                <form action="${pageContext.request.contextPath}/account" method="POST">
                    <input type="hidden" name="action" value="login">
                    <div style="display:flex;flex-direction:column;gap:14px;">
                        <div class="form-group">
                            <label for="inUsername">Tên đăng nhập</label>
                            <input type="text" id="inUsername" name="inUsername"
                                   placeholder="Nhập tên đăng nhập"
                                   value="<%= request.getAttribute("inUsername") != null ? request.getAttribute("inUsername") : "" %>"
                                   required autofocus>
                        </div>
                        <div class="form-group">
                            <label for="inPassword">Mật khẩu</label>
                            <input type="password" id="inPassword" name="inPassword"
                                   placeholder="Nhập mật khẩu" required>
                        </div>
                        <button type="submit" id="btnLogin" name="subLogin" class="btn btn-primary btn-lg" style="margin-top:4px;">
                            Đăng nhập
                        </button>
                    </div>
                </form>

                <hr class="divider">
                
            </div>
        </div>
    </div>
</div>
</body>
</html>
