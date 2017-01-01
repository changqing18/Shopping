package servlet;

import db.FunDelete;
import db.PoolConn;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

/**
 * Created by 28713 on 2016/12/27.
 */
@WebServlet(value = "/servlet/Buy", name = "Buy")
public class Buy extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String[] get = request.getParameterValues("checkbox");
        String[][] Trans = new FunDelete().TranString(get);
        int i = Trans.length;
        Long[] orderID = new Long[i];
        Long[] gid = new Long[i];
        int[] number = new int[i];
        for (; i >= 0; i--) {
            orderID[i] = Long.parseLong(request.getParameter(Trans[i][0]));
            gid[i] = Long.parseLong(request.getParameter(Trans[i][1]));
            number[i] = Integer.parseInt(request.getParameter(Trans[i][2]));
        }

        String sql = "SELECT number FROM good WHERE gid=?";
        PoolConn poolConn = PoolConn.getPoolConn();
        try (Connection con = poolConn.getConnection();
             PreparedStatement statement = con.prepareStatement(sql);
             CallableStatement cs = con.prepareCall("CALL buy(?,?,?)")) {
            //先查询库存是否满足，好像效率有点低!
            ResultSet rs = null;
            for (int j = 0; j < Trans.length; j++) {
                statement.setLong(1, gid[j]);
                rs = statement.executeQuery();
                rs.next();
                if (rs.getInt(1) < number[j]) {
                    rs.close();
                    response.sendRedirect("/user_error.html?Email=email&name=name&error=41");
                }
            }
            if (rs != null) rs.close();

            for (int j = 0; j < Trans.length; j++) {
                cs.setLong(1, orderID[j]);
                cs.setLong(2, gid[j]);
                cs.setInt(3, number[j]);
                cs.addBatch();
            }
            cs.executeBatch();
            response.sendRedirect("/user_error.html?Email=email&name=name&error=40");

        } catch (SQLException e) {
            response.sendRedirect("/user_error.html?Email=email&name=name&error=42");
            e.printStackTrace();
        }
    }
}
