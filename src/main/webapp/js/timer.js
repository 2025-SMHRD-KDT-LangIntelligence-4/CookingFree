let countdownTimer;
let totalSeconds;

document.addEventListener('DOMContentLoaded', (event) => {
    updateButtonStates(false);
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
    if (countdownTimer) return;

    const min = parseInt(document.getElementById('minInput').value);
    const sec = parseInt(document.getElementById('secInput').value);

    if (isNaN(min) || isNaN(sec) || min < 0 || sec < 0) {
        alert("올바른 시간(분, 초)을 입력해주세요.");
        return;
    }

    if (totalSeconds === undefined || totalSeconds === 0) {
        totalSeconds = (min * 60) + sec;
        console.log("Initial totalSeconds:", totalSeconds); // 추가
        if (totalSeconds <= 0) {
            alert("0초 이상으로 시간을 설정해주세요.");
            return;
        }
    }

    updateButtonStates(true);

    document.getElementById("timerDisplay").innerText = formatTime(totalSeconds);

    countdownTimer = setInterval(() => {
        totalSeconds--;

        document.getElementById("timerDisplay").innerText = formatTime(totalSeconds);

        if (totalSeconds <= 0) {
            clearInterval(countdownTimer);
            countdownTimer = null;
            document.getElementById("timerDisplay").innerText = "00분 00초";
            showTimeUpModal();
            updateButtonStates(false);
            document.getElementById('resetButton').disabled = false;
        }
    }, 1000);
}

function stopCountdown() {
    clearInterval(countdownTimer);
    countdownTimer = null;
    updateButtonStates(false);
    document.getElementById('startButton').disabled = false;
    document.getElementById('resetButton').disabled = false;
}

function resetCountdown() {
    clearInterval(countdownTimer);
    countdownTimer = null;
    totalSeconds = undefined;
    document.getElementById("timerDisplay").innerText = "00분 00초";
    document.getElementById('minInput').value = 0;
    document.getElementById('secInput').value = 0;
    updateButtonStates(false);
}

// 전체 타이머 모달 열기
function openTimerModal() {
    document.getElementById('fullTimerModal').style.display = 'flex';
}

// 전체 타이머 모달 닫기
function closeTimerModal() {
    // 모달을 닫을 때 타이머도 정지시킬지 선택할 수 있습니다.
    // resetCountdown(); // 이 줄의 주석을 풀면 모달 닫을 때마다 타이머가 초기화됩니다.
    document.getElementById('fullTimerModal').style.display = 'none';
}

// 시간 초과 알림 모달 열기
function showTimeUpModal() {
    document.getElementById('timeUpModal').style.display = 'flex';
}

// 시간 초과 알림 모달 닫기
function closeTimeUpModal() {
    document.getElementById('timeUpModal').style.display = 'none';
}
function closeTimerModal() {
    const fullTimerModal = document.getElementById('fullTimerModal');
    if (fullTimerModal) {
        resetCountdown();
        fullTimerModal.style.display = 'none';
    }
}
document.addEventListener('DOMContentLoaded', function() {
    // ... (기존 DOMContentLoaded 내용: updateButtonStates(false); ) ...

    const fullTimerModalElement = document.getElementById('fullTimerModal');
    const timeUpModalElement = document.getElementById('timeUpModal');

    window.addEventListener('click', function(event) {
        // 클릭된 요소가 fullTimerModal 자체인 경우 (모달 배경 클릭)
        if (fullTimerModalElement && event.target === fullTimerModalElement) {
            closeTimerModal();
        }
        // 클릭된 요소가 timeUpModal 자체인 경우 (모달 배경 클릭)
        if (timeUpModalElement && event.target === timeUpModalElement) {
            closeTimeUpModal();
        }
    });
});
