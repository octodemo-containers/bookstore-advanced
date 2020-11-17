package com.github.demo.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebInitParam;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(
    name = "StatusServlet",
    urlPatterns = {"/status"},
    loadOnStartup = 1
)
@WebInitParam(name = "allowedTypes", value = "html")
public class StatusServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;

    // TODO as an improvement, make the database service shared and refer to the connection status of the database
    // to help diagnose our application status.

    public StatusServlet() {
        
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setHeader("Content-Type", "text/html; charset=UTF-8");
        resp.getWriter().write("ok");
    }

}
