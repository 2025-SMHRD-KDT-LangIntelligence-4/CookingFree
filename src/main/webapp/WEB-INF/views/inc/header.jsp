<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<c:set var="cpath" value="${pageContext.request.contextPath}" />
<style>
body {
	font-family: Arial, sans-serif;
	display: flex;
	flex-direction: column;
	justify-content: center;
	min-height: 100vh;
	margin: 0;
	background-color: #f4f4f4;
	ㄴ
}
/* 기존 timer-container 스타일 유지 */
.timer-container {
	background-color: #fff;
	padding: 30px;
	border-radius: 10px;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
	text-align: center;
}

input {
	width: 80px;
	padding: 8px;
	margin: 0 5px 20px 5px;
	border: 1px solid #ddd;
	border-radius: 5px;
	font-size: 16px;
	text-align: center;
}

button {
	padding: 10px 20px;
	margin: 5px;
	border: none;
	border-radius: 5px;
	background-color: #007bff;
	color: white;
	font-size: 16px;
	cursor: pointer;
	transition: background-color 0.3s ease;
}

button:hover {
	background-color: #0056b3;
}

button:disabled {
	background-color: #cccccc;
	cursor: not-allowed;
}

#timerDisplay {
	font-size: 4em;
	font-weight: bold;
	margin-bottom: 20px;
	color: #333;
}
/* 모달 스타일 (전체 화면 덮기) */
.modal {
	display: none; /* 기본적으로 숨김 */
	position: fixed; /* 고정 위치 */
	z-index: 10; /* 다른 요소 위에 표시 */
	left: 0;
	top: 0;
	width: 100%;
	height: 100%;
	overflow: auto;
	background-color: rgba(0, 0, 0, 0.6); /* 어두운 배경 */
	justify-content: center;
	align-items: center;
}

.modal-content {
	background-color: #fefefe;
	margin: auto;
	padding: 20px;
	border: 1px solid #888;
	border-radius: 8px;
	width: 90%; /* 화면 크기에 따라 조절 */
	max-width: 400px; /* 최대 너비 설정 */
	text-align: center;
	box-shadow: 0 5px 15px rgba(0, 0, 0, 0.4);
	position: relative; /* 닫기 버튼 위치를 위해 */
}

.close-button {
	color: #aaa;
	position: absolute; /* 모달 내용의 오른쪽 상단에 고정 */
	top: 10px;
	right: 15px;
	font-size: 28px;
	font-weight: bold;
}

.close-button:hover, .close-button:focus {
	color: black;
	text-decoration: none;
	cursor: pointer;
}
</style>
<body>
</body>
<div class="gnb">
	<div class="gnb-left">
		<a class="start-timer" onclick="openTimerModal()"><img src="${cpath}/upload/timer.svg"
			class="icon" /></a>
	</div>
	<div class="gnb-center">
		<a href="${cpath}" style="text-decoration-line: none;"><div
				class="logo">CookIN(G)Free</div></a>
	</div>
	<div class="gnb-right">
		<!-- 로그인 상태일 때만 보이는 '마이페이지' 버튼 -->
		<sec:authorize access="isAuthenticated()">
			<a href="${cpath}/cfMyPage"> <img
				src="${cpath}/upload/Vectorinfo.svg" class="icon" />
			</a>
		</sec:authorize>

		<!-- 비로그인 상태일 때만 보이는 '로그인' 버튼 -->
		<sec:authorize access="!isAuthenticated()">
			<a href="${cpath}/login"> <img
				src="${cpath}/upload/Vectorinfo.svg" class="icon" />
			</a>
		</sec:authorize>

		<!-- 로그인 여부와 상관없이 항상 보이는 버튼들 -->
		<a href="${cpath}/cfRecipeIndex"><img
			src="${cpath}/upload/Vectorfood.svg" class="icon" /> </a> <a href="#"><img
			src="${cpath}/upload/Vectorsetting.svg" class="icon" /></a>
	</div>
</div>
<div id="fullTimerModal" class="modal">
	<div class="modal-content">
		<div class="timer-container">
			<h3>카운트다운 타이머</h3>
			<div>
				<input type="number" id="minInput" value="0" min="0" placeholder="분">
				분 <input type="number" id="secInput" value="0" min="0" max="59"
					placeholder="초"> 초
			</div>
			<div id="timerDisplay">00분 00초</div>
			<button id="startButton" onclick="startCountdown()">시작</button>
			<button id="resetButton" onclick="resetCountdown()" disabled>초기화</button>
			<button id="stopButton" onclick="stopCountdown()" disabled>정지</button>
		</div>
	</div>
</div>

<div id="timeUpModal" class="modal">
	<div class="modal-content">
		<span class="close-button" onclick="closeTimeUpModal()">&times;</span>
		<h2>시간 초과!</h2>
		<p>설정된 시간이 종료되었습니다.</p>
	</div>
</div>
<script src="${cpath}/js/timer.js"></script>
