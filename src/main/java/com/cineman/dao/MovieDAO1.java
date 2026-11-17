package com.cineman.dao;

import com.cineman.model.Movie1;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Lớp MovieDAO1 - Xử lý truy vấn dữ liệu liên quan đến phim
 * Kế thừa từ DAO1
 * Lưu ý: Không dùng hàm helper riêng để đóng gói ResultSet (theo sơ đồ lớp thiết kế)
 */
public class MovieDAO1 extends DAO1 {

    public MovieDAO1() {
        super();
    }

    /**
     * Tìm danh sách phim có tên chứa từ khóa movieName
     */
    public List<Movie1> searchMovie(String movieName) {
        List<Movie1> list = new ArrayList<>();
        String sql = "SELECT * FROM tblMovie WHERE LOWER(movieName) LIKE ? ORDER BY id ASC";
        Connection connection = getConnection();
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String keyword = "%" + (movieName != null ? movieName.trim().toLowerCase() : "") + "%";
            ps.setString(1, keyword);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    // Đóng gói inline — không dùng hàm riêng (theo sơ đồ lớp)
                    Movie1 movie = new Movie1();
                    movie.setId(rs.getInt("id"));
                    movie.setMovieName(rs.getString("movieName"));
                    movie.setGenre(rs.getString("genre"));
                    movie.setDirector(rs.getString("director"));
                    movie.setActors(rs.getString("actors"));
                    movie.setDuration(rs.getInt("duration"));
                    movie.setDescription(rs.getString("description"));
                    movie.setPoster(rs.getString("poster"));
                    movie.setReleaseDate(rs.getDate("releaseDate"));
                    movie.setLanguage(rs.getString("language"));
                    movie.setStatus(rs.getString("status"));
                    movie.setBaseTicketPrice(rs.getDouble("baseTicketPrice"));
                    list.add(movie);
                }
            }
        } catch (SQLException e) {
            System.err.println("[MovieDAO1] Lỗi khi tìm kiếm phim: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy thông tin chi tiết phim theo ID
     */
    public Movie1 getMovieDetail(int movieId) {
        String sql = "SELECT * FROM tblMovie WHERE id = ?";
        Connection connection = getConnection();
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, movieId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Đóng gói inline — không dùng hàm riêng (theo sơ đồ lớp)
                    Movie1 movie = new Movie1();
                    movie.setId(rs.getInt("id"));
                    movie.setMovieName(rs.getString("movieName"));
                    movie.setGenre(rs.getString("genre"));
                    movie.setDirector(rs.getString("director"));
                    movie.setActors(rs.getString("actors"));
                    movie.setDuration(rs.getInt("duration"));
                    movie.setDescription(rs.getString("description"));
                    movie.setPoster(rs.getString("poster"));
                    movie.setReleaseDate(rs.getDate("releaseDate"));
                    movie.setLanguage(rs.getString("language"));
                    movie.setStatus(rs.getString("status"));
                    movie.setBaseTicketPrice(rs.getDouble("baseTicketPrice"));
                    return movie;
                }
            }
        } catch (SQLException e) {
            System.err.println("[MovieDAO1] Lỗi khi lấy chi tiết phim: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lấy danh sách các phim đang chiếu
     */
    public List<Movie1> getNowShowingMovies() {
        List<Movie1> list = new ArrayList<>();
        String sql = "SELECT * FROM tblMovie WHERE status = 'Đang chiếu' OR status IS NULL ORDER BY id ASC";
        Connection connection = getConnection();
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                // Đóng gói inline — không dùng hàm riêng (theo sơ đồ lớp)
                Movie1 movie = new Movie1();
                movie.setId(rs.getInt("id"));
                movie.setMovieName(rs.getString("movieName"));
                movie.setGenre(rs.getString("genre"));
                movie.setDirector(rs.getString("director"));
                movie.setActors(rs.getString("actors"));
                movie.setDuration(rs.getInt("duration"));
                movie.setDescription(rs.getString("description"));
                movie.setPoster(rs.getString("poster"));
                movie.setReleaseDate(rs.getDate("releaseDate"));
                movie.setLanguage(rs.getString("language"));
                movie.setStatus(rs.getString("status"));
                movie.setBaseTicketPrice(rs.getDouble("baseTicketPrice"));
                list.add(movie);
            }
        } catch (SQLException e) {
            System.err.println("[MovieDAO1] Lỗi khi lấy danh sách phim đang chiếu: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }
}
