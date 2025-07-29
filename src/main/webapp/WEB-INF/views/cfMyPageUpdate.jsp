<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<c:set var="cpath" value="${pageContext.request.contextPath}" />
<!-- CSRF token 값 선언 -->
<c:set var="_csrf" value="${_csrf}"/>
<!DOCTYPE html>
<html>
<head>
    <title>회원정보 수정</title>
    <link rel="stylesheet" href="${cpath}/css/cfMyPageUpdate.css" />
</head>
<body>
<jsp:include page="inc/header.jsp" />

<div class="body">
    <div class="all-container">
        <div class="my-page-title">
            <div>My Page</div>
        </div>
        <form action="${cpath}/mypageUpdate" method="post"
              enctype="multipart/form-data" class="joinform">
            <!-- CSRF 토큰 -->
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

            <!-- 프로필 이미지 업로드 영역 -->
            <div class="pr-img-container">
                <div name="profile_img" class="pr-img">
					<img src="${not empty user.profile_img ? user.profile_img : cpath}/upload/profileDefault.jpg" id="previewImg" />
					<input type="file" name="profile_img" id="profile_img" accept="image/*" onchange="document.getElementById('previewImg').src = window.URL.createObjectURL(this.files[0])"/>     
                </div>
			
                <div class="name-container">
                    <div class="usernick">${user.nick}<div>등급</div></div>
                    <form id="logoutForm" action="${cpath}/logout" method="post" style="display:none;">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    </form>
                    <button type="button" onclick="document.getElementById('logoutForm').submit();"
                            class="logout-button" style="margin-right: 10px;">로그아웃</button>
                </div>
                
            </div>

            <!-- 회원정보 수정 폼 -->
            <div class="info-container">
                <div>회원정보</div>
                <div><a href="${cpath}/cfMyPageUpdate">회원정보 수정</a></div>
            </div>

            <div class="myPage-container">
                <div class="div1">이메일</div>
                <div class="userInfo">${user.email}</div>
            </div>
            <div class="myPage-container">
                <div class="div1">닉네임</div>
                <input class="userInfo" type="text" name="nick" value="${user.nick}" />
            </div>
            <div class="myPage-container">
                <div class="div1">가입일자</div>
                <div class="userInfo">${user.joined_at}</div>
            </div>
            <div class="myPage-container">
                <div class="div1">선호하는 요리</div>
                <input class="userInfo" type="text" name="prefer_taste" value="${user.prefer_taste}" />
            </div>
            <div class="myPage-container">
                <div class="div1">요리 실력</div>
                <input class="userInfo" type="text" name="cooking_skill" value="${user.cooking_skill}" />
            </div>
            <div class="myPage-container">
                <div class="div1">보유 알러지</div>
                <input class="userInfo" type="text" name="alg_code" value="${user.alg_code}" />
            </div>

            <button type="submit" class="save-button">저장</button>
        </form>
    </div>
</div>

<footer class="footer"></footer>
</body>
</html>
