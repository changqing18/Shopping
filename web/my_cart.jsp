<%@ page import="db.PoolConn" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %><%--
  Created by IntelliJ IDEA.
  User: 28713
  Date: 2016/12/27
  Time: 16:20
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>我的购物车</title>
</head>
<body>
<header>
    <%
        session = request.getSession();
        String Email = (String) session.getAttribute("Email");
        if (Email == null) {
    %>
    <a href="login.html">请登录</a>&nbsp;&nbsp;<a href="register.html">请注册</a>
    <%
    } else {
    %>
    欢迎您<a href="user_center.jsp"><%=Email%>
</a>
    <%
        }
    %>
</header>
<section id="nav">
    <ul>
        <li><a href="index.jsp">首页</a></li>
        <li><a href="all_goods.jsp">所有商品</a></li>
        <li><a href="my_cart.jsp">购物车</a></li>
        <li><a href="my_order.jsp">我的订单</a></li>
        <li><a href="user_center.jsp">个人中心</a></li>
    </ul>
</section>
<%
    String sql = "SELECT gorder.orderid,gorder.gid,gorder.number,good.gname FROM gorder good " +
            "WHERE gorder.email=?&&gorder.gid=good.gid";
    PoolConn poolConn = PoolConn.getPoolConn();
    try (Connection con = poolConn.getConnection();
         PreparedStatement statement = con.prepareStatement(sql)) {
        statement.setString(1, Email);
        ResultSet resultSet = statement.executeQuery();
%>
<form method="post" action="servlet/Buy">
    <table>
    <%
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy年MM月dd日HH时mm分");
        Date date;
        long gid;
        String time;
        while (resultSet.next()) {
            int i=0;
            i++;
            gid=resultSet.getLong(2);
            date=new Date(gid);
            time=formatter.format(date);
    %>
<tr>
    <td><label for="checkbox<%=i%>"></label>
        <input id="checkbox<%=i%>" type="checkbox" name="checkbox" value="<%=i%>">
    </td>
    <td>
        <%=time%>
    </td>
    <td>
        <a href="good.jsp?gid=<%=gid%>"><%=resultSet.getString(4)%></a>
    </td>
    <td>
        <label for="number<%=i%>"></label>
        <input class="number" type="number" id="number<%=i%>" name="number<%=i%>"
               min="1" max="<%=resultSet.getInt(3)%>" value="<%=resultSet.getInt(3)%>">
    </td>
    <td>
        <a href="servlet/Delete?gid=<%=gid%>"></a>
    </td>
</tr>
    <%

            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    %>
    </table>
    <input type="submit" id="submit" value="立刻购买">
    <%--TODO 删除--%>
    <a href="servlet/Delete">删除所选</a>
</form>
</body>
</html>
