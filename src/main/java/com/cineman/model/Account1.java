package com.cineman.model;

import java.io.Serializable;

/**
 * Entity Account1 - Tài khoản người dùng (Customer / Manager)
 * Theo thiết kế tầng thực thể hệ thống CineMan
 */
public class Account1 implements Serializable {
    private static final long serialVersionUID = 1L;

    // Thuộc tính ẩn role: "Customer" hoặc "Manager" (hidden input trên MainUI1)
    public static final String ROLE_CUSTOMER = "Customer";
    public static final String ROLE_MANAGER  = "Manager";

    private int id;
    private String username;
    private String password;
    private String fullName;
    private String role; // "Customer" hoặc "Manager"

    public Account1() {}

    public Account1(int id, String username, String password, String fullName, String role) {
        this.id       = id;
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.role     = role;
    }

    public int getId()                   { return id; }
    public void setId(int id)            { this.id = id; }

    public String getUsername()          { return username; }
    public void setUsername(String u)    { this.username = u; }

    public String getPassword()          { return password; }
    public void setPassword(String p)    { this.password = p; }

    public String getFullName()          { return fullName; }
    public void setFullName(String fn)   { this.fullName = fn; }

    public String getRole()              { return role; }
    public void setRole(String r)        { this.role = r; }

    public boolean isManager()           { return ROLE_MANAGER.equalsIgnoreCase(role); }
    public boolean isCustomer()          { return ROLE_CUSTOMER.equalsIgnoreCase(role); }

    @Override
    public String toString() {
        return "Account1{id=" + id + ", username='" + username + "', role='" + role + "'}";
    }
}

