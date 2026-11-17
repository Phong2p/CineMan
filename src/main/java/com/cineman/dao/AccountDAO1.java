package com.cineman.dao;

import com.cineman.model.Account1;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

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
}
