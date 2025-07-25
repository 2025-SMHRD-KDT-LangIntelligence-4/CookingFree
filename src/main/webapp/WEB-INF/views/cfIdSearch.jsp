<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
    <c:set var="cpath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
 	<title>Document</title>
 	<link rel="stylesheet" href="${cpath}/css/cfIdSearch.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="${cpath}/css/cfIdSearch.css">
</head>
<body>
<!---------------------------------------------------------gnb 배너입니다.--------------------------------------------------------------------->
	<div class="login-wrapper">
	  <div class="login-form">
	    <div class="login-title">LOGIN</div>
	    <input class="id" type="text" placeholder="아이디" />
	    <input class="pw" type="password" placeholder="비밀번호" />
	    <div class="login-links">
	      <div class="searchIdPw">아이디/비밀번호 찾기</div>
	      <div class="createUser">회원가입</div>
	    </div>
	    <div class="sns-icons">
	      <div class="sns-icon" title="연동1">
	      	<a href="/oauth2/authorization/google"><img src="${cpath}/upload/Google.png"/></a>
	      </div>
	      <div class="sns-icon" title="연동2">
	      	<a href="/oauth2/authorization/naver"><img src="${cpath}/upload/naver.png"/></a>
	      </div>
	      <div class="sns-icon" title="연동3">
	      	<a href="/oauth2/authorization/kakao"><img src="${cpath}/upload/카카오톡.png"></a>
	      </div>
	    </div>
	  </div>
	</div>

</body>
</html>