package com.github.demo.service;

import com.github.demo.model.Book;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

import java.util.Collection;

public class BookDatabaseImplTest {

    private BookDatabase booksDatabase;

    @Before
    public void setUp() throws Exception {
        booksDatabase = new BookDatabaseImpl();
    }

    @After
    public void tearDown() throws Exception {
        booksDatabase.destroy();
    }

    @Test
    public void testGetAllBooks() throws Exception {
        Collection<Book> books = booksDatabase.getAll();
        assertEquals("Books in database should match", BookUtils.getSampleBooks().size(), books.size());
    }

    @Test
    public void testGetBooksByTitle() throws Exception {
        String title = "Crossing";

        Collection<Book> matched = booksDatabase.getBooksByTitle(title);
        assertEquals("Matched books count for tile ''" + title +"''", 1, matched.size());
    }
}
