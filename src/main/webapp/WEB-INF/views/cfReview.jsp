<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
    <c:set var="cpath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Document</title>
<style>
    * {
      box-sizing: border-box;
    }

    body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 0;
    }

    /* 상단 레이아웃 */
    .header {
      display: flex;
      justify-content: center;
      align-items: center;
      padding: 20px;
      border-bottom: 1px solid #ddd;
    }

    .recipe-title-input {
      font-size: 18px;
      font-weight: bold;
      width: 60%;
      padding: 10px;
      border: 2px solid #ccc;
      border-radius: 10px;
      text-align: center;
    }

    /* 중간 콘텐츠 영역 */
    .main-content {
      display: flex;
      justify-content: center;
      gap: 30px;
      padding: 30px;
    }

    .recipe-image {
      width: 400px;
      height: auto;
      border-radius: 10px;
      box-shadow: 0 0 5px rgba(0,0,0,0.1);
    }

    .side-panel {
      display: flex;
      flex-direction: column;
      gap: 20px;
      justify-content: center;
    }

    .message-box, .achievement-box {
      padding: 20px;
      border-radius: 12px;
      box-shadow: 0 0 6px rgba(0,0,0,0.1);
      font-weight: bold;
      text-align: center;
    }

    .message-box {
      background-color: #000;
      color: white;
      font-size: 18px;
      width: 300px;
      height: 200px;
    }

    .achievement-box {
      background-color: #f5f5f5;
      font-size: 16px;
      color: #444;
      width: 300px;
      height: 200px;
    }

    /* 댓글 영역 */
    .comment-section {
      width: 700px;
      margin: 50px auto;
    }

    .comment-sort {
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-size: 14px;
      color: #555;
      margin-bottom: 10px;
    }

    .sort-dropdown {
      position: relative;
    }

    #sortToggle {
      cursor: pointer;
      background: #eee;
      border: none;
      padding: 5px 10px;
      border-radius: 5px;
    }

    .dropdown-options {
      position: absolute;
      top: 30px;
      right: 0;
      background: #fff;
      border: 1px solid #ccc;
      box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
      z-index: 10;
    }

    .dropdown-options div {
      padding: 10px;
      cursor: pointer;
    }

    .dropdown-options div:hover {
      background: #f2f2f2;
    }

    .hidden {
      display: none;
    }

    .comment-input-wrapper {
      display: flex;
      align-items: flex-start;
      gap: 10px;
      margin-bottom: 20px;
    }

    .profile {
      width: 40px;
      height: 40px;
      border-radius: 50%;
    }

    .input-box {
      flex-grow: 1;
      position: relative;
    }

    .input-box input {
      width: 100%;
      padding: 10px;
      font-size: 14px;
      border: none;
      border-bottom: 1px solid #ccc;
      outline: none;
    }

    .line {
      height: 2px;
      background-color: black;
      width: 0;
      transition: width 0.3s;
      position: absolute;
      bottom: 0;
      left: 0;
    }

    .buttons {
      margin-top: 10px;
      display: flex;
      gap: 10px;
    }

    .buttons button {
      padding: 8px 14px;
      border-radius: 999px;
      border: none;
      font-size: 13px;
      cursor: pointer;
    }

    .cancel-btn {
      background: #f2f2f2;
      color: #333;
    }

    .submit-btn {
      background: #ddd;
      color: #999;
    }

    .submit-btn.active {
      background: #000;
      color: #fff;
    }

    .comment-item {
      margin-top: 10px;
      padding: 10px;
      border-bottom: 1px solid #eee;
    }
    /* GNB */
.gnb {
	display: flex; /*화면을 능동으로 배치할때*/
	flex-wrap: nowrap; /*수직정렬을 제한함 근데 기능 구현이 실패한듯함*/
	justify-content: space-between;
	align-items: center;
	padding: 20px 20px;
	background: #fff;
	overflow-x: auto;
	border-bottom: 1px solid #ddd;
	box-sizing: border-box;
	gap: 12px;
}

/* 왼쪽/오른쪽 아이콘 링크 */
.gnb-left a, .gnb-right a {
	display: flex;
	align-items: center;
	margin-left: 10px;
	text-decoration: none;
}

/* 가운데 로고 */
.gnb-center {
	flex: 0 1 auto; /* 기본값 auto 유지 + 필요시 줄어듬 */
	min-width: 80px; /* 최소 넓이 확보 */
	position: absolute;
	left: 50%;
	transform: translateX(-50%);
}

.logo {
	font-size: clamp(18px, 4vw, 32px); /* 반응형 크기 */
	font-weight: bold;
	font-family: 'Inter', sans-serif;
	color: #000;
}

/* 오른쪽 아이콘들 */
.gnb-right {
	display: flex;
	gap: 12px;
}

/* 아이콘 유동 크기 + 최소한의 보장 */
.icon {
	width: clamp(18px, 5vw, 36px);
	height: clamp(18px, 5vw, 36px);
	min-width: 18px;
	min-height: 18px;
	object-fit: contain;
}
/* 모바일 대응 */
@media ( max-width : 768px) {
	.gnb {
		padding: 12px;
		gap: 8px;
	}
	.gnb-right a {
		margin-left: 6px;
	}
}
    
  </style>
</head>
<body>
		<div class="gnb">
            <div class="gnb-left">
                <a href="#"><img src="${cpath}/upload/Vector.png" class="icon" /></a>
            </div>
           	<div class="gnb-center">
                <a href="${cpath}" style="text-decoration-line: none;"><div class="logo">CookIN(G)Free</div></a>
            </div>
            <div class="gnb-right">
                <a href="${cpath}/login"><img src="${cpath}/upload/Vectorinfo.svg" class="icon" /></a>
                <a href="${cpath}/cfMyPage"><img src="${cpath}/upload/Vectorfood.svg" class="icon" /></a>
                <a href="#"><img src="${cpath}/upload/Vectorsetting.svg" class="icon" /></a>
            </div>
        </div>
  <!-- 상단 레시피 제목 -->
  <div class="header">
    <input class="recipe-title-input" placeholder="레시피 제목을 입력하세요" />
  </div>

  <!-- 레시피 본문 영역 -->
  <div class="main-content">
    <img class="recipe-image" src="https://recipe1.ezmember.co.kr/cache/recipe/2020/11/23/8f32e12fbcfdd346a407e8cc3bd63c541.jpg" alt="레시피 이미지" />
    
    <div class="side-panel">
      <div class="message-box"> 레시피 완성 축하해요!</div>
      <div class="achievement-box"> 달성도 페이지로 이동</div>
    </div>
  </div>

  <!-- 댓글 영역 -->
  <div class="comment-section">
    <div class="comment-sort">
      <span id="comment-count">댓글 0개</span>
      <div class="sort-dropdown">
        <button id="sortToggle">정렬 기준 ▾</button>
        <div id="sortOptions" class="dropdown-options hidden">
          <div onclick="sortComments('popular')">인기순</div>
          <div onclick="sortComments('recent')">최신순</div>
        </div>
      </div>
    </div>

    <div class="comment-input-wrapper">
      <img class="profile" src="https://yt3.ggpht.com/default.jpg" />
      <div class="input-box">
        <input 
          type="text" 
          placeholder="댓글 추가..." 
          onfocus="showButtons()"
          oninput="checkInput(this.value)"
          onkeydown="if(event.key === 'Enter') addComment()"
          id="commentInput"
        >
        <div class="line" id="line"></div>
        <div class="buttons" id="buttons"></div>
      </div>
    </div>

    <div class="comment-list" id="commentList"></div>
  </div>

  <script>
    const comments = [
      { user: "태현", content: "좋아요!", date: "2024-05-01", likes: 5 },
      { user: "구크르", content: "완전 최고!", date: "2024-05-03", likes: 10 },
      { user: "MJ", content: "좋은 정보 감사합니다!", date: "2024-04-28", likes: 3 }
    ];

    const listEl = document.getElementById("commentList");
    const sortToggle = document.getElementById("sortToggle");
    const sortOptions = document.getElementById("sortOptions");
    const line = document.getElementById("line");
    const input = document.getElementById("commentInput");
    const buttons = document.getElementById("buttons");

    sortToggle.addEventListener("click", () => {
      sortOptions.classList.toggle("hidden");
    });

    function renderComments(type) {
      listEl.innerHTML = "";
      const sorted = [...comments];
      if (type === "popular") sorted.sort((a, b) => b.likes - a.likes);
      else sorted.sort((a, b) => new Date(b.date) - new Date(a.date));

      sorted.forEach(c => {
        const el = document.createElement("div");
        el.className = "comment-item";
        el.innerHTML = `<strong>${c.user}</strong>: ${c.content} <br/><small>❤️ ${c.likes} | ${c.date}</small>`;
        listEl.appendChild(el);
      });

      document.getElementById("comment-count").innerText = `댓글 ${sorted.length}개`;
    }

    function sortComments(criteria) {
      renderComments(criteria);
      sortOptions.classList.add("hidden");
      sortToggle.innerText = criteria === "popular" ? "인기순 ▾" : "최신순 ▾";
    }

    function showButtons() {
      line.style.width = "100%";
      buttons.innerHTML = `
        <button class="cancel-btn" onclick="cancelComment()">취소</button>
        <button class="submit-btn" id="submitBtn" onclick="addComment()" "disabled>댓글</button>
      `;
    }

    function cancelComment() {
      input.value = "";
      buttons.innerHTML = "";
      line.style.width = "0";
    }

    function checkInput(value) {
      const btn = document.getElementById("submitBtn");
      if (!btn) return;
      btn.disabled = !value.trim();
      btn.classList.toggle("active", value.trim());
    }

    function addComment() {
      const value = input.value.trim();
      if (!value) return;
      comments.push({ user: "익명", content: value, date: new Date().toISOString().slice(0, 10), likes: 0 });
      cancelComment();
      renderComments("recent");
    }

    renderComments("recent");
  </script>
s
</body>
</html>