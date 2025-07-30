<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="cpath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<title>Document</title>
<link rel="stylesheet" href="${cpath}/css/cfJoinform.css">
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
	<jsp:include page="inc/header.jsp" />
	<div class="joinform-title">
		<div class="title-name">
			<div>회원가입</div>
			<!-- s -->
		</div>
	</div>
	<div class="full-container">
		<div class="join-container">

			<form action="cfjoinId" method="post" class="joinform">
				<input type="hidden" name="${_csrf.parameterName}"
					value="${_csrf.token}" />

				<c:set var="realAuthType"
					value="${authType != null ? authType : 'L'}" />
				<c:set var="realEmail" value="${email != null ? email : ''}" />
				<c:set var="realNickname"
					value="${nickname != null ? nickname : ''}" />
				<c:set var="realSocialId"
					value="${socialId != null ? socialId : ''}" />

				<div class="create-user">
					<label for="nickname">닉네임 입력</label> <input type="text"
						id="nickname" name="nickname" value="${realNickname}" required />
				</div>

				<div class="create-user">
					<label for="userId">사용할 ID / 이메일 입력</label> <input type="text"
						id="userId" name="userId" value="${realEmail}" required
						<c:if test="${realAuthType != 'L'}">readonly</c:if> />
				</div>

				<c:if test="${realAuthType == 'L'}">
					<div class="create-user">
						<label for="userPW">사용할 PW 입력</label> <input type="password"
							id="userPW" name="userPW" required />
					</div>
					<div class="create-user">
						<label for="checkPW">사용할 PW 재입력</label> <input type="password"
							id="checkPW" name="checkPW" required />
					</div>
				</c:if>

				<input type="hidden" name="authType" value="${realAuthType}" /> <input
					type="hidden" name="socialId" value="${realSocialId}" />

				<div class="create-user">
					<label for="userAlgCode">보유 알러지</label> <input type="text"
						id="userAlgCode" class="userAlgCode" name="userAlgCode" readonly />
					<button type="button" id="searchAllergyBtn">검색하기</button>
				</div>

				<div class="create-user">
					<label for="userPreferTaste">선호하는 맛</label> <input type="text"
						id="userPreferTaste" class="userPreferTaste"
						name="userPreferTaste" placeholder="예: 매운맛, 한식, 치킨" />
				</div>

				<div class="create-user">
				  <label>요리실력</label> 
				  <input type="radio" id="skill_beginner" name="userCookingSkill" value="초급" checked />
				  <label for="skill_beginner">초급</label>
				
				  <input type="radio" id="skill_intermediate" name="userCookingSkill" value="중급" />
				  <label for="skill_intermediate">중급</label>
				
				  <input type="radio" id="skill_advanced" name="userCookingSkill" value="고급" />
				  <label for="skill_advanced">고급</label>
				</div>

				<button type="submit" class="joinbutton">생성하기</button>

				<!-- 에러 메시지 출력 -->
				<c:if test="${not empty msg}">
					<div style="color: red; margin-top: 10px;">${msg}</div>
				</c:if>
			</form>



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
              <c:if test="${fn:contains(userAlgCode, alg.alergy_name)}">checked</c:if> />
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
	<!---------------------------------------------------페이지 양식입니다.------------------------------------------------------------- -->
</body>
 <script>
(function() {
  // 1) 요소 참조
  var modal          = document.getElementById('allergyModal');
  var openBtn        = document.getElementById('searchAllergyBtn');
  var cancelBtn      = document.getElementById('cancelSelectionBtn');
  var doneBtn        = document.getElementById('selectDoneBtn');
  var inputField     = document.getElementById('userAlgCode');
  var checkContainer = document.getElementById('allergyCheckboxes');
  var searchInput    = document.getElementById('allergySearchInput');

  // 2) 모달 열고 닫기 핸들러 등록
  openBtn.addEventListener('click', function() {
    modal.style.display = 'flex';  // CSS에 flex 레이아웃 설정 시
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
    var names = Array.from(checked).map(function(cb) { return cb.value; });
    inputField.value = names.join(', ');
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