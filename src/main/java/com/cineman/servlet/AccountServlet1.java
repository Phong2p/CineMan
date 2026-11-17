package com.cineman.servlet;

import com.cineman.dao.AccountDAO1;
import com.cineman.model.Account1;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * AccountServlet1 - Điều hướng và xử lý đăng nhập / đăng ký
 * URL: /account
 */
@WebServlet(name = "AccountServlet1", urlPatterns = {"/account", "/AccountServlet1"})
public class AccountServlet1 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private AccountDAO1 accountDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        accountDAO = new AccountDAO1();
    }

    @Override
    protected void doGet(HttpServletRequest rq, HttpServletResponse rp) throws ServletException, IOException {
        rq.setCharacterEncoding("UTF-8");
        rp.setCharacterEncoding("UTF-8");
        String action = rq.getParameter("action");
        if ("showRegister".equalsIgnoreCase(action)) {
            rq.getRequestDispatcher("/RegisterUI1.jsp").forward(rq, rp);
        } else if ("logout".equalsIgnoreCase(action)) {
            rq.getSession().invalidate();
            rp.sendRedirect(rq.getContextPath() + "/LoginUI1.jsp");
        } else {
            rq.getRequestDispatcher("/LoginUI1.jsp").forward(rq, rp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest rq, HttpServletResponse rp) throws ServletException, IOException {
        rq.setCharacterEncoding("UTF-8");
        rp.setCharacterEncoding("UTF-8");
        String action = rq.getParameter("action");
        if ("login".equalsIgnoreCase(action)) {
            handleLogin(rq, rp);
        } else if ("register".equalsIgnoreCase(action)) {
            handleRegister(rq, rp);
        } else {
            rp.sendRedirect(rq.getContextPath() + "/LoginUI1.jsp");
        }
    }

    private void handleLogin(HttpServletRequest rq, HttpServletResponse rp) throws ServletException, IOException {
        String username = rq.getParameter("inUsername");
        String password = rq.getParameter("inPassword");

        if (username == null || username.trim().isEmpty() || password == null || password.isEmpty()) {
            rq.setAttribute("outMessage", "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu!");
            rq.getRequestDispatcher("/LoginUI1.jsp").forward(rq, rp);
            return;
        }

        Account1 account = accountDAO.login(username, password);
        if (account == null) {
            rq.setAttribute("outMessage", "Tên đăng nhập hoặc mật khẩu không đúng!");
            rq.setAttribute("inUsername", username);
            rq.getRequestDispatcher("/LoginUI1.jsp").forward(rq, rp);
            return;
        }

        HttpSession session = rq.getSession();
        session.setAttribute("currentAccount", account);
        // Điều hướng theo role
        rp.sendRedirect(rq.getContextPath() + "/MainUI1.jsp");
    }

    private void handleRegister(HttpServletRequest rq, HttpServletResponse rp) throws ServletException, IOException {
        String username = rq.getParameter("inUsername");
        String password = rq.getParameter("inPassword");
        String confirmPwd = rq.getParameter("inConfirmPassword");
        String fullName  = rq.getParameter("inFullName");
        String role      = rq.getParameter("inRole");

        // Validation
        if (username == null || username.trim().isEmpty()) {
            rq.setAttribute("outMessage", "Tên đăng nhập không được để trống!");
            rq.getRequestDispatcher("/RegisterUI1.jsp").forward(rq, rp); return;
        }
        if (password == null || password.length() < 6) {
            rq.setAttribute("outMessage", "Mật khẩu phải có ít nhất 6 ký tự!");
            rq.getRequestDispatcher("/RegisterUI1.jsp").forward(rq, rp); return;
        }
        if (!password.equals(confirmPwd)) {
            rq.setAttribute("outMessage", "Mật khẩu xác nhận không khớp!");
            rq.getRequestDispatcher("/RegisterUI1.jsp").forward(rq, rp); return;
        }
        if (accountDAO.isUsernameExist(username)) {
            rq.setAttribute("outMessage", "Tên đăng nhập đã tồn tại, vui lòng chọn tên khác!");
            rq.getRequestDispatcher("/RegisterUI1.jsp").forward(rq, rp); return;
        }

        // Chỉ cho phép đăng ký role Customer; Manager phải được cấp bởi admin
        String safeRole = Account1.ROLE_CUSTOMER;
        if (Account1.ROLE_MANAGER.equalsIgnoreCase(role)) {
            safeRole = Account1.ROLE_MANAGER;
        }

        Account1 newAccount = new Account1();
        newAccount.setUsername(username.trim());
        newAccount.setPassword(password);
        newAccount.setFullName(fullName != null ? fullName.trim() : "");
        newAccount.setRole(safeRole);

        boolean success = accountDAO.register(newAccount);
        if (success) {
            rq.setAttribute("outMessage", "Đăng ký thành công! Vui lòng đăng nhập.");
            rq.getRequestDispatcher("/LoginUI1.jsp").forward(rq, rp);
        } else {
            rq.setAttribute("outMessage", "Đăng ký thất bại, vui lòng thử lại!");
            rq.getRequestDispatcher("/RegisterUI1.jsp").forward(rq, rp);
        }
    }
}

