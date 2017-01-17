<%@ page import="db.PoolConn" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %><%--
  Created by IntelliJ IDEA.
  User: 28713
  Date: 2016/12/25
  Time: 16:19
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>商品详情</title>
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
    long gid = Long.parseLong(request.getParameter("gid"));
    String sql = "SELECT gname,price,number FROM good WHERE gid=?";
    PoolConn poolConn = PoolConn.getPoolConn();
    try (Connection con = poolConn.getConnection();
         PreparedStatement statement = con.prepareStatement(sql)) {
        statement.setLong(1, gid);
        ResultSet resultSet = statement.executeQuery();
        resultSet.next();
%>
<div id="good">
    <div id="image">
        <img src="images/<%=gid%>.jpg" height="220" width="220"/>
    </div>
    <div id="form">
        <p id="gname"><%=resultSet.getString(1)%></p>
        <p id="price">￥<%=resultSet.getFloat(2)%></p>
        <form method="post" action="servlet/Ad_cart">
            <ul>
                <li>选择版本:
                    <label for="type1">默认</label>
                    <input id="type1" name="type" type="radio" value="0">
                    <input type="hidden" name="gid" value="<%=gid%>">
                </li>
                <li>选择颜色：
                    <label for="color1">白色</label>
                    <input type="radio" id="color1" name="color" value="white">
                    <label for="color2">黑色</label>
                    <input type="radio" id="color2" name="color" value="black">
                </li>
                <li>套餐类型：
                    <label for="spec1">裸机</label>
                    <input type="radio" id="spec1" name="spec" value="1">
                </li>
                <li>储存容量：
                    <label for="cap1">64G</label>
                    <input type="radio" id="cap1" name="cap" value="64">
                </li>
                <li>数量
                    <label for="number"></label>
                    <input type="number" id="number" name="number" min="1"
                           max="<%=resultSet.getInt(3)%>">&nbsp;&nbsp;
                    <div id="stock">
                        库存<%=resultSet.getInt(3)%>件
                    </div>
                </li>
                <li>
                    <input type="submit" value="加入购物车" id="submit">
                </li>
            </ul>
        </form>
    </div>
</div>
<%
        resultSet.close();
        poolConn.returnConnection(con);
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
</body>
</html>
