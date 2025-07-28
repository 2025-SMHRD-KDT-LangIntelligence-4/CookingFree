<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="cpath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Document</title>
<link rel="stylesheet" href="${cpath}/css/cfReview.css">
</head>
<body onload="updateViews()">
	<header>
		<input type="text" class="title-input" placeholder="레시피 제목을 입력하세요" />
	</header>

	<section class="hero">
		<img class="img1" src="HTML/img/오리.jpg">
		<div class="overlay-card">
			<h2>Green salad with cherries</h2>
			<p>This salad recipe may seem a bit boring and insignificant, but
				this recipe is sort of the basic foundation of...</p>
			<div class="author-info">
				<img src="https://randomuser.me/api/portraits/women/68.jpg"
					alt="Julia Mayers" style="width: 100px; height: 100px;">
				<!--프로필 이미지-->
				<div class="author-details">
					<div class="name">Julia Mayers</div>
					<div class="date">Jul 23, 2015</div>
				</div>
				<button class="like-button" onclick="toggleLike(this)">♡</button>
				<span class="like-count"><span id="likeCount">224</span> Like</span>
			</div>
			<div class="meta-info">
				<a href="#" class="read-more">Read More</a> <span class="views">👁️
					<span id="viewCount">0</span> Views
				</span> <span class="comments"
					onclick="document.getElementById('commentInput').focus()">💬
					Comment</span>
			</div>
		</div>
	</section>

	<section class="achievements">🎉 오늘의 추천 레시피를 달성했습니다!</section>

	<section class="progress">
		<h3>달성도</h3>
		<div class="progress-bar">
			<div class="progress-fill">70%</div>
		</div>
	</section>

	<section class="comment-section">
		<h3>댓글</h3>
		<div class="comment-input">
			<input type="file" id="commentImageUpload" accept="image/*">
			<input type="text" id="commentInput" placeholder="댓글을 입력하세요...">
			<button onclick="addComment()">작성</button>
		</div>
		<div class="comment-list" id="commentList"></div>
	</section>

	<script>
    function updateViews() {
      const viewElem = document.getElementById('viewCount');
      let views = localStorage.getItem('views') || 0;
      views++;
      localStorage.setItem('views', views);
      viewElem.innerText = views;
    }

    function addComment() {
      const commentInput = document.getElementById('commentInput');
      const imageInput = document.getElementById('commentImageUpload');
      const commentList = document.getElementById('commentList');

      const text = commentInput.value.trim();
      const file = imageInput.files[0];

      if (!text && !file) {
        alert('댓글 내용 또는 이미지를 입력해주세요.');
        return;
      }

      const commentItem = document.createElement('div');
      commentItem.className = 'comment-item';

      if (text) {
        const textElem = document.createElement('p');
        textElem.innerText = text;
        commentItem.appendChild(textElem);
      }

      if (file) {
        const reader = new FileReader();
        reader.onload = function (e) {
          const img = document.createElement('img');
          img.className = 'comment-image';
          img.src = e.target.result;
          commentItem.appendChild(img);
        };
        reader.readAsDataURL(file);
      }

      commentList.prepend(commentItem);
      commentInput.value = '';
      imageInput.value = '';
    }

    let liked = localStorage.getItem('liked') === 'true';
    document.addEventListener('DOMContentLoaded', () => {
      const button = document.querySelector('.like-button');
      const countElem = document.getElementById('likeCount');
      if (liked) {
        button.innerText = '♥';
      }
    });

    function toggleLike(button) {
      const countElem = document.getElementById('likeCount');
      let count = parseInt(countElem.innerText);
      liked = !liked;
      localStorage.setItem('liked', liked);
      if (liked) {
        button.innerText = '♥';
        countElem.innerText = count + 1;
      } else {
        button.innerText = '♡';
        countElem.innerText = count - 1;
      }
    }
  </script>
</body>
</html>