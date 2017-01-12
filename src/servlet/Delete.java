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
 * Created by 28713 on 2016/12/27.
 */
@WebServlet(value = "/servlet/Delete", name = "Delete")
public class Delete extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String gid = request.getParameter("gid");

        String sql = "DELETE FROM cart WHERE gid=?";
        PoolConn poolConn = PoolConn.getPoolConn();
        try (Connection con = poolConn.getConnection();
             PreparedStatement statement = con.prepareStatement(sql)) {
            if (gid != null) {
                statement.setString(1, gid);
                statement.executeUpdate();
                response.sendRedirect("/user_error.html?Email=&name=&&error=50");
            } else {
                response.sendRedirect("/user_error.html?Email=&name=&&error=52");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
