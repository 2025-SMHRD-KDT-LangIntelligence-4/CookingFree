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
.join-container{
    width: 500px;
    height: 500px;
    border: 3px solid rgb(131, 131, 131);
    border-radius: 10px;
    box-sizing: border-box;
    justify-content: center;
    display: flex;
    margin-top: 50px;
}
.joinform{
    margin-top: 50px;
}
.create-user{
    display: flex;
    justify-content: space-between;
    padding: 10px;
    gap: 20px;
}
.title-name{
    display: flex;
    justify-content: center;
}
.full-container{
    display: flex;
    justify-content: center;
}
.joinform-title{
    display: flex;
    justify-content: center;
    width: 100%;
}
.title-name{
    font-size: 40px;
    border-bottom: 3px solid #919191;
    width: fit-content;
    width: 100%;
    width: fit-content;
    text-align: center;
    padding: 0 20px;
    margin-top: 80px;

}
input{
     border: none;
     border-bottom: 3px solid #919191;
}
button{
    margin-top: 30px;
}
.footer{
    height: 300px;
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
<div class="joinform-title">
    <div class="title-name">
        <div>회원가입</div>
    </div>
</div>
<div class="full-container">
    <div class="join-container">
        <form action="cfjoinId" class="joinform">
            <div class="create-user">
                닉네임 입력
                <input type="text" class="nickname">
            </div>
            <div class="create-user">
                사용할ID/이메일 입력
                <input type="text" class="userId">
            </div>
            <div class="create-user">
                사용할PW입력
                <input type="text" class="userPW">
            </div>
             <div class="create-user">
                사용할PW재입력
                <input type="text" class="checkPW">
            </div>
              <div class="create-user">
                 인증타입입력
                <input type="text" class="userAuthType">
            </div>
            <div class="create-user">
                 보유 알러지
                <input type="text" class="userAlgCode">
            </div>
            <div class="create-user">
                 선호하는 맛
                <input type="text" class="userPreferTaste">
            </div>
            <div class="create-user">
                 요리실력
                <input type="text" class="userCookingSkill">
            </div>
            <button type="submit" style="margin-left: 300px;">생성하기</button>
        </form>
    </div>
    s
</div>
<footer class="footer"></footer>
<!---------------------------------------------------페이지 양식입니다.------------------------------------------------------------- -->
</body>
</html>