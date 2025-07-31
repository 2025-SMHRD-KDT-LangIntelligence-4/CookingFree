<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="cpath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>레시피 목록</title>
<link rel="stylesheet" href="${cpath}/css/cfRecipeIndex.css">
</head>
<body>
<div class="all-wrapper">
	<!--------------------------------------------------------gnb 배너입니다.---------------------------------------------------------- -->
	<jsp:include page="inc/header.jsp" />
	<!--------------------------------------------------------gnb배너입니다.---------------------------------------------------------- -->
	<!---------------------------------------------------페이지 양식입니다.------------------------------------------------------------- -->
	<div class="title-container">
	    <div class="title">Free(G)recipe</div>
	</div>
	
	<div class="recipe-index-container">
	    <c:forEach var="recipe" items="${recipeList}">
	        <div class="recipe-index">
	            <div class="recipe-image">
	                <c:choose>
	                    <c:when test="${not empty recipe.recipe_img}">
	                        <img src="${recipe.recipe_img}" alt="${recipe.recipe_name}" style="width:100%; height:100%; object-fit: cover;" />
	                    </c:when>
	                    <c:otherwise>
	                        <div style="width:100%; height:100%; background-color:#aaa; display:flex; justify-content:center; align-items:center; color:#fff;">
	                            이미지 없음
	                        </div>
	                    </c:otherwise>
	                </c:choose>
	            </div>
	            <div class="recipe-name" data-full-name="<c:out value='${recipe.recipe_name}' />"> <%-- data-full-name 속성을 추가 --%>
	                <c:out value="${recipe.recipe_name}" default="이름 없음" /> <%-- 일단 전체 이름을 출력 --%>
	            </div>
	            <div class="recipe-date">
	                <fmt:formatDate value="${recipe.created_at}" pattern="yyyy-MM-dd" />
	            </div>
	            <button class="recipeInfo"
	                    data-recipe-idx="${recipe.recipe_idx}"
	                    data-recipe-name="${recipe.recipe_name}"
	                    data-recipe-img="${recipe.recipe_img}"
	                    data-recipe-desc="${recipe.recipe_desc != null ? recipe.recipe_desc : '설명 없음'}">
	                레시피확인하기
	            </button>
	        </div>
	    </c:forEach>
	</div>
	
	<!---------------------------------------------------레시피정보출력창입니다------------------------------------------------------------>
	<div class="recipe-info-modal" id="recipeModal" style="display:none;">
	    <div class="recipe-info-modal-content">
	        <h2 id="modalTitle">레시피 이름입니다.</h2>
	        <div class="recipe-info-container">
	            <div class="recipe-info-image" id="modalImage" style="width: 200px; height: 200px; background-color: #eee; margin-right: 20px;">
	                <!-- 이미지 들어감 -->
	            </div>
	            <div class="short-info" id="modalDesc" style="text-align:left; max-height:300px; overflow-y:auto;">
	                레시피간단 정보입니다.
	            </div>
	        </div>
	        <button class="move-recipe" id="modalGoButton">요리하러가기</button>   
	        <button style="margin-top: 15px;" id="modalCloseButton">닫기</button>
	    </div>
	</div>
	
	<footer class="footer"></footer>
</div>
<!---------------------------------------------------페이지 양식입니다.------------------------------------------------------------- -->

<script>
	//**새로운 부분: 페이지 로드 후 레시피 이름을 잘라 표시**
	document.addEventListener('DOMContentLoaded', function() {
	    const recipeNameElements = document.querySelectorAll('.recipe-name');
	    const displayMaxLength = 15; // 메인 화면에 표시할 최대 글자 수
	
	    recipeNameElements.forEach(element => {
	        const fullName = element.getAttribute('data-full-name');
	        element.textContent = truncateText(fullName, displayMaxLength);
	    });
	});
	function truncateText(text, maxLength) {
	    if (text && text.length > maxLength) { // text가 null이 아닌 경우를 확인합니다.
	        return text.substring(0, maxLength) + '...';
	    }
	    return text;
	}
	document.addEventListener('DOMContentLoaded', function() {
	    const recipeNameElements = document.querySelectorAll('.recipe-name');
	    const displayMaxLength = 10; // 메인 화면에 표시할 최대 글자 수

	    recipeNameElements.forEach(element => {
	        const fullName = element.getAttribute('data-full-name');
	        element.textContent = truncateText(fullName, displayMaxLength);
	    });
	});
    // 모달과 버튼 요소 선택
    const modal = document.getElementById('recipeModal');
    const modalTitle = document.getElementById('modalTitle');
    const modalImage = document.getElementById('modalImage');
    const modalDesc = document.getElementById('modalDesc');
    const modalGoButton = document.getElementById('modalGoButton');
    const modalCloseButton = document.getElementById('modalCloseButton');

    // 레시피확인하기 버튼 모두 선택 후 이벤트 걸기
    document.querySelectorAll('.recipeInfo').forEach(button => {
        button.addEventListener('click', (e) => {
            e.stopPropagation();
            const name = button.getAttribute('data-recipe-name') || '이름 없음';
            const imgSrc = button.getAttribute('data-recipe-img') || '';
            const desc = button.getAttribute('data-recipe-desc') || '설명 없음';
            const recipeIdx = button.getAttribute('data-recipe-idx');

            modalTitle.textContent = name;

            // 이미지 처리
            if(imgSrc) {
                modalImage.innerHTML = '<img src="'+imgSrc+'" alt="'+name+'" style="width:100%; height:100%; object-fit:cover; border-radius:8px;">';
            } else {
                modalImage.innerHTML = '<div style="width:100%; height:100%; background:#ccc; display:flex; justify-content:center; align-items:center; color:#666;">이미지 없음</div>';
            }

            modalDesc.textContent = desc;

            modalGoButton.onclick = function() {
                window.location.href = '${cpath}/recipe/detail?recipe_idx=' + recipeIdx;
            };

            modal.style.display = 'flex';
            modal.style.justifyContent = 'center';
            modal.style.alignItems = 'center';
        });
    });

    // 모달 닫기 버튼 이벤트
    modalCloseButton.addEventListener('click', () => {
        modal.style.display = 'none';
    });

    // 모달 외부클릭시 닫기 기능
    modal.addEventListener('click', (ev) => {
        if(ev.target === modal) {
            modal.style.display = 'none';
        }
    });

    // ESC키로 닫기
    document.addEventListener('keydown', (e) => {
        if(e.key === 'Escape') {
            modal.style.display = 'none';
        }
    });
</script>
</body>
</html>