<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="cpath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${recipe.recipe_name}완료 | 쿠킹프리</title>
<link rel="stylesheet" href="${cpath}/css/cfReview.css">
<style>
/* 기본 스타일 (기존 코드와 유사) */
body {
	font-family: 'HakgyoansimByeoljariTTF-B', sans-serif !important;
	margin: 0;
	padding: 0;
	background-color: #f8f8f8;
	color: #333;
}
*{
	font-family: 'HakgyoansimByeoljariTTF-B', sans-serif !important;
}
header {
	background-color: #fff;
	padding: 15px 20px;
	border-bottom: 1px solid #eee;
	text-align: center;
}

.title-input {
	width: 100%;
	padding: 10px 15px;
	border: none;
	font-size: 24px;
	font-weight: bold;
	text-align: center;
	background: transparent;
	box-sizing: border-box;
}

/* Hero 섹션 */
.hero {
	position: relative;
	width: 100%;
	border-radius: 10px;
	overflow: hidden;
}

.hero .img1 {
	width: 100%; /* 이미지가 부모(hero) 너비에 꽉 차도록 */
	object-fit: cover; /* 이미지가 잘리더라도 비율을 유지하며 채우도록 */
	display: block;
}

.overlay-card {
	position: absolute;
	bottom: 0;
	right: 0;
	background: rgba(255, 255, 255, 0.9);
	padding: 20px;
	/* transform: translateY(0%); 이 속성은 제거하거나 모바일 미디어 쿼리 안으로 이동*/
	transition: transform 0.3s ease-in-out;
	box-sizing: border-box; /* padding이 너비 계산에 포함되도록 */
	max-height: 80%; /* 오버레이 카드의 최대 높이 설정 (조정 가능) */
	overflow-y: auto; /* 내용이 넘치면 스크롤 가능하도록 */
}

.hero:hover .overlay-card {
	transform: translateY(0); /* 항상 보이도록 유지 */
}

.overlay-card h2 {
	font-size: 2em;
	margin-top: 0;
	margin-bottom: 10px;
	color: #333;
}

.overlay-card p {
	font-size: 1em;
	color: #555;
	margin-bottom: 15px;
}

.author-info {
	display: flex;
	align-items: center;
	gap: 10px;
	margin-bottom: 15px;
}

.author-info img {
	border-radius: 50%;
	border: 2px solid #ddd;
}

.author-details .name {
	font-weight: bold;
	color: #333;
}

.author-details .date {
	font-size: 0.85em;
	color: #777;
}

.like-button {
	background: #ff6b6b;
	color: #fff;
	border: none;
	border-radius: 5px;
	padding: 5px 10px;
	cursor: pointer;
	margin-left: auto; /* 오른쪽으로 밀기 */
}

.meta-info {
	display: flex;
	justify-content: space-between;
	align-items: center;
	font-size: 0.9em;
	color: #777;
}

.read-more, .comments {
	cursor: pointer;
	text-decoration: none;
	color: #007bff;
}

.achievements, .progress, .comment-section {
	width: 100%;
	padding: 20px;
	background-color: #fff;
	border-radius: 10px;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
}

.achievements {
	text-align: center;
	font-size: 1.2em;
	font-weight: bold;
	color: #4CAF50;
}

.progress-bar {
	background-color: #e0e0e0;
	border-radius: 5px;
	overflow: hidden;
	height: 25px;
	margin-top: 10px;
}

.progress-fill {
	height: 100%;
	background-color: #4CAF50;
	width: var(--progress-width, 0%); /* JS에서 설정할 예정 */
	display: flex;
	align-items: center;
	justify-content: center;
	color: white;
	font-weight: bold;
	transition: width 0.5s ease-in-out;
}

.comment-input {
	display: flex;
	flex-direction: column;
	gap: 10px;
	margin-bottom: 20px;
}

.input-row {
	display: flex;
	gap: 10px;
	align-items: flex-end;
}

.comment-input textarea {
	flex: 1;
	padding: 8px;
	resize: none;
	border: 1px solid #ddd;
	border-radius: 4px;
}

.comment-input input[type="file"] {
	width: 100%; /* 모바일에서 전체 너비 사용 */
	padding: 8px 0;
	box-sizing: border-box;
}

.comment-input button {
	padding: 8px 16px;
	background: #4caf50;
	color: #fff;
	border: none;
	border-radius: 4px;
	cursor: pointer;
}

.review-image, .image-preview {
	max-width: 100%; /* 모바일에서 이미지 크기 제한 */
	height: auto; /* 비율 유지 */
	object-fit: cover;
	border-radius: 4px;
	margin-top: 8px;
	display: block; /* 블록 요소로 만들어 줄바꿈 */
}

.comment-item {
	border-bottom: 1px solid #ddd;
	padding: 12px 0;
}

.review-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 8px;
	flex-wrap: wrap; /* 작은 화면에서 줄바꿈 허용 */
}

.reviewer-name {
	font-weight: bold;
	margin-right: 10px; /* 이름과 날짜 사이 간격 */
}

.review-date {
	color: #666;
	font-size: 12px;
}

.delete-btn {
	background: #f44336;
	color: #fff;
	border: none;
	padding: 4px 8px;
	border-radius: 4px;
	cursor: pointer;
	font-size: 12px;
	margin-left: 10px; /* 날짜와 버튼 사이 간격 */
}

.review-content {
	margin-bottom: 8px;
	font-size: 1em;
	line-height: 1.5;
}

/* ==============================================
   모바일 반응형 디자인을 위한 미디어 쿼리 시작
   ============================================== */
@media ( max-width : 768px) {
	/* 일반적인 조정 */
	body {
		font-size: 15px; /* 기본 폰트 크기 조정 */
	}
	header {
		padding: 10px 15px;
	}
	.title-input {
		font-size: 20px; /* 제목 폰트 크기 조정 */
		padding: 8px 10px;
	}

	/* Hero 섹션 */
	.hero {
		height:auto;
	}
	.hero .img1 {
		height: 200px; /* 모바일에서 이미지 높이를 더 줄임 */
		/* object-fit: contain;  이미지가 잘리지 않도록 (필요시 cover 대신 사용) */
	}
	.overlay-card {
		position: relative; /* 모바일에서는 상대적 위치로 변경하여 이미지 아래에 배치 */
		background: #fff; /* 불투명하게 변경 */
		padding: 15px;
		transform: translateY(0); /* 항상 보이도록 유지 */
		max-height: none; /* 모바일에서는 최대 높이 제한을 해제하여 내용이 다 보이도록 */
		overflow-y: visible; /* 스크롤바 숨김 */
		max-width:400px;
	}
	.overlay-card h2 {
		font-size: 1.5em; /* 제목 크기 조정 */
	}
	.overlay-card p {
		font-size: 0.9em; /* 설명 폰트 크기 조정 */
		margin-bottom: 10px;
	}
	.author-info {
		flex-wrap: wrap; /* 요소들이 많을 경우 줄바꿈 */
		justify-content: center; /* 중앙 정렬 */
		margin-bottom: 10px;
	}
	.author-info img {
		width: 40px;
		height: 40px;
	}
	.like-button {
		margin-left: 0; /* 중앙 정렬을 위해 마진 제거 */
		width: 100%; /* 너비를 꽉 채우도록 */
		margin-top: 10px; /* 버튼 위에 간격 추가 */
		padding: 8px;
	}
	.like-count {
		width: 100%; /* 너비를 꽉 채우도록 */
		text-align: center;
		margin-top: 5px;
	}
	.meta-info {
		flex-direction: column; /* 메타 정보를 세로로 쌓기 */
		align-items: center; /* 중앙 정렬 */
		gap: 8px; /* 간격 추가 */
		font-size: 0.85em;
	}

	/* Achievements & Progress 섹션 */
	.achievements, .progress, .comment-section {
		padding: 15px; /* 내부 패딩 줄이기 */
		border-radius: 5px; /* 모서리 둥글기 줄이기 */
	}
	.achievements {
		font-size: 1em;
	}

	/* Comment 섹션 */
	.comment-input .input-row {
		flex-direction: column; /* 입력창과 버튼을 세로로 쌓기 */
		align-items: stretch; /* 늘려서 너비를 채우도록 */
		gap: 8px;
	}
	.comment-input textarea {
		min-height: 80px; /* 텍스트 영역 최소 높이 */
	}
	.comment-input button {
		width: 100%; /* 버튼 너비 꽉 채우기 */
		padding: 10px;
	}

	/* 파일 입력 및 이미지 미리보기 */
	.comment-input input[type="file"] {
		font-size: 0.9em;
	}
	.review-image, .image-preview {
		max-width: 100%; /* 모바일에서 이미지 최대 너비 */
		height: auto;
	}
	.review-header {
		flex-direction: column; /* 후기 헤더 정보 세로로 쌓기 */
		align-items: flex-start; /* 왼쪽 정렬 */
		gap: 5px;
	}
	.review-date, .delete-btn {
		margin-left: 0; /* 정렬을 위해 마진 제거 */
	}
	.review-date {
		order: 2; /* 날짜를 아래로 */
	}
	.delete-btn {
		order: 3; /* 삭제 버튼을 가장 아래로 */
		align-self: flex-end; /* 오른쪽으로 */
	}
	.reviewer-name {
		order: 1; /* 이름을 위로 */
		width: 100%; /* 이름이 한 줄을 차지하도록 */
		margin-right: 0;
	}
	.review-content {
		font-size: 0.95em; /* 후기 내용 폰트 크기 조정 */
	}
}
</style>
</head>
<body onload="updateViews()">
	<jsp:include page="inc/header.jsp" />

	<header>
		<input type="text" class="title-input" value="${recipe.recipe_name}"
			readonly />
	</header>

	<section class="hero">
		<img class="img1"
			src="${not empty recipe.recipe_img ? recipe.recipe_img : cpath + '/upload/default-recipe.jpg'}"
			alt="레시피 이미지">
		<div class="overlay-card">
			<h2>${recipe.recipe_name}</h2>
			<p>${recipe.recipe_desc}</p>
			<div class="author-info">
				<img src="${cpath}/upload/profileDefault.jpg" alt="Author"
					style="width: 50px; height: 50px;">
				<div class="author-details">
					<div class="name">${recipe.author_nick}</div>
					<div class="date">
						<fmt:formatDate value="${recipe.created_at}" pattern="yyyy.MM.dd" />
					</div>
				</div>
				<button class="like-button" onclick="toggleLike(this)">♡</button>
				<span class="like-count"><span id="likeCount">0</span> Like</span>
			</div>
			<div class="meta-info">
				<a href="#" class="read-more">Read More</a> <span class="views">👁️
					<span id="viewCount">0</span> Views
				</span> <span class="comments"
					onclick="document.getElementById('reviewContent').focus()">💬
					Comment</span>
			</div>
		</div>
	</section>

	<section class="achievements">🎉 ${recipe.recipe_name} 요리를
		완성했습니다!</section>

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
				<input type="file" id="reviewImage" accept="image/*"
					onchange="previewImage(this)"> <img id="imagePreview"
					class="image-preview" style="display: none;">
			</div>
		</c:if>
		<c:if test="${empty userIdx}">
			<p>
				후기를 작성하려면 <a href="${cpath}/login">로그인</a>해주세요.
			</p>
		</c:if>
		<div class="comment-list" id="commentList">
			<c:forEach var="review" items="${reviews}">
				<div class="comment-item" data-review-idx="${review.review_idx}">
					<div class="review-header">
						<span class="reviewer-name">${review.nick}</span>
						<div>
							<span class="review-date"><fmt:formatDate
									value="${review.created_at}" pattern="yyyy-MM-dd HH:mm" /></span>
							<c:if test="${review.user_idx == userIdx}">
								<button class="delete-btn"
									onclick="deleteReview(${review.review_idx})">삭제</button>
							</c:if>
						</div>
					</div>
					<p class="review-content">${review.cmt_content}</p>
					<c:if test="${not empty review.review_img}">
						<img src="${cpath}${review.review_img}" alt="리뷰 이미지"
							class="review-image">
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
