package com.cineman.model;

import java.io.Serializable;
import java.sql.Date;

/**
 * Entity class Movie1 - Lưu trữ thông tin phim
 * Theo thiết kế tầng thực thể hệ thống CineMan
 */
public class Movie1 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String movieName;
    private String genre;
    private String director;
    private String actors;
    private int duration; // Thời lượng (phút)
    private String description;
    private String poster;
    private Date releaseDate;
    private String language;
    private String status; // "Đang chiếu", "Sắp chiếu", v.v.
    private double baseTicketPrice;

    public Movie1() {
    }

    public Movie1(int id, String movieName, String genre, String director, String actors,
                  int duration, String description, String poster, Date releaseDate,
                  String language, String status, double baseTicketPrice) {
        this.id = id;
        this.movieName = movieName;
        this.genre = genre;
        this.director = director;
        this.actors = actors;
        this.duration = duration;
        this.description = description;
        this.poster = poster;
        this.releaseDate = releaseDate;
        this.language = language;
        this.status = status;
        this.baseTicketPrice = baseTicketPrice;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getMovieName() {
        return movieName;
    }

    public void setMovieName(String movieName) {
        this.movieName = movieName;
    }

    public String getGenre() {
        return genre;
    }

    public void setGenre(String genre) {
        this.genre = genre;
    }

    public String getDirector() {
        return director;
    }

    public void setDirector(String director) {
        this.director = director;
    }

    public String getActors() {
        return actors;
    }

    public void setActors(String actors) {
        this.actors = actors;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPoster() {
        return poster;
    }

    public void setPoster(String poster) {
        this.poster = poster;
    }

    public Date getReleaseDate() {
        return releaseDate;
    }

    public void setReleaseDate(Date releaseDate) {
        this.releaseDate = releaseDate;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public double getBaseTicketPrice() {
        return baseTicketPrice;
    }

    public void setBaseTicketPrice(double baseTicketPrice) {
        this.baseTicketPrice = baseTicketPrice;
    }

    @Override
    public String toString() {
        return "Movie1{" +
                "id=" + id +
                ", movieName='" + movieName + '\'' +
                ", genre='" + genre + '\'' +
                ", duration=" + duration +
                ", status='" + status + '\'' +
                '}';
    }
}

