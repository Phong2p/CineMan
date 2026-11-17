package com.cineman.dao;

import com.cineman.model.Movie1;
import com.cineman.model.Screening1;
import com.cineman.model.ScreeningRoom1;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.List;

/**
 * Lớp ScreeningDAO1 - Xử lý truy vấn và lưu trữ dữ liệu suất chiếu
 * Kế thừa từ DAO1
 */
public class ScreeningDAO1 extends DAO1 {

    public ScreeningDAO1() {
        super();
    }

    /**
     * Lấy danh sách các suất chiếu trong tuần hiện tại
     * @return Danh sách các suất chiếu
     */
    public List<Screening1> getScreeningsByWeek() {
        LocalDate monday = LocalDate.now().with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        return getScreeningsByWeek(Date.valueOf(monday), Date.valueOf(monday.plusDays(6)));
    }

    /**
     * Lấy danh sách suất chiếu trong khoảng ngày từ startDate đến endDate
     * @param startDate Ngày bắt đầu tuần
     * @param endDate Ngày kết thúc tuần
     * @return Danh sách suất chiếu
     */
    public List<Screening1> getScreeningsByWeek(Date startDate, Date endDate) {
        List<Screening1> list = new ArrayList<>();
        String sql = "SELECT s.id AS s_id, s.screeningDate, s.startTime, s.endTime, " +
                     "       m.id AS m_id, m.movieName, m.genre, m.director, m.actors, m.duration, " +
                     "       m.description AS m_desc, m.poster, m.releaseDate, m.language, m.status, m.baseTicketPrice, " +
                     "       r.id AS r_id, r.roomName, r.capacity, r.description AS r_desc " +
                     "FROM tblScreening s " +
                     "JOIN tblMovie m ON s.movieId = m.id " +
                     "JOIN tblScreeningRoom r ON s.screeningRoomId = r.id " +
                     "WHERE s.screeningDate BETWEEN ? AND ? " +
                     "ORDER BY s.screeningDate ASC, s.startTime ASC, r.id ASC";

        Connection connection = getConnection();
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDate(1, startDate);
            ps.setDate(2, endDate);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Screening1 screening = new Screening1();
                    screening.setId(rs.getInt("s_id"));
                    screening.setScreeningDate(rs.getDate("screeningDate"));
                    screening.setStartTime(rs.getTime("startTime"));
                    screening.setEndTime(rs.getTime("endTime"));

                    // Movie
                    Movie1 movie = new Movie1();
                    movie.setId(rs.getInt("m_id"));
                    movie.setMovieName(rs.getString("movieName"));
                    movie.setGenre(rs.getString("genre"));
                    movie.setDirector(rs.getString("director"));
                    movie.setActors(rs.getString("actors"));
                    movie.setDuration(rs.getInt("duration"));
                    movie.setDescription(rs.getString("m_desc"));
                    movie.setPoster(rs.getString("poster"));
                    movie.setReleaseDate(rs.getDate("releaseDate"));
                    movie.setLanguage(rs.getString("language"));
                    movie.setStatus(rs.getString("status"));
                    movie.setBaseTicketPrice(rs.getDouble("baseTicketPrice"));
                    screening.setMovie(movie);

                    // ScreeningRoom
                    ScreeningRoom1 room = new ScreeningRoom1();
                    room.setId(rs.getInt("r_id"));
                    room.setRoomName(rs.getString("roomName"));
                    room.setCapacity(rs.getInt("capacity"));
                    room.setDescription(rs.getString("r_desc"));
                    screening.setScreeningRoom(room);

                    list.add(screening);
                }
            }
        } catch (SQLException e) {
            System.err.println("[ScreeningDAO1] Lỗi khi lấy danh sách suất chiếu: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lưu suất chiếu mới vào cơ sở dữ liệu
     * @param screening Đối tượng suất chiếu cần lưu
     * @return true nếu lưu thành công, false nếu thất bại
     */
    public boolean saveScreening(Screening1 screening) {
        if (screening == null || screening.getMovie() == null || screening.getScreeningRoom() == null) {
            return false;
        }

        String sql = "INSERT INTO tblScreening (screeningDate, startTime, endTime, movieId, screeningRoomId) " +
                     "VALUES (?, ?, ?, ?, ?)";
        Connection connection = getConnection();

        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setDate(1, screening.getScreeningDate());
            ps.setTime(2, screening.getStartTime());
            ps.setTime(3, screening.getEndTime());
            ps.setInt(4, screening.getMovie().getId());
            ps.setInt(5, screening.getScreeningRoom().getId());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        screening.setId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("[ScreeningDAO1] Lỗi khi lưu suất chiếu mới: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
}

