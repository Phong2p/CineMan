package com.cineman.servlet;

import com.cineman.dao.MovieDAO1;
import com.cineman.model.Movie1;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Servlet MovieServlet1 - Điều hướng và xử lý các yêu cầu thuộc module tìm kiếm phim
 * Khớp chính xác với thiết kế tĩnh và thiết kế tuần tự J2EE
 */
@WebServlet(name = "MovieServlet1", urlPatterns = {"/movie", "/MovieServlet1"})
public class MovieServlet1 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private MovieDAO1 movieDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        movieDAO = new MovieDAO1();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse rp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        rp.setCharacterEncoding("UTF-8");
        rp.setContentType("text/html;charset=UTF-8");

        String action = req.getParameter("action");
        if (action == null || action.trim().isEmpty() || "showSearchForm".equalsIgnoreCase(action)) {
            showSearchForm(req, rp);
        } else if ("searchMovie".equalsIgnoreCase(action)) {
            searchMovie(req, rp);
        } else if ("showMovieDetail".equalsIgnoreCase(action) || "detail".equalsIgnoreCase(action)) {
            showMovieDetail(req, rp);
        } else {
            showSearchForm(req, rp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse rp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        rp.setCharacterEncoding("UTF-8");
        rp.setContentType("text/html;charset=UTF-8");

        String action = req.getParameter("action");
        if ("searchMovie".equalsIgnoreCase(action)) {
            searchMovie(req, rp);
        } else {
            doGet(req, rp);
        }
    }

    /**
     * Chuyển tiếp sang giao diện tìm kiếm phim (MovieSearchUI1.jsp)
     */
    private void showSearchForm(HttpServletRequest rq, HttpServletResponse rp) throws ServletException, IOException {
        rq.getRequestDispatcher("/customer/MovieSearchUI1.jsp").forward(rq, rp);
    }

    /**
     * Tìm kiếm phim theo tên và chuyển tiếp kết quả sang MovieSearchResultUI1.jsp
     */
    private void searchMovie(HttpServletRequest rq, HttpServletResponse rp) throws ServletException, IOException {
        String movieName = rq.getParameter("inMovieName");
        if (movieName == null) {
            movieName = rq.getParameter("movieName");
        }

        List<Movie1> listMovie = movieDAO.searchMovie(movieName);
        rq.setAttribute("listMovie", listMovie);
        rq.setAttribute("inMovieName", movieName != null ? movieName.trim() : "");
        rq.setAttribute("searchKeyword", movieName != null ? movieName.trim() : "");

        if (listMovie == null || listMovie.isEmpty()) {
            rq.setAttribute("outMessage", "Không tìm thấy phim phù hợp với từ khóa: \"" + (movieName != null ? movieName : "") + "\"");
        }

        rq.getRequestDispatcher("/customer/MovieSearchResultUI1.jsp").forward(rq, rp);
    }

    /**
     * Lấy thông tin chi tiết phim và chuyển tiếp sang MovieDetailUI1.jsp
     */
    private void showMovieDetail(HttpServletRequest rq, HttpServletResponse rp) throws ServletException, IOException {
        String movieIdStr = rq.getParameter("movieId");
        if (movieIdStr == null) {
            movieIdStr = rq.getParameter("id");
        }

        if (movieIdStr != null && !movieIdStr.trim().isEmpty()) {
            try {
                int movieId = Integer.parseInt(movieIdStr.trim());
                Movie1 movie = movieDAO.getMovieDetail(movieId);
                if (movie != null) {
                    rq.setAttribute("movie", movie);
                    rq.getRequestDispatcher("/customer/MovieDetailUI1.jsp").forward(rq, rp);
                    return;
                }
            } catch (NumberFormatException e) {
                System.err.println("[MovieServlet1] Sai định dạng movieId: " + movieIdStr);
            }
        }

        // Nếu không có phim, quay lại trang tìm kiếm với thông báo
        rq.setAttribute("outMessage", "Không tìm thấy thông tin chi tiết phim yêu cầu!");
        rq.getRequestDispatcher("/customer/MovieSearchUI1.jsp").forward(rq, rp);
    }
}

