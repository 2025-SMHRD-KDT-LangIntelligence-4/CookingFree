<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
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
.join-container {
	width: 500px;
	height: 500px;
	border: 3px solid rgb(131, 131, 131);
	border-radius: 10px;
	box-sizing: border-box;
	justify-content: center;
	display: flex;
	margin-top: 50px;
}

.joinform {
	margin-top: 50px;
}

.create-user {
	display: flex;
	justify-content: space-between;
	padding: 10px;
	gap: 20px;
}

.title-name {
	display: flex;
	justify-content: center;
}

.full-container {
	display: flex;
	justify-content: center;
}

.joinform-title {
	display: flex;
	justify-content: center;
	width: 100%;
}

.title-name {
	font-size: 40px;
	border-bottom: 3px solid #919191;
	width: fit-content;
	width: 100%;
	width: fit-content;
	text-align: center;
	padding: 0 20px;
	margin-top: 80px;
}

input {
	border: none;
	border-bottom: 3px solid #919191;
}

button {
	margin-top: 30px;
}

.footer {
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
			<a href="${cpath}" style="text-decoration-line: none;"><div
					class="logo">CookIN(G)Free</div></a>
		</div>
		<div class="gnb-right">
			<a href="${cpath}/login"><img src="${cpath}/upload/Vectorinfo.svg"
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

			<form action="cfjoinId" method="post" class="joinform">
				<input type="hidden" name="${_csrf.parameterName}"
					value="${_csrf.token}" />

				<c:set var="realAuthType"
					value="${authType != null ? authType : 'L'}" />
				<c:set var="realEmail" value="${email != null ? email : ''}" />
				<c:set var="realNickname"
					value="${nickname != null ? nickname : ''}" />
				<c:set var="realSocialId"
					value="${socialId != null ? socialId : ''}" />

				<div class="create-user">
					<label for="nickname">닉네임 입력</label> <input type="text"
						id="nickname" name="nickname" value="${realNickname}" required />
				</div>

				<div class="create-user">
					<label for="userId">사용할 ID / 이메일 입력</label> <input type="text"
						id="userId" name="userId" value="${realEmail}" required
						<c:if test="${realAuthType != 'L'}">readonly</c:if> />
				</div>

				<c:if test="${realAuthType == 'L'}">
					<div class="create-user">
						<label for="userPW">사용할 PW 입력</label> <input type="password"
							id="userPW" name="userPW" required />
					</div>
					<div class="create-user">
						<label for="checkPW">사용할 PW 재입력</label> <input type="password"
							id="checkPW" name="checkPW" required />
					</div>
				</c:if>

				<input type="hidden" name="authType" value="${realAuthType}" /> <input
					type="hidden" name="socialId" value="${realSocialId}" />

				<div class="create-user">
					<label for="userAlgCode">보유 알러지</label> <input type="text"
						id="userAlgCode" class="userAlgCode" name="userAlgCode" />
				</div>

				<div class="create-user">
					<label for="userPreferTaste">선호하는 맛</label> <input type="text"
						id="userPreferTaste" class="userPreferTaste"
						name="userPreferTaste" />
				</div>

				<div class="create-user">
					<label for="userCookingSkill">요리실력</label> <input type="text"
						id="userCookingSkill" class="userCookingSkill"
						name="userCookingSkill" />
				</div>

				<button type="submit" style="margin-left: 300px;">생성하기</button>

				<!-- 에러 메시지 출력 -->
				<c:if test="${not empty msg}">
					<div style="color: red; margin-top: 10px;">${msg}</div>
				</c:if>
			</form>



		</div>

	</div>
	<footer class="footer"></footer>
	<!---------------------------------------------------페이지 양식입니다.------------------------------------------------------------- -->
</body>
</html>