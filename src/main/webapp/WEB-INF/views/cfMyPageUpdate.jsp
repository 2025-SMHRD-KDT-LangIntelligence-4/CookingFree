<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<c:set var="cpath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
    <title>회원정보 수정</title>
    <link rel="stylesheet" href="${cpath}/css/cfMyPageUpdate.css" />
</head>
<body>
<jsp:include page="inc/header.jsp" />
<div class="body">
    <div class="all-container">
        <div class="my-page-title">
            <div>My Page</div>
        </div>
        <div class="pr-img-container">
            <div class="pr-img" style="margin-left: 10px;">
                <img>이미지 넣을거에요~
            </div>
            <div class="name-container">
                <div class="usernick">${user.nick}<div>등급</div></div>
                <form id="logoutForm" action="${pageContext.request.contextPath}/logout" method="post" style="display:none;">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                </form>
                <button type="button" onclick="document.getElementById('logoutForm').submit();" class="logout-button" style="margin-right: 10px;">
                    로그아웃
                </button>
            </div>
        </div>
        <form action="${cpath}/updateMyPage" method="post" class="joinform">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <div class="info-container">
                <div>회원정보</div>
                <div><a href="${cpath}/cfMyPageUpdate">회원정보 수정 </a></div>
            </div>
            <div class="myPage-container">
            <div class="div1">이메일</div>
                <div class="userInfo">${user.email}</div>
            </div>
            <div class="myPage-container">
                <div class="div1">닉네임</div>
                <input class="userInfo" value="${user.nick}"></input>
            </div>
            <div class="myPage-container">
                <div class="div1">가입일자</div>
                <div class="userInfo">${user.joined_at}</div>
            </div>
            <div class="myPage-container">
                <div class="div1">선호하는요리</div>
                <input class="userInfo" value="${user.prefer_taste}"></input>
            </div>
            <div class="myPage-container">
                <div class="div1">요리실력</div>
                <input class="userInfo" value="${user.cooking_skill}"></input>
            </div>
            <div class="myPage-container">
                <div class="div1">보유알러지</div>
                <input class="userInfo" value="${user.alg_code}"></input>
            </div>
        </form>
    </div>
</div>
<footer class="footer"></footer>
</body>
</html>