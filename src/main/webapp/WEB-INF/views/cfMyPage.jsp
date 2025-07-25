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
	<div class="myPage-title-container">
		<div class="myPage-title">
			<div>My Page</div>
		</div>
	</div>
	<div class="full-container">
		<div class="pr-img-container">
			<div class="pr-img">이미지 넣을거에요~</div>
			<div class="usernick" style="width:310px;">닉네임<div>등급</div></div>
			<button class="logout">로그아웃</button>
		</div>
	</div>
	<div class="full-container">
		<div class="myPage-info-container">
			<div style="margin-left:20px;">회원정보</div><div style="margin-left:330px;">회원정보 수정</div>
		</div>
		<div class="myPage-container">
			<div>이메일</div><div >사용자 이메일 출력칸입니다~</div>  
		</div>
		<div class="myPage-container">
			<div>소셜아이디</div><div >사용자 소셜아이디 출력칸입니다~</div>  
		</div>
		<div class="myPage-container">
			<div>가입일자</div><div >사용자 가입일자 출력칸입니다~</div>  
		</div>
		<div class="myPage-user-container">
			<div style="margin-left:20px;">이용정보</div><div style="margin-left:330px;">이용정보 수정</div>
		</div>
		<div class="myPage-container">
			<div>선호하는요리</div><div >사용자 선호요리 출력칸입니다~</div>  
		</div>
		<div class="myPage-container">
			<div>요리실력</div><div >사용자 요리실력 출력칸입니다~</div>  
		</div>
		<div class="myPage-container">
			<div>보유알러지</div><div >사용자 알러지내역 출력칸입니다~</div>  
		</div>
	</div>
	<footer class="footer"></footer>
<!---------------------------------------------------페이지 양식입니다.------------------------------------------------------------- -->
</body>
</html>