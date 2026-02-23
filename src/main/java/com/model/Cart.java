package com.model;

import java.io.Serializable;

public class Cart implements Serializable {
    
    private int cartId;      
    private int userId;     
    private int productId;  
    private int quantity;    
    private String productName;
    private double price;
    private String image;

    public Cart() {}

    // Getters and Setters for Database Columns
    public int getCartId() { return cartId; }
    public void setCartId(int cartId) { this.cartId = cartId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    // Getters and Setters for UI Display
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
}