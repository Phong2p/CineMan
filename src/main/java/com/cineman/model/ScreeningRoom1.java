package com.cineman.model;

import java.io.Serializable;

/**
 * Entity class ScreeningRoom1 - Lưu trữ thông tin phòng chiếu
 * Theo thiết kế tầng thực thể hệ thống CineMan
 */
public class ScreeningRoom1 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String roomName;
    private int capacity;
    private String description;

    public ScreeningRoom1() {
    }

    public ScreeningRoom1(int id, String roomName, int capacity, String description) {
        this.id = id;
        this.roomName = roomName;
        this.capacity = capacity;
        this.description = description;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "ScreeningRoom1{" +
                "id=" + id +
                ", roomName='" + roomName + '\'' +
                ", capacity=" + capacity +
                '}';
    }
}

