<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<c:set var="cpath" value="${pageContext.request.contextPath}" />
<c:set var="_csrf" value="${_csrf}" />
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Document</title>
<link rel="stylesheet" href="${cpath}/css/cfSearchRecipe.css">
</head>
<body><!-- s -->
<jsp:include page="inc/header.jsp" />
<!---------------------------------------------------직접입력 검색창입니다.------------------------------------------------------------------------------->
	<form action="${cpath}/searchRecipe" method="post" class="search-Form">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <div class="logo-img-wrapper">
        	<img class="logo-img" src="${cpath}/upload/cookingfree로고.jpg">
        </div>
        <div class="searchBar">
          <input id="searchtext"  name="searchText" type="text" placeholder="검색어를 입력해주세요">
          <button class="search-button" type="submit">검색</button>
        </div>
    </form>
    <c:if test="${not empty searchResults}">
  <div class="results">
    <h2>“${searchText}” 검색 결과 (${fn:length(searchResults)}건)</h2>
    <c:forEach var="r" items="${searchResults}">
      <div class="result-card" onclick="location.href='${cpath}/recipe/detail/${r.recipe_idx}'">
        <img src="${not empty r.recipe_img ? r.recipe_img : cpath.concat('/upload/default-recipe.jpg')}" alt="${r.recipe_name}">
        <h3>${r.recipe_name}</h3>
        <p>${r.recipe_desc}</p>
      </div>
    </c:forEach>
  </div>
</c:if>
    
    <div class="start-gpt-container">
		<button class="start-gpt">프리G에게 물어보기</button>
    </div>
<!---------------------------------------------------GPT검색창 입니다.-------------------------------------------------------------------------------->
	<!-- GPT 검색화면이 전체화면 아래쪽에 있다고 가정 -->
	<div class="gpt-modal-overlay" id="gptModal">
		<div class="gpt-modal-content">
			<div class="chat-box" id="chat-box">
      			<div class="chat-message bot">안녕하세요! 어떤 요리를 도와드릴까요?</div>
    		</div>
			<div class="gpt-container">
      			<input class="gpt-input" type="text" id="user-input" placeholder="예: 김치찌개 레시피 알려줘">
      			<button class="gpt-send-btn" onclick="sendMessage()" style="width:40px;">전송</button>
			</div>
		</div>
	</div>
<!---------------------------------------------------GPT검색창 입니다.-------------------------------------------------------------------------------->
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
  
  /*---------------------------------------------------------gpt대화기능입니다-------------------------------------------------*/
  
  function sendMessage() {
    const input = document.getElementById('user-input');
    const chatBox = document.getElementById('chat-box');
    const userMessage = input.value;

    if (!userMessage.trim()) return;

    chatBox.innerHTML += `<div class="chat-message user">${userMessage}</div>`;
	
    let botResponse = '';
	    if (userMessage.includes('김치찌개')) {
	      botResponse = '김치찌개 레시피:\n1. 김치, 돼지고기 볶기\n2. 물 넣고 끓이기\n3. 두부, 파 추가하고 간 맞추기';
	    } else if (userMessage.includes('된장찌개')) {
	      botResponse = '된장찌개 레시피:\n1. 된장, 멸치 육수 끓이기\n2. 야채, 두부 넣기\n3. 10분 정도 끓이면 완성!';
	    } else {
	      botResponse = '죄송해요. 해당 요리는 아직 학습되지 않았어요 😢';
	    }
	
    chatBox.innerHTML += `<div class="chat-message bot">${botResponse}</div>`;

    input.value = '';
    chatBox.scrollTop = chatBox.scrollHeight;
  }
  
</script>
</html>