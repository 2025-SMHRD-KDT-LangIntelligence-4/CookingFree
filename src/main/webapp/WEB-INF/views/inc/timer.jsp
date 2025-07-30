<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         isELIgnored="true"%>

<% response.setHeader("X-Frame-Options","SAMEORIGIN"); %>
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

<button id="openTimerModalButton">타이머 열기</button>

<div id="timerModal" class="modal">
    <div class="modal-content">
        <span class="close-button" onclick="closeTimerModal()">&times;</span>
        <h3>쿠킹프리 타이머</h3>

        <div id="inputSection" class="timer-container">
            <input type="number" id="minInput" value="0" min="0" placeholder="분"> 분
            <input type="number" id="secInput" value="0" min="0" max="59" placeholder="초"> 초
        </div>

        <div id="timerDisplay">00분 00초</div>

        <div class="timer-container">
            <button id="startTimer" class="timer-btn">시작</button>
            <button id="stopTimer"  class="timer-btn" disabled>정지</button>
            <button id="resetTimer" class="timer-btn" disabled>초기화</button>
        </div>

        <div id="timeUpMessage" style="display:none;" onclick="closeTimerModal()">
            <h4>⏰ 시간 종료!</h4>
            <p>클릭하면 모달이 닫힙니다.</p>
        </div>
    </div>
</div>

<script>
    const openBtn      = document.getElementById('openTimerModalButton');
    const modal        = document.getElementById('timerModal');
    const inputSection = document.getElementById('inputSection');
    const displayEl    = document.getElementById('timerDisplay');
    const startBtn     = document.getElementById('startTimer');
    const stopBtn      = document.getElementById('stopTimer');
    const resetBtn     = document.getElementById('resetTimer');
    const timeUpMsg    = document.getElementById('timeUpMessage');

    let countdownTimer = null;
    let seconds        = 0;
    let voiceMode      = false;

    document.addEventListener('DOMContentLoaded', () => {
        const dur = parseInt(new URLSearchParams(window.location.search).get('duration')||'0', 10);
        if (dur > 0) openTimerModal(dur);
    });
    openBtn.addEventListener('click', () => openTimerModal(0));

    function openTimerModal(duration) {
        voiceMode = duration > 0;
        seconds   = duration;
        inputSection.style.display  = voiceMode ? 'none' : 'block';
        displayEl.innerText         = formatTime(seconds);
        timeUpMsg.style.display     = 'none';
        startBtn.disabled = false;
        stopBtn.disabled  = true;
        resetBtn.disabled = true;
        openBtn.style.display = 'none';
        modal.style.display   = 'flex';
        if (voiceMode) startCountdown();
    }

    startBtn.addEventListener('click', () => {
        const m = parseInt(document.getElementById('minInput').value,10);
        const s = parseInt(document.getElementById('secInput').value,10);
        seconds = m*60 + s;
        if (seconds <= 0) return alert('0초 이상 설정해주세요.');
        inputSection.style.display = 'none';
        startCountdown();
    });

    function startCountdown() {
        startBtn.disabled = true; stopBtn.disabled = false; resetBtn.disabled = false;
        countdownTimer = setInterval(() => {
            seconds--;
            displayEl.innerText = formatTime(seconds);
            if (seconds <= 0) {
                clearInterval(countdownTimer);
                stopBtn.disabled = true;
                if (voiceMode) {
                    closeTimerModal();
                    const u = new SpeechSynthesisUtterance('타이머가 종료되었습니다.');
                    u.lang = 'ko-KR'; u.rate = 0.9;
                    speechSynthesis.speak(u);
                } else {
                    timeUpMsg.style.display = 'block';
                }
            }
        }, 1000);
    }

    stopBtn.addEventListener('click', () => {
        clearInterval(countdownTimer);
        startBtn.disabled = false; stopBtn.disabled = true;
    });

    resetBtn.addEventListener('click', () => {
        clearInterval(countdownTimer);
        seconds = 0;
        displayEl.innerText = '00분 00초';
        inputSection.style.display = 'block';
        startBtn.disabled = false; stopBtn.disabled = true; resetBtn.disabled = true;
        timeUpMsg.style.display = 'none';
    });

    function closeTimerModal() {
        // 1. 부모 페이지의 모달 닫기
        if (window.parent && typeof window.parent.closeTimerModal === 'function') {
            window.parent.closeTimerModal();
        }
        // 2. iframe 내부 화면 초기화 (옵션)
        document.body.innerHTML = '';
    }

    // 시간 종료 시 닫기 호출
    function onTimeUp() {
        // 기존 TTS 로직 이후
        if (window.parent && window.parent.closeTimerModal) {
            window.parent.closeTimerModal();
        }
        // 1초 뒤 닫기
        setTimeout(closeTimerModal, 200);
    }

    function formatTime(sec) {
        const m = String(Math.floor(sec/60)).padStart(2,'0');
        const s = String(sec%60).padStart(2,'0');
        return `${m}분 ${s}초`;
    }
</script>


</body>
</html>
