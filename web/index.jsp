<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="db.PoolConn" %><%--
  Created by IntelliJ IDEA.
  User: 28713
  Date: 2016/12/9
  Time: 22:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>快乐购物</title>
    <link rel="stylesheet" href="css/good.css">
    <link rel="stylesheet" href="css/header.css">
    <link rel="stylesheet" href="css/scroll.css">
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
        <li><a href="allgoods.jsp">所有商品</a></li>
        <li><a href="#">购物车</a></li>
        <li><a href="#">我的订单</a></li>
        <li><a href="user_center.jsp">个人中心</a></li>
    </ul>
</section>
<div class="lyc-container">
    <div class="lyc-out">
        <ul class="lyc-inner">
            <li><img src="images/s1.jpg" alt=""></li>
            <li><img src="images/s2.jpg" alt=""></li>
            <li><img src="images/s3.jpg" alt=""></li>
            <li><img src="images/s4.jpg" alt=""></li>
            <li><img src="images/s1.jpg" alt=""></li>
        </ul>
    </div>
    <ul class="lyc-imgs_indexs">
        <li class="lyc-current">1</li>
        <li>2</li>
        <li>3</li>
        <li>4</li>
    </ul>
    <p class="lyc-left"></p>
    <p class="lyc-right"></p>
</div>
<script src="js/scroll.js"></script>
<section id="good">
    <%
        String sql = "SELECT gid,gname,price FROM good LIMIT 0,5";
        PoolConn poolConn = PoolConn.getPoolConn();
        try (Connection conn = poolConn.getConnection();
             PreparedStatement statement = conn.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()
        ) {
    %>
    <ul>
        <%
            for (int i = 0; i < 5; i++) {
                resultSet.next();
                long gid = resultSet.getLong(1);
        %>
        <li>
            <div class="dimage"><a href="good.html?gid=<%=gid%>">
                <img class="gimage" src="images/<%=gid%>.jpg" alt="图片">
            </a></div>
            <a class="gname" href="good.html?gid=<%=gid%>"><%=resultSet.getString(2)%>
            </a>
            <p class="price">￥<%=resultSet.getFloat(3)%>
            </p>
        </li>
        <%
            }
        %>
    </ul>
</section>
<footer id="page_footer">
    <p>Copyrights &copy; 2016 AweseomeCo.</p>
    <nav>
        <ul>
            <li><a href="#">Home</a></li>
            <li><a href="#">About</a></li>
            <li><a href="#">Terms of Service</a></li>
            <li><a href="#">Privacy</a></li>
        </ul>
    </nav>
</footer>
<%
        poolConn.returnConnection(conn);
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
</body>
</html>
