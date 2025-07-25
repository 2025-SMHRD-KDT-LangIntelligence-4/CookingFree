<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="cpath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<title>Document</title>
<link rel="stylesheet" href="${cpath}/css/cfJoinform.css">
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
	<div class="joinform-title">
		<div class="title-name">
			<div>회원가입</div><!-- s -->
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