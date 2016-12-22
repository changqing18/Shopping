/**
 * Created by 28713 on 2016/12/21.
 */
function showPages(page, total) {
    var str = "<a href=\"../allgoods.jsp?pageNo=" + page + "\">" + page + "</a>";
    for (var i = 1; i <= 3; i++) {
        if (page - i > 1) {
            str = "<a href=\"../allgoods.jsp\">" + (page - i) + "</a> " + str;
        }
        if (page + i < total) {
            str = str+ " <a href=\"../allgoods.jsp?pageNo=" + (page + i) + "\">" + (page + i) + "</a>";
        }
    }
    if (page - 4 > 1) {
        str = "<a href=\"#\">... </a>" + str;
    }
    if (page > 1) {
        str = "<a href=\"../allgoods.jsp?pageNo=" + (page - 1) + "\">" + "上一页</a> " +
            "<a href=\"../allgoods.jsp?pageNo=1\">1</a>"+" "+ str;
    }
    if (page + 4 < total) {
        str = str +"<a href=\"#\">... </a>";
    }
    if (page < total) {
        str = str + " " + "<a href=\"allgoods.jsp?pageNo=" + total + "\">" + total + "</a>" + " " +
            "<a href=\"../allgoods.jsp?pageNo=" + (page + 1) + "\">" + "下一页</a>";
    }
    return str;
}
function show(page, total) {
    var p=document.getElementById("page");
    p.innerHTML=showPages(page,total);
}
function pageWrite() {
    var page=document.getElementById("curNo").innerText;
    var total=document.getElementById("TotalPageNo").innerText;
    console.log(Number(page));
    console.log(Number(total));
    show(Number(page),Number(total));
}
pageWrite();

