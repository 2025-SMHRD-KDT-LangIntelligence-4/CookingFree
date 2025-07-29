<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="cpath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}"/>
	<meta name="_csrf_header" content="${_csrf.headerName}"/>
    
    <title>쿠킹프리 챗봇</title>
    <link rel="stylesheet" href="${cpath}/css/cfChatbot.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <div class="container">
        <jsp:include page="inc/header.jsp" />
    </div>
    
    <div class="chatbot-container">
        <div class="chatbot-header">
            <div class="header-title">
                🤖 쿠킹프리 레시피 추천 봇
            </div>
            <div class="header-actions">
                <button class="header-btn" onclick="resetChat()">새 대화</button>
                <button class="header-btn" onclick="goHome()">홈으로</button>
            </div>
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
        
        <div class="typing-indicator" id="typingIndicator">
            쿠킹프리 봇이 답변을 준비하고 있어요... 💭
        </div>
        
        <div class="chatbot-input">
            <input type="text" id="userMessage" placeholder="메시지를 입력하세요... (예: 레시피 추천해줘)" maxlength="300">
            <button id="sendButton" onclick="sendMessage()">전송</button>
        </div>
    </div>

    <script>
    const csrfToken = document.querySelector('meta[name="_csrf"]')?.getAttribute('content');
    const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.getAttribute('content');

        let isProcessing = false;
        
        function sendMessage() {
            if (isProcessing) return;
            
            const input = document.getElementById('userMessage');
            const message = input.value.trim();
            
            if (!message) return;
            
            // 특별 명령어 처리
            if (message.toLowerCase() === '/timer') {
                // 타이머 모달을 보여줌
                openTimerModal(); // cfChatbot 페이지 내에 정의된 함수 (모달 열기)
                
                input.value = '';
                addMessage('bot', '타이머가 열렸습니다! ⏰ 요리를 관리해보세요.', 'system');
                return;
            }
            
            // 사용자 메시지 표시
            addMessage('user', message);
            input.value = '';
            setProcessing(true);
            
            // 타이핑 인디케이터 표시
            showTypingIndicator();
            
            // 서버에 메시지 전송
            fetch('${cpath}/chatbot/message', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    [csrfHeader]: csrfToken
                },
                body: 'message=' + encodeURIComponent(message)
            })
            .then(response => response.json())
            .then(data => {
                hideTypingIndicator();
                
                if (data.success) {
                    addMessage('bot', data.message, data.source);
                    
                    // 레시피 추천이 포함된 경우 레시피 카드도 표시 (향후 확장)
                    if (data.recipes && data.recipes.length > 0) {
                        addRecipes(data.recipes);
                    }
                } else {
                    addMessage('bot', data.message || '오류가 발생했습니다.', 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                hideTypingIndicator();
                addMessage('bot', '죄송합니다. 일시적인 오류가 발생했습니다. 다시 시도해주세요.', 'error');
            })
            .finally(() => {
                setProcessing(false);
            });
        }
        
        function addMessage(sender, message, source = null) {
            const messagesDiv = document.getElementById('chatMessages');
            const messageDiv = document.createElement('div');
            messageDiv.className = `message ${sender}`;
            
            const avatarDiv = document.createElement('div');
            avatarDiv.className = 'message-avatar';
            avatarDiv.innerHTML = sender === 'user' ? '👤' : '🤖';
            
            const bubbleDiv = document.createElement('div');
            bubbleDiv.className = 'message-bubble';
            
            // 메시지 내용
            const formattedMessage = formatMessage(message);
            bubbleDiv.innerHTML = formattedMessage;
            
            // 시간 표시
            const timeDiv = document.createElement('div');
            timeDiv.className = 'message-time';
            timeDiv.textContent = new Date().toLocaleTimeString('ko-KR', {
                hour: '2-digit',
                minute: '2-digit'
            });
            bubbleDiv.appendChild(timeDiv);
            
            // 소스 표시 (봇 메시지만)
            if (sender === 'bot' && source) {
                const sourceDiv = document.createElement('div');
                sourceDiv.className = `source-indicator source-${source}`;
                
                const sourceText = {
                    'openai': 'AI 답변',
                    'stored': '학습된 답변',
                    'rule': '기본 답변',
                    'system': '시스템',
                    'error': '오류'
                };
                
                sourceDiv.textContent = sourceText[source] || source;
                bubbleDiv.appendChild(sourceDiv);
            }
            
            if (sender === 'user') {
                messageDiv.appendChild(bubbleDiv);
                messageDiv.appendChild(avatarDiv);
            } else {
                messageDiv.appendChild(avatarDiv);
                messageDiv.appendChild(bubbleDiv);
            }
            
            messagesDiv.appendChild(messageDiv);
            scrollToBottom();
        }
        
        function formatMessage(message) {
            // 기본적인 마크다운 스타일 지원
            return message
                .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
                .replace(/\*(.*?)\*/g, '<em>$1</em>')
                .replace(/\n/g, '<br>')
                .replace(/🍽️|😊|😅|🔍|👨‍🍳|⏱️|👥|📊|📝|⏰/g, '<span style="font-size: 1.1em;">$&</span>');
        }
        
        function showTypingIndicator() {
            document.getElementById('typingIndicator').classList.add('show');
            scrollToBottom();
        }
        
        function hideTypingIndicator() {
            document.getElementById('typingIndicator').classList.remove('show');
        }
        
        function setProcessing(processing) {
            isProcessing = processing;
            const button = document.getElementById('sendButton');
            const input = document.getElementById('userMessage');
            
            button.disabled = processing;
            input.disabled = processing;
            
            if (processing) {
                button.textContent = '전송중...';
            } else {
                button.textContent = '전송';
            }
        }
        
        function scrollToBottom() {
            const messagesDiv = document.getElementById('chatMessages');
            setTimeout(() => {
                messagesDiv.scrollTop = messagesDiv.scrollHeight;
            }, 100);
        }
        
        function resetChat() {
            if (confirm('대화 내용을 초기화하시겠습니까?')) {
                fetch('${cpath}/chatbot/reset', {
                    method: 'POST',
                    headers: {
                    	'Content-Type': 'application/x-www-form-urlencoded',
                        [csrfHeader]: csrfToken
                    },
                    body: ''
                })
                .then(response => response.json())
                .then(data => {
                    location.reload();
                })
                .catch(error => {
                    console.error('Reset error:', error);
                    location.reload();
                });
            }
        }
        
        function goHome() {
            window.location.href = '${cpath}/cfMain';
        }
        
        // 엔터키로 메시지 전송
        document.getElementById('userMessage').addEventListener('keypress', function(e) {
            if (e.key === 'Enter' && !e.shiftKey && !isProcessing) {
                e.preventDefault();
                sendMessage();
            }
        });
        
        // 페이지 로드 시 입력창에 포커스
        window.addEventListener('load', function() {
            document.getElementById('userMessage').focus();
        });
    </script>
</body>
</html>
