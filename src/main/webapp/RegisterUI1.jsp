<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký — CineMan</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="page-centered">
<div class="cm-card-sm">
    <div class="cm-header">
        <span class="cm-logo">CineMan</span>
        <span class="cm-sep">|</span>
        <h2>Đăng ký tài khoản</h2>
    </div>

    <div class="cm-body">
        <div class="cm-center">
            <div class="cm-form">
                <% String msg = (String) request.getAttribute("outMessage");
                   if (msg != null && !msg.isEmpty()) { %>
                    <div class="alert alert-error"><%= msg %></div>
                <% } %>

                <form action="${pageContext.request.contextPath}/account" method="POST">
                    <input type="hidden" name="action" value="register">
                    <div style="display:flex;flex-direction:column;gap:14px;">
                        <div class="form-group">
                            <label for="inFullName">Họ và tên</label>
                            <input type="text" id="inFullName" name="inFullName"
                                   placeholder="Nguyễn Văn A" required>
                        </div>
                        <div class="form-group">
                            <label for="inUsername">Tên đăng nhập</label>
                            <input type="text" id="inUsername" name="inUsername"
                                   placeholder="Chọn tên đăng nhập" required autofocus>
                        </div>
                        <div class="form-group">
                            <label for="inPassword">Mật khẩu (ít nhất 6 ký tự)</label>
                            <input type="password" id="inPassword" name="inPassword"
                                   placeholder="Nhập mật khẩu" required>
                        </div>
                        <div class="form-group">
                            <label for="inConfirmPassword">Xác nhận mật khẩu</label>
                            <input type="password" id="inConfirmPassword" name="inConfirmPassword"
                                   placeholder="Nhập lại mật khẩu" required>
                        </div>
                        <div class="form-group">
                            <label for="inRole">Vai trò</label>
                            <select id="inRole" name="inRole">
                                <option value="Customer">Khách hàng</option>
                                <option value="Manager">Quản lý</option>
                            </select>
                        </div>
                        <button type="submit" id="btnRegister" name="subRegister" class="btn btn-primary btn-lg" style="margin-top:4px;">
                            Đăng ký
                        </button>
                    </div>
                </form>

                <hr class="divider">
                <div style="text-align:center;font-size:14px;color:var(--text-muted);">
                    Đã có tài khoản?
                    <a href="${pageContext.request.contextPath}/LoginUI1.jsp" id="linkLogin" class="link-back" style="font-size:14px;">Đăng nhập</a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
