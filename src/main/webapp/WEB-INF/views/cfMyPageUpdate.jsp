<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<c:set var="cpath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
    <title>회원정보 수정</title>
    <link rel="stylesheet" href="${cpath}/css/cfMyPageUpdate.css" />
</head>
<body>
<jsp:include page="inc/header.jsp" />

<div class="myPage-title-container">
    <div class="myPage-title">
        <div>내정보 수정</div>
    </div>
</div>

<form action="${cpath}/mypageUpdate" method="post" >
<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    <div class="form-group">
        <label for="email">이메일(수정 불가)</label>
        <input type="email" id="email" name="email" value="${user.email}" readonly />
    </div>
    <div class="form-group">
        <label for="nick">닉네임</label>
        <input type="text" id="nick" name="nick" value="${user.nick}" required />
    </div>
    
    <!-- 추가 수정 가능한 항목들 -->
    <div class="form-group">
        <label for="prefer_taste">선호하는 요리</label>
        <input type="text" id="prefer_taste" name="prefer_taste" value="${user.prefer_taste}" />
    </div>
    <div class="form-group">
        <label for="cooking_skill">요리 실력</label>
        <input type="text" id="cooking_skill" name="cooking_skill" value="${user.cooking_skill}" />
    </div>
    <div class="form-group">
        <label for="alg_code">보유 알러지</label>
        <input type="text" id="alg_code" name="alg_code" value="${user.alg_code}" />
    </div>

    <button type="submit">수정하기</button>
</form>

<footer class="footer"></footer>
</body>
</html>