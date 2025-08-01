<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="cpath" value="${pageContext.request.contextPath}" />
<%
	// ────────── (1) 이 헤더를 반드시 추가 ──────────
	response.setHeader("X-Frame-Options","SAMEORIGIN");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>${recipe.recipe_name}| 쿠킹프리</title>

<style>
.gnb {
	display: flex;
	flex-wrap: nowrap;
	justify-content: space-between;
	align-items: center;
	padding: 20px 20px;
	background: #fff;
	overflow-x: auto;
	border-bottom: 1px solid #ddd;
	box-sizing: border-box;
	gap: 12px;
}

.gnb-left a, .gnb-right a {
	display: flex;
	align-items: center;
	margin-left: 10px;
	text-decoration: none;
}

.gnb-center {
	flex: 0 1 auto; 
	min-width: 80px;
	left: 50%;
	transform: translateX(-50%);
	position: absolute;
}

.logo {
	font-size: clamp(18px, 4vw, 32px); 
	font-weight: bold;
	font-family: 'Inter', sans-serif;
	color: #000;
}

.gnb-right {
	display: flex;
	gap: 12px;
}

.icon {
	width: clamp(18px, 5vw, 36px);
	height: clamp(18px, 5vw, 36px);
	min-width: 18px;
	min-height: 18px;
	object-fit: contain;
}
@media ( max-width : 768px) {
	.gnb {
		padding: 12px;
		gap: 8px;
	}
	.gnb-right a {
		margin-left: 6px;
	}
}

html, body {
	margin: 0;
	padding: 0;
	width: 100%;
	height: 100%;
	font-family: 'HakgyoansimByeoljariTTF-B',
	sans-serif !important;
}
input{
	font-family: 'HakgyoansimByeoljariTTF-B',
	sans-serif !important;
	}
#cookMode {
	height: 100vh;
	overflow: hidden;
	position: relative;
	justify-content: center;
	display: flex;
}

#stepContainer {
	width: 80%;
	height: 100vh;
	overflow-y: hidden;
	display: flex;
	flex-direction: column;
}

.step {
	display: none;
	position: relative;
	padding: 20px;
	box-sizing: border-box;
	height: 100%;
}

.step.active {
	display: flex;
	flex-direction: column;
	justify-content: center;
	width: 100%;
	align-items: center;
	height: auto;
	max-height: calc(100vh - 120px)
}

h2 {
	border-bottom: 3px solid #ddd;
	margin-top: 5%;
}

h3 {
	margin-top: 0 !important;
	margin-bottom: 20px !important;
}

.overview .layout {
	flex: 1;
	display: flex;
}

.overview .left {
	flex: 2;
	padding: 1% 3% 1% 0%;
}

.overview .left img {
	width: 100%;
	max-height: 70%;
	object-fit: cover;
	border: 3px solid #ddd;
	border-radius: 10px;
}

.overview .left p {
	margin-top: 20px;
	font-size: 16px;
	color: #333;
}

.overview .right {
	flex: 1;
	display: flex;
	flex-direction: column;
	justify-content: center;
	align-items: center;
}

.btn-mode {
	width: 100%;
	height: 90%;
	background: #fff;
	border: 3px solid #ddd;
	border-radius: 10px;
	font-size: 24px;
	cursor: pointer;
}

.ingredients ul {
	list-style: none;
	padding: 0;
	border: 3px solid #ddd;
	border-radius: 10px;
	padding: 5%;
	overflow-y: auto;
}

.ingredients li {
	margin: 8px 0;
	font-size: 16px;
}

#stepItems {
	flex: 1;
	display: flex;
	align-items: center;
	justify-content: center;
	position: relative;
	flex-direction: column;
	padding-bottom: 20px;
}

.step-item {
	display: none; 
	flex-direction: row;
	align-items: center;
	text-align: center;
	justify-content: center;
	width: 100%;
	flex: 1;
	padding: 10px 0;
	gap: 20px;
	box-sizing: border-box;
}

.step-item.active {
	display: flex;
}

.step-item img {
	max-width: 40%;
	height: auto;
	max-height: 30vh;
	border: 3px solid #ddd;
	border-radius: 10px;
	height: auto;
	object-fit: contain;
	margin: 0;
}

.step-text {
	font-size: 16px;
	color: #333;
	width: 80%;
	max-width: 55%;
	text-align: left; 
	flex-grow: 1; 
}

.review .comment-input {
	display: flex;
	gap: 8px;
	margin-bottom: 16px;
}

.review textarea {
	flex: 1;
	padding: 8px;
	resize: none;
}

.review select {
	width: 80px;
}

.review button {
	padding: 8px 16px;
	background: #4caf50;
	color: #fff;
	border: none;
	border-radius: 4px;
	cursor: pointer;
}

.comment-list {
	width: 100%;
	max-width: 600px;
	margin: 0 auto;
}

.comment-item {
	border-bottom: 1px solid #ddd;
	padding: 12px 0;
}

.comment-item .meta {
	font-size: 14px;
	color: #666;
	margin-bottom: 4px;
}

.comment-item .content {
	font-size: 16px;
}

.nav-buttons {
	width: 100%;
	display: flex;
	justify-content: space-between;
	margin-top: auto;
	padding: 20px 0;
	box-sizing: border-box;
}

.nav-buttons button {
	background: #4caf50;
	color: #fff;
	border: none;
	padding: 10px 20px;
	border-radius: 4px;
	cursor: pointer;
}

#btnSpeakStep {
	width: 10%;
	color: black;
	background: #fff;
	border: 1px solid #ccc;
	border-radius: 4px;
	padding: 8px;
	cursor: pointer;
}

#cookMode {
	height: 100vh;
	overflow: hidden;
	position: relative;
	display: flex;
	justify-content: center;
}

#stepContainer {
	width: 80%;
	overflow-y: hidden;
	display: flex;
	flex-direction: column;
}
.gnb {
    display: flex;
    flex-wrap: nowrap;
    justify-content: space-between;
    align-items: center;
    padding: 20px 20px;
    background: #fff;
    overflow-x: auto;
    border-bottom: 1px solid #ddd;
    box-sizing: border-box;
    gap: 12px;
}

.gnb-left a, .gnb-right a {
    display: flex;
    align-items: center;
    margin-left: 10px;
    text-decoration: none;
}

.gnb-center {
    flex: 0 1 auto;
    min-width: 80px;
    left: 50%;
    transform: translateX(-50%);
    position: absolute;
}

.logo {
    font-size: clamp(18px, 4vw, 32px);
    font-weight: bold;
    font-family: 'Inter', sans-serif;
    color: #000;
}

.gnb-right {
    display: flex;
    gap: 12px;
}

.icon {
    width: clamp(18px, 5vw, 36px);
    height: clamp(18px, 5vw, 36px);
    min-width: 18px;
    min-height: 18px;
    object-fit: contain;
}

@media (max-width: 768px) {
    .gnb {
        padding: 12px;
        gap: 8px;
    }
    .gnb-right a {
        margin-left: 6px;
    }
}

html, body {
    margin: 0;
    padding: 0;
    width: 100%;
    height: 100%;
    font-family: 'HakgyoansimByeoljariTTF-B', sans-serif !important;
}
input {
    font-family: 'HakgyoansimByeoljariTTF-B', sans-serif !important;
}

#cookMode {
    height: 100vh; 
    overflow: hidden; 
    position: relative;
    justify-content: center;
    display: flex;
}

#stepContainer {
    width: 80%;
    height: 100vh; 
    overflow-y: hidden;
    display: flex;
    flex-direction: column;
}

.step {
    display: none;
    position: relative;
    padding: 20px;
    box-sizing: border-box;
    height: 100%;
}

.step.active {
    display: flex;
    flex-direction: column;
    justify-content: center;
    width: 100%;
    align-items: center;
    height: auto;
    max-height: calc(100vh - 120px); 
}

h2 {
    border-bottom: 3px solid #ddd;
    margin-top: 5%;
}

h3 {
    margin-top: 0 !important;
    margin-bottom: 20px !important;
}

/* Overview 섹션 스타일 - 기존 코드 유지 */
.overview .layout {
    flex: 1;
    display: flex;
}

.overview .left {
    flex: 2;
    padding: 1% 3% 1% 0%;
}

.overview .left img {
    width: 100%;
    max-height: 70%;
    object-fit: cover;
    border: 3px solid #ddd;
    border-radius: 10px;
}

.overview .left p {
    margin-top: 20px;
    font-size: 16px;
    color: #333;
}

.overview .right {
    flex: 1;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
}

.btn-mode {
    width: 100%;
    height: 90%;
    background: #fff;
    border: 3px solid #ddd;
    border-radius: 10px;
    font-size: 24px;
    cursor: pointer;
}

.ingredients ul {
    list-style: none;
    padding: 0;
    border: 3px solid #ddd;
    border-radius: 10px;
    padding: 5%;
    overflow-y: auto;
}

.ingredients li {
    margin: 8px 0;
    font-size: 16px;
}

#stepItems {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    position: relative;
    flex-direction: column;
    padding-bottom: 20px;
}

.step-item {
    display: none;
    flex-direction: row;
    align-items: center;
    text-align: center;
    justify-content: center;
    width: 100%;
    flex: 1;
    padding: 10px 0;
    gap: 20px;
    box-sizing: border-box;
}

.step-item.active {
    display: flex;
}

.step-item img {
    max-width: 40%;
    height: auto;
    max-height: 30vh;
    border: 3px solid #ddd;
    border-radius: 10px;
    object-fit: contain;
    margin: 0;
}

.step-text {
    font-size: 16px;
    color: #333;
    width: 80%;
    max-width: 55%; 
    text-align: left; 
    flex-grow: 1;
}

.review .comment-input {
    display: flex;
    gap: 8px;
    margin-bottom: 16px;
}

.review textarea {
    flex: 1;
    padding: 8px;
    resize: none;
}

.review select {
    width: 80px;
}

.review button {
    padding: 8px 16px;
    background: #4caf50;
    color: #fff;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}

.comment-list {
    width: 100%;
    max-width: 600px;
    margin: 0 auto;
}

.comment-item {
    border-bottom: 1px solid #ddd;
    padding: 12px 0;
}

.comment-item .meta {
    font-size: 14px;
    color: #666;
    margin-bottom: 4px;
}

.comment-item .content {
    font-size: 16px;
}

.nav-buttons {
    width: 100%;
    display: flex;
    justify-content: space-between;
    margin-top: auto;
    padding: 20px 0;
    box-sizing: border-box;
}

.nav-buttons button {
    background: #4caf50;
    color: #fff;
    border: none;
    padding: 10px 20px;
    border-radius: 4px;
    cursor: pointer;
}

#btnSpeakStep {
    width: 10%;
    color: black;
    background: #fff;
    border: 1px solid #ccc;
    border-radius: 4px;
    padding: 8px;
    cursor: pointer;
}

@media (max-width: 768px) {
    html, body {
        font-size: 14px; 
    }

    #cookMode {
        margin-top: 0; 
        overflow: visible;
        padding: 10px;
    }

    #stepContainer {
        width: 100%;
        height: auto;
        margin-top: 0;
        padding: 0 5px;
    }

    .step.active {
        padding: 10px; 
        max-height: none;
    }

    h2 {
        font-size: 1.8em;
        margin-top: 3%;
        margin-bottom: 15px;
    }

    h3 {
        font-size: 1.3em;
        margin-bottom: 15px !important;
    }

    .overview .layout {
        flex-direction: column;
        gap: 20px;
    }

    .overview .left,
    .overview .right {
        flex: none;
        width: 100%; 
        padding: 0;
    }

    .overview .left img {
        max-height: 250px; 
        object-fit: contain;
    }

    .overview .btn-mode {
        height: 80px; 
        font-size: 20px; 
        margin-bottom: 10px;
    }

    .ingredients ul {
        padding: 15px;
        max-height: 300px;
        font-size: 15px;
    }

    .ingredients li {
        margin: 6px 0;
        font-size: 15px;
    }

    #stepItems {
        padding-bottom: 10px;
    }

    .step-item {
        flex-direction: column;
        gap: 10px; 
        padding: 5px 0; 
        text-align: center; 
    }

    .step-item img {
        max-width: 80%;
        max-height: 20vh; 
        margin: 0 auto; 
    }

    .step-text {
        width: 90%; 
        max-width: 90%;
        text-align: center;
        font-size: 15px;
        left:0 !important;
    }

    .review .comment-input {
        flex-direction: column; 
        gap: 10px; 
    }

    .review textarea {
        min-height: 60px;
    }

    .review select {
        width: 100%; 
        height: 40px;
    }

    .review button {
        width: 100%;
        padding: 10px;
    }

    .comment-list {
        width: 100%; 
        padding: 0 5px;
    }

    .comment-item {
        padding: 10px 0;
    }

    .comment-item .meta {
        font-size: 13px;
    }

    .comment-item .content {
        font-size: 15px;
    }

    .nav-buttons {
        padding: 10px 0;
        flex-wrap: wrap; 
        justify-content: center;
        gap: 10px;
    }

    .nav-buttons button {
        padding: 8px 15px; 
        font-size: 14px;
        flex-grow: 1; 
        min-width: 120px; 
    }

    #btnSpeakStep {
        width: auto;
        min-width: 40px;
        flex-grow: 0; 
    }

	/* 모달 스타일 */
	.modal { position: fixed; top: 0; left: 0; width: 100%; height: 100%;
		background: rgba(0,0,0,0.5); display: none; align-items: center; justify-content: center; }
	.modal-content { background: #fff; padding: 20px; border-radius: 8px; width: 90%; max-width: 400px; }
	.modal .close { float: right; cursor: pointer; font-size: 1.5em; }

}
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

	<jsp:include page="inc/header.jsp" />

	<div id="cookMode">
		<div id="stepContainer">

			<!-- 1. Overview -->
			<section id="overview" class="step overview active">
				<h2>요리 개요: ${recipe.recipe_name}</h2>
				<div class="layout">
					<div class="left">
						<img
								src="${not empty recipe.recipe_img
          ? (fn:startsWith(recipe.recipe_img, 'http')
              ? recipe.recipe_img
              : cpath.concat(recipe.recipe_img.startsWith('/') ? '' : '/').concat(recipe.recipe_img))
          : cpath.concat('/upload/default-recipe.jpg')}"
								alt="레시피 이미지" />
						<p>${recipe.recipe_desc}</p>
					</div>
					<div class="right">
						<button id="btnVoiceMode" class="btn-mode">🎤</button>
						<p>*처음,이전,다음,다시읽어,타이머로 음성조작</p>
						<button id="btnTouchMode" class="btn-mode">👆</button>
					</div>
				</div>
				<div class="nav-buttons">
					<button class="btnPrev">← 이전</button>
					<button class="btnNext">다음 →</button>
				</div>
			</section>

			<!-- 2. Ingredients -->
			<section id="ingredients" class="step ingredients">
				<h2>필요한 재료</h2>
				<c:if test="${fn:length(ingredients) == 0}">
					<p>재료 정보가 없습니다.</p>
				</c:if>
				<ul>
					<c:forEach var="ing" items="${ingredients}">
						<li>${ing.ingre_name}${ing.input_amount}${ing.ingre_unit}</li>
					</c:forEach>
				</ul>
				<div class="nav-buttons">
					<button class="btnPrev">← 이전</button>
					<button class="btnNext">다음 →</button>
				</div>
			</section>

			<!-- 3. Steps -->
			<section id="steps" class="step steps">
				<h2>조리 단계</h2>

				<div id="stepItems">
					<c:forEach var="step" items="${steps}" varStatus="st">
						<div class="step-item" data-index="${st.index}">
							<h3>STEP ${step.step_order}/${steps.size()}</h3>
							<img
									src="${not empty step.img
          ? (fn:startsWith(step.img, 'http')
                ? step.img
                : cpath.concat(step.img.startsWith('/') ? '' : '/').concat(step.img))
          : cpath.concat('/upload/default-step.jpg')}"
									alt="step"
									style="width:600px; height:600px; object-fit:cover;" />
							<p class="step-text" style="position:relative; left:20%; text-align:center;">${step.cooking_desc}</p>
						</div>
					</c:forEach>
				</div>
				<div class="nav-buttons">
					<button id="btnPrevStep">← 이전 단계</button>
					<button id="btnSpeakStep">🔊</button>
					<button id="btnNextStep">다음 단계 →</button>
				</div>
			</section>

			<!-- 4. Review -->
			<section id="review" class="step review">
				<h2>리뷰</h2>
				<div class="comment-input">
					<textarea id="reviewContent" rows="2" placeholder="댓글을 입력하세요…"></textarea>
					<select id="reviewRating">
						<option>5</option>
						<option>4</option>
						<option>3</option>
						<option>2</option>
						<option>1</option>
					</select>
					<button id="btnSubmitReview">작성</button>
				</div>
				<div id="commentList" class="comment-list">
					<c:forEach var="rev" items="${reviews}">
						<div class="comment-item">
							<div class="meta">
								${rev.nick} •
								<fmt:formatDate value="${rev.created_at}"
									pattern="yyyy-MM-dd HH:mm" />
								• ★${rev.rating}
							</div>
							<div class="content">${rev.cmt_content}</div>
						</div>
					</c:forEach>
				</div>
				<div id="cookfree-text" style="display: none;"></div>
				<div class="nav-buttons">
					<button class="btnPrev">← 이전</button>
				</div>
			</section>

		</div>
	</div>
	<!-- 타이머 모달 -->
	<div id="timerModal" class="modal">
		<div class="modal-content">
			<span id="closeTimerModal" class="close-button" onclick="closeTimerModal()">&times;</span>
			<!-- ────────── (2) src는 '/timer?duration=' 매핑 URL로 열도록 둠 ────────── -->
			<iframe id="timerFrame"
					src="about:blank"
					style="width:100%; height:300px; border:none;">
			</iframe>
		</div>
	</div>

	<!-- kor-to-number 라이브러리 (한글 수사 → 숫자) -->
	<script src="https://unpkg.com/kor-to-number@1.1.5/dist/kor-to-number.umd.js"></script>
	<script>

		// wakelock
		let wakeLock = null;

		// 화면 꺼짐 방지 요청 함수
		async function requestWakeLock() {
			try {
				wakeLock = await navigator.wakeLock.request("screen");
				console.log("Wake Lock 획득됨");
				// 해제 이벤트 리스너 등록
				wakeLock.addEventListener("release", () => {
					console.log("Wake Lock 해제됨");
				});
			} catch (err) {
				console.error(`웨이크락 요청 실패: ${err.name}, ${err.message}`);
			}
		}

		// 페이지가 보일 때마다 웨이크락 재요청
		document.addEventListener("visibilitychange", () => {
			if (document.visibilityState === "visible") {
				requestWakeLock();
			}
		});

		// 페이지 로드 직후 자동 요청
		window.addEventListener("load", () => {
			requestWakeLock();
		});
		// ──────────────────────────────────────────────────────────────────────────────
		// 1) TTS(음성 합성) 준비
		//    - 페이지 로드 시 시스템 음성 목록을 불러와 한국어 음성 선택
		//    - speak(text) 호출로 언제든 음성 재생 가능
		// ──────────────────────────────────────────────────────────────────────────────
		let koreanVoice = null;

		function loadVoices() {
			const voices = speechSynthesis.getVoices();
			// 한국어 음성(ko) 중 첫 번째 선택
			koreanVoice = voices.find(v => v.lang.startsWith('ko'));
		}

		// 음성 목록 변경 시 다시 로드
		speechSynthesis.onvoiceschanged = loadVoices;
		loadVoices();

		// 텍스트를 한국어 음성으로 읽음
		function speak(text) {
			if (!text || !koreanVoice) return;
			const utter = new SpeechSynthesisUtterance(text);
			utter.lang = 'ko-KR';
			utter.voice = koreanVoice;
			utter.rate = 0.9;
			speechSynthesis.cancel();
			speechSynthesis.speak(utter);
		}

		// ──────────────────────────────────────────────────────────────────────────────
		// 2) 타이머 모달 제어
		//    openTimerModal(duration) 호출 시:
		//      - iframe에 timer.jsp?duration=<초> 로딩
		//      - duration 초 뒤에 “타이머가 종료되었습니다” 음성 알람 자동 실행
		//    closeTimerModal() 호출 시:
		//      - 모달 닫기, iframe src 초기화
		// ──────────────────────────────────────────────────────────────────────────────
		function openTimerModal(duration) {
			// iframe에 timer.jsp 로딩
			const url = window.location.origin
					+ '<%= request.getContextPath() %>'
					+ '/timer?duration=' + duration;
			console.log('[Timer] iframe URL →', url);
			$('#timerFrame').attr('src', url);
			$('#timerModal').fadeIn(200);

			// duration(초) 후 음성 알람 예약
			setTimeout(() => {
				speak('타이머가 종료되었습니다');
			}, duration * 1000);
		}

		function closeTimerModal() {
			$('#timerModal').fadeOut(200);
			$('#timerFrame').attr('src', 'about:blank');
		}

		// 모달 닫기 버튼 클릭 시
		$('#closeTimerModal').off().on('click', closeTimerModal);


		// ──────────────────────────────────────────────────────────────────────────────
		// 3) 한글 수사 → 초 변환 유틸
		//    “1분 30초” 같은 문자열을 초 단위 숫자로 파싱
		// ──────────────────────────────────────────────────────────────────────────────
		function parseTimeStringToSeconds(str) {
			const extract = window.korToNumber.extractNumber;
			const parts = str.match(/([가-힣0-9]+)\s*(시간|시|분|초)/g) || [];
			let total = 0;

			parts.forEach(p => {
				const m = p.match(/([가-힣0-9]+)\s*(시간|시|분|초)/);
				if (!m) return;
				const num = extract(m[1])[0];
				if (isNaN(num)) return;
				if (m[2].includes('시'))   total += num * 3600;
				else if (m[2].includes('분')) total += num * 60;
				else if (m[2].includes('초')) total += num;
			});

			return total;
		}


		// ──────────────────────────────────────────────────────────────────────────────
		// 4) 음성 명령으로 타이머 시작
		//    invokeTimerCommand("1분 30초") 형태로 호출
		//    - 파싱 성공 시 openTimerModal(sec)
		//    - 실패 시 콘솔에 오류 표시
		// ──────────────────────────────────────────────────────────────────────────────
		function invokeTimerCommand(timeStr) {
			const sec = parseTimeStringToSeconds(timeStr);
			if (sec > 0) {
				console.log('Timer start:', sec);
				openTimerModal(sec);
			} else {
				console.log('타이머 파싱 실패:', timeStr);
			}
		}


		// ──────────────────────────────────────────────────────────────────────────────
		// 5) 화면 단계 표시 & 내비게이션
		//    - Overview → Ingredients → Steps → Review 총 4단계
		//    - Steps 단계에서 각 조리 단계별로 TTS 재생
		// ──────────────────────────────────────────────────────────────────────────────
		$(function() {
			// 상태 변수
			let isRecognizing = false;
			let currentStage = 0;
			let stepIdx = 0;
			const totalStages = 3;
			const $steps = $('.step');
			const $items = $('#stepItems .step-item');
			const lastIdx = $items.length - 1;

			// 레벨스테인 거리 계산 (퍼지 매칭)
			function levenshtein(a, b) {
				const dp = Array(a.length + 1).fill().map(() => Array(b.length + 1).fill(0));
				for (let i = 0; i <= a.length; i++) dp[i][0] = i;
				for (let j = 0; j <= b.length; j++) dp[0][j] = j;
				for (let i = 1; i <= a.length; i++) {
					for (let j = 1; j <= b.length; j++) {
						const cost = a[i - 1] === b[j - 1] ? 0 : 1;
						dp[i][j] = Math.min(
								dp[i - 1][j] + 1,
								dp[i][j - 1] + 1,
								dp[i - 1][j - 1] + cost
						);
					}
				}
				return dp[a.length][b.length];
			}

			// 단계 표시 함수
			function showStage(idx) {
				currentStage = Math.max(0, Math.min(idx, totalStages));
				$steps.hide().eq(currentStage).addClass('active').show();

				// Steps(2) 단계 진입 시 첫 번째 조리 단계 TTS
				if (currentStage === 2) {
					 stepIdx = 0;
				      $items.hide().removeClass('active');
				      $items.eq(0).show().addClass('active');
				      speak($items.eq(0).find('.step-text').text());
				}
				bindNavButtons();
			}

			// 내비게이션 바인딩
			function bindNavButtons() {
  // 우선 모든 단계의 nav-buttons 숨김
  $('.step .nav-buttons').hide();

  if (currentStage === 2) {
    // 조리 단계일 때
    $('#steps .nav-buttons').show();

    $('#btnPrevStep').off('click').on('click', () => {
      if (stepIdx > 0) {
        $items.eq(stepIdx).hide().removeClass('active');
        stepIdx--;
        $items.eq(stepIdx).show().addClass('active');
        speak($items.eq(stepIdx).find('.step-text').text());
      }
    });

    $('#btnNextStep').off('click').on('click', () => {
      if (stepIdx < lastIdx) {
        $items.eq(stepIdx).hide().removeClass('active');
        stepIdx++;
        $items.eq(stepIdx).show().addClass('active');
        speak($items.eq(stepIdx).find('.step-text').text());
      } else {
        // 마지막 스텝 이후 리뷰로
        window.location.href = `${cpath}/cfReview?recipe_idx=${recipe.recipe_idx}`;
      }
    });

  } else {
    // Overview, Ingredients, Review 단계일 때
    const $nav = $steps.eq(currentStage).find('.nav-buttons');
    $nav.show();
    $nav.find('.btnPrev').off('click').on('click', () => showStage(currentStage - 1));
    $nav.find('.btnNext').off('click').on('click', () => showStage(currentStage + 1));
  }
}

			// ──────────────────────────────────────────────────────────────────────────
			// 6) 음성 인식 설정
			//    - “쿠킹프리타이머 1분 30초” → invokeTimerCommand()
			//    - “쿠킹프리다음/이전/처음/다시읽어” 명령 지원
			// ──────────────────────────────────────────────────────────────────────────
			const SR = window.SpeechRecognition || window.webkitSpeechRecognition;
			const recog = new SR();
			recog.lang = 'ko-KR';
			recog.continuous = true;
			recog.interimResults = false;

			recog.onstart = () => {
				isRecognizing = true;
				$('#btnVoiceMode').prop('disabled', true).text('음성 제어 중…');
			};

			recog.onend = () => recog.start();

			recog.onresult = e => {
				  const raw = e.results[e.results.length - 1][0].transcript;
				  const txt = raw.toLowerCase()
				    .replace(/[^가-힣0-9]/g, '')
				    .replace(/쿠킹프리|쿠키프리|부킹프리/g, '쿠킹프리')
				    .replace(/쿠킹프리타임어|쿠키프리타이어|부킹프리타임어|쿠키프리타임어/g, '쿠킹프리타이머');

				  console.log('Voice:', raw, '→', txt);

				// 타이머 명령
				if (txt.includes('쿠킹프리타이머')) {
				invokeTimerCommand(txt.replace('쿠킹프리타이머', ''));
				return;
				}

				  // “다음” 명령
				  if (txt.includes('쿠킹프리다음')) {
				    if (currentStage === 2) {
				      // 조리 단계 내부 다음 스텝
				      if (stepIdx < lastIdx) {
				        $items.eq(stepIdx).hide().removeClass('active');
				        stepIdx++;
				        $items.eq(stepIdx).show().addClass('active');
				        speak($items.eq(stepIdx).find('.step-text').text());
				      } else {
				        // 마지막 스텝 이후 리뷰 섹션으로 전환
				        showStage(3);
				      }
				    } else {
				      // Overview, Ingredients, Review 단계: 섹션 전환
				      showStage(currentStage + 1);
				    }
				    return;
				  }

				  // “이전” 명령
				  if (txt.includes('쿠킹프리이전')) {
				    if (currentStage === 2) {
				      // 조리 단계 내부 이전 스텝
				      if (stepIdx > 0) {
				        $items.eq(stepIdx).hide().removeClass('active');
				        stepIdx--;
				        $items.eq(stepIdx).show().addClass('active');
				        speak($items.eq(stepIdx).find('.step-text').text());
				      }
				    } else {
				      showStage(currentStage - 1);
				    }
				    return;
				  }

				  // “처음” 명령
				  if (txt.includes('쿠킹프리처음')) {
				    showStage(0);
				    return;
				  }

				  // “다시읽어” 명령
				  if (txt.includes('쿠킹프리다시읽어')) {
				    if (currentStage === 2) {
				      speak($items.eq(stepIdx).find('.step-text').text());
				    } else {
				      speak($('#cookfree-text').text());
				    }
				    return;
				  }

			};

			// 음성 제어 버튼 클릭 시 인식 시작
			$('#btnVoiceMode').on('click', () => {
				if (!isRecognizing) recog.start();
			});

			// 터치 모드 버튼 클릭 시 1단계로 이동
			$('#btnTouchMode').on('click', () => showStage(1));

			// 초기 화면 설정
			showStage(0);
		});
	</script>


</body>
</html>
