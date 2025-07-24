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
<style>
/* GNB */
.gnb {
	display: flex; /*화면을 능동으로 배치할때*/
	flex-wrap: nowrap; /*수직정렬을 제한함 근데 기능 구현이 실패한듯함*/
	justify-content: space-between;
	align-items: center;
	padding: 20px 20px;
	background: #fff;
	overflow-x: auto;
	border-bottom: 1px solid #ddd;
	box-sizing: border-box;
	gap: 12px;
}

/* 왼쪽/오른쪽 아이콘 링크 */
.gnb-left a, .gnb-right a {
	display: flex;
	align-items: center;
	margin-left: 10px;
	text-decoration: none;
}

/* 가운데 로고 */
.gnb-center {
	flex: 0 1 auto; /* 기본값 auto 유지 + 필요시 줄어듬 */
	min-width: 80px; /* 최소 넓이 확보 */
	position: absolute;
	left: 50%;
	transform: translateX(-50%);
}

.logo {
	font-size: clamp(18px, 4vw, 32px); /* 반응형 크기 */
	font-weight: bold;
	font-family: 'Inter', sans-serif;
	color: #000;
}

/* 오른쪽 아이콘들 */
.gnb-right {
	display: flex;
	gap: 12px;
}

/* 아이콘 유동 크기 + 최소한의 보장 */
.icon {
	width: clamp(18px, 5vw, 36px);
	height: clamp(18px, 5vw, 36px);
	min-width: 18px;
	min-height: 18px;
	object-fit: contain;
}
/* 모바일 대응 */
@media ( max-width : 768px) {
	.gnb {
		padding: 12px;
		gap: 8px;
	}
	.gnb-right a {
		margin-left: 6px;
	}
}
/*--------------------------------------------------------------------gnb배너입니다--------------------------------------------------------*/
.myPage-container{
	display: flex;
	align-items: center;
	margin-top: 1rem;
	width: 100%;
	box-sizing: border-box;
	justify-content: left;
	border-bottom: 1px solid #ddd;
	
}
.full-container{
	box-sizing: border-box;
	max-width: 600px;
	padding-left:40px;
	margin: 0 auto; 
}
.myPage-title{
	display: flex;
	align-items: center;
	margin-top: 3rem;
	width: fit-content;
	box-sizing: border-box;
	justify-content: center;
	font-size:50px;
	padding:10px 40px;
	margin-bottom:50px;
	border-bottom: 3px solid #ddd; 
}
.myPage-title-container{
	display: flex;
	justify-content: center;
	width:100%;
}
.pr-img{
	box-sizing: border-box;
	border-radius: 50%;
	background-color:#c79d9d;
	width:100px;
	height:100px;
	overflow:hidden;
	align-items: center;
	margin-right:20px;
	margin-left:20px;
}
.myPage-container input{
	width : 300px;
	box-sizing: border-box;
	padding: 10px;
	font-size: 1rem;
}
.myPage-container div{
	width: auto;
	box-sizing: border-box;
	padding: 10px;
	font-size: 1rem;
	margin-right: 10px;
}
.pr-img-container{
	display: flex;
	align-items: center;
	margin-top: 1rem;
	width: 100%;
	box-sizing: border-box;
	justify-content: left;
	margin-bottom:3rem;
}
.footer{
	width:100%;
	height:100px;
}
.myPage-info-container{
	display: flex;
	align-items: center;
	margin-top: 1rem;
	width: 100%;
	box-sizing: border-box;
	justify-content: left;
	border-bottom: 3px solid #ddd;
	padding:10px;
}
.myPage-user-container{
	display: flex;
	align-items: center;
	margin-top: 4rem;
	width: 100%;
	box-sizing: border-box;
	justify-content: left;
	border-bottom: 3px solid #ddd;
	padding:10px;
}
</style>
</head>
<body>
<!--------------------------------------------------------gnb 배너입니다.---------------------------------------------------------- -->
<div class="gnb">
	<div class="gnb-left">
		<a href="#"><img src="${cpath}/upload/Vector.png" class="icon" /></a>
	</div>
	<div class="gnb-center">
		<a href="${cpath}" style="text-decoration-line: none;"><div class="logo">CookIN(G)Free</div></a>
	</div>
	<div class="gnb-right">
		<a href="cfLogin"><img src="${cpath}/upload/Vectorinfo.svg"
			class="icon" /></a> <a href="#"><img
			src="${cpath}/upload/Vectorfood.svg" class="icon" /></a> <a href="#"><img
			src="${cpath}/upload/Vectorsetting.svg" class="icon" /></a>
	</div>
</div>
<!--------------------------------------------------------gnb배너입니다.---------------------------------------------------------- -->
<!---------------------------------------------------페이지 양식입니다.------------------------------------------------------------- -->
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