package db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 * Created by 28713 on 2016/12/17.
 */
public class PoolConn{

    private static final ConnectionPool connection = new ConnectionPool(
            "com.mysql.jdbc.Driver", "",
            "", "");

    private static final PoolConn poolConn = new PoolConn();

    public ConnectionPool getPool() {
        return connection;
    }

    public Connection getConnection() throws SQLException {
        try {
            connection.createPool();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return connection.getConnection();
    }

    public void returnConnection(Connection conn) {
        connection.returnConnection(conn);
    }

    public static PoolConn getPoolConn() {
        return poolConn;
    }

    public int preparedStatement(String sql,String[] array) throws SQLException{
        Connection conn=poolConn.getConnection();
        PreparedStatement statement=conn.prepareStatement(sql);
        for (int i = 0; i < array.length; i++) {
            statement.setString(i+1,array[i]);
        }
        int i=statement.executeUpdate();
        statement.close();
        poolConn.returnConnection(conn);
        conn.close();
        return i;
    }
}