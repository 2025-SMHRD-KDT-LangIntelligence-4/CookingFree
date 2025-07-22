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
.myPage-container{
	display: flex;
	align-items: center;
	margin-top: 1rem;
	width: 100%;
	box-sizing: border-box;
	justify-content: center;
}
.myPage-title{
	display: flex;
	align-items: center;
	margin-top: 5rem;
	width: 100%;
	box-sizing: border-box;
	justify-content: center;
}
.pr-img{
	box-sizing: border-box;
	border-radius: 50%;
	background-color:#c79d9d;
	width:200px;
	height:200px;
}
.myPage-container input{
	width : 300px;
	border: 3px solid #bababa;
	border-radius: 8px;	
	box-sizing: border-box;
	padding: 10px;
	font-size: 1rem;
}
.myPage-container div{
	width : 100px;
	border: 3px solid #bababa;
	border-radius: 8px;	
	box-sizing: border-box;
	padding: 10px;
	font-size: 1rem;
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
	<div class="myPage-title">
		<div>My Page</div>
	</div>
	<div >
		<div class="pr-img">이미지 넣을거에요~</div>
	</div>
	<div class="myPage-container">
		<div>아이디</div><input placeholder="사용자 아이디 출력칸입니다~"></input>  
	</div>
	<div class="myPage-container">
		<div>닉네임</div><input placeholder="사용자 닉네임 출력칸입니다~"></input>  
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