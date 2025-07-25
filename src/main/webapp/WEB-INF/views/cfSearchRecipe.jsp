<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
   <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
       <c:set var="cpath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Document</title>
<link rel="stylesheet" href="${cpath}/css/cfSearchRecipe.css">
</head>
<body>
<!---------------------------------------------------직접입력 검색창입니다.------------------------------------------------------------------------------->
	<form action="searchRecipe" method="post" class="search-Form">
        <div class="logo-img-wrapper">
        	<img class="logo-img" src="${cpath}/upload/cookingfree로고.jpg">
        </div>
        <div class="searchBar">
          <input id="searchtext" type="text" placeholder="검색어를 입력해주세요">
          <button class="search-button" type="submit">검색</button>
        </div>
    </form>
    <div class="start-gpt-container">
		<button class="start-gpt">프리G에게 물어보기</button>
    </div>
<!---------------------------------------------------GPT검색창 입니다.-------------------------------------------------------------------------------->
	<!-- GPT 검색화면이 전체화면 아래쪽에 있다고 가정 -->
	<div class="gpt-modal-overlay" id="gptModal">
		<div class="gpt-modal-content">
			<h2>프리G 검색</h2>
			<div class="gpt-container">
				<input class="gpt-input" type="text" placeholder="궁금한 내용을 입력하세요..."
					style="width:70%; font-size: 1rem;" />
				<button class="gpt-send-btn">
					<img src="${cpath}/upload/ic_baseline-keyboard-arrow-up.svg" style="width:40px; transform: rotate(90deg);"/>
				</button>
			</div>
		</div>
	</div>
</body>
<script>
  const startBtn = document.querySelector('.start-gpt');
  const modal = document.getElementById('gptModal');
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