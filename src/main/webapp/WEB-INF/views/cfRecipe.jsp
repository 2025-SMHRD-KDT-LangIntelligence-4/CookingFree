<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="cpath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>${recipe.recipe_name} | 쿠킹프리</title>
<%--    <link rel="stylesheet" href="${cpath}/css/header.css"/>--%>
    <style>
        html, body { margin:0; padding:0; width:100%; height:100%; font-family:'Noto Sans KR'; }
        #cookMode { height:100vh; overflow:hidden; position:relative; }
        #stepContainer { height:100vh; overflow-y:hidden; display:flex; flex-direction:column; }

        .step { display:none; position:relative; flex:1; padding:20px; box-sizing:border-box; }
        .step.active { display:flex; flex-direction:column; }

        .overview .layout { flex:1; display:flex; }
        .overview .left { flex:2; padding:20px; }
        .overview .left img { width:100%; max-height:60%; object-fit:cover; border:3px solid #ddd; border-radius:10px; }
        .overview .left p { margin-top:20px; font-size:16px; color:#333; }
        .overview .right { flex:1; display:flex; flex-direction:column; justify-content:center; align-items:center; gap:20px; }
        .btn-mode { width:120px; height:120px; background:#fff; border:3px solid #ddd; border-radius:10px; font-size:24px; cursor:pointer; }

        .ingredients ul { list-style:none; padding:0; margin:0; }
        .ingredients li { margin:8px 0; font-size:16px; }

        #stepItems { flex:1; display:flex; align-items:center; justify-content:center; position:relative; }
        .step-item { display:none; flex-direction:column; align-items:center; text-align:center; }
        .step-item.active { display:flex; }
        .step-item img { max-width:60%; margin:20px 0; border:3px solid #ddd; border-radius:10px; }
        .step-text { font-size:16px; color:#333; margin:0 0 20px; }

        .review .comment-input { display:flex; gap:8px; margin-bottom:16px; }
        .review textarea { flex:1; padding:8px; resize:none; }
        .review select { width:80px; }
        .review button { padding:8px 16px; background:#4caf50; color:#fff; border:none; border-radius:4px; cursor:pointer; }
        .comment-list { width:100%; max-width:600px; margin:0 auto; }
        .comment-item { border-bottom:1px solid #ddd; padding:12px 0; }
        .comment-item .meta { font-size:14px; color:#666; margin-bottom:4px; }
        .comment-item .content { font-size:16px; }

        .nav-buttons { width:100%; display:flex; justify-content:space-between; padding:0 20px; margin-top:auto; }
        .nav-buttons button { background:#4caf50; color:#fff; border:none; padding:10px 20px; border-radius:4px; cursor:pointer; }

        #btnSpeakStep { position:absolute; top:20px; left:20px; font-size:24px; background:#fff; border:1px solid #ccc; border-radius:4px; padding:8px; cursor:pointer; }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<%--<jsp:include page="inc/header.jsp"/>--%>

<div id="cookMode">
    <div id="stepContainer">

        <!-- 1. Overview -->
        <section id="overview" class="step overview active">
            <h2>요리 개요: ${recipe.recipe_name}</h2>
            <div class="layout">
                <div class="left">
                    <img src="${not empty recipe.recipe_img ? recipe.recipe_img : cpath + '/upload/default-recipe.jpg'}" alt="레시피 이미지"/>
                    <p>${recipe.recipe_desc}</p>
                </div>
                <div class="right">
                    <button id="btnVoiceMode" class="btn-mode">🎤</button>
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
                     <li>${ing.ingre_name} ${ing.input_amount}${ing.ingre_unit}</li>
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
            <button id="btnSpeakStep">🔊 읽기</button>
            <div id="stepItems">
                <c:forEach var="step" items="${steps}" varStatus="st">
                    <div class="step-item" data-index="${st.index}">
                        <h3>STEP ${step.step_order}/${steps.size()}</h3>
                        <img src="${not empty step.img ? step.img : cpath + '/upload/default-step.jpg'}" alt="step"/>
                        <p class="step-text">${step.cooking_desc}</p>
                    </div>
                </c:forEach>
            </div>
            <div class="nav-buttons">
                <button id="btnPrevStep">← 이전 단계</button>
                <button id="btnNextStep">다음 단계 →</button>
            </div>
        </section>

        <!-- 4. Review -->
        <section id="review" class="step review">
            <h2>리뷰</h2>
            <div class="comment-input">
                <textarea id="reviewContent" rows="2" placeholder="댓글을 입력하세요…"></textarea>
                <select id="reviewRating">
                    <option>5</option><option>4</option><option>3</option><option>2</option><option>1</option>
                </select>
                <button id="btnSubmitReview">작성</button>
            </div>
            <div id="commentList" class="comment-list">
                <c:forEach var="rev" items="${reviews}">
                    <div class="comment-item">
                        <div class="meta">
                                ${rev.nick} • <fmt:formatDate value="${rev.created_at}" pattern="yyyy-MM-dd HH:mm"/> • ★${rev.rating}
                        </div>
                        <div class="content">${rev.cmt_content}</div>
                    </div>
                </c:forEach>
            </div>
            <div id="cookfree-text" style="display:none;">
                쿠킹프리 첫번째 레시피입니다. 다음 명령어를 말씀해주세요.
            </div>
            <div class="nav-buttons">
                <button class="btnPrev">← 이전</button>
            </div>
        </section>

    </div>
</div>

<script>
    $(function(){
        let isRecognizing = false;
        let currentStage = 0, totalStages = 3;
        let stepIdx = 0;
        const $steps = $('.step');
        const $items = $('#stepItems .step-item');
        const lastIdx = $items.length - 1;

        // Levenshtein 거리 함수
        function levenshtein(a, b) {
            const dp = Array(a.length + 1).fill(null).map(() => Array(b.length + 1).fill(0));
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

        // TTS 음성 로드
        let koreanVoice = null;
        function loadVoices() {
            const voices = speechSynthesis.getVoices();
            koreanVoice = voices.find(v =>
                v.lang === 'ko-KR' || v.lang.startsWith('ko') || v.name.includes('한국')
            );
        }
        speechSynthesis.onvoiceschanged = loadVoices;
        loadVoices();

        // 텍스트 읽기 함수
        function speak(text) {
            if (!text || !koreanVoice) return;
            const u = new SpeechSynthesisUtterance(text.trim());
            u.lang = 'ko-KR';
            u.voice = koreanVoice;
            u.rate = 0.9;
            speechSynthesis.cancel();
            speechSynthesis.speak(u);
        }

        // 섹션 표시 함수
        function showStage(idx) {
            currentStage = Math.min(Math.max(0, idx), totalStages);
            $steps.each((i, el) => {
                const $el = $(el);
                if (i === currentStage) $el.addClass('active').show();
                else $el.removeClass('active').hide();
            });
            if (currentStage === 2) {
                stepIdx = 0;
                $items.removeClass('active').hide()
                    .eq(0).addClass('active').show();
                speak($items.eq(0).find('.step-text').text());
            }
            bindNavButtons();
            $('#stepContainer').css('overflow-y', currentStage === 0 ? 'hidden' : 'auto');
        }
        function bindNavButtons() {
            $('.nav-buttons').hide();

            if (currentStage === 2) {                      // 조리 단계 화면
              const $nav = $('#btnPrevStep, #btnNextStep').closest('.nav-buttons').show();

              // 1) 버튼 라벨 동적 변경
              const $nextBtn = $('#btnNextStep');
              $nextBtn.text(stepIdx === lastIdx ? '요리 완료' : '다음 단계 →');

              // 2) 이벤트 재바인딩
              $nextBtn.off('click').on('click', () => {
                if (stepIdx < lastIdx) {                   // 아직 남은 단계가 있을 때
                  $items.eq(stepIdx).removeClass('active').hide();
                  stepIdx++;
                  $items.eq(stepIdx).addClass('active').show();
                  speak($items.eq(stepIdx).find('.step-text').text());
                  // 라벨 갱신
                  $nextBtn.text(stepIdx === lastIdx ? '요리 완료' : '다음 단계 →');
                } else {                                   // 마지막 단계 → cfReview 이동
                  const ridx = ${recipe.recipe_idx};
                  window.location.href = '${cpath}/cfReview?recipe_idx=' + ridx;
                }
              });

              $('#btnPrevStep').off('click').on('click', () => {
                if (stepIdx > 0) {
                  $items.eq(stepIdx).removeClass('active').hide();
                  stepIdx--;
                  $items.eq(stepIdx).addClass('active').show();
                  speak($items.eq(stepIdx).find('.step-text').text());
                  // 라벨 갱신
                  $nextBtn.text('다음 단계 →');
                }
              });

            } else {                                       // Overview·Ingredients
              const $nav = $steps.eq(currentStage).find('.nav-buttons').show();
              $nav.find('.btnNext').off().on('click', () => showStage(currentStage + 1));
              $nav.find('.btnPrev').off().on('click', () => showStage(currentStage - 1));
            }
          };

          // ====== showStage 진입 시 라벨 초기화 보강 ======
          function showStage(idx) {
            currentStage = Math.min(Math.max(0, idx), totalStages);
            $steps.hide().removeClass('active').eq(currentStage).addClass('active').show();

            if (currentStage === 2) {
              stepIdx = 0;
              $items.hide().removeClass('active').eq(0).addClass('active').show();
              speak($items.eq(0).find('.step-text').text());
            }
            bindNavButtons();
            $('#stepContainer').css('overflow-y', currentStage === 0 ? 'hidden' : 'auto');
          }


        // 초기 표시
        showStage(0);

        // 터치 모드 버튼
        $('#btnTouchMode').on('click', () => showStage(1));

        // 음성 인식 설정
        const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
        const recognition = new SpeechRecognition();
        recognition.lang = 'ko-KR';
        recognition.continuous = true;
        recognition.interimResults = false;

        // 음성 모드 버튼
        $('#btnVoiceMode').on('click', () => {
            if (!isRecognizing) recognition.start();
        });

        recognition.onstart = () => {
            isRecognizing = true;
            $('#btnVoiceMode').prop('disabled', true).text('음성 제어 중…');
        };

        recognition.onresult = e => {
            let raw = e.results[e.results.length - 1][0].transcript;
            let txt = raw.toLowerCase().trim().replace(/[^가-힣]/g, '');
            // 정규화: '쿠킹프리' 합치기
            txt = txt.replace(/쿠킹프리/g, '쿠킹프리');

            console.log('인식 원본:', raw, '정규화:', txt);

            const cmds = [
                { key: '쿠킹프리다음', action: () => currentStage === 2 ? $('#btnNextStep').click() : showStage(currentStage + 1) },
                { key: '쿠킹프리이전', action: () => currentStage === 2 ? $('#btnPrevStep').click() : showStage(currentStage - 1) },
                { key: '쿠킹프리처음', action: () => showStage(2) },
                { key: '쿠킹프리다시읽어', action: () => { currentStage === 2 ? speak($items.eq(stepIdx).find('.step-text').text()) : speak($('#cookfree-text').text()); } }
            ];

            cmds.forEach(cmd => {
                const dist = levenshtein(txt, cmd.key);
                if (dist <= 2) {
                    console.log(`명령 인식: ${cmd.key} (거리 ${dist})`);
                    cmd.action();
                }
            });
        };

        recognition.onerror = () => {
            if (isRecognizing) recognition.stop();
        };

        recognition.onend = () => {
            if (isRecognizing) {
                try { recognition.start(); } catch {}
            } else {
                $('#btnVoiceMode').prop('disabled', false).text('🎤');
                bindNavButtons();
            }
        };

        // 읽기 버튼
        $('#btnSpeakStep').on('click', () => {
            if (currentStage === 2) {
                speak($items.eq(stepIdx).find('.step-text').text());
            }
        });

        // review submit
        $('#btnSubmitReview').on('click', function(){
            const content=$('#reviewContent').val().trim();
            const rating=$('#reviewRating').val();
            if(!content){ alert('리뷰 내용을 입력해주세요.'); return; }
            $.ajax({
                url:'${cpath}/recipe/review/add', type:'POST',
                beforeSend:x=>x.setRequestHeader('${_csrf.headerName}','${_csrf.token}'),
                data:{recipe_idx:${recipe.recipe_idx},cmt_content:content,rating},
                success(res){
                    if(res.success){
                        $('#commentList').prepend(`
<div class="comment-item">
  <div class="meta">${res.nick} • ${res.created_at} • ★${res.rating}</div>
  <div class="content">${res.cmt_content}</div>
</div>`);
                        $('#reviewContent').val('');$('#reviewRating').val('5');
                    } else alert(res.message);
                },
                error(){ alert('리뷰 등록 중 오류'); }
            });
        });
    });
</script>
</body>
</html>
