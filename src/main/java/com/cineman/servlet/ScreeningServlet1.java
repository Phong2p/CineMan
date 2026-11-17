package com.cineman.servlet;

import com.cineman.dao.MovieDAO1;
import com.cineman.dao.ScreeningDAO1;
import com.cineman.dao.ScreeningRoomDAO1;
import com.cineman.model.Movie1;
import com.cineman.model.Screening1;
import com.cineman.model.ScreeningRoom1;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.text.SimpleDateFormat;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet ScreeningServlet1 - Điều hướng và xử lý quy trình module lên lịch chiếu
 * Khớp chính xác với thiết kế tĩnh và thiết kế tuần tự J2EE
 */
@WebServlet(name = "ScreeningServlet1", urlPatterns = {"/screening", "/ScreeningServlet1"})
public class ScreeningServlet1 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ScreeningDAO1 screeningDAO;
    private ScreeningRoomDAO1 screeningRoomDAO;
    private MovieDAO1 movieDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        screeningDAO = new ScreeningDAO1();
        screeningRoomDAO = new ScreeningRoomDAO1();
        movieDAO = new MovieDAO1();
    }

    @Override
    protected void doGet(HttpServletRequest rq, HttpServletResponse rp) throws ServletException, IOException {
        rq.setCharacterEncoding("UTF-8");
        rp.setCharacterEncoding("UTF-8");
        rp.setContentType("text/html;charset=UTF-8");

        String action = rq.getParameter("action");
        if (action == null || action.trim().isEmpty() || "listScreenings".equalsIgnoreCase(action)) {
            listScreenings(rq, rp);
        } else if ("showAddScreeningForm".equalsIgnoreCase(action)) {
            showAddScreeningForm(rq, rp);
        } else {
            listScreenings(rq, rp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest rq, HttpServletResponse rp) throws ServletException, IOException {
        rq.setCharacterEncoding("UTF-8");
        rp.setCharacterEncoding("UTF-8");
        rp.setContentType("text/html;charset=UTF-8");

        String action = rq.getParameter("action");
        if ("createScreening".equalsIgnoreCase(action) || "findAvailableRooms".equalsIgnoreCase(action)) {
            createScreening(rq, rp);
        } else if ("selectRoom".equalsIgnoreCase(action)) {
            selectRoom(rq, rp);
        } else if ("selectMovie".equalsIgnoreCase(action)) {
            selectMovie(rq, rp);
        } else if ("confirmScreening".equalsIgnoreCase(action)) {
            confirmScreening(rq, rp);
        } else {
            doGet(rq, rp);
        }
    }

    /**
     * Hiển thị danh sách các suất chiếu trong tuần
     */
    private void listScreenings(HttpServletRequest rq, HttpServletResponse rp) throws ServletException, IOException {
        // Xử lý tuần hiển thị, bắt đầu từ thứ Hai của tuần hiện tại.
        int weekOffset = 0;
        try {
            String offsetParam = rq.getParameter("weekOffset");
            if (offsetParam != null) {
                weekOffset = Integer.parseInt(offsetParam.trim());
            }
        } catch (NumberFormatException ignored) {}

        LocalDate baseMonday = LocalDate.now()
                .with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY))
                .plusWeeks(weekOffset);
        LocalDate baseSunday = baseMonday.plusDays(6);

        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        String currentWeekStr = baseMonday.format(dtf) + " - " + baseSunday.format(dtf);

        Date startDate = Date.valueOf(baseMonday);
        Date endDate = Date.valueOf(baseSunday);

        List<Screening1> screenings = screeningDAO.getScreeningsByWeek(startDate, endDate);
        rq.setAttribute("listScreenings", screenings);
        rq.setAttribute("outScreeningList", screenings);
        rq.setAttribute("outCurrentWeek", currentWeekStr);
        rq.setAttribute("weekOffset", weekOffset);

        // Đọc flash message thành công (nếu có) và xóa khỏi session
        HttpSession session = rq.getSession(false);
        if (session != null) {
            String flash = (String) session.getAttribute("flashSuccess");
            if (flash != null) {
                rq.setAttribute("outMessage", flash);
                session.removeAttribute("flashSuccess");
            }
        }

        rq.getRequestDispatcher("/manager/ScreeningManagementUI1.jsp").forward(rq, rp);
    }

    /**
     * Chuyển tiếp sang giao diện thêm lịch chiếu (AddScreeningUI1.jsp)
     */
    private void showAddScreeningForm(HttpServletRequest rq, HttpServletResponse rp) throws ServletException, IOException {
        rq.getRequestDispatcher("/manager/AddScreeningUI1.jsp").forward(rq, rp);
    }

    /**
     * Xử lý luồng tạo suất chiếu và chuyển tiếp sang tìm phòng chiếu trống
     */
    private void createScreening(HttpServletRequest rq, HttpServletResponse rp) throws ServletException, IOException {
        findAvailableRooms(rq, rp);
    }

    /**
     * Tìm danh sách phòng chiếu còn trống theo ngày, giờ bắt đầu và kết thúc
     */
    private void findAvailableRooms(HttpServletRequest rq, HttpServletResponse rp) throws ServletException, IOException {
        String dateStr = rq.getParameter("inScreeningDate");
        String startStr = rq.getParameter("inStartTime");
        String endStr = rq.getParameter("inEndTime");

        if (dateStr == null || startStr == null || endStr == null ||
            dateStr.trim().isEmpty() || startStr.trim().isEmpty() || endStr.trim().isEmpty()) {
            rq.setAttribute("outMessage", "Vui lòng nhập đầy đủ ngày chiếu, giờ bắt đầu và giờ kết thúc!");
            rq.getRequestDispatcher("/manager/AddScreeningUI1.jsp").forward(rq, rp);
            return;
        }

        try {
            // Định dạng ngày (hỗ trợ cả yyyy-MM-dd và dd/MM/yyyy)
            Date screeningDate;
            if (dateStr.contains("/")) {
                String[] parts = dateStr.split("/");
                // dd/MM/yyyy -> yyyy-MM-dd
                screeningDate = Date.valueOf(parts[2] + "-" + String.format("%02d", Integer.parseInt(parts[1])) + "-" + String.format("%02d", Integer.parseInt(parts[0])));
            } else {
                screeningDate = Date.valueOf(dateStr);
            }

            // Định dạng giờ (hỗ trợ HH:mm hoặc HH:mm:ss)
            String sTime = startStr.length() == 5 ? startStr + ":00" : startStr;
            String eTime = endStr.length() == 5 ? endStr + ":00" : endStr;
            Time startTime = Time.valueOf(sTime);
            Time endTime = Time.valueOf(eTime);

            if (!endTime.after(startTime)) {
                rq.setAttribute("outMessage", "Giờ kết thúc phải sau giờ bắt đầu!");
                rq.getRequestDispatcher("/manager/AddScreeningUI1.jsp").forward(rq, rp);
                return;
            }

            // Khởi tạo đối tượng Screening1 lưu vào session phục vụ các bước tiếp theo
            Screening1 screening = new Screening1();
            screening.setScreeningDate(screeningDate);
            screening.setStartTime(startTime);
            screening.setEndTime(endTime);

            HttpSession session = rq.getSession();
            session.setAttribute("currentScreening", screening);

            // Tìm phòng chiếu trống
            List<ScreeningRoom1> availableRooms = screeningRoomDAO.getAvailableRooms(screeningDate, startTime, endTime);

            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
            String formattedDate = dateFormat.format(screeningDate);
            String timeSlot = startStr.substring(0, 5) + "-" + endStr.substring(0, 5);

            rq.setAttribute("screening", screening);
            rq.setAttribute("listAvailableRooms", availableRooms);
            rq.setAttribute("outAvailableRoomList", availableRooms);
            rq.setAttribute("outScreeningDate", formattedDate);
            rq.setAttribute("outTimeSlot", timeSlot);

            if (availableRooms.isEmpty()) {
                rq.setAttribute("outMessage", "Không tìm thấy phòng chiếu nào còn trống trong khung giờ này!");
            }

            rq.getRequestDispatcher("/manager/ScreeningRoomSelectionUI1.jsp").forward(rq, rp);

        } catch (Exception e) {
            e.printStackTrace();
            rq.setAttribute("outMessage", "Dữ liệu ngày giờ không hợp lệ! Vui lòng kiểm tra lại ngày và giờ.");
            rq.getRequestDispatcher("/manager/AddScreeningUI1.jsp").forward(rq, rp);
        }
    }

    /**
     * Xử lý chọn phòng chiếu và chuyển sang giao diện chọn phim
     */
    private void selectRoom(HttpServletRequest rq, HttpServletResponse rp) throws ServletException, IOException {
        HttpSession session = rq.getSession();
        Screening1 screening = (Screening1) session.getAttribute("currentScreening");

        String roomIdStr = rq.getParameter("roomId");
        if (screening == null || roomIdStr == null) {
            rp.sendRedirect(rq.getContextPath() + "/screening?action=listScreenings");
            return;
        }

        try {
            int roomId = Integer.parseInt(roomIdStr.trim());
            ScreeningRoom1 room = screeningRoomDAO.getRoomById(roomId);
            screening.setScreeningRoom(room);
            session.setAttribute("currentScreening", screening);

            List<Movie1> movies = movieDAO.getNowShowingMovies();

            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
            String formattedDate = dateFormat.format(screening.getScreeningDate());
            String timeSlot = screening.getStartTime().toString().substring(0, 5) + " - " + 
                              screening.getEndTime().toString().substring(0, 5);

            rq.setAttribute("screening", screening);
            rq.setAttribute("listMovie", movies);
            rq.setAttribute("tblMovieList", movies);
            rq.setAttribute("outScreeningDate", formattedDate);
            rq.setAttribute("outTimeSlot", timeSlot);
            rq.setAttribute("outSelectedRoom", room != null ? room.getRoomName() : "");

            rq.getRequestDispatcher("/manager/MovieSelectionUI1.jsp").forward(rq, rp);

        } catch (Exception e) {
            e.printStackTrace();
            rp.sendRedirect(rq.getContextPath() + "/screening?action=listScreenings");
        }
    }

    /**
     * Xử lý chọn phim và chuyển sang giao diện xác nhận lịch chiếu
     */
    private void selectMovie(HttpServletRequest rq, HttpServletResponse rp) throws ServletException, IOException {
        HttpSession session = rq.getSession();
        Screening1 screening = (Screening1) session.getAttribute("currentScreening");

        String movieIdStr = rq.getParameter("movieId");
        if (screening == null || movieIdStr == null) {
            rp.sendRedirect(rq.getContextPath() + "/screening?action=listScreenings");
            return;
        }

        try {
            int movieId = Integer.parseInt(movieIdStr.trim());
            Movie1 movie = movieDAO.getMovieDetail(movieId);
            screening.setMovie(movie);
            session.setAttribute("currentScreening", screening);

            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
            String formattedDate = dateFormat.format(screening.getScreeningDate());
            String timeSlot = screening.getStartTime().toString().substring(0, 5) + "-" + 
                              screening.getEndTime().toString().substring(0, 5);

            rq.setAttribute("screening", screening);
            rq.setAttribute("outMovieName", movie != null ? movie.getMovieName() : "");
            rq.setAttribute("outDuration", movie != null ? movie.getDuration() + " phút" : "");
            rq.setAttribute("outScreeningDate", formattedDate);
            rq.setAttribute("outTimeSlot", timeSlot);
            rq.setAttribute("outScreeningRoom", screening.getScreeningRoom() != null ? screening.getScreeningRoom().getRoomName() : "");

            rq.getRequestDispatcher("/manager/ScreeningConfirmationUI1.jsp").forward(rq, rp);

        } catch (Exception e) {
            e.printStackTrace();
            rp.sendRedirect(rq.getContextPath() + "/screening?action=listScreenings");
        }
    }

    /**
     * Xác nhận lên lịch chiếu, kiểm tra lại tình trạng phòng và lưu vào cơ sở dữ liệu
     */
    private void confirmScreening(HttpServletRequest rq, HttpServletResponse rp) throws ServletException, IOException {
        HttpSession session = rq.getSession();
        Screening1 screening = (Screening1) session.getAttribute("currentScreening");

        if (screening == null || screening.getMovie() == null || screening.getScreeningRoom() == null) {
            rp.sendRedirect(rq.getContextPath() + "/screening?action=listScreenings");
            return;
        }

        // Bước kiểm tra lại tình trạng phòng trống (ngăn chặn xung đột lịch đặt đồng thời)
        boolean isAvailable = screeningRoomDAO.checkRoomAvailability(
                screening.getScreeningRoom().getId(),
                screening.getScreeningDate(),
                screening.getStartTime(),
                screening.getEndTime()
        );

        if (!isAvailable) {
            rq.setAttribute("outMessage", "Phòng chiếu " + screening.getScreeningRoom().getRoomName() +
                    " đã bị trùng lịch với suất chiếu khác trong khung giờ này! Vui lòng chọn lại.");
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
            rq.setAttribute("outScreeningDate", dateFormat.format(screening.getScreeningDate()));
            rq.setAttribute("outTimeSlot", screening.getStartTime().toString().substring(0, 5) + "-" +
                    screening.getEndTime().toString().substring(0, 5));
            rq.setAttribute("outScreeningRoom", screening.getScreeningRoom().getRoomName());
            rq.setAttribute("outMovieName", screening.getMovie().getMovieName());
            rq.setAttribute("outDuration", screening.getMovie().getDuration() + " phút");
            rq.getRequestDispatcher("/manager/ScreeningConfirmationUI1.jsp").forward(rq, rp);
            return;
        }

        // Lưu suất chiếu
        boolean success = screeningDAO.saveScreening(screening);
        if (success) {
            session.removeAttribute("currentScreening");
            // Flash message thông báo thành công (dùng session để giữ qua redirect)
            session.setAttribute("flashSuccess", "Lên lịch chiếu thành công!");
            rp.sendRedirect(rq.getContextPath() + "/screening?action=listScreenings");
        } else {
            rq.setAttribute("outMessage", "Lỗi: Không thể lưu suất chiếu vào cơ sở dữ liệu!");
            rq.getRequestDispatcher("/manager/ScreeningConfirmationUI1.jsp").forward(rq, rp);
        }
    }
}

