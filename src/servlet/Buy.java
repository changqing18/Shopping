package servlet;

import db.FunDelete;
import db.PoolConn;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;

/**
 * Created by 28713 on 2016/12/27.
 */
@WebServlet(value = "/servlet/Buy", name = "Buy")
public class Buy extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session1 = request.getSession();
        String Email = (String) session1.getAttribute("Email");
        if (Email == null)
            response.sendRedirect("/user_error.html?Email=email&name=name&error=40");

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

            String sql = "SELECT number FROM good WHERE gid in(";
            for (int j = 0; j < gid.length - 1; j++)
                sql = sql + gid[j] + ",";
            sql = sql + gid[gid.length - 1] + ");";
            String sql1 = "UPDATE cart SET number=? WHERE orderid=?";

            PoolConn poolConn = PoolConn.getPoolConn();
            try (Connection con = poolConn.getConnection();
                 Statement statement = con.createStatement();
                 PreparedStatement statement1 = con.prepareStatement(sql1);
                 CallableStatement cs = con.prepareCall("CALL buy(?,?,?,?)")) {

                //先查询库存是否满足，好像效率有点低!
                ResultSet rs = statement.executeQuery(sql);
                int x = -1;
                while (rs.next()) {
                    x++;
                    if (rs.getInt(1) < gid[x]) {
                        rs.close();
                        for (int j = 0; j < Trans.length; j++) {//库存不足时，更新数据，并提示不足，调回购物车
                            statement1.setInt(1, number[j]);
                            statement1.setLong(2, orderID[i]);
                            statement1.addBatch();
                        }
                        statement1.executeBatch();
                        response.sendRedirect("/user_error.html?Email=email&name=name&error=41");
                    }
                }
                rs.close();
                //库存满足 执行存储过程（将数据插进border，并从cart中删除相应数据，从good中减去购买数量）
                for (int j = 0; j < Trans.length; j++) {
                    cs.setLong(1, orderID[j]);
                    cs.setString(2, Email);
                    cs.setLong(3, gid[j]);
                    cs.setInt(4, number[j]);
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
