package com.cineman.dao;

import com.cineman.model.ScreeningRoom1;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

/**
 * Lớp ScreeningRoomDAO1 - Xử lý truy vấn dữ liệu liên quan đến phòng chiếu
 * Kế thừa từ DAO1
 * Lưu ý: Không dùng hàm helper riêng để đóng gói ResultSet (theo sơ đồ lớp thiết kế)
 */
public class ScreeningRoomDAO1 extends DAO1 {

    public ScreeningRoomDAO1() {
        super();
    }

    /**
     * Tìm danh sách phòng chiếu còn trống trong ngày và khung giờ đã chọn
     */
    public List<ScreeningRoom1> getAvailableRooms(Date screeningDate, Time startTime, Time endTime) {
        List<ScreeningRoom1> list = new ArrayList<>();
        String sql = "SELECT * FROM tblScreeningRoom WHERE id NOT IN (" +
                     "  SELECT screeningRoomId FROM tblScreening " +
                     "  WHERE screeningDate = ? AND startTime < ? AND endTime > ?" +
                     ") ORDER BY id ASC";
        Connection connection = getConnection();
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDate(1, screeningDate);
            ps.setTime(2, endTime);
            ps.setTime(3, startTime);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    // Đóng gói inline — không dùng hàm riêng (theo sơ đồ lớp)
                    ScreeningRoom1 room = new ScreeningRoom1();
                    room.setId(rs.getInt("id"));
                    room.setRoomName(rs.getString("roomName"));
                    room.setCapacity(rs.getInt("capacity"));
                    room.setDescription(rs.getString("description"));
                    list.add(room);
                }
            }
        } catch (SQLException e) {
            System.err.println("[ScreeningRoomDAO1] Lỗi khi lấy danh sách phòng rảnh: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Kiểm tra phòng chiếu có còn trống trong khoảng thời gian không
     */
    public boolean checkRoomAvailability(int roomId, Date screeningDate, Time startTime, Time endTime) {
        String sql = "SELECT COUNT(*) FROM tblScreening " +
                     "WHERE screeningRoomId = ? AND screeningDate = ? AND startTime < ? AND endTime > ?";
        Connection connection = getConnection();
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setDate(2, screeningDate);
            ps.setTime(3, endTime);
            ps.setTime(4, startTime);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) == 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("[ScreeningRoomDAO1] Lỗi khi kiểm tra tình trạng phòng: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy thông tin chi tiết phòng chiếu theo ID
     */
    public ScreeningRoom1 getRoomById(int roomId) {
        String sql = "SELECT * FROM tblScreeningRoom WHERE id = ?";
        Connection connection = getConnection();
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Đóng gói inline — không dùng hàm riêng (theo sơ đồ lớp)
                    ScreeningRoom1 room = new ScreeningRoom1();
                    room.setId(rs.getInt("id"));
                    room.setRoomName(rs.getString("roomName"));
                    room.setCapacity(rs.getInt("capacity"));
                    room.setDescription(rs.getString("description"));
                    return room;
                }
            }
        } catch (SQLException e) {
            System.err.println("[ScreeningRoomDAO1] Lỗi khi lấy phòng theo id: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
}
