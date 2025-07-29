<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<c:set var="cpath" value="${pageContext.request.contextPath}" />
<c:set var="_csrf" value="${_csrf}"/>
<!DOCTYPE html>
<html>
<head>
    <meta name="_csrf" content="${_csrf.token}" />
    <meta name="_csrf_header" content="${_csrf.headerName}" />
    <title>회원정보 수정</title>
    <link rel="stylesheet" href="${cpath}/css/cfMyPageUpdate.css" />
</head>
<body>
<jsp:include page="inc/header.jsp" />

<div class="body">
    <div class="all-container">

        <!-- 1) 회원정보 수정 폼을 감싸는 래퍼 -->
        <div class="form-wrapper">
            <form action="${cpath}/mypageUpdate" method="post"
                  enctype="multipart/form-data" class="joinform">
                <!-- CSRF 토큰 -->
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                <!-- 프로필 이미지 업로드 영역 -->
                <div class="pr-img-container">
                    <div class="pr-img">
                        <img src="${not empty user.profile_img ? user.profile_img : cpath}/upload/profileDefault.jpg"
                             id="previewImg"
                             onclick="document.getElementById('profileImgFile').click();"/>
                        <input type="file" name="profileImgFile" id="profileImgFile" accept="image/*"
                               onchange="document.getElementById('previewImg').src = window.URL.createObjectURL(this.files[0])"/>
                    </div>
                    <div class="name-container">
                        <div class="usernick">
                            ${user.nick}
                            <div>등급</div>
                        </div>
                        <!-- 로그아웃 버튼만 포지션 외부로 분리 -->
                        <button type="button" class="logout-button" id="logoutBtn" style="margin-right:10px;">
                            로그아웃
                        </button>
                    </div>
                </div>

                <!-- 회원정보 수정 폼 링크 -->
                <div class="info-container">
                    <div>회원정보</div>
                    <div><a href="${cpath}/cfMyPageUpdate">회원정보 수정</a></div>
                </div>

                <!-- 회원정보 입력 필드들 -->
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

                <!-- 저장 버튼 -->
                <button type="submit" class="save-button">저장</button>
            </form>
        </div>

        <!-- 2) 로그아웃 전용 폼은 별도 배치 (플렉스 흐름에 간섭 없음) -->
        <form id="logoutForm" action="${cpath}/logout" method="post" style="display:none;">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        </form>

    </div>
</div>

<script>
    // 동적 로그아웃 처리
    document.getElementById('logoutBtn').addEventListener('click', function() {
        document.getElementById('logoutForm').submit();
    });
</script>

</body>
<footer class="footer"></footer>
</html>
