<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
    <c:set var="cpath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
 	<title>Document</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
<style type="text/css">
.div, .div * {
	box-sizing: border-box;
}

.div {
	background: #ffffff;
	height: 1116px;
	position: relative;
	box-shadow: 0px 4px 4px 0px rgba(0, 0, 0, 0.25);
	overflow: hidden;
}

.group-4 {
	position: absolute;
	inset: 0;
}

.div2 {
	background: linear-gradient(to left, rgba(0, 0, 0, 0.2),
		rgba(0, 0, 0, 0.2));
	border-style: solid;
	border-color: #000000;
	border-width: 0px 1px 1px 0px;
	width: 100%;
	height: 100%;
	position: absolute;
	right: 0%;
	left: 0%;
	bottom: 0%;
	top: 0%;
	overflow: hidden;
}

.loginform {
	background: rgba(255, 255, 255, 0.8);
	border-radius: 30px;
	border-style: solid;
	border-color: #bababa;
	border-width: 3px;
	width: 45%;
	height: 60%;
	position: absolute;
	right: 23.96%;
	left: 23.96%;
	bottom: 11.11%;
	top: 17.2%;
	box-shadow: 0px 4px 4px 0px rgba(0, 0, 0, 0.25);
	overflow: hidden;
}

.login {
	color: #000000;
	text-align: center;
	font-family: "Inter-BoldItalic", sans-serif;
	font-size: 70px;
	font-weight: 700;
	font-style: italic;
	position: absolute;
	right: 3.33%;
	left: 3.44%;
	width: 93.22%;
	bottom: 73.62%;
	top: 0.21%;
	height: 26.17%;
	display: flex;
	align-items: flex-end;
	justify-content: center;
}

.div3 {
	position: absolute;
	inset: 0;
}

.pw {
	background: linear-gradient(to left, #ffffff, #ffffff),
		linear-gradient(to left, #ffffff, #ffffff),
		linear-gradient(to left, #ffffff, #ffffff);
	border-style: solid;
	border-color: #bababa;
	border-width: 3px;
	width: 60%;
	height: 11.5%;
	position: absolute;
	right: 10%;
	left: 20%;
	bottom: 43.83%;
	top: 44.67%;
	overflow: hidden;
}

.id {
	background: linear-gradient(to left, #ffffff, #ffffff),
		linear-gradient(to left, #ffffff, #ffffff),
		linear-gradient(to left, #ffffff, #ffffff);
	border-style: solid;
	border-color: #bababa;
	border-width: 3px;
	width: 60%;
	height: 11.5%;
	position: absolute;
	right: 10%;
	left: 20%;
	bottom: 56.58%;
	top: 31.92%;
	overflow: hidden;
}

.loginData {
	width: 44.22%;
	height: 11.83%;
	position: absolute;
	right: 22.56%;
	left: 33.22%;
	bottom: 31.42%;
	top: 56.75%;
}

.searchIdPw {
	color: #000000;
	text-align: center;
	font-family: "Inter-BoldItalic", sans-serif;
	font-size: 15px;
	font-weight: 700;
	font-style: italic;
	position: absolute;
	right: 30%;
	left: 0%;
	width: 60%;
	bottom: 45%;
	top: 70%;
	height: 9%;
	display: flex;
	align-items: center;
	justify-content: center;
}

.createUser {
	color: #000000;
	text-align: left;
	font-family: "Inter-BoldItalic", sans-serif;
	font-size: 15px;
	font-weight: 700;
	font-style: italic;
	position: absolute;
	right: 0%;
	left: 70%;
	width: 45%;
	bottom: 45%;
	top: 70%;
	height: 9%;
	display: flex;
	align-items: center;
	justify-content: flex-start;
}

.sns {
	position: absolute;
	inset: 0;
}

.conn1 {
	background: #ffffff;
	border-radius: 100px;
	width: 14%;
	height: 15%;
	position: absolute;
	right: 43%;
	left: 43%;
	bottom: 16%;
	top: 69%;
	overflow: hidden;
}

.conn2 {
	background: #ffffff;
	border-radius: 100px;
	width: 14%;
	height: 15%;
	position: absolute;
	right: 24%;
	left: 62%;
	bottom: 16%;
	top: 69%;
	overflow: hidden;
}

.conn3 {
	background: #ffffff;
	border-radius: 100px;
	width: 14%;
	height: 15%;
	position: absolute;
	right: 62%;
	left: 24%;
	bottom: 16%;
	top: 69%;
	overflow: hidden;
}

.gnb {
	width: 1202.27px;
	height: 120px;
	position: static;
}

.menu {
	background: rgba(255, 255, 255, 0);
	padding: 26px 15px 26px 40px;
	display: flex;
	flex-direction: row;
	gap: 5px;
	align-items: center;
	justify-content: flex-start;
	width: 16.61%;
	height: 10.74%;
	position: absolute;
	right: 68.23%;
	left: 15.16%;
	bottom: 89.26%;
	top: 0%;
}

.ic-baseline-menu {
	flex-shrink: 0;
	width: 80px;
	height: 80px;
	position: relative;
	overflow: visible;
}

.main {
	background: rgba(255, 255, 255, 0);
	padding: 26px 15px 26px 15px;
	display: flex;
	flex-direction: row;
	gap: 10px;
	align-items: center;
	justify-content: flex-start;
	width: 36.35%;
	height: 10.74%;
	position: absolute;
	right: 31.87%;
	left: 31.77%;
	bottom: 89.26%;
	top: 0%;
}

.cook-in-g-free {
	color: #ffffff;
	text-align: center;
	font-family: "Inter-BoldItalic", sans-serif;
	font-size: 50px;
	font-weight: 700;
	font-style: italic;
	position: relative;
	flex: 1;
	height: 15px;
	display: flex;
	align-items: center;
	justify-content: center;
}

.my-page {
	background: rgba(255, 255, 255, 0);
	padding: 26px 15px 26px 15px;
	display: flex;
	flex-direction: row;
	gap: 10px;
	align-items: center;
	justify-content: center;
	width: 5.54%;
	height: 10.74%;
	position: absolute;
	right: 26.34%;
	left: 68.13%;
	bottom: 89.25%;
	top: 0.01%;
}

.ic-baseline-person-outline {
	flex-shrink: 0;
	width: 50px;
	height: 50px;
	position: relative;
	overflow: visible;
	aspect-ratio: 1;
}

.recipe {
	display: flex;
	flex-direction: row;
	gap: 10px;
	align-items: center;
	justify-content: center;
	width: 5.54%;
	height: 10.74%;
	position: absolute;
	right: 20.8%;
	left: 73.66%;
	bottom: 89.26%;
	top: 0%;
	overflow: visible;
}

.setting {
	background: rgba(255, 255, 255, 0);
	padding: 26px 15px 26px 15px;
	display: flex;
	flex-direction: row;
	gap: 10px;
	align-items: center;
	justify-content: center;
	width: 5.54%;
	height: 10.74%;
	position: absolute;
	right: 15.26%;
	left: 79.2%;
	bottom: 89.26%;
	top: 0%;
}

.lets-icons-setting-line {
	flex-shrink: 0;
	width: 50px;
	height: 50px;
	position: relative;
	overflow: visible;
	aspect-ratio: 1;
}
</style>
</head>
<body>
<div class="gnb">
    <div class="menu">
        <img class="ic-baseline-menu" src="${cpath}/upload/Vector.png" />
    </div>
    <div class="main">
        <div class="cook-in-g-free">CookIN(G)Free</div>
    </div>
    <div class="my-page">
        <img
          class="ic-baseline-person-outline"
          src="${cpath}/upload/Vectorinfo.svg"
        />
    </div>
      <img class="recipe" src="${cpath}/upload/Vectorfood.svg" />
    <div class="setting">
        <img class="lets-icons-setting-line" src="${cpath}/upload/Vectorsetting.svg" />
    </div>
</div>
<div class="loginForm">
  <div
    class="div2"
    style="
      background: url(${cpath}/upload/간계밥.jpg) center;
      background-size: cover;
      background-repeat: no-repeat;
    "
  >
    <div class="loginform">
      <div class="login">LOGIN</div>
      <input class="id" style="font-size : 25px;"></input>
      <input type="password" class="pw" style="font-size : 25px;"></input>
      <div class="loginData">
        <div class="searchIdPw">아이디/비밀번호 찾기</div>
        <div class="createUser">회원가입</div>
      </div>
      <div class="conn1" title="계정연동1"></div>
      <div class="conn2" title="계정연동2"></div>
      <div class="conn3" title="계정연동3"></div>
    </div>
  </div>
</div>

</body>
</html>