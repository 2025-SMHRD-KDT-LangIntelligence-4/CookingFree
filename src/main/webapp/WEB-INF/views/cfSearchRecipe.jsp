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
<body><!-- s -->
<jsp:include page="inc/header.jsp" />
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
			<div class="header-title">
                프리G
            </div>
            <div class="header-actions">
                <button class="header-btn" onclick="resetChat()">새 대화</button>
                <button class="header-btn" onclick="goHome()">홈으로</button>
            </div>
            <div class="chatbot-messages" id="chatMessages">
            <div class="message bot">
                <div class="message-avatar">🤖</div>
                <div class="message-bubble">
                    안녕하세요! 알레르기에서 자유로운 레시피를 추천해드리는 쿠킹프리 봇입니다. 🍽️<br><br>
                    <strong>이런 것들을 물어보세요:</strong><br>
                    • "레시피 추천해줘"<br>
                    • "뭐 먹을까?"<br>
                    • "간단한 요리 알려줘"<br>
                    • "한식 레시피"<br><br>
                    회원님의 알레르기 정보를 고려해서 안전한 레시피만 추천해드려요! 😊<br><br>
                    요리 중 타이머가 필요하시면 "<strong>/timer</strong>"라고 말씀해주세요! ⏰
                    <div class="source-indicator">시스템 메시지</div>
                </div>
            </div>
        </div>
			<div class="gpt-container">
				 <input type="text" id="userMessage" placeholder="메시지를 입력하세요... (예: 레시피 추천해줘)" maxlength="300">
            	<button id="#sendButton" onclick="sendMessage()" class="gpt-send-btn">전송</button>
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