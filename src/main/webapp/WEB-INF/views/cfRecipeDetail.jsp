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
	<title>${recipe.recipe_name}- 쿠킹프리</title>
	<meta name="_csrf" content="${_csrf.token}" />
	<meta name="_csrf_header" content="${_csrf.headerName}" />
	<link rel="stylesheet" href="${cpath}/css/cfRecipeDetail.css">
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<style>
		.gnb {
			display: flex;
			flex-wrap: nowrap;
			justify-content: space-between;
			align-items: center;
			padding: 20px 20px;
			background: #fff;
			overflow-x: auto;
			border-bottom: 1px solid #ddd;
			box-sizing: border-box;
			gap: 12px;
		}

		.gnb-left a, .gnb-right a {
			display: flex;
			align-items: center;
			margin-left: 10px;
			text-decoration: none;
		}

		.gnb-center {
			flex: 0 1 auto;
			min-width: 80px;
			position: absolute;
			left: 50%;
			transform: translateX(-50%);
		}

		.logo {
			font-size: clamp(18px, 4vw, 32px);
			font-weight: bold;
			font-family: 'Inter', sans-serif;
			color: #000;
		}

		.gnb-right {
			display: flex;
			gap: 12px;
		}

		.icon {
			width: clamp(18px, 5vw, 36px);
			height: clamp(18px, 5vw, 36px);
			min-width: 18px;
			min-height: 18px;
			object-fit: contain;
		}

	</style>
</head>

<body>
<jsp:include page="inc/header.jsp" />

<!-- 레시피 헤더 -->
<div class="container">
	<div class="recipe-header">
		<div class="recipe-title-input" readonly>${recipe.recipe_name}</div>
	</div>

	<!-- 레시피 메인 콘텐츠 -->
	<div class="main-content">
		<img class="recipe-image"
			 src="${not empty recipe.recipe_img ? recipe.recipe_img : cpath.concat('/upload/default-recipe.jpg')}"
			 alt="${recipe.recipe_name}" />

		<div class="side-panel">
			<div class="message-box">
				<div class="recipe-meta-info">
					<div class="meta-row">
						<span class="meta-label">분류:</span> <span class="meta-value">${recipe.cook_type}</span>
					</div>
					<div class="meta-row">
						<span class="meta-label">난이도:</span> <span class="meta-value">${recipe.recipe_difficulty}</span>
					</div>
					<c:if test="${recipe.cooking_time != null}">
						<div class="meta-row">
							<span class="meta-label">시간:</span> <span class="meta-value">${recipe.cooking_time}분</span>
						</div>
					</c:if>
					<c:if test="${recipe.servings != null}">
						<div class="meta-row">
							<span class="meta-label">인분:</span> <span class="meta-value">${recipe.servings}인분</span>
						</div>
					</c:if>
					<div class="meta-row view-count-row">
						<span class="meta-label">조회수:</span> <span class="meta-value">👁️
								<fmt:formatNumber value="${recipe.view_count}" pattern="#,###" />
							</span>
					</div>
				</div>
			</div>
		</div>
		<div class="achievement-box">
			<p class="recipe-description">${recipe.recipe_desc}</p>

			<c:if test="${not empty recipe.tags}">
				<div class="recipe-tags">
					<c:forEach var="tag" items="${recipe.tags.split(',')}"
							   varStatus="status">
						<span class="tag">#${tag.trim()}</span>
					</c:forEach>
				</div>
			</c:if>

			<div class="recipe-actions">
				<button class="btn-back" onclick="goBack()"><img src="${cpath}/upload/reset.svg" style="width:4vw; aspect-ratio:1/1;"/></button>
				<button class="btn-cooktime" onclick="gocook()">요리모드</button>
				<c:if test="${currentUserIdx != null}">
					<button class="btn-favorite" onclick="addToFavorites()"><img src="${cpath}/upload/star.svg" style="width:4vw; aspect-ratio:1/1;"/></button>
				</c:if>
			</div>
		</div>
	</div>
</div>

<!-- 댓글 섹션 -->
<div class="comment-section">
	<div class="comment-sort">
		<span id="comment-count">댓글 ${totalReviews}개</span>
		<div class="sort-dropdown">
			<button id="sortToggle">최신순 ▾</button>
			<div id="sortOptions" class="dropdown-options hidden">
				<div onclick="sortComments('recent')">최신순</div>
				<div onclick="sortComments('popular')">인기순</div>
			</div>
		</div>
	</div>

	<!-- 댓글 작성 -->
	<c:if test="${currentUserIdx != null}">
		<div class="comment-input-wrapper">
			<input type="hidden" name="${_csrf.parameterName}"
				   value="${_csrf.token}" /> <img class="profile"
												  src="${cpath}/upload/profileDefault.jpg" />
			<div class="input-box">
				<input type="text" placeholder="댓글 추가..." onfocus="showButtons()"
					   oninput="checkInput(this.value)"
					   onkeydown="if(event.key === 'Enter') addComment()"
					   id="commentInput" maxlength="500">
				<div class="line" id="line"></div>
				<div class="buttons" id="buttons"></div>
			</div>
		</div>
	</c:if>

	<c:if test="${currentUserIdx == null}">
		<div class="login-prompt">
			<p>
				댓글을 작성하려면 <a href="${cpath}/login">로그인</a>이 필요합니다.
			</p>
		</div>
	</c:if>

	<!-- 댓글 목록 -->
	<div class="comment-list" id="commentList">
		<c:choose>
			<c:when test="${not empty reviews}">
				<c:forEach var="review" items="${reviews}">
					<div
							class="comment-item ${review.super_idx != null ? 'reply' : 'main'}"
							data-review-id="${review.review_idx}">
						<div class="comment-content">
							<div class="comment-author">
								<strong>${review.nick}</strong> <span class="comment-date">
										<fmt:formatDate value="${review.created_at}"
														pattern="yyyy-MM-dd HH:mm" />
									</span>
							</div>

							<div class="comment-text" id="comment-text-${review.review_idx}">
									${review.cmt_content}</div>

							<!-- 댓글 수정 폼 (숨김) -->
							<div class="comment-edit-form"
								 id="edit-form-${review.review_idx}" style="display: none;">
								<input type="text" class="edit-input"
									   value="${review.cmt_content}" maxlength="500">
								<div class="edit-actions">
									<button onclick="saveEdit(${review.review_idx})"
											class="btn-save">저장</button>
									<button onclick="cancelEdit(${review.review_idx})"
											class="btn-cancel">취소</button>
								</div>
							</div>

							<div class="comment-actions">
								<c:if
										test="${review.super_idx == null && currentUserIdx != null}">
									<button onclick="showReplyForm(${review.review_idx})"
											class="btn-reply">답글</button>
								</c:if>

								<!-- 작성자만 수정/삭제 가능 -->
								<c:if test="${currentUserIdx == review.user_idx}">
									<button onclick="editComment(${review.review_idx})"
											class="btn-edit">수정</button>
									<button onclick="deleteComment(${review.review_idx})"
											class="btn-delete">삭제</button>
								</c:if>
							</div>

							<!-- 답글 작성 폼 (숨김) -->
							<c:if
									test="${currentUserIdx != null && review.super_idx == null}">
								<div class="reply-form" id="reply-form-${review.review_idx}"
									 style="display: none;">
									<input type="text" placeholder="답글을 입력하세요..." maxlength="500">
									<div class="reply-actions">
										<button onclick="submitReply(${review.review_idx})"
												class="btn-submit">답글 등록</button>
										<button onclick="hideReplyForm(${review.review_idx})"
												class="btn-cancel">취소</button>
									</div>
								</div>
							</c:if>
						</div>
					</div>
				</c:forEach>
			</c:when>
			<c:otherwise>
				<div class="no-comments">
					<p>아직 댓글이 없습니다. 첫 번째 댓글을 작성해보세요! 🍳</p>
				</div>
			</c:otherwise>
		</c:choose>
	</div>

	<!-- 페이징 -->
	<c:if test="${totalPages > 1}">
		<div class="pagination">
			<c:if test="${currentPage > 1}">
				<a href="?page=${currentPage - 1}" class="page-btn">이전</a>
			</c:if>

			<c:forEach begin="1" end="${totalPages}" var="pageNum">
				<a href="?page=${pageNum}"
				   class="page-btn ${pageNum == currentPage ? 'active' : ''}">${pageNum}</a>
			</c:forEach>

			<c:if test="${currentPage < totalPages}">
				<a href="?page=${currentPage + 1}" class="page-btn">다음</a>
			</c:if>
		</div>
	</c:if>
</div>

<script>
	var csrfToken  = $("meta[name='_csrf']").attr("content");
	var csrfHeader = $("meta[name='_csrf_header']").attr("content");
	// 댓글 입력 관련
	const line = document.getElementById("line");
	const input = document.getElementById("commentInput");
	const buttons = document.getElementById("buttons");
	const sortToggle = document.getElementById("sortToggle");
	const sortOptions = document.getElementById("sortOptions");

	// 정렬 토글
	if (sortToggle) {
		sortToggle.addEventListener("click", () => {
			sortOptions.classList.toggle("hidden");
		});
	}

	// 댓글 입력 시 버튼 표시
	function showButtons() {
		if (line) line.style.width = "100%";
		if (buttons) {
			buttons.innerHTML = `
                    <button class="cancel-btn" onclick="cancelComment()">취소</button>
                    <button class="submit-btn" id="submitBtn" onclick="addComment()" disabled>댓글</button>
                `;
		}
	}

	// 댓글 입력 취소
	function cancelComment() {
		if (input) input.value = "";
		if (buttons) buttons.innerHTML = "";
		if (line) line.style.width = "0";
	}

	// 입력 체크
	function checkInput(value) {
		const btn = document.getElementById("submitBtn");
		if (!btn) return;
		btn.disabled = !value.trim();
		btn.classList.toggle("active", value.trim());
	}

	function addComment() {
		const content = input ? input.value.trim() : '';

		if (!content) {
			alert('댓글 내용을 입력해주세요.');
			return;
		}

		$.ajax({
			url: '${cpath}/recipe/review/add',
			type: 'POST',
			data: {
				recipeIdx: ${recipe.recipe_idx},
				cmtContent: content
			},
			beforeSend: function(xhr) {
				xhr.setRequestHeader(csrfHeader, csrfToken);
			},
			success: function(response) {
				if (response.success) {
					alert(response.message);
					location.reload();
				} else {
					alert(response.message);
				}
			},
			error: function() {
				alert('댓글 등록 중 오류가 발생했습니다.');
			}
		});
	}

	// 답글 폼 표시/숨김
	function showReplyForm(reviewIdx) {
		$('#reply-form-' + reviewIdx).show();
	}

	function hideReplyForm(reviewIdx) {
		$('#reply-form-' + reviewIdx).hide();
	}

	// 답글 작성

	function submitReply(parentIdx) {
		const content = $('#reply-form-' + parentIdx + ' input').val().trim();
		if (!content) {
			alert('답글 내용을 입력해주세요.');
			return;
		}
		$.ajax({
			url: '${cpath}/recipe/review/add',
			type: 'POST',
			data: {
				recipeIdx: ${recipe.recipe_idx},
				cmtContent: content,
				superIdx: parentIdx
			},
			beforeSend: function(xhr) {
				xhr.setRequestHeader(csrfHeader, csrfToken);
			},
			success: function(response) {
				if (response.success) {
					alert(response.message);
					location.reload();
				} else {
					alert(response.message);
				}
			},
			error: function() {
				alert('답글 등록 중 오류가 발생했습니다.');
			}
		});
	}




	// 댓글 수정
	function editComment(reviewIdx) {
		$('#comment-text-' + reviewIdx).hide();
		$('#edit-form-' + reviewIdx).show();
	}

	function cancelEdit(reviewIdx) {
		$('#comment-text-' + reviewIdx).show();
		$('#edit-form-' + reviewIdx).hide();
	}

	function saveEdit(reviewIdx) {
		const content = $('#edit-form-' + reviewIdx + ' input').val().trim();

		if (!content) {
			alert('댓글 내용을 입력해주세요.');
			return;
		}

		$.ajax({
			url: '${cpath}/recipe/review/update',
			type: 'POST',
			data: {
				reviewIdx: reviewIdx,
				cmtContent: content
			},
			beforeSend: function(xhr) {
				xhr.setRequestHeader(csrfHeader, csrfToken);
			},
			success: function(response) {
				if (response.success) {
					alert(response.message);
					location.reload();
				} else {
					alert(response.message);
				}
			},
			error: function() {
				alert('댓글 수정 중 오류가 발생했습니다.');
			}
		});
	}


	// 댓글 삭제
	function deleteComment(reviewIdx) {
		if (!confirm('정말로 이 댓글을 삭제하시겠습니까?')) {
			return;
		}

		$.ajax({
			url: '${cpath}/recipe/review/delete',
			type: 'POST',
			data: {
				reviewIdx: reviewIdx
			},
			beforeSend: function(xhr) {
				xhr.setRequestHeader(csrfHeader, csrfToken);
			},
			success: function(response) {
				if (response.success) {
					alert(response.message);
					location.reload();
				} else {
					alert(response.message);
				}
			},
			error: function() {
				alert('댓글 삭제 중 오류가 발생했습니다.');
			}
		});
	}


	// 정렬 기능
	function sortComments(criteria) {
		const url = new URL(window.location);
		url.searchParams.set('sort', criteria);
		window.location.href = url.toString();
	}
	// 요리모드 버튼
	function gocook() {
		// recipeIdx는 JSP 모델에서 바인딩된 recipe.recipe_idx
		const idx = ${recipe.recipe_idx};
		// cfRecipe.jsp로 recipeIdx 쿼리 파라미터와 함께 이동
		window.location.href = '${cpath}/cfRecipe?recipe_idx=' + idx;
	}

	// 뒤로가기
	function goBack() {
		history.back();
	}

	// 타이머 열기
	function openTimer() {
		window.open('${cpath}/timer', 'timer', 'width=500,height=600,scrollbars=no,resizable=no');
	}

	// 즐겨찾기 (추후 구현)
	function addToFavorites() {
		alert('즐겨찾기 기능은 준비 중입니다.');
	}



</script>
</body>
</html>
