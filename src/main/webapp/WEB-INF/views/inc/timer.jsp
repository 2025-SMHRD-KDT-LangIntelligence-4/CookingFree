<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>카운트다운 타이머 모달</title>
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
            background-color: rgba(0,0,0,0.6); /* 어두운 배경 */
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
            box-shadow: 0 5px 15px rgba(0,0,0,0.4);
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
        </div>
    </div>

    <div id="timeUpModal" class="modal">
        <div class="modal-content">
            <span class="close-button" onclick="closeTimeUpModal()">&times;</span>
            <h2>시간 초과!</h2>
            <p>설정된 시간이 종료되었습니다.</p>
        </div>
    </div>

    <script>
        let countdownTimer;
        let totalSeconds;

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
            // 타이머가 실행 중이 아니거나 totalSeconds가 정의되지 않았다면 리셋 버튼 비활성화
            document.getElementById('resetButton').disabled = !isTimerRunning && totalSeconds === undefined;
            document.getElementById('stopButton').disabled = !isTimerRunning;
        }

        function startCountdown() {
            if (countdownTimer) return; // 이미 타이머가 실행 중이면 중복 실행 방지

            const min = parseInt(document.getElementById('minInput').value);
            const sec = parseInt(document.getElementById('secInput').value);

            if (isNaN(min) || isNaN(sec) || min < 0 || sec < 0) {
                alert("올바른 시간(분, 초)을 입력해주세요.");
                return;
            }

            if (totalSeconds === undefined || totalSeconds === 0) {
                totalSeconds = (min * 60) + sec;
                if (totalSeconds <= 0) {
                    alert("0초 이상으로 시간을 설정해주세요.");
                    return;
                }
            }

            updateButtonStates(true); // 타이머 시작 시 버튼 상태 업데이트

            document.getElementById("timerDisplay").innerText = formatTime(totalSeconds);

            countdownTimer = setInterval(() => {
                totalSeconds--;

                document.getElementById("timerDisplay").innerText = formatTime(totalSeconds);

                if (totalSeconds <= 0) {
                    clearInterval(countdownTimer);
                    countdownTimer = null;
                    document.getElementById("timerDisplay").innerText = "00분 00초";
                    showTimeUpModal(); // 시간 초과 시 모달창 띄우기 (이름 변경)
                    updateButtonStates(false);
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

        // 전체 타이머 모달 열기
        function openTimerModal() {
            document.getElementById('fullTimerModal').style.display = 'flex';
        }

        // 전체 타이머 모달 닫기
        function closeTimerModal() {
            // 모달을 닫을 때 타이머도 정지시키고 초기화할지 선택
            // resetCountdown(); // 주석을 풀면 닫을 때마다 타이머가 초기화됩니다.
            document.getElementById('fullTimerModal').style.display = 'none';
        }

        // 시간 초과 알림 모달 열기 (기존 showModal에서 이름 변경)
        function showTimeUpModal() {
            document.getElementById('timeUpModal').style.display = 'flex';
        }

        // 시간 초과 알림 모달 닫기 (기존 closeModal에서 이름 변경)
        function closeTimeUpModal() {
            document.getElementById('timeUpModal').style.display = 'none';
        }
    </script>
</body>
</html>