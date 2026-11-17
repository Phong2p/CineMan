package com.cineman.dao;

import com.cineman.model.Account1;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Lớp AccountDAO1 - Xử lý truy vấn dữ liệu tài khoản người dùng
 * Kế thừa từ DAO1
 * Lưu ý: Không dùng hàm helper riêng để đóng gói ResultSet -> Account1
 *        (theo đúng sơ đồ lớp trong tài liệu thiết kế)
 */
public class AccountDAO1 extends DAO1 {

    public AccountDAO1() {
        super();
    }

    /**
     * Đăng nhập: kiểm tra username và password
     * @param username Tên đăng nhập
     * @param password Mật khẩu
     * @return Đối tượng Account1 nếu hợp lệ, null nếu sai
     */
    public Account1 login(String username, String password) {
        String sql = "SELECT * FROM tblAccount WHERE username = ? AND password = ?";
        Connection connection = getConnection();
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username != null ? username.trim() : "");
            ps.setString(2, password != null ? password : "");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Đóng gói inline — không dùng hàm riêng (theo sơ đồ lớp)
                    Account1 acc = new Account1();
                    acc.setId(rs.getInt("id"));
                    acc.setUsername(rs.getString("username"));
                    acc.setPassword(rs.getString("password"));
                    acc.setFullName(rs.getString("fullName"));
                    acc.setRole(rs.getString("role"));
                    return acc;
                }
            }
        } catch (SQLException e) {
            System.err.println("[AccountDAO1] Lỗi khi đăng nhập: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Kiểm tra username đã tồn tại chưa
     * @param username Tên đăng nhập cần kiểm tra
     * @return true nếu đã tồn tại
     */
    public boolean isUsernameExist(String username) {
        String sql = "SELECT COUNT(*) FROM tblAccount WHERE username = ?";
        Connection connection = getConnection();
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username != null ? username.trim() : "");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("[AccountDAO1] Lỗi khi kiểm tra username: " + e.getMessage());
        }
        return false;
    }

    /**
     * Đăng ký tài khoản mới
     * @param account Đối tượng Account1 cần đăng ký
     * @return true nếu đăng ký thành công
     */
    public boolean register(Account1 account) {
        if (account == null || account.getUsername() == null || account.getPassword() == null) {
            return false;
        }
        String sql = "INSERT INTO tblAccount (username, password, fullName, role) VALUES (?, ?, ?, ?)";
        Connection connection = getConnection();
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, account.getUsername().trim());
            ps.setString(2, account.getPassword());
            ps.setString(3, account.getFullName() != null ? account.getFullName().trim() : "");
            ps.setString(4, account.getRole() != null ? account.getRole() : Account1.ROLE_CUSTOMER);
            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) account.setId(keys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("[AccountDAO1] Lỗi khi đăng ký tài khoản: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
}

