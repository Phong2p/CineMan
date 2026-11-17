package com.cineman.dao;

import com.cineman.model.Movie1;
import com.cineman.model.Screening1;
import com.cineman.model.ScreeningRoom1;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.sql.Date;
import java.sql.Time;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Kiểm thử lớp ScreeningDAO1")
public class ScreeningDAOTest {

    private ScreeningDAO1 screeningDAO;
    private MovieDAO1 movieDAO;
    private ScreeningRoomDAO1 roomDAO;

    @BeforeEach
    public void setUp() {
        screeningDAO = new ScreeningDAO1();
        movieDAO = new MovieDAO1();
        roomDAO = new ScreeningRoomDAO1();
    }

    @Test
    @DisplayName("Lấy danh sách các suất chiếu trong tuần hiện tại")
    public void testGetScreeningsByWeek() {
        List<Screening1> screenings = screeningDAO.getScreeningsByWeek();
        assertNotNull(screenings);
        LocalDate monday = LocalDate.now().with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        LocalDate sunday = monday.plusDays(6);

        for (Screening1 s : screenings) {
            LocalDate screeningDate = s.getScreeningDate().toLocalDate();
            assertFalse(screeningDate.isBefore(monday));
            assertFalse(screeningDate.isAfter(sunday));
            assertNotNull(s.getMovie(), "Mỗi suất chiếu phải liên kết với một phim");
            assertNotNull(s.getScreeningRoom(), "Mỗi suất chiếu phải liên kết với một phòng chiếu");
        }
    }

    @Test
    @DisplayName("Sắp xếp suất chiếu theo ngày, giờ bắt đầu và mã phòng")
    public void testScreeningsAreOrderedByDateTimeAndRoom() {
        String[] dates = {"2099-12-02", "2099-12-01", "2099-12-01", "2099-12-01"};
        String[] startTimes = {"09:00:00", "10:00:00", "10:00:00", "11:00:00"};
        int[] roomIds = {2, 5, 3, 1};
        Movie1 movie = movieDAO.getMovieDetail(3);

        for (int i = 0; i < roomIds.length; i++) {
            Screening1 screening = new Screening1();
            screening.setScreeningDate(Date.valueOf(dates[i]));
            screening.setStartTime(Time.valueOf(startTimes[i]));
            screening.setEndTime(Time.valueOf("12:00:00"));
            screening.setMovie(movie);
            screening.setScreeningRoom(roomDAO.getRoomById(roomIds[i]));
            assertTrue(screeningDAO.saveScreening(screening));
        }

        List<Screening1> screenings = screeningDAO.getScreeningsByWeek(
                Date.valueOf("2099-12-01"), Date.valueOf("2099-12-02"));
        assertEquals(4, screenings.size());
        assertEquals(3, screenings.get(0).getScreeningRoom().getId());
        assertEquals(5, screenings.get(1).getScreeningRoom().getId());
        assertEquals(1, screenings.get(2).getScreeningRoom().getId());
        assertEquals(2, screenings.get(3).getScreeningRoom().getId());
    }

    @Test
    @DisplayName("Lưu suất chiếu mới thành công")
    public void testSaveScreening() {
        Movie1 movie = movieDAO.getMovieDetail(3); // Bleach
        ScreeningRoom1 room = roomDAO.getRoomById(1); // Phòng 1

        Screening1 newScreening = new Screening1();
        newScreening.setScreeningDate(Date.valueOf("2026-09-23"));
        newScreening.setStartTime(Time.valueOf("09:00:00"));
        newScreening.setEndTime(Time.valueOf("11:00:00"));
        newScreening.setMovie(movie);
        newScreening.setScreeningRoom(room);

        boolean saved = screeningDAO.saveScreening(newScreening);
        assertTrue(saved, "Lưu suất chiếu mới phải thành công");
        assertTrue(newScreening.getId() > 0, "ID của suất chiếu mới phải được sinh tự động (> 0)");
    }
}

