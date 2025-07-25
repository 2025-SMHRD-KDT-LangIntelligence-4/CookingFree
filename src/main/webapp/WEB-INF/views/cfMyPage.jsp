<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
    <c:set var="cpath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head><!-- s -->
 	<title>Document</title>
 	<link rel="stylesheet" href="${cpath}/css/cfMyPage.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
<jsp:include page="inc/header.jsp" />
	<div class="myPage-title-container">
		<div class="myPage-title">
			<div>My Page</div>
		</div>
	</div>
	<div class="full-container">
		<div class="pr-img-container">
			<div class="pr-img">이미지 넣을거에요~</div>
			<div class="usernick" style="width:310px;">${user.nick}<div>등급</div></div>
			<!-- 로그아웃 버튼 전용 안보이는 form -->
			<form id="logoutForm" action="${pageContext.request.contextPath}/logout" method="post" style="display:none;">
			  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
			</form> 
			<button type="button" onclick="document.getElementById('logoutForm').submit();" class="logout-button">
			  로그아웃
			</button>
		</div>
	</div>
	<div class="full-container">
		<div class="myPage-info-container">
			<div style="margin-left:20px;">회원정보</div><div style="margin-left:330px;" ><a href="${cpath}/cfMyPageUpdate">회원정보 수정 </a></div>
		</div>
		<div class="myPage-container">
			<div>이메일</div><div >${user.email}</div>  
		</div>
		<div class="myPage-container">
			<div>닉네임</div><div >${user.nick}</div>  
		</div>
		<div class="myPage-container">
			<div>가입일자</div><div >${user.joined_at}</div>  
		</div>
		<div class="myPage-user-container">
			<div style="margin-left:20px;">이용정보</div><div style="margin-left:330px;">이용정보 수정</div>
		</div>
		<div class="myPage-container">
			<div>선호하는요리</div><div >${user.prefer_taste}</div>  
		</div>
		<div class="myPage-container">
			<div>요리실력</div><div >${user.cooking_skill}</div>  
		</div>
		<div class="myPage-container">
			<div>보유알러지</div><div >${user.alg_code}</div>  
		</div>
	</div>
	<footer class="footer"></footer>
<!---------------------------------------------------페이지 양식입니다.------------------------------------------------------------- -->
</body>
</html>