<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
    <c:set var="cpath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
 	<title>Document</title>
 	<link rel="stylesheet" href="${cpath}/css/cfMyPageUpdate.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body><!-- s -->
<jsp:include page="inc/header.jsp" />
	<div class="myPage-title-container">
		<div class="myPage-title">
			<div>My Page</div>
		</div>
	</div>
	<div class="pr-img-container">
		<div class="pr-img">이미지 넣을거에요~</div>
	</div>
	<div class="myPage-container">
		<div>닉네임</div><input placeholder="사용자 닉네임 출력칸입니다~"></input>  
	</div>
	<div class="myPage-container">
		<div>아이디</div><input placeholder="사용자 아이디 출력칸입니다~"></input>  
	</div>
	<div class="myPage-container">
		<div>이메일</div><input placeholder="사사용자 이메일 출력칸입니다~"></input>  
	</div>
	<div class="myPage-container">
		<div>소셜아이디</div><input placeholder="사용자 소셜아이디 출력칸입니다~"></input>  
	</div>
	<div class="myPage-container">
		<div>선호하는요리</div><input placeholder="사용자 선호요리 출력칸입니다~"></input>  
	</div>
	<div class="myPage-container">
		<div>요리실력</div><input placeholder="사용자 요리실력 출력칸입니다~"></input>  
	</div>
	<div class="myPage-container">
		<div>가입일자</div><input placeholder="사용자 가입일자 출력칸입니다~"></input>  
	</div>
<!---------------------------------------------------페이지 양식입니다.------------------------------------------------------------- -->
</body>
</html>