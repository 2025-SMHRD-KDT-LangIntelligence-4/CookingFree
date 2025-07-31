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



	<div class="start-gpt-container" style="text-align: center; margin: 20px 0;">
		<button class="start-gpt">프리G에게 물어보기</button>
	</div>

	<div id="gptModal" class="gpt-modal-overlay">
		<div class="gpt-modal-content">
			<button class="gpt-close-btn">&times;</button>
			<div class="chatbot-header">
				<div class="header-title">🤖 쿠킹프리 레시피 추천 봇</div>
				<div class="header-actions">
					<button class="header-btn" onclick="resetChat()">새 대화</button>
					<button class="header-btn" onclick="goHome()">홈으로</button>
				</div>
			</div>
			<div class="chatbot-messages" id="chatMessages">
				<div class="message bot">
					<div class="message-avatar">🤖</div>
					<div class="message-bubble">
						안녕하세요! 알레르기에서 자유로운 레시피를 추천해드리는 쿠킹프리 봇입니다. 😊<br/><br/>
						• "레시피 추천해줘"<br/>
						• "한식요리" "양식요리"<br/>
						<div class="source-indicator">시스템</div>
					</div>
				</div>
			</div>
			<div class="typing-indicator" id="typingIndicator">응답 준비 중…</div>
			<div class="chatbot-input">
				<input type="text" id="userMessage"
					   placeholder="메시지를 입력하세요" maxlength="300" />
				<button id="sendButton" onclick="sendMessage()">전송</button>
			</div>
		</div>
	</div>

	<script>
		const csrfToken = $("meta[name='_csrf']").attr("content");
		const csrfHeader = $("meta[name='_csrf_header']").attr("content");
		const cpath = "${cpath}";

		let isProcessing = false;
		let lastRecipeList = [];

		// 모달 열기
		$(document).on('click', '.start-gpt', function() {
			// 서버 세션 초기화
			fetch(`${cpath}/chatbot/reset`, {
				method: 'POST',
				headers: { [csrfHeader]: csrfToken }
			})
					.finally(() => {
						// 클라이언트 상태 초기화
						lastRecipeList = [];
						hasSearched = false;
						// 모달 열기
						$('#gptModal').addClass('active');
					});
		});
		// 모달 닫기
		$(document).on('click', '.gpt-close-btn', function() {
			$('#gptModal').removeClass('active');
		});
		$('#gptModal').on('click', function(e) {
			if (e.target === this) $(this).removeClass('active');
		});
		$(document).on('keydown', function(e) {
			if (e.key === 'Escape') $('#gptModal').removeClass('active');
		});

		function sendMessage() {
			if (isProcessing) return;
			const msg = $("#userMessage").val().trim();
			if (!msg) return;
			addMessage('user', msg);
			$("#userMessage").val('');
			setProcessing(true);
			showTypingIndicator();

			$.ajax({
				url: `${cpath}/chatbot/message`,
				type: 'POST',
				headers: { [csrfHeader]: csrfToken },
				data: { message: msg },
				success(data) {
					hideTypingIndicator();
					if (!data.success) {
						addMessage('bot', data.message || '오류 발생', 'error');
						return;
					}

					// 1) 리디렉션 URL이 있을 경우 즉시 이동
					if (data.redirectUrl) {
						window.location.href = cpath + data.redirectUrl;
						return;
					}

					// 2) 정상 응답 처리
					addMessage('bot', data.message, data.source);

					// 3) 레시피 리스트 있으면 렌더링
					if (data.recipes) {
						lastRecipeList = data.recipes;
						addRecipes(data.recipes);
					}
				},
				error() {
					hideTypingIndicator();
					addMessage('bot', '일시적 오류 발생', 'error');
				},
				complete() {
					setProcessing(false);
				}
			});
		}

		function addMessage(sender, text, source) {
			const avatarChar = sender === 'user' ? '👤' : '🤖';
			const $msgDiv = $(`<div class="message ${sender}">`);
			const $avatar = $('<div class="message-avatar"></div>').text(avatarChar);
			const $bubble = $(`<div class="message-bubble"></div>`).html(
					text.replace(/\n/g, '<br/>')
			);
			if (sender === 'bot' && source) {
				const sourceText = {
					openai: 'AI 답변',
					stored: '학습된 답변',
					rule: '기본 답변',
					system: '시스템',
					error: '오류'
				}[source] || source;
				$bubble.append(
						`<div class="source-indicator source-${source}">${sourceText}</div>`
				);
			}
			if (sender === 'user') {
				$msgDiv.append($bubble).append($avatar);
			} else {
				$msgDiv.append($avatar).append($bubble);
			}
			const $chat = $("#chatMessages");
			$chat.append($msgDiv).scrollTop($chat[0].scrollHeight);
		}

		function addRecipes(recipes) {
			// 필요 시 구현
		}

		function showTypingIndicator() {
			$("#typingIndicator").show();
		}
		function hideTypingIndicator() {
			$("#typingIndicator").hide();
		}
		function setProcessing(flag) {
			isProcessing = flag;
			$("#sendButton, #userMessage").prop('disabled', flag)
					.text(flag ? '전송중…' : '전송');
		}
		function resetChat() {
			$("#chatMessages").empty();
			addMessage('bot',
					'안녕하세요! 알레르기에서 자유로운 레시피를 추천해드리는 쿠킹프리 봇입니다. 😊', 'system'
			);
		}
		function goHome() {
			location.href = `${cpath}/cfMain`;
		}

		$(function(){
			$("#userMessage").keypress(e => {
				if (e.key === 'Enter' && !isProcessing) {
					e.preventDefault();
					sendMessage();
				}
			});
		});
	</script>
</body>
</html>