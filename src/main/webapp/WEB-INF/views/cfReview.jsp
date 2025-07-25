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
<link rel="stylesheet" href="${cpath}/css/cfReview.css">
</head>
<body>
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