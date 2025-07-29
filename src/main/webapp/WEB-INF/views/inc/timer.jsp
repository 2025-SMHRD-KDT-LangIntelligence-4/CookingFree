<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>쿠킹프리 타이머 모달</title>
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
        /* 깔끔한 timer-container 스타일 */
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
        /* 모달 스타일 (전체 화면 어둡게 처리) */
        .modal {
            display: none; /* 처음엔 숨김 */
            position: fixed; /* 고정 위치 */
            z-index: 10; /* 다른 요소보다 위에 표시 */
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.6); /* 반투명 배경 */
            justify-content: center;
            align-items: center;
        }
        .modal-content {
            background-color: #fefefe;
            margin: auto;
            padding: 20px;
            border: 1px solid #888;
            border-radius: 8px;
            width: 90%; /* 화면 크기에 따라 반응형 */
            max-width: 400px; /* 최대 너비 제한 */
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.4);
            position: relative; /* 닫기 버튼 위치 조정용 */
        }
        .close-button {
            color: #aaa;
            position: absolute; /* 닫기 버튼 위치 지정 */
            top: 10px;
            right: 15px;
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

    <button id="openTimerModalButton" onclick="openTimerModal()">타이머 열기</button>

    <div id="fullTimerModal" class="modal">
        <div class="modal-content">
            <span class="close-button" onclick="closeTimerModal()">&times;</span>
            <div class="timer-container">
                <h3>쿠킹프리 타이머</h3>
                <div>
                    <input type="number" id="minInput" value="0" min="0" placeholder="분"> 분
                    <input type="number" id="secInput" value="0" min="0" max="59" placeholder="초"> 초
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
            <h2>시간 종료!</h2>
            <p>설정한 시간이 경과하였습니다.</p>
        </div>
    </div>

    <script>
        let countdownTimer;
        let totalSeconds;

        // 초기화 후 버튼 상태 설정
        document.addEventListener('DOMContentLoaded', (event) => {
            updateButtonStates(false); // 초기엔 시작 버튼만 활성화
        });

        function formatTime(sec) {
            const minutes = Math.floor(sec / 60);
            const seconds = sec % 60;
            return `${minutes.toString().padStart(2, '0')}분 ${seconds.toString().padStart(2, '0')}초`;
        }

        function updateButtonStates(isTimerRunning) {
            document.getElementById('startButton').disabled = isTimerRunning;
            // 타이머가 작동중이 아니고, totalSeconds가 undefined면 초기화 버튼 비활성화
            document.getElementById('resetButton').disabled = !isTimerRunning && totalSeconds === undefined;
            document.getElementById('stopButton').disabled = !isTimerRunning;
        }

        function startCountdown() {
            if (countdownTimer) return; // 이미 타이머 작동 중이면 중복 실행 방지

            const min = parseInt(document.getElementById('minInput').value);
            const sec = parseInt(document.getElementById('secInput').value);

            if (isNaN(min) || isNaN(sec) || min < 0 || sec < 0) {
                alert("분 또는 초를 올바르게 입력해주세요.");
                return;
            }

            if (totalSeconds === undefined || totalSeconds === 0) {
                totalSeconds = (min * 60) + sec;
                if (totalSeconds <= 0) {
                    alert("0초 이상으로 타이머를 설정해주세요.");
                    return;
                }
            }

            updateButtonStates(true); // 버튼 상태 갱신 (시작 중)

            document.getElementById("timerDisplay").innerText = formatTime(totalSeconds);

            countdownTimer = setInterval(() => {
                totalSeconds--;

                document.getElementById("timerDisplay").innerText = formatTime(totalSeconds);

                if (totalSeconds <= 0) {
                    clearInterval(countdownTimer);
                    countdownTimer = null;
                    document.getElementById("timerDisplay").innerText = "00분 00초";
                    showTimeUpModal(); // 타이머 종료 알림 띄우기
                    updateButtonStates(false);
                    document.getElementById('resetButton').disabled = false; // 초기화 버튼 활성화
                }
            }, 1000);
        }

        function stopCountdown() {
            clearInterval(countdownTimer);
            countdownTimer = null;
            updateButtonStates(false); // 버튼 상태 갱신 (정지 상태)
            document.getElementById('startButton').disabled = false; // 다시 시작 버튼 활성화
            document.getElementById('resetButton').disabled = false; // 초기화 버튼 활성화
        }

        function resetCountdown() {
            clearInterval(countdownTimer);
            countdownTimer = null;
            totalSeconds = undefined; // 타이머 초기값 제거
            document.getElementById("timerDisplay").innerText = "00분 00초";
            document.getElementById('minInput').value = 0; // 입력창 초기화
            document.getElementById('secInput').value = 0;
            updateButtonStates(false); // 버튼 상태 초기화
        }

        // 타이머 모달 열기
        function openTimerModal() {
            document.getElementById('fullTimerModal').style.display = 'flex';
        }

        // 타이머 모달 닫기
        function closeTimerModal() {
            // 필요하다면 닫기 시 타이머 초기화 여부 결정 가능
            // resetCountdown();
            document.getElementById('fullTimerModal').style.display = 'none';
        }

        // 타이머 종료 모달 열기
        function showTimeUpModal() {
            document.getElementById('timeUpModal').style.display = 'flex';
        }

        // 타이머 종료 모달 닫기
        function closeTimeUpModal() {
            document.getElementById('timeUpModal').style.display = 'none';
        }
    </script>
</body>
</html>
