package servlet;

import db.PoolConn;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;

/**
 * Created by 28713 on 2016/12/26.
 */
@WebServlet(value = "/servlet/Ad_cart", name = "Ad_cart")
public class Ad_cart extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String Email = (String) session.getAttribute("Email");
        if (Email == null)
            response.sendRedirect("/user_error.html?Email=email&name=name&error=21");
        long gid = Long.parseLong(request.getParameter("gid"));
        int number = Integer.parseInt(request.getParameter("number"));
        PoolConn poolConn = PoolConn.getPoolConn();
        try (Connection con = poolConn.getConnection();
             CallableStatement cs = con.prepareCall("CALL cart_merge(?,?,?,?)")) {
            cs.setLong(1, System.currentTimeMillis());
            cs.setString(2, Email);
            cs.setLong(3, gid);
            cs.setInt(4, number);
            int i=cs.executeUpdate();
            poolConn.returnConnection(con);
            if(i==1)
                response.sendRedirect("/user_error.html?Email=email&name=name&error=30");
            else{
                response.sendRedirect("/user_error.html?Email=email&name=name&error=32");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
