package com.cineman.dao;

import com.cineman.model.Movie1;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Kiểm thử lớp MovieDAO1")
public class MovieDAOTest {

    private MovieDAO1 movieDAO;

    @BeforeEach
    public void setUp() {
        movieDAO = new MovieDAO1();
    }

    @Test
    @DisplayName("Tìm kiếm phim theo từ khóa 'Chiikawa'")
    public void testSearchMovie() {
        List<Movie1> results = movieDAO.searchMovie("Chiikawa");
        assertNotNull(results, "Danh sách phim trả về không được null");
        assertTrue(results.size() >= 2, "Phải tìm thấy ít nhất 2 phim liên quan đến 'Chiikawa'");

        boolean foundChiikawa = false;
        boolean foundChiikawa2 = false;
        for (Movie1 m : results) {
            if ("Chiikawa".equals(m.getMovieName())) foundChiikawa = true;
            if ("Chiikawa 2".equals(m.getMovieName())) foundChiikawa2 = true;
        }
        assertTrue(foundChiikawa, "Phải tìm thấy phim 'Chiikawa'");
        assertTrue(foundChiikawa2, "Phải tìm thấy phim 'Chiikawa 2'");
    }

    @Test
    @DisplayName("Lấy chi tiết phim theo ID 1 (Chiikawa)")
    public void testGetMovieDetail() {
        Movie1 movie = movieDAO.getMovieDetail(1);
        assertNotNull(movie, "Phim với ID 1 phải tồn tại");
        assertEquals("Chiikawa", movie.getMovieName());
        assertEquals("Thiếu nhi", movie.getGenre());
        assertEquals("Kei Oikawa", movie.getDirector());
        assertEquals("Haruka Aoki", movie.getActors());
        assertEquals(90, movie.getDuration());
        assertEquals("Tiếng Nhật", movie.getLanguage());
    }

    @Test
    @DisplayName("Lấy danh sách các phim đang chiếu")
    public void testGetNowShowingMovies() {
        List<Movie1> nowShowing = movieDAO.getNowShowingMovies();
        assertNotNull(nowShowing, "Danh sách phim đang chiếu không được null");
        assertFalse(nowShowing.isEmpty(), "Danh sách phim đang chiếu không được rỗng");

        for (Movie1 m : nowShowing) {
            assertTrue("Đang chiếu".equals(m.getStatus()) || m.getStatus() == null,
                    "Tất cả phim lấy ra phải có trạng thái Đang chiếu");
        }
    }

    @Test
    @DisplayName("Dữ liệu mẫu có thêm bốn phim mới, poster chờ được cung cấp")
    public void testAddedMovies() {
        assertEquals("Thanh Gươm Diệt Quỷ: Chuyến Tàu Vô Tận", movieDAO.getMovieDetail(6).getMovieName());
        assertEquals("Spider-Man: No Way Home", movieDAO.getMovieDetail(7).getMovieName());
        assertEquals("Your Name", movieDAO.getMovieDetail(8).getMovieName());
        assertEquals("Doraemon: Nobita và Bản Giao Hưởng Địa Cầu", movieDAO.getMovieDetail(9).getMovieName());
        assertEquals("images/chiikawa.png", movieDAO.getMovieDetail(1).getPoster());
        assertEquals("images/chiikawa-2.jpg", movieDAO.getMovieDetail(2).getPoster());
        assertEquals("images/bleach.jpg", movieDAO.getMovieDetail(3).getPoster());
        assertEquals("images/conan.jpg", movieDAO.getMovieDetail(4).getPoster());
        assertEquals("images/kimetsu-no-yaiba.jpeg", movieDAO.getMovieDetail(6).getPoster());
        assertEquals("images/spider-man-no-way-home.jpg", movieDAO.getMovieDetail(7).getPoster());
        assertEquals("images/your-name.jpg", movieDAO.getMovieDetail(8).getPoster());
        assertEquals("images/doraemon-earth-symphony.jpeg", movieDAO.getMovieDetail(9).getPoster());
        assertNull(movieDAO.getMovieDetail(5).getPoster());
    }
}

