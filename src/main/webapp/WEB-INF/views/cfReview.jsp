<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="cpath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${recipe.recipe_name} 완료 | 쿠킹프리</title>
    <link rel="stylesheet" href="${cpath}/css/cfReview.css">
    <style>
        .comment-input { display:flex; flex-direction:column; gap:10px; margin-bottom:20px; }
        .input-row { display:flex; gap:10px; align-items:flex-end; }
        .comment-input textarea { flex:1; padding:8px; resize:none; }
        .comment-input input[type="file"] { width:200px; }
        .comment-input button { padding:8px 16px; background:#4caf50; color:#fff; border:none; border-radius:4px; cursor:pointer; }
        .review-image, .image-preview { max-width:200px; max-height:150px; object-fit:cover; border-radius:4px; margin-top:8px; }
        .comment-item { border-bottom:1px solid #ddd; padding:12px 0; }
        .review-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:8px; }
        .reviewer-name { font-weight:bold; }
        .review-date { color:#666; font-size:12px; }
        .delete-btn { background:#f44336; color:#fff; border:none; padding:4px 8px; border-radius:4px; cursor:pointer; font-size:12px; }
        .review-content { margin-bottom:8px; }
    </style>
</head>
<body onload="updateViews()">
<jsp:include page="inc/header.jsp"/>

<header>
    <input type="text" class="title-input" value="${recipe.recipe_name}" readonly />
</header>

<section class="hero">
    <img class="img1" src="${not empty recipe.recipe_img ? recipe.recipe_img : cpath + '/upload/default-recipe.jpg'}" alt="레시피 이미지">
    <div class="overlay-card">
        <h2>${recipe.recipe_name}</h2>
        <p>${recipe.recipe_desc}</p>
        <div class="author-info">
            <img src="${cpath}/upload/profile/default.jpg" alt="Author" style="width:100px;height:100px;">
            <div class="author-details">
                <div class="name">${recipe.author_nick}</div>
                <div class="date"><fmt:formatDate value="${recipe.created_at}" pattern="yyyy.MM.dd"/></div>
            </div>
            <button class="like-button" onclick="toggleLike(this)">♡</button>
            <span class="like-count"><span id="likeCount">0</span> Like</span>
        </div>
        <div class="meta-info">
            <a href="#" class="read-more">Read More</a>
            <span class="views">👁️ <span id="viewCount">0</span> Views</span>
            <span class="comments" onclick="document.getElementById('reviewContent').focus()">💬 Comment</span>
        </div>
    </div>
</section>

<section class="achievements">🎉 ${recipe.recipe_name} 요리를 완성했습니다!</section>

<section class="progress">
    <h3>달성도</h3>
    <div class="progress-bar">
        <div class="progress-fill">${achievementRate}%</div>
    </div>
</section>

<section class="comment-section">
    <h3>요리 후기</h3>
    <c:if test="${not empty userIdx}">
        <div class="comment-input">
            <div class="input-row">
                <textarea id="reviewContent" rows="3" placeholder="요리 후기를 남겨주세요..."></textarea>
                <button onclick="addComment()">작성</button>
            </div>
            <input type="file" id="reviewImage" accept="image/*" onchange="previewImage(this)">
            <img id="imagePreview" class="image-preview" style="display:none;">
        </div>
    </c:if>
    <c:if test="${empty userIdx}">
        <p>후기를 작성하려면 <a href="${cpath}/login">로그인</a>해주세요.</p>
    </c:if>
    <div class="comment-list" id="commentList">
        <c:forEach var="review" items="${reviews}">
            <div class="comment-item" data-review-idx="${review.review_idx}">
                <div class="review-header">
                    <span class="reviewer-name">${review.nick}</span>
                    <div>
                        <span class="review-date"><fmt:formatDate value="${review.created_at}" pattern="yyyy-MM-dd HH:mm"/></span>
                        <c:if test="${review.user_idx == userIdx}">
                            <button class="delete-btn" onclick="deleteReview(${review.review_idx})">삭제</button>
                        </c:if>
                    </div>
                </div>
                <p class="review-content">${review.cmt_content}</p>
                <c:if test="${not empty review.review_img}">
                    <img src="${cpath}${review.review_img}" alt="리뷰 이미지" class="review-image">
                </c:if>
            </div>
        </c:forEach>
    </div>
</section>

<script>
    const recipeIdx = ${recipe.recipe_idx};
    const userIdx = ${not empty userIdx ? userIdx : 'null'};

    function updateViews() {
        const viewElem = document.getElementById('viewCount');
        const key = `views_recipe_${recipeIdx}`;
        let views = localStorage.getItem(key) || 0;
        views++;
        localStorage.setItem(key, views);
        viewElem.innerText = views;
    }

    function previewImage(input) {
        const preview = document.getElementById('imagePreview');
        if (input.files[0]) {
            const reader = new FileReader();
            reader.onload = e => { preview.src = e.target.result; preview.style.display = 'block'; };
            reader.readAsDataURL(input.files[0]);
        } else {
            preview.style.display = 'none';
        }
    }

    function addComment() {
        const content = document.getElementById('reviewContent').value.trim();
        const file = document.getElementById('reviewImage').files[0];
        if (!content) { alert('후기 내용을 입력해주세요.'); return; }
        if (!userIdx) { alert('로그인이 필요합니다.'); return; }
        const formData = new FormData();
        formData.append('recipe_idx', recipeIdx);
        formData.append('content', content);
        if (file) formData.append('image', file);
        fetch('${cpath}/cfReview/addReview', {
            method: 'POST',
            headers: { '${_csrf.headerName}': '${_csrf.token}' },
            body: formData
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                const commentList = document.getElementById('commentList');
                const div = document.createElement('div');
                div.className = 'comment-item';
                
                // 이미지 HTML을 조건부로 생성
                let imgHtml = '';
                if (data.imagePath) {
                    imgHtml = `<img src="${cpath}${data.imagePath}" class="review-image">`;
                }
                
                div.innerHTML = `
        <div class="review-header">
          <span class="reviewer-name">나</span>
          <div>
            <span class="review-date">방금 전</span>
            <button class="delete-btn" onclick="deleteReview(${data.reviewIdx})">삭제</button>
          </div>
        </div>
        <p class="review-content">${content}</p>
        ${imgHtml}
        `;
                commentList.prepend(div);
                document.getElementById('reviewContent').value = '';
                document.getElementById('reviewImage').value = '';
                document.getElementById('imagePreview').style.display = 'none';
            } else {
                alert(data.message);
            }
        })
        .catch(() => alert('후기 등록 중 오류'));
    }

    function deleteReview(idx) {
        if (!confirm('정말로 삭제하시겠습니까?')) return;
        fetch('${cpath}/cfReview/deleteReview', {
            method: 'POST',
            headers: { 'Content-Type':'application/x-www-form-urlencoded', '${_csrf.headerName}':'${_csrf.token}' },
            body: `review_idx=${idx}`
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                document.querySelector(`[data-review-idx="${idx}"]`).remove();
            } else alert(data.message);
        })
        .catch(() => alert('삭제 중 오류'));
    }

    function toggleLike(btn) {
        const countElem = document.getElementById('likeCount');
        let count = parseInt(countElem.innerText);
        let liked = localStorage.getItem(`liked_recipe_${recipeIdx}`) === 'true';
        liked = !liked;
        localStorage.setItem(`liked_recipe_${recipeIdx}`, liked);
        btn.innerText = liked ? '♥' : '♡';
        countElem.innerText = liked ? count+1 : count-1;
    }
</script>
</body>
</html>
