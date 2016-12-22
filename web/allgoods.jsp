<%@ page import="db.PoolConn" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %><%--
  Created by IntelliJ IDEA.
  User: 28713
  Date: 2016/12/20
  Time: 15:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>所有商品</title>
    <link rel="stylesheet" href="css/good.css">
    <link rel="stylesheet" href="css/header.css">
    <link rel="stylesheet" href="css/page.css">
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
<section id="good">
    <%
        String sql = "SELECT count(*) FROM good";
        String sql1 = "SELECT gid,gname,price FROM good LIMIT ?,?";
        PoolConn poolConn = PoolConn.getPoolConn();
        try (Connection conn = poolConn.getConnection();
             PreparedStatement statement = conn.prepareStatement(sql);
             PreparedStatement statement1 = conn.prepareStatement(sql1);
             ResultSet resultSet = statement.executeQuery()
        ) {
            resultSet.next();
            int TotalNum = resultSet.getInt(1);
            int pageSize = 15;
            String pageNo = request.getParameter("pageNo");
            int curNo;
            if (pageNo == null) {
                curNo = 1;
            } else {
                curNo = Integer.parseInt(pageNo);
            }
            int minNum = (curNo - 1) * pageSize;
            int curNum = TotalNum - minNum;
            int TotalPageNo = TotalNum / pageSize + (TotalNum % pageSize > 0 ? 1 : 0);
            int x = 0;
            statement1.setInt(1, minNum);
            statement1.setInt(2, pageSize);
            ResultSet resultSet1 = statement1.executeQuery();
            outLoop:for (int i = 0; i < 3; i++) {
    %>
    <ul>
        <%
            for (int j = 0; j < 5; j++) {
                resultSet1.next();
                x++;
                long gid = resultSet1.getLong(1);
        %>
        <li>
            <div class="dimage"><a href="good.jsp?gid=<%=gid%>">
                <img class="gimage" src="images/<%=gid%>.jpg" alt="图片">
            </a></div>
            <a class="gname" href="good.jsp?gid=<%=gid%>"><%=resultSet1.getString(2)%>
            </a>
            <p class="price">￥<%=resultSet1.getFloat(3)%>
            </p>
        </li>
        <%
                if (x == curNum) {
                    out.print("</ul>");
                    break outLoop;
                }
            }
        %>
    </ul>
    <%
        }
    %>

</section>
<div id="page">
    <%
        String ah = "<a href=\"../allgoods.jsp?curNoNo=";
        String ahb = "\">";
        String ab = "</a>";
        String str = ah + curNo + ahb + curNo + ab;
        for (int i = 0; i <= 3; i++) {
            if (curNo - i > 1)
                str = ah + (curNo - i) + ahb + (curNo - i) + ab + str;
            if (curNo + i < TotalPageNo)
                str = str + ah + (curNo + i) + ahb + (curNo + i) + ab;
            if (curNo - 4 > 1)
                str = "<a href=\"#\">... </a>" + str;
            if (curNo > 1)
                str = ah + (curNo - 1) + ahb + "上一页</a> " +
                        ah + 1 + ahb + 1 + ab + " " + str;
            if (curNo + 4 < TotalPageNo)
                str = str + "<a href=\"#\">... </a>";
            if (curNo < TotalPageNo)
                str = str + " " + ah + TotalPageNo + "\">" + TotalPageNo + ab + " " +
                        ah + (curNo + 1) + ahb + "下一页" + ab;
        }
        out.print(str);
    %>
</div>
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
        resultSet1.close();
        poolConn.returnConnection(conn);
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
</body>
</html>
