<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
    <c:set var="cpath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
 	<title>Document</title>
 	<link rel="stylesheet" href="${cpath}/css/cfLogin.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body><!-- s -->
<jsp:include page="inc/header.jsp" />
	<div class="login-wrapper" style="background: url(${cpath}/upload/일러스트23.jpg) center/cover no-repeat;">
	  <div class="login-form">
	    <div class="login-title">LOGIN</div>
			<form action="${cpath}/login" method="post">
				<input type="hidden" name="${_csrf.parameterName}"
					value="${_csrf.token}" /> <input class="id" type="text"
					name="username" placeholder="아이디" required /> <input class="pw"
					type="password" name="password" placeholder="비밀번호" required />
				<button class="loginBtn" type="submit">로그인</button>
			</form>
	    <div class="login-links">
	      <a href="${cpath}/cfJoinform?mode=local" class="createUser">회원가입</a>
	    </div>
	    <div class="sns-icons">
	      <div class="sns-icon" title="연동1">
	      	<a href="${cpath}/oauth2/authorization/google"><img src="${cpath}/upload/Google.png"/></a>
	      </div>
	      <div class="sns-icon" title="연동2">
	      	<a href="${cpath}/oauth2/authorization/naver"><img src="${cpath}/upload/naver.png"/></a>
	      </div>
	      <div class="sns-icon" title="연동3">
	      	<a href="${cpath}/oauth2/authorization/kakao"><img src="${cpath}/upload/카카오톡.png"></a>
	      </div>
	    </div>
	  </div>
	</div>

</body>
</html>