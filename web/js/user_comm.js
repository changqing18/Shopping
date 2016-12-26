/**
 * Created by 28713 on 2016/12/11.
 */
function PreUrl() {
    var u = document.referrer;
    var date = new Date();
    date.setMinutes(date.getMinutes() + 30);

    if (u == "")
        u = "/index.jsp";

    if (u.indexOf("_error.html") == -1 &&
        u.indexOf("register.html") == -1 &&
        u.indexOf("login.html") == -1) {
        document.cookie = "preurl=\"" + u + "\"; expires=" + date.toUTCString() + "path=/";
    }
}
function getRequest() {
    var Email = "";
    var name = "";
    var error=-1;
    var requests = location.search;
    if (requests.indexOf("?") != -1) {
        var str = requests.substr(1).split("&");
        try {
            Email = decodeURIComponent(str[0].split("=")[1]);
            name = decodeURIComponent(str[1].split("=")[1]);
            error = str[2].split("=")[1];
        }catch(ignored){ }
    }
    return [Email,name,error];
}