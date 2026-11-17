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
 * AccountServlet1 - Điều hướng và xử lý đăng nhập / đăng xuất
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
        if ("logout".equalsIgnoreCase(action)) {
            HttpSession session = rq.getSession(false);
            if (session != null) {
                session.invalidate();
            }
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
        rp.sendRedirect(rq.getContextPath() + "/MainUI1.jsp");
    }
}
