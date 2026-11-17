package com.cineman.model;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Time;

/**
 * Entity class Screening1 - Lưu trữ thông tin suất chiếu
 * Theo thiết kế tầng thực thể hệ thống CineMan
 */
public class Screening1 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private Date screeningDate;
    private Time startTime;
    private Time endTime;
    private Movie1 movie;
    private ScreeningRoom1 screeningRoom;

    public Screening1() {
    }

    public Screening1(int id, Date screeningDate, Time startTime, Time endTime,
                      Movie1 movie, ScreeningRoom1 screeningRoom) {
        this.id = id;
        this.screeningDate = screeningDate;
        this.startTime = startTime;
        this.endTime = endTime;
        this.movie = movie;
        this.screeningRoom = screeningRoom;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getScreeningDate() {
        return screeningDate;
    }

    public void setScreeningDate(Date screeningDate) {
        this.screeningDate = screeningDate;
    }

    public Time getStartTime() {
        return startTime;
    }

    public void setStartTime(Time startTime) {
        this.startTime = startTime;
    }

    public Time getEndTime() {
        return endTime;
    }

    public void setEndTime(Time endTime) {
        this.endTime = endTime;
    }

    public Movie1 getMovie() {
        return movie;
    }

    public void setMovie(Movie1 movie) {
        this.movie = movie;
    }

    public ScreeningRoom1 getScreeningRoom() {
        return screeningRoom;
    }

    public void setScreeningRoom(ScreeningRoom1 screeningRoom) {
        this.screeningRoom = screeningRoom;
    }

    /**
     * Helper method định dạng khung giờ dạng "HH:mm - HH:mm"
     */
    public String getTimeSlot() {
        if (startTime != null && endTime != null) {
            String s = startTime.toString().substring(0, 5);
            String e = endTime.toString().substring(0, 5);
            return s + " - " + e;
        }
        return "";
    }

    @Override
    public String toString() {
        return "Screening1{" +
                "id=" + id +
                ", screeningDate=" + screeningDate +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                ", movie=" + (movie != null ? movie.getMovieName() : "null") +
                ", screeningRoom=" + (screeningRoom != null ? screeningRoom.getRoomName() : "null") +
                '}';
    }
}

