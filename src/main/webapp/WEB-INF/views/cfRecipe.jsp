<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="cpath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>문서</title>
    <link rel="stylesheet" href="${cpath}/css/cfRecipe.css" />
</head>
<body>
<!-- s ㄴ-->
<jsp:include page="inc/header.jsp" />
    <div class="title-container">
        <div class="title">레시피 상세</div>
    </div>
    <div class="container">
        <div class="recipe-img">
            레시피 이미지
        </div>
        <div class="btn-container">
            <div class="voice-btn">
                목소리로 말하기
            </div>
            <div class="touch-btn">
                터치로 입력하기
            </div>
        </div>
    </div>

    <div class="scroll">
        <img src="${cpath}/upload/ic_baseline-keyboard-arrow-up.svg" />
    </div>

    <div class="title-container">
        <div class="title">재료</div>
    </div>
    <div class="ingredient">
        <div class="ingre-container">
            <textarea class="ingre-text">재료</textarea>
        </div>
    </div>

    <div class="scroll">
        <img src="${cpath}/upload/ic_baseline-keyboard-arrow-up.svg" />
    </div>

    <div class="title-container">
        <div class="title">조리 과정(단계)</div>
    </div>
    <div class="container">
        <div class="recipe-img">
            조리 과정 이미지
        </div>
        <div class="btn-container">
            <div class="recipe-step">
                조리 순서
            </div>
        </div>
    </div>
</body>
</html>