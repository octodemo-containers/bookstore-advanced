package com.github.demo.model;

/**
 * Model class for book.
 */
public class Book {

    private String title;

    private String author;

    private String cover;

    private int rating;

    public Book() {
        this.title = "";
        this.author = "";
        this.cover = "";
        this.rating = 0;
    }

    public Book(String author, String title) {
        this();
        this.author = author;
        this.title = title;
    }

    public Book(String author, String title, String cover) {
        this();
        this.author = author;
        this.title = title;
        this.cover = cover;
    }

    public Book(String author, String title, String cover, int rating) {
        this();
        this.author = author;
        this.title = title;
        this.cover = cover;
        this.rating = rating;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getDetails() {
        return author + " " + title;
    }

    public String getCover() {
        return cover;
    }

    public void setCover(String cover) {
        this.cover = cover;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }
}
