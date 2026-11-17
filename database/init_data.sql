-- Init tables for CineMan System (MySQL & H2 compatible)
CREATE TABLE IF NOT EXISTS tblMovie (
    id INT AUTO_INCREMENT PRIMARY KEY,
    movieName VARCHAR(255) NOT NULL,
    genre VARCHAR(100),
    director VARCHAR(150),
    actors TEXT,
    duration INT NOT NULL,
    description TEXT,
    poster VARCHAR(255),
    releaseDate DATE,
    language VARCHAR(100),
    status VARCHAR(50) DEFAULT 'Đang chiếu',
    baseTicketPrice DOUBLE DEFAULT 75000.0
);

CREATE TABLE IF NOT EXISTS tblScreeningRoom (
    id INT AUTO_INCREMENT PRIMARY KEY,
    roomName VARCHAR(100) NOT NULL,
    capacity INT NOT NULL,
    description VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS tblScreening (
    id INT AUTO_INCREMENT PRIMARY KEY,
    screeningDate DATE NOT NULL,
    startTime TIME NOT NULL,
    endTime TIME NOT NULL,
    movieId INT NOT NULL,
    screeningRoomId INT NOT NULL
);

CREATE TABLE IF NOT EXISTS tblAccount (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    fullName VARCHAR(200),
    role VARCHAR(20) DEFAULT 'Customer'
);

-- Seed data if empty
MERGE INTO tblMovie (id, movieName, genre, director, actors, duration, description, poster, releaseDate, language, status, baseTicketPrice) 
KEY(id) VALUES
(1, 'Chiikawa', 'Thiếu nhi', 'Kei Oikawa', 'Haruka Aoki', 90, 
 'Phim kể về cuộc sống thường ngày nhưng đầy phiêu lưu kỳ thú của chú sóc nhỏ Chiikawa cùng những người bạn đáng yêu Hachiware và Usagi trong thế giới ngập tràn phép màu.', 
 'images/chiikawa.png', '2026-09-24', 'Tiếng Nhật', 'Đang chiếu', 80000.0),

(2, 'Chiikawa 2', 'Hoạt hình / Phiêu lưu', 'Kei Oikawa', 'Haruka Aoki, Masato Tanaka', 95, 
 'Phần tiếp theo của Chiikawa với chuyến thám hiểm tới khu rừng ngọt ngào và những thử thách mới.', 
 'images/chiikawa-2.jpg', '2026-10-01', 'Tiếng Nhật', 'Đang chiếu', 85000.0),

(3, 'Bleach', 'Hành động / Siêu nhiên', 'Noriyuki Abe', 'Masakazu Morita, Fumiko Orikasa', 110, 
 'Trận chiến đỉnh cao của Thần Chết Kurosaki Ichigo bảo vệ Karakura và Linh giới trước các thế lực bóng tối.', 
 'images/bleach.jpg', '2026-09-15', 'Tiếng Nhật', 'Đang chiếu', 90000.0),

(4, 'Thám Tử Lừng Danh Conan', 'Trinh thám / Hoạt hình', 'Chika Nagaoka', 'Minami Takayama, Wakana Yamazaki', 112, 
 'Vụ án bí ẩn tại công viên thủy cung quốc tế liên quan đến Tổ chức Áo Đen bí ẩn.', 
 'images/conan.jpg', '2026-08-20', 'Tiếng Nhật', 'Đang chiếu', 85000.0),

(5, 'Avatar 3: Hỏa Giới', 'Khoa học viễn tưởng', 'James Cameron', 'Sam Worthington, Zoe Saldana', 185, 
 'Cuộc đối đầu kịch tính mới tại Pandora với bộ tộc Người Tro sống tại vùng núi lửa.', 
 NULL, '2026-12-18', 'Tiếng Anh', 'Sắp chiếu', 120000.0),

(6, 'Thanh Gươm Diệt Quỷ: Chuyến Tàu Vô Tận', 'Hoạt hình / Hành động', 'Haruo Sotozaki',
 'Natsuki Hanae, Akari Kito, Yoshitsugu Matsuoka, Satoshi Hino', 117,
 'Tanjiro cùng các kiếm sĩ điều tra những vụ mất tích bí ẩn trên một chuyến tàu.',
 'images/kimetsu-no-yaiba.jpeg', '2020-10-16', 'Tiếng Nhật', 'Đang chiếu', 95000.0),

(7, 'Spider-Man: No Way Home', 'Hành động / Phiêu lưu', 'Jon Watts',
 'Tom Holland, Zendaya, Benedict Cumberbatch', 148,
 'Peter Parker tìm cách xử lý hậu quả khi danh tính của mình bị tiết lộ và một sự cố đa vũ trụ xảy ra.',
 'images/spider-man-no-way-home.jpg', '2021-12-17', 'Tiếng Anh', 'Đang chiếu', 105000.0),

(8, 'Your Name', 'Hoạt hình / Lãng mạn', 'Makoto Shinkai',
 'Ryunosuke Kamiki, Mone Kamishiraishi', 107,
 'Hai học sinh ở những nơi xa lạ bất ngờ hoán đổi cơ thể và tìm cách gặp nhau.',
 'images/your-name.jpg', '2016-08-26', 'Tiếng Nhật', 'Đang chiếu', 90000.0),

(9, 'Doraemon: Nobita và Bản Giao Hưởng Địa Cầu', 'Hoạt hình / Phiêu lưu', 'Kazuaki Imai',
 'Wasabi Mizuta, Megumi Ohara, Yumi Kakazu, Subaru Kimura, Tomokazu Seki', 115,
 'Nobita và nhóm bạn bước vào hành trình âm nhạc để ngăn một mối đe dọa ảnh hưởng đến Trái Đất.',
 'images/doraemon-earth-symphony.jpeg', '2024-03-01', 'Tiếng Nhật', 'Đang chiếu', 90000.0);

MERGE INTO tblScreeningRoom (id, roomName, capacity, description) 
KEY(id) VALUES
(1, 'Phòng 1', 120, 'Phòng chiếu 2D tiêu chuẩn, âm thanh Dolby 7.1 sống động'),
(2, 'Phòng 2', 150, 'Phòng chiếu 3D màn ảnh rộng kỹ thuật số thế hệ mới'),
(3, 'Phòng 3', 80, 'Phòng VIP ghế da cao cấp, phục vụ đồ uống tại chỗ'),
(4, 'Phòng 4', 220, 'Phòng IMAX Laser hiện đại với âm thanh vòm 12 kênh'),
(5, 'Phòng 5', 100, 'Phòng chiếu tiêu chuẩn hiện đại, ấm cúng'),
(6, 'Phòng 6', 96, 'Phòng chiếu 2D cỡ vừa, 96 ghế, âm thanh vòm 5.1'),
(7, 'Phòng 7', 110, 'Phòng chiếu 2D với 110 ghế, phù hợp các suất chiếu thông thường'),
(8, 'Phòng 8', 125, 'Phòng chiếu 3D với 125 ghế và hệ thống máy chiếu kỹ thuật số'),
(9, 'Phòng 9', 90, 'Phòng chiếu 2D nhỏ gọn, 90 ghế, phù hợp nhóm khán giả vừa'),
(10, 'Phòng 10', 135, 'Phòng chiếu 2D với 135 ghế, màn chiếu rộng và âm thanh vòm');

MERGE INTO tblScreening (id, screeningDate, startTime, endTime, movieId, screeningRoomId) 
KEY(id) VALUES
(1, '2026-09-21', '09:00:00', '11:00:00', 1, 2),
(2, '2026-09-21', '14:00:00', '16:00:00', 3, 1),
(3, '2026-09-22', '10:00:00', '12:00:00', 2, 3),
(4, '2026-09-22', '19:00:00', '21:00:00', 3, 4),
(5, '2026-09-23', '09:00:00', '11:00:00', 4, 2),
(6, '2026-09-23', '09:30:00', '11:30:00', 2, 4),
(7, '2026-09-24', '15:00:00', '17:00:00', 1, 1),
(8, '2026-09-25', '18:00:00', '20:00:00', 3, 5),
(9, '2026-09-26', '20:00:00', '22:00:00', 1, 2),
(10, '2026-09-27', '16:00:00', '18:00:00', 2, 3);

-- Tài khoản mẫu: manager / 123456 | customer / 123456
MERGE INTO tblAccount (id, username, password, fullName, role)
KEY(id) VALUES
(1, 'manager', '123456', 'Nguyễn Quản Lý', 'Manager'),
(2, 'customer', '123456', 'Trần Khách Hàng', 'Customer');
