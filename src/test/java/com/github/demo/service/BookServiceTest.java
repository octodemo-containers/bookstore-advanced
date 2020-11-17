package com.github.demo.service;

import com.github.demo.model.Book;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.util.List;

import static org.junit.Assert.assertEquals;

/**
 * Unit test for BookService
 */
public class BookServiceTest {

    private BookService bookService;

    @Test
    public void testGetBooks() throws Exception {
        List<Book> books = bookService.getBooks();
        assertEquals("list length should be 6", 6, books.size());
    }

    @Before
    public void setUp() throws Exception{
        bookService = new BookService();
    }

    @After
    public void tearDown() {
        bookService = null;
    }
}