package com.cineman.dao;

import com.cineman.model.ScreeningRoom1;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.sql.Date;
import java.sql.Time;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Kiểm thử lớp ScreeningRoomDAO1")
public class ScreeningRoomDAOTest {

    private ScreeningRoomDAO1 roomDAO;

    @BeforeEach
    public void setUp() {
        roomDAO = new ScreeningRoomDAO1();
    }

    @Test
    @DisplayName("Tìm phòng rảnh ngày 23/09/2026 khung giờ 09:00 - 11:00 (Khớp hình ảnh ScreeningRoomSelection)")
    public void testGetAvailableRooms() {
        Date date = Date.valueOf("2026-09-23");
        Time start = Time.valueOf("09:00:00");
        Time end = Time.valueOf("11:00:00");

        List<ScreeningRoom1> availableRooms = roomDAO.getAvailableRooms(date, start, end);
        assertNotNull(availableRooms);

        // Theo seed data, ngày 23/09/2026 từ 09:00 đến 11:00: Phòng 2 và Phòng 4 bận.
        // Phòng 1, Phòng 3, Phòng 5 phải rảnh (như trong hình ScreeningRoomSelection)
        boolean hasRoom1 = false;
        boolean hasRoom3 = false;
        boolean hasRoom5 = false;
        boolean hasRoom2 = false;

        for (ScreeningRoom1 r : availableRooms) {
            if ("Phòng 1".equals(r.getRoomName())) hasRoom1 = true;
            if ("Phòng 3".equals(r.getRoomName())) hasRoom3 = true;
            if ("Phòng 5".equals(r.getRoomName())) hasRoom5 = true;
            if ("Phòng 2".equals(r.getRoomName())) hasRoom2 = true;
        }

        assertTrue(hasRoom1, "Phòng 1 phải có trong danh sách phòng rảnh");
        assertTrue(hasRoom3, "Phòng 3 phải có trong danh sách phòng rảnh");
        assertTrue(hasRoom5, "Phòng 5 phải có trong danh sách phòng rảnh");
        assertFalse(hasRoom2, "Phòng 2 đang có lịch chiếu nên không được xuất hiện");
    }

    @Test
    @DisplayName("Kiểm tra tính khả dụng của phòng cụ thể")
    public void testCheckRoomAvailability() {
        Date date = Date.valueOf("2026-09-23");
        Time start = Time.valueOf("09:00:00");
        Time end = Time.valueOf("11:00:00");

        // Phòng 1 rảnh -> true
        assertTrue(roomDAO.checkRoomAvailability(1, date, start, end), "Phòng 1 phải khả dụng");

        // Phòng 2 bận -> false
        assertFalse(roomDAO.checkRoomAvailability(2, date, start, end), "Phòng 2 phải không khả dụng (bận)");
    }

    @Test
    @DisplayName("Dữ liệu mẫu có thêm năm phòng chiếu sức chứa vừa")
    public void testAdditionalScreeningRooms() {
        for (int roomId = 6; roomId <= 10; roomId++) {
            ScreeningRoom1 room = roomDAO.getRoomById(roomId);
            assertNotNull(room, "Phòng " + roomId + " phải tồn tại");
            assertTrue(room.getCapacity() >= 90 && room.getCapacity() <= 135,
                    "Sức chứa phòng cần nằm trong khoảng 90–135 ghế");
        }
    }
}

