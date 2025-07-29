<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="cpath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />
<title>Document</title>
<link rel="stylesheet" href="${cpath}/css/cfSearchRecipe.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body style="background-color:white;">
	<!-- s -->
	<jsp:include page="inc/header.jsp" />
	<!---------------------------------------------------직접입력 검색창입니다.------------------------------------------------------------------------------->
	<form action="searchRecipe" method="post" class="search-Form">
		<input type="hidden" name="${_csrf.parameterName}"
			value="${_csrf.token}" />
		<div class="logo-img-wrapper">
			<img class="logo-img" src="${cpath}/upload/cookingfree로고.jpg"
				alt="쿠킹프리 로고">
		</div>
		<div class="searchBar">
			<input id="searchtext" name="searchText" type="text"
				placeholder="검색어를 입력해주세요" required />
			<button class="search-button" type="submit">검색</button>
		</div>
	</form>
	<c:if test="${not empty searchResults}">
		<div class="results">
			<h3>“${searchText}” 검색 결과 (${searchResults.size()}건)</h3>
			<div class="results-grid">
				<c:forEach var="recipe" items="${searchResults}">
					<div class="result-card"
						onclick="location.href='${cpath}/recipe/detail/${recipe.recipe_idx}'">
						<c:if test="${not empty recipe.recipe_img}">
							<img src="${recipe.recipe_img}" alt="${recipe.recipe_name}"
								class="recipe-img" />
						</c:if>
						<div class="recipe-info">
							<h4 class="recipe-name">${recipe.recipe_name}</h4>
							<p class="recipe-desc">${fn:length(recipe.recipe_desc) > 60
                  ? fn:substring(recipe.recipe_desc, 0, 60).concat("...")
                  : recipe.recipe_desc}
							</p>
							<div class="recipe-meta">
								<span>조회수: ${recipe.view_count}</span> <span>난이도:
									${recipe.recipe_difficulty}</span> <span>⏱️
									${recipe.cooking_time}분</span>
							</div>
						</div>
					</div>
				</c:forEach>
			</div>
		</div>
	</c:if>



	<div class="start-gpt-container">
		<button class="start-gpt">프리G에게 물어보기</button>
	</div>
	<!---------------------------------------------------GPT검색창 입니다.-------------------------------------------------------------------------------->
	<!-- GPT 검색화면이 전체화면 아래쪽에 있다고 가정 -->
	<div id="gptModal" class="gpt-modal-overlay" style="display: none;">
		<div class="gpt-modal-content">
			<div id="chatbotContainer"></div>
		</div>
	</div>


	<script>
		const startBtn = document.querySelector('.start-gpt');
		const modal = document.getElementById('gptModal');
		const closeBtn = modal.querySelector('.gpt-close-btn');
		$(function() {
			// 이벤트 위임: 문서에 바인딩 후 '.' 클래스 사용
			$(document).on(
					'click',
					'.start-gpt',
					function() {
						console.log($._data(document, "events")); // click 이벤트 등록 확인
						$('#gptModal').show();
						if (!$('#chatbotContainer').data('loaded')) {
							$('#chatbotContainer').load(
									'${cpath}/cfChatbot',
									function() {
										$('#chatbotContainer').data('loaded',
												true);
									});
						}
					});

			// 모달 외부 클릭, ESC 키 닫기
			$('#gptModal').on('click', function(e) {
				if (e.target === this)
					$(this).hide();
			});
			$(document).on('keydown', function(e) {
				if (e.key === 'Escape')
					$('#gptModal').hide();
			});
		});
	</script>
</body>
</html>