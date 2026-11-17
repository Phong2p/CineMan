#!/bin/bash
# Script khởi chạy CineMan Web Application
echo "=========================================================="
echo "      ĐANG KHỞI CHẠY HỆ THỐNG CINEMAN (J2EE / JETTY)      "
echo "=========================================================="

# Sử dụng JAVA_HOME hiện tại nếu hợp lệ; nếu không, tìm JDK đã cài trên macOS.
if [ -z "$JAVA_HOME" ] || [ ! -x "$JAVA_HOME/bin/java" ]; then
    if [ -x /usr/libexec/java_home ]; then
        JAVA_HOME=$(/usr/libexec/java_home -v 17+ 2>/dev/null || /usr/libexec/java_home 2>/dev/null)
    fi
fi

if [ -z "$JAVA_HOME" ] || [ ! -x "$JAVA_HOME/bin/java" ]; then
    echo "Không tìm thấy JDK 17 trở lên. Hãy cài JDK và thử lại."
    exit 1
fi

export JAVA_HOME
export PATH="$JAVA_HOME/bin:$PATH"

# Giải phóng cổng 8080 nếu đang bị chiếm dụng bởi tiến trình chạy trước đó
PID_OCCUPIED=$(lsof -ti :8080 2>/dev/null)
if [ -n "$PID_OCCUPIED" ]; then
    echo "Phát hiện tiến trình (PID: $PID_OCCUPIED) đang chiếm port 8080. Đang giải phóng..."
    kill -9 $PID_OCCUPIED 2>/dev/null || true
    sleep 1
fi

echo "Java Version: $(java -version 2>&1 | head -n 1)"
echo "Đang khởi động máy chủ tại: http://localhost:8080/CineMan"
echo "Để dừng máy chủ, nhấn Ctrl + C"
echo "=========================================================="

mvn jetty:run
