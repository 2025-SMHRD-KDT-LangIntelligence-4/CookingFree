<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
    <c:set var="cpath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>카운트다운 타이머</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            margin: 0;
            background-color: #f4f4f4;
        }
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
            font-size: 4em; /* 더 크게 */
            font-weight: bold;
            margin-bottom: 20px;
            color: #333;
        }
        .modal {
            display: none; /* Hidden by default */
            position: fixed; /* Stay in place */
            z-index: 1; /* Sit on top */
            left: 0;
            top: 0;
            width: 100%; /* Full width */
            height: 100%; /* Full height */
            overflow: auto; /* Enable scroll if needed */
            background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
            justify-content: center;
            align-items: center;
        }
        .modal-content {
            background-color: #fefefe;
            margin: auto;
            padding: 20px;
            border: 1px solid #888;
            border-radius: 8px;
            width: 80%;
            max-width: 300px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        }
        .close-button {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }
        .close-button:hover,
        .close-button:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="timer-container">
        <h3>카운트다운 타이머</h3>
        <div>
            <input type="number" id="minInput" value="0" min="0" placeholder="분"> 분
            <input type="number" id="secInput" value="0" min="0" max="59" placeholder="초"> 초
        </div>
        <div id="timerDisplay">00분 00초</div>
        <button id="startButton" onclick="startCountdown()">시작</button>
        <button id="resetButton" onclick="resetCountdown()" disabled>초기화</button>
        <button id="stopButton" onclick="stopCountdown()" disabled>정지</button>
    </div>

    <div id="timeUpModal" class="modal">
        <div class="modal-content">
            <span class="close-button" onclick="closeModal()">&times;</span>
            <h2>시간 초과!</h2>
            <p>설정된 시간이 종료되었습니다.</p>
        </div>
    </div>

    <script>
        let countdownTimer; // setInterval 참조용 변수
        let totalSeconds;   // 총 남은 시간 (초 단위)

        // 초기화 시 버튼 상태 설정
        document.addEventListener('DOMContentLoaded', (event) => {
            updateButtonStates(false); // 초기에는 시작 버튼만 활성화
        });

        function formatTime(sec) {
            const minutes = Math.floor(sec / 60);
            const seconds = sec % 60;
            return `${minutes.toString().padStart(2, '0')}분 ${seconds.toString().padStart(2, '0')}초`;
        }

        function updateButtonStates(isTimerRunning) {
            document.getElementById('startButton').disabled = isTimerRunning;
            document.getElementById('resetButton').disabled = !isTimerRunning && totalSeconds === undefined;
            document.getElementById('stopButton').disabled = !isTimerRunning;
        }

        function startCountdown() {
            // 이미 타이머가 실행 중이면 중복 실행 방지
            if (countdownTimer) return;

            // 입력값 가져오기
            const min = parseInt(document.getElementById('minInput').value);
            const sec = parseInt(document.getElementById('secInput').value);

            // 입력값 유효성 검사 (음수 방지 및 숫자 여부 확인)
            if (isNaN(min) || isNaN(sec) || min < 0 || sec < 0) {
                alert("올바른 시간(분, 초)을 입력해주세요.");
                return;
            }

            // 첫 시작이거나 리셋 후 시작할 때만 총 초를 설정
            if (totalSeconds === undefined || totalSeconds === 0) {
                 totalSeconds = (min * 60) + sec;
                 // 처음 시작할 때 00:00인 경우 시작하지 않음
                 if (totalSeconds <= 0) {
                     alert("0초 이상으로 시간을 설정해주세요.");
                     return;
                 }
            }


            updateButtonStates(true); // 타이머 시작 시 버튼 상태 업데이트

            // 타이머 디스플레이 초기 업데이트
            document.getElementById("timerDisplay").innerText = formatTime(totalSeconds);

            countdownTimer = setInterval(() => {
                totalSeconds--;

                document.getElementById("timerDisplay").innerText = formatTime(totalSeconds);

                if (totalSeconds <= 0) {
                    clearInterval(countdownTimer);
                    countdownTimer = null; // 타이머 참조 초기화
                    document.getElementById("timerDisplay").innerText = "00분 00초";
                    showModal(); // 시간 초과 시 모달창 띄우기
                    updateButtonStates(false); // 타이머 종료 시 버튼 상태 업데이트
                    document.getElementById('resetButton').disabled = false; // 종료 후에는 리셋 가능
                }
            }, 1000);
        }

        function stopCountdown() {
            clearInterval(countdownTimer);
            countdownTimer = null;
            updateButtonStates(false); // 정지 시 버튼 상태 업데이트
            document.getElementById('startButton').disabled = false; // 정지 후에는 시작 가능
            document.getElementById('resetButton').disabled = false; // 정지 후에는 리셋 가능
        }

        function resetCountdown() {
            clearInterval(countdownTimer);
            countdownTimer = null;
            totalSeconds = undefined; // 총 시간 초기화
            document.getElementById("timerDisplay").innerText = "00분 00초";
            document.getElementById('minInput').value = 0; // 입력 필드 초기화
            document.getElementById('secInput').value = 0;
            updateButtonStates(false); // 리셋 시 버튼 상태 업데이트
        }

        function showModal() {
            document.getElementById('timeUpModal').style.display = 'flex';
        }

        function closeModal() {
            document.getElementById('timeUpModal').style.display = 'none';
        }
    </script>
</body>
</html>