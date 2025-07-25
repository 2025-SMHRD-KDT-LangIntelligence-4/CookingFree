<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
    <c:set var="cpath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="${cpath}/css/cfRecipeIndex.css">
</head>
<body>
<!--------------------------------------------------------gnb 배너입니다.---------------------------------------------------------- -->
<jsp:include page="inc/header.jsp" />
<!--------------------------------------------------------gnb배너입니다.---------------------------------------------------------- -->
<!---------------------------------------------------페이지 양식입니다.------------------------------------------------------------- -->
<div class="title-container">
    <div class="title">Free(G)recipe</div>
</div>
<div class="recipe-index-container">
    <div class="recipe-index">
        <div class="recipe-image">레시피 이미지공간입니다.</div>
        <div class="recipe-name">레시피 이름공간입니다.</div>
        <div class="recipe-date">레시피 등록일 공간입니다.</div>
        <button class="recipeInfo">레시피확인하기</button>
    </div>
    <div class="recipe-index">
        <div class="recipe-image">레시피 이미지공간입니다.</div>
        <div class="recipe-name">레시피 이름공간입니다.이버튼을 누르면 레시피정보로 이동합니다.</div>
        <div class="recipe-date">레시피 등록일 공간입니다.</div>
    </div>
    <div class="recipe-index">
        <div class="recipe-image">레시피 이미지공간입니다.</div>
        <div class="recipe-name">레시피 이름공간입니다.이버튼을 누르면 레시피정보로 이동합니다.</div>
        <div class="recipe-date">레시피 등록일 공간입니다.</div>
    </div>
    <div class="recipe-index">
        <div class="recipe-image">레시피 이미지공간입니다.</div>
        <div class="recipe-name">레시피 이름공간입니다.이버튼을 누르면 레시피정보로 이동합니다.</div>
        <div class="recipe-date">레시피 등록일 공간입니다.</div>
    </div>
    <div class="recipe-index">
        <div class="recipe-image">레시피 이미지공간입니다.</div>
        <div class="recipe-name">레시피 이름공간입니다.이버튼을 누르면 레시피정보로 이동합니다.</div>
        <div class="recipe-date">레시피 등록일 공간입니다.</div>
    </div>
    <div class="recipe-index">
        <div class="recipe-image">레시피 이미지공간입니다.</div>
        <div class="recipe-name">레시피 이름공간입니다.이버튼을 누르면 레시피정보로 이동합니다.</div>
        <div class="recipe-date">레시피 등록일 공간입니다.</div>
    </div>
    <div class="recipe-index">
        <div class="recipe-image">레시피 이미지공간입니다.</div>
        <div class="recipe-name">레시피 이름공간입니다.이버튼을 누르면 레시피정보로 이동합니다.</div>
        <div class="recipe-date">레시피 등록일 공간입니다.</div>
    </div>
</div>
<!---------------------------------------------------레시피정보출력창입니다------------------------------------------------------------>
<div class="recipe-info-modal" id="recipeModal">
		<div class="recipe-info-modal-content">
			<h2>레시피 이름입니다.</h2>
			<div class="recipe-info-container">
				<div class="recipe-info-image">레시피이미지입니다.</div>
				<div class="short-info">레시피간단 정보입니다.</div>
	            <button class="move-recipe">요리하러가기</button>   
			</div>
		</div>
	</div>
<footer class="footer"></footer>
<!---------------------------------------------------페이지 양식입니다.------------------------------------------------------------- -->
</body>
<script>
  const startBtn = document.querySelector('.recipeInfo');
  const modal = document.getElementById('recipeModal');
  const closeBtn = modal.querySelector('.gpt-close-btn');

  // 1. 모달 열기
  startBtn.addEventListener('click', () => {
    modal.style.display = 'flex';
  });
  // 3. 모달 바깥 영역 클릭 시 닫기
  modal.addEventListener('click', (e) => {
    if (e.target === modal) {
      modal.style.display = 'none';
    }
  });

  // 4. ESC 키 누르면 닫기
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
      modal.style.display = 'none';
    }
  });
</script>
</html>