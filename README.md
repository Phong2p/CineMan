# CineMan - Hệ Thống Quản Lý Rạp Chiếu Phim (J2EE Architecture)

Dự án được xây dựng theo chuẩn kiến trúc J2EE (MVC - Model View Controller) dựa trên tài liệu thiết kế phân tích hệ thống CineMan.

## Chạy nhanh

Yêu cầu **JDK 17 trở lên** và **Maven**. Mở Terminal tại thư mục gốc `CineMan`, sau đó chạy:

```bash
chmod +x run.sh
./run.sh
```

Khi Jetty báo đã khởi động, mở [http://localhost:8080/CineMan/](http://localhost:8080/CineMan/) để vào trang đăng nhập. Có thể mở trực tiếp [http://localhost:8080/CineMan/LoginUI1.jsp](http://localhost:8080/CineMan/LoginUI1.jsp).

Trong chế độ H2 fallback, tài khoản mẫu là `manager` / `123456` hoặc `customer` / `123456`. Sau khi chạy `cineman.sql` trên MySQL, hai tài khoản mẫu này cũng được tạo ở đó. Đây là tài khoản chỉ dùng để kiểm thử cục bộ.

Ứng dụng thử kết nối MySQL theo cấu hình trong `src/main/resources/db.properties` trước. Nếu không kết nối được, ứng dụng dùng H2 in-memory và nạp dữ liệu mẫu từ `src/main/resources/init_data.sql`.

---

## 1. Cấu Trúc Thư Mục Dự Án

```
CineMan/
├── pom.xml                                     # Cấu hình Maven project & dependencies
├── cineman.sql                                 # Script tạo cơ sở dữ liệu và dữ liệu mẫu (MySQL)
├── README.md                                   # Tài liệu hướng dẫn sử dụng và thuyết minh
└── src/
    ├── main/
    │   ├── java/
    │   │   └── com/cineman/
    │   │       ├── model/                      # Tầng Thực Thể (Entity/Model)
    │   │       │   ├── Movie1.java             # Thực thể Phim
    │   │       │   ├── ScreeningRoom1.java     # Thực thể Phòng chiếu
    │   │       │   └── Screening1.java         # Thực thể Suất chiếu
    │   │       ├── dao/                        # Tầng Truy Xuất Dữ Liệu (DAO)
    │   │       │   ├── DAO1.java               # Lớp DAO cơ sở, quản lý kết nối CSDL & fallback H2
    │   │       │   ├── MovieDAO1.java          # DAO thao tác với bảng tblMovie
    │   │       │   ├── ScreeningRoomDAO1.java  # DAO thao tác với bảng tblScreeningRoom & kiểm tra phòng trống
    │   │       │   └── ScreeningDAO1.java      # DAO thao tác với bảng tblScreening & lưu lịch chiếu
    │   │       └── servlet/                    # Tầng Điều Khiển (Controller / Servlet)
    │   │           ├── MovieServlet1.java      # Servlet xử lý module tìm kiếm phim
    │   │           └── ScreeningServlet1.java  # Servlet xử lý module lên lịch chiếu
    │   ├── resources/
    │   │   ├── db.properties                   # Cấu hình kết nối MySQL và H2 Fallback
    │   │   └── init_data.sql                   # Dữ liệu khởi tạo cho H2 In-Memory
    │   └── webapp/                             # Tầng Giao Diện (View / JSP)
    │       ├── WEB-INF/
    │       │   └── web.xml                     # Cấu hình triển khai web (Deployment Descriptor)
    │       ├── css/
    │       │   └── style.css                   # CSS mô phỏng chính xác wireframe thiết kế
    │       ├── MainUI1.jsp                     # Giao diện chính hệ thống CineMan
    │       ├── MovieSearchUI1.jsp              # Giao diện tìm kiếm phim
    │       ├── MovieSearchResultUI1.jsp       # Giao diện hiển thị kết quả tìm kiếm
    │       ├── MovieDetailUI1.jsp              # Giao diện hiển thị chi tiết phim
    │       ├── ScreeningManagementUI1.jsp      # Giao diện quản lý lịch chiếu trong tuần
    │       ├── AddScreeningUI1.jsp             # Giao diện nhập ngày, giờ tìm phòng chiếu
    │       ├── ScreeningRoomSelectionUI1.jsp   # Giao diện chọn phòng chiếu còn trống
    │       ├── MovieSelectionUI1.jsp           # Giao diện chọn phim đang chiếu
    │       └── ScreeningConfirmationUI1.jsp    # Giao diện xác nhận và lưu lịch chiếu
    └── test/
        └── java/com/cineman/dao/
            ├── MovieDAOTest.java               # Unit tests cho MovieDAO1
            ├── ScreeningRoomDAOTest.java       # Unit tests cho ScreeningRoomDAO1
            └── ScreeningDAOTest.java           # Unit tests cho ScreeningDAO1
```

---

## 2. Chi Tiết Các Module Đã Xây Dựng

### A. Module 1: Tìm Kiếm Thông Tin Phim
1. **Giao diện**:
   - `MainUI1.jsp`: Nút chọn "Tìm kiếm phim".
   - `MovieSearchUI1.jsp`: Nhập từ khóa tên phim (`inMovieName`), nút tìm kiếm `Search` (`subSearch`).
   - `MovieSearchResultUI1.jsp`: Hiển thị danh sách kết quả (`outMovieList`: STT, Tên phim, nút `[Select]`), thông báo `outMessage` khi không tìm thấy phim phù hợp.
   - `MovieDetailUI1.jsp`: Hiển thị poster (nếu có) và thông tin chi tiết phim.
2. **Servlet**:
   - `MovieServlet1`: Nhận request, gọi `MovieDAO1.searchMovie(movieName)` và `MovieDAO1.getMovieDetail(movieId)`, đính kèm dữ liệu vào request và forward sang trang JSP tương ứng.
3. **DAO & Model**:
   - `MovieDAO1` kế thừa từ `DAO1`.
   - `Movie1`: Chứa đầy đủ các thuộc tính theo thiết kế tĩnh.

### B. Module 2: Lên Lịch Chiếu
1. **Giao diện**:
   - `MainUI1.jsp`: Nút chọn "Quản lý lịch chiếu".
   - `ScreeningManagementUI1.jsp`: Hiển thị tuần hiện tại (`outCurrentWeek`), bảng danh sách suất chiếu (`tblScreeningList`), nút chuyển tuần (`< Tuần trước`, `Tuần sau >`), nút `+ Thêm lịch chiếu`.
   - `AddScreeningUI1.jsp`: Nhập ngày chiếu (`inScreeningDate`), thời gian bắt đầu (`inStartTime`), kết thúc (`inEndTime`), nút `Tìm phòng`.
   - `ScreeningRoomSelectionUI1.jsp`: Hiển thị thông tin ngày chiếu, khung giờ, bảng các phòng chiếu còn trống (`tblAvailableRoomList`), nút `Chọn`.
   - `MovieSelectionUI1.jsp`: Hiển thị thông tin ngày chiếu, khung giờ, phòng đã chọn, bảng danh sách phim đang chiếu (`tblMovieList`), nút `Chọn`.
   - `ScreeningConfirmationUI1.jsp`: Hiển thị thông tin tổng hợp (Ngày chiếu, Khung giờ, Phòng, Phim, Thời lượng), nút `Confirm`.
2. **Servlet**:
   - `ScreeningServlet1`: Điều hướng theo đúng trình tự thiết kế tuần tự (listScreenings -> showAddScreeningForm -> createScreening / findAvailableRooms -> selectRoom -> selectMovie -> confirmScreening).
   - Kiểm tra lại phòng trống bằng `ScreeningRoomDAO1.checkRoomAvailability(...)` trước khi gọi `ScreeningDAO1.saveScreening(...)` nhằm ngăn chặn xung đột lịch chiếu.
3. **DAO & Model**:
   - `ScreeningDAO1`, `ScreeningRoomDAO1`, `MovieDAO1` kế thừa `DAO1`.
   - `Screening1`, `ScreeningRoom1`, `Movie1`.

---

## 3. Cơ Chế Kết Nối Cơ Sở Dữ Liệu Thông Minh (`DAO1`)

Lớp `DAO1` được thiết kế linh hoạt:
1. **Chế độ MySQL**: Ưu tiên kết nối tới MySQL Database `localhost:3306/cineman` với tài khoản cấu hình trong `db.properties`.
2. **Chế độ Fallback H2 In-Memory**: Nếu MySQL chưa khởi động hoặc gặp sự cố kết nối, hệ thống sẽ tự động kích hoạt H2 In-Memory Database và nạp dữ liệu từ `init_data.sql`. Nhờ vậy, giảng viên/người chấm bài có thể chạy và đánh giá toàn bộ chức năng của hệ thống ngay lập tức mà không gặp bất kỳ lỗi kết nối nào!

Để khởi tạo MySQL, mở `cineman.sql` trong SQL Editor của DBeaver và chạy script. Script tạo bảng còn thiếu và thêm dữ liệu mẫu còn thiếu; chạy lại sẽ không xóa hoặc ghi đè các bản ghi hiện có. Tài khoản kiểm thử: `manager` / `123456` (Manager) và `customer` / `123456` (Customer).

---

## 4. Kiểm thử & triển khai

### 4.1. Chạy Unit Test
```bash
mvn test
```
Toàn bộ 10 bài test cho chức năng tìm kiếm phim, dữ liệu poster, phòng chiếu trống và lưu lịch chiếu sẽ được thực thi tự động.

### 4.2. Đóng Gói Thành File WAR (Web Application Archive)
```bash
mvn clean package
```
File đóng gói được tạo ra tại: `target/CineMan.war`.

### 4.3. Triển Khai Lên Apache Tomcat
1. Sao chép file `target/CineMan.war` vào thư mục `webapps/` của Tomcat.
2. Khởi động Tomcat (`bin/startup.sh` hoặc `bin/startup.bat`).
3. Mở trình duyệt web và truy cập địa chỉ:
   ```
   http://localhost:8080/CineMan/
   ```
Hoặc cấu hình Server trong **Eclipse IDE** / **IntelliJ IDEA** / **NetBeans**:
- `Import Project` -> `Existing Maven Projects`.
- Chọn Run on Server -> `Apache Tomcat`.
