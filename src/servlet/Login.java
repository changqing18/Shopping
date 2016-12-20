package servlet;

import db.PoolConn;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Created by 28713 on 2016/12/10.
 */
@WebServlet(value = "/servlet/Login", name = "Login")
public class Login extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String sql = "SELECT password FROM user WHERE email=?";
        PoolConn poolConn=PoolConn.getPoolConn();
        try (Connection conn=poolConn.getConnection();
             PreparedStatement statement = conn.prepareStatement(sql)) {

             statement.setString(1,email);
             ResultSet resultSet=statement.executeQuery();
             poolConn.returnConnection(conn);
            if (!resultSet.next()) {
                //输出不存在该用户，并调回登录界面 连同之前进入登录界面的url,以及email
                resultSet.close();
                response.sendRedirect("/user_error.html?Email=" + email + "&name=name&error=2");
            } else if (!password.equals(resultSet.getString(1))) {
                //输出密码错误，返回登录界面，连同之前进入登录界面的url,以及email
                resultSet.close();
                response.sendRedirect("/user_error.html?Email=" + email + "&name=name&error=1");
            } else {
                resultSet.close();
                Cookie[] cookies = request.getCookies();
                String preUrl="/index.jsp";
                for (Cookie cookie : cookies) {
                    if (cookie.getName().equals("preurl")) {
                        preUrl=cookie.getValue();
                        cookie.setMaxAge(0);
                        cookie.setPath("/");
                        response.addCookie(cookie);
                        break;
                    }
                }
                Cookie cookie = new Cookie("user", email);
                cookie.setMaxAge(60*60*24*7);
                cookie.setPath("/");
                response.addCookie(cookie);

                HttpSession session1 = request.getSession();
                session1.setAttribute("Email",email);
                response.sendRedirect(preUrl);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}