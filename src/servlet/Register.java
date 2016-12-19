package servlet;

import db.PoolConn;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 * Created by 28713 on 2016/12/10.
 */
@WebServlet(value = "/servlet/Register", name = "Register")
public class Register extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        String sql = "insert into user values(?,?,?)";
        String[] array = {name, email, password};

        try {
            int i=PoolConn.getPoolConn().preparedStatement(sql,array);
            if (i== 1) {
                response.sendRedirect("/user_error.html?Email=" + email + "&name=" + name + "&error=10");
            } else {
                response.sendRedirect("/user_error.html?Email=" + email + "&name=" + name + "&error=12");
            }
        } catch (SQLException e) {
            if(e.getMessage().contains("Duplicate entry"))
                response.sendRedirect("/user_error.html?Email=" + email + "&name=" + name + "&error=11");
            else {
                e.printStackTrace();
            }
        }
    }
}
