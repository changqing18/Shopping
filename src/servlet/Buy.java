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
@WebServlet(value = "/servlet/Buy", name = "Buy")
public class Buy extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        String[] get = request.getParameterValues("checkbox");
//        String[][] Trans = new FunDelete().TranString(get);
//        int i = Trans.length;
//        Long[] orderid = new Long[i];
//        Long[] gid = new Long[i];
//        int[] number = new int[i];
//        for (; i >= 0; i--) {
//            orderid[i] = Long.parseLong(request.getParameter(Trans[i][0]));
//            gid[i] = Long.parseLong(request.getParameter(Trans[i][1]));
//            number[i] = Integer.parseInt(request.getParameter(Trans[i][2]));
//        }
        String[] orderID=request.getParameterValues("checkbox");

        String sql = "INSERT INTO border (orderid,gid,number,email) " +
                "SELECT orderid,gid,number,email FROM cart WHERE orderid=?";
        String sql1="delete from cart where orderid=?";
        PoolConn poolConn = PoolConn.getPoolConn();
        try (Connection con = poolConn.getConnection();
             PreparedStatement statement = con.prepareStatement(sql);
             PreparedStatement statement1=con.prepareStatement(sql1)
        ) {
            for (String anOrderID : orderID) {
                Long temp=Long.parseLong(anOrderID);
                statement.setLong(1, temp);
                statement.addBatch();
                statement1.setLong(1,temp);
                statement1.addBatch();
            }
            statement.executeBatch();
            statement1.executeBatch();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
