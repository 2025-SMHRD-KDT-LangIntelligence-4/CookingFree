<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<c:set var="cpath" value="${pageContext.request.contextPath}" />
<c:set var="_csrf" value="${_csrf}" />
<!DOCTYPE html>
<html>
<head>
<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />
<title>회원정보 수정</title>
<link rel="stylesheet" href="${cpath}/css/cfMyPageUpdate.css" />
</head>
<body>
	<jsp:include page="inc/header.jsp" />
	<div class="body">
		<div class="all-container">
			<!-- 1) 회원정보 수정 폼을 감싸는 래퍼 -->
			<div class="form-wrapper">
				<form action="${cpath}/mypageUpdate" method="post"
					enctype="multipart/form-data" class="joinform">
					<!-- CSRF 토큰 -->
					<input type="hidden" name="${_csrf.parameterName}"
						value="${_csrf.token}" />

					<!-- 프로필 이미지 업로드 영역 -->
					<div class="pr-img-container">
						<div class="pr-img">
							<img
								src="${not empty user.profile_img ? user.profile_img : cpath}/upload/profileDefault.jpg"
								id="previewImg"
								onclick="document.getElementById('profileImgFile').click();" />
							<input type="file" name="profileImgFile" id="profileImgFile"
								accept="image/*"
								onchange="document.getElementById('previewImg').src = window.URL.createObjectURL(this.files[0])" />
						</div>
						<div class="name-container">
							<div class="usernick">
								${user.nick}
								<div>등급</div>
							</div>
							<!-- 로그아웃 버튼만 포지션 외부로 분리 -->
							<button type="button" class="logout-button" id="logoutBtn"
								style="margin-right: 10px;">로그아웃</button>
						</div>
					</div>

					<!-- 회원정보 수정 폼 링크 -->
					<div class="info-container">
						<div>회원정보</div>
					</div>

					<!-- 회원정보 입력 필드들 -->
					<div class="myPage-container">
						<div class="div1">이메일</div>
						<div class="userInfo">${user.email}</div>
					</div>
					<div class="myPage-container">
						<div class="div1">닉네임</div>
						<input class="userInfo" type="text" name="nick"
							value="${user.nick}" />
					</div>
					<div class="myPage-container">
						<div class="div1">가입일자</div>
						<div class="userInfo">${user.joined_at}</div>
					</div>
					<div class="myPage-container">
						<div class="div1">선호하는 요리</div>
						<input class="userInfo" type="text" name="prefer_taste"
							value="${user.prefer_taste}" />
					</div>
						<div class="myPage-container">
						  	<label style="padding-right: 10%;">요리실력</label>
							<input type="radio" id="skill_beginner" name="userCookingSkill" value="초급" checked />
							<label for="skill_beginner">초급</label>

							<input type="radio" id="skill_intermediate" name="userCookingSkill" value="중급" />
							<label for="skill_intermediate">중급</label>

							<input type="radio" id="skill_advanced" name="userCookingSkill" value="고급" />
							<label for="skill_advanced">고급</label>
						</div>
					<div class="myPage-container">
						<label for="userAlgCode">보유 알러지</label> <!-- 화면 표시용 (readonly) -->
						<input type="text"
							   id="userAlgCode"
							   value="${user.alg_code}"
							   readonly />

						<!-- 전송용 hidden -->
						<input type="hidden"
							   id="userAlgCodehidden"
							   name="alg_code"
							   value="${user.alg_code}" />


						<button type="button" id="searchAllergyBtn">검색하기</button>
					</div>

					<!-- 저장 버튼 -->
					<button type="submit" class="save-button">저장</button>
				</form>
				<!-- 2) 로그아웃 전용 폼은 별도 배치 (플렉스 흐름에 간섭 없음) -->
				<form id="logoutForm" action="${cpath}/logout" method="post"
					style="display: none;">
					<input type="hidden" name="${_csrf.parameterName}"
						value="${_csrf.token}" />
				</form>

			</div>
		</div>
	</div>
	 <div id="allergyModal" class="modal">
    <div class="modal-content">
      <h2>알러지 검색</h2>
      <div class="allergy-search-box">
        <input type="text" id="allergySearchInput" placeholder="알러지 검색...">
      </div>
      <div id="allergyCheckboxes" class="allergy-list-container">
        <c:forEach var="alg" items="${allergies}">
          <div class="allergy-item">
            <input
              type="checkbox"
              id="allergy_${alg.alergy_idx}"
              name="allergy"
              value="${alg.alergy_name}"
              data-allergy-idx="${alg.alergy_idx}"
              <c:if test="${fn:contains(user.alg_code, alg.alergy_name)}">checked</c:if> />
            <label for="allergy_${alg.alergy_idx}">${alg.alergy_name}</label>
            <span class="allergy-info">${alg.alergy_info}</span>
          </div>
        </c:forEach>
      </div>
      <div class="modal-buttons">
        <button type="button" id="selectDoneBtn">선택 완료</button>
        <button type="button" id="cancelSelectionBtn" class="secondary-button">취소</button>
      </div>
    </div>
  </div>
	<footer class="footer"></footer>
</body>
<script>
	// 동적 로그아웃 처리
	document.getElementById('logoutBtn').addEventListener('click', function() {
		document.getElementById('logoutForm').submit();
	});

	(function() {
		// 1) 요소 참조
		var modal          = document.getElementById('allergyModal');
		var openBtn        = document.getElementById('searchAllergyBtn');
		var cancelBtn      = document.getElementById('cancelSelectionBtn');
		var doneBtn        = document.getElementById('selectDoneBtn');
		var displayField   = document.getElementById('userAlgCode'); // 화면 표시용
		var hiddenField    = document.getElementById('userAlgCodehidden');        // 전송용 hidden
		var checkContainer = document.getElementById('allergyCheckboxes');
		var searchInput    = document.getElementById('allergySearchInput');

		// 2) 모달 열고 닫기 핸들러 등록
		openBtn.addEventListener('click', function() {
			modal.style.display = 'flex';
			searchInput.value = '';
			filterList('');
		});

		cancelBtn.addEventListener('click', function() {
			modal.style.display = 'none';
		});

		window.addEventListener('click', function(e) {
			if (e.target === modal) {
				modal.style.display = 'none';
			}
		});

		// 3) 선택 완료
		doneBtn.addEventListener('click', function() {
			var checked = checkContainer.querySelectorAll('input[type="checkbox"]:checked');
			var names   = Array.from(checked).map(function(cb) { return cb.value; }).join(', ');
			// 화면 표시용에 동기화
			displayField.value = names;
			// 폼 전송용 hidden에 설정
			hiddenField.value = names;
			modal.style.display = 'none';
		});

		// 4) 검색 필터
		searchInput.addEventListener('input', function() {
			filterList(this.value.trim().toLowerCase());
		});

		function filterList(term) {
			var items = checkContainer.querySelectorAll('.allergy-item');
			items.forEach(function(item) {
				var text = item.querySelector('label').textContent.toLowerCase();
				item.style.display = text.includes(term) ? '' : 'none';
			});
		}
	})();
</script>
</html>
