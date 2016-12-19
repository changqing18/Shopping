<%@ page import="db.PoolConn" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.ResultSet" %><%--
  Created by IntelliJ IDEA.
  User: 28713
  Date: 2016/12/17
  Time: 22:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>用户中心</title>
    <link rel="stylesheet" href="css/user_comm.css">
    <style>
        #box {
            width: 360px;
            margin: auto;
            font-family: "微软雅黑", "黑体", "Arial";
            font-size: 20px;
            text-align: center;
        }
        label {
            width: 90px;
        }
        form {
            width: 360px;
        }
        #change_name, #chang_passwd {
            width: 120px;
            display: block;
            margin: auto;
            background-color: #9bdfe5;
            height: 34px;
            font-size: 25px;
            font-family: "微软雅黑", "黑体", "Arial";
        }
    </style>
    <script>
        function check() {
            var pass1 = document.getElementById("password").value;
            var pass2 = document.getElementById("password_confirmation").value;
            if (pass1 != pass2) {
                alert("两次密码输入不一致！");
                return false;
            } else
                return true;
        }
    </script>
</head>
<body>
<%
    PoolConn poolConn = PoolConn.getPoolConn();
    session = request.getSession();
    String Email = (String) session.getAttribute("Email");
    if (Email == null) {
        response.sendRedirect("user_error.html?Email=&name=&error=21");
    }

    String username = request.getParameter("username");

    if (username != null) {
        String sql = "update user set username=? where email=?";
        String[] array = {username, Email};
        int i = -1;
        try {
            i = poolConn.preparedStatement(sql, array);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        if (i != 1) {
            response.sendRedirect("user_error.html?Email=&name=&error=-1");
        }
    } else {
        String sql = "SELECT username FROM user WHERE email=?";
        try (Connection conn = poolConn.getConnection();
             PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setString(1, Email);
            ResultSet resultSet = statement.executeQuery();
            resultSet.next();
            username = resultSet.getString(1);
            resultSet.close();
            poolConn.returnConnection(conn);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    if (request.getParameter("password") != null) {
        String sql = "update user set password=? where email=?";
        String[] array = {request.getParameter("password"), Email};
        int i = -1;
        try {
            i = poolConn.preparedStatement(sql, array);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        if (i != 1) {
            response.sendRedirect("user_error.html?Email=&name=&error=-1");
        }
    }
%>
<div id="box">
    邮箱:&nbsp;&nbsp;<%=Email%>
</div>

<form method="post" action="user_center.jsp">
    <ol>
        <li>
            <label for="name">昵称</label>
            <input id="name" name="username" type="text" value="<%=username%>" required>
        </li>
        <li><input id="change_name" value="修改昵称" type="submit"></li>
    </ol>
</form>

<form class="change" method="post" action="user_center.jsp">
    <ol>
        <li>
            <label for="password">密码</label>
            <input id="password" type="password" name="password" value="" autocomplete="off"
                   placeholder="8个字符及以上"
                   pattern="^\w{8,20}$"
                   title="请输入8到20位字符，包含字母、数字以及下划线" required/>
        </li>
        <li>
            <label for="password_confirmation">确认密码</label>
            <input id="password_confirmation" type="password"
                   name="password_confirmation" value="" autocomplete="off"
                   placeholder="请再次输入您的密码" required/>
        </li>
        <li><input id="chang_passwd" value="修改密码" type="submit" onclick="return check()"></li>
    </ol>
</form>
</body>
</html>
