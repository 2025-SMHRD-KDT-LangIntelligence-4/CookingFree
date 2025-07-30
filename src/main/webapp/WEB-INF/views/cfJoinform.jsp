<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
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
						name="userPreferTaste" />
				</div>

				<div class="create-user">
					<label for="userCookingSkill">요리실력</label> <input type="text"
						id="userCookingSkill" class="userCookingSkill"
						name="userCookingSkill" />
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
			<div id="allergyCheckboxes" class="allergy-list-container"></div>
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
document.addEventListener('DOMContentLoaded', function() {
	   console.log("DOM content loaded."); // 1. DOMContentLoaded 이벤트 확인

	    // 모달 요소를 가져옵니다.
	    var modal = document.getElementById("allergyModal");
	    console.log("modal:", modal); // 2. modal 요소가 잘 찾아졌는지 확인

	    // 모달을 여는 버튼 요소를 가져옵니다.
	    var btn = document.getElementById("searchAllergyBtn");
	    console.log("searchAllergyBtn:", btn); // 3. 검색 버튼이 잘 찾아졌는지 확인

	    // 모달을 닫는 <span> (X 표시) 요소를 가져옵니다.
	    var closeButton = document.querySelector('#allergyModal .modal-content .close-button');
	    console.log("closeButton:", closeButton); // 4. 닫기 버튼이 잘 찾아졌는지 확인

	    var selectDoneBtn = document.getElementById("selectDoneBtn");
	    var cancelSelectionBtn = document.getElementById("cancelSelectionBtn");
	    var allergySearchInput = document.getElementById("allergySearchInput");
	    var allergyCheckboxesContainer = document.getElementById("allergyCheckboxes");
	    console.log("allergyCheckboxesContainer:", allergyCheckboxesContainer); // 5. 체크박스 컨테이너 확인

	    var allergyInput = document.getElementById("userAlgCode"); // 알러지 입력 필드
	    console.log("allergyInput:", allergyInput); // 6. 알러지 입력 필드 확인
    const alergy_rows = [
        {"alergy_idx":"101","alergy_name":"난류","alergy_info":"계란 및 달걀(흰자, 노른자) 알레르기, 오믈렛, 마요네즈 등 완제품 포함"},
        {"alergy_idx":"102","alergy_name":"우유","alergy_info":"우유 및 유제품 알레르기(치즈, 요구르트, 분유, 버터 등)"},
        {"alergy_idx":"103","alergy_name":"메밀","alergy_info":"메밀국수, 메밀묵, 동동주(메밀 포함) 알레르기"},
        {"alergy_idx":"104","alergy_name":"땅콩","alergy_info":"땅콩, 땅콩버터, 땅콩분말(과자, 초콜릿, 소스 포함) 알레르기"},
        {"alergy_idx":"105","alergy_name":"대두","alergy_info":"대두(콩)를 원료로 한 콩나물, 두부, 된장, 간장 등(완제품 포함) 알레르기"},
        {"alergy_idx":"106","alergy_name":"밀","alergy_info":"밀가루, 빵, 면류, 일부 과자, 맥주 등 밀 사용 제품 알레르기"},
        {"alergy_idx":"107","alergy_name":"고등어","alergy_info":"고등어 회·구이, 통조림, 가공식품, 소스(액젓 포함) 알레르기"},
        {"alergy_idx":"108","alergy_name":"게","alergy_info":"게(꽃게, 대게, 홍게 등 포함) 및 게 가공 식품 알레르기"},
        {"alergy_idx":"109","alergy_name":"새우","alergy_info":"새우 및 새우가공식품(튀김, 만두, 어묵, 젓갈, 액젓 등) 알레르기"},
        {"alergy_idx":"110","alergy_name":"돼지고기","alergy_info":"돼지고기 및 가공제품(햄, 소시지, 베이컨 등) 알레르기"},
        {"alergy_idx":"111","alergy_name":"복숭아","alergy_info":"복숭아 및 복숭아 잼, 통조림, 음료 등 포함 알레르기"},
        {"alergy_idx":"112","alergy_name":"토마토","alergy_info":"토마토, 케찹, 파스타 소스 등 토마토 함유제품 알레르기"},
        {"alergy_idx":"113","alergy_name":"호두","alergy_info":"호두, 호두분말, 호두빵 등의 알레르기"},
        {"alergy_idx":"114","alergy_name":"닭고기","alergy_info":"닭고기, 백숙, 치킨 등 가공제품 포함 알레르기"},
        {"alergy_idx":"115","alergy_name":"쇠고기","alergy_info":"소고기 및 소고기 가공제품 알레르기(육포, 햄버거 등)"},
        {"alergy_idx":"116","alergy_name":"오징어","alergy_info":"오징어회, 오징어젓, 오징어채 등 알레르기"},
        {"alergy_idx":"117","alergy_name":"조개류","alergy_info":"굴, 전복, 홍합 등 패류 전체 알레르기"},
        {"alergy_idx":"118","alergy_name":"아황산류","alergy_info":"아황산나트륨 및 각종 식품첨가물(보존제, 건조과일 등)"},
        {"alergy_idx":"119","alergy_name":"잣","alergy_info":"잣 및 잣 함유식품을 통한 알레르기"},
        {"alergy_idx":"120","alergy_name":"오이","alergy_info":"오이 및 오이 관련 알레르기(교차반응 가능)"},
        {"alergy_idx":"121","alergy_name":"키위","alergy_info":"키위 및 키위 가공제품 알레르기"},
        {"alergy_idx":"122","alergy_name":"건새우","alergy_info":"건조 새우 및 마른 새우 활용 제품에 대한 알레르기"},
        {"alergy_idx":"123","alergy_name":"조기","alergy_info":"조기 및 조기 가공제품 알레르기"},
        {"alergy_idx":"124","alergy_name":"게알","alergy_info":"게알 섭취 시 발생 알레르기(드묾)"},
        {"alergy_idx":"125","alergy_name":"홍합","alergy_info":"홍합 및 홍합가공식품 알레르기"},
        {"alergy_idx":"126","alergy_name":"어패류","alergy_info":"다양한 어류 및 패류에 대한 알레르기(광범위 반응)"},
    ];
    console.log("alergy_rows (데이터):", alergy_rows); // 7. 알러지 데이터가 잘 로드되었는지 확인
    console.log("alergy_rows.length:", alergy_rows.length); // 8. 데이터 개수 확인
    
    function generateAllergyCheckboxes(allergies) {
    	console.log("generateAllergyCheckboxes 함수 실행됨. 전달된 알러지 개수:", allergies.length); // 9. 함수 실행 확인 및 전달된 데이터 개수 확인
        allergyCheckboxesContainer.innerHTML = ''; // 기존 목록 초기화
        allergies.forEach((allergy,index) => { // 여기서 allergy 변수 사용
            const div = document.createElement('div');
            div.className = 'allergy-item'; // CSS 스타일 적용을 위한 클래스
            div.innerHTML = `
                <input type="checkbox" id="allergy_${allergy.alergy_idx}" name="allergy" value="${allergy.alergy_name}" data-allergy-idx="${allergy.alergy_idx}">
                <label for="allergy_${allergy.alergy_idx}">${allergy.alergy_name}</label>
                <span class="allergy-info">${allergy.alergy_info}</span>
            `;
            const htmlString = `
                <input type="checkbox" id="allergy_${allergy.alergy_idx}" name="allergy" value="${allergy.alergy_name}" data-allergy-idx="${allergy.alergy_idx}">
                <label for="allergy_${allergy.alergy_idx}">${allergy.alergy_name}</label>
                <span class="allergy-info">${allergy.alergy_info}</span>
            `;
            console.log(`[${index}] 생성될 HTML 스트링:`, htmlString); // <-- 이 부분을 추가
            div.innerHTML = htmlString;
            allergyCheckboxesContainer.appendChild(div);
        });

        // 사용자가 이미 선택한 알러지가 있다면 체크박스에 반영
        updateCheckboxesBasedOnInput();
        console.log("generateAllergyCheckboxes 실행 완료."); // 10. 함수 완료 확인
    }

    function updateCheckboxesBasedOnInput() {
        const currentAllergiesText = allergyInput.value; // 현재 입력 필드 값 (예: 난류, 우유)
        const currentAllergyNames = currentAllergiesText ? currentAllergiesText.split(', ').map(name => name.trim()) : [];

        const checkboxes = allergyCheckboxesContainer.querySelectorAll('input[type="checkbox"]');
        checkboxes.forEach(checkbox => {
            if (currentAllergyNames.includes(checkbox.value)) {
                checkbox.checked = true;
            } else {
                checkbox.checked = false;
            }
        });
    }

    allergySearchInput.addEventListener('keyup', function() {
        const searchTerm = this.value.toLowerCase();
        const filteredAllergies = alergy_rows.filter(allergy =>
            allergy.alergy_name.toLowerCase().includes(searchTerm) ||
            allergy.alergy_info.toLowerCase().includes(searchTerm)
        );
        generateAllergyCheckboxes(filteredAllergies); // 필터링된 목록으로 다시 생성
    });

    // "검색하기" 버튼을 클릭하면 모달을 엽니다.
    btn.onclick = function() {
        modal.style.display = "flex"; // 모달을 보이게 함 (CSS에서 flex를 사용한다면)
        generateAllergyCheckboxes(alergy_rows); // 모달 열릴 때 전체 목록 생성
        allergySearchInput.value = ''; // 검색 필드 초기화
    }

    // "X" 닫기 버튼 클릭 시 모달 닫기
    if (closeButton) { // closeButton이 존재하는지 확인
        closeButton.onclick = function() {
            modal.style.display = "none";
        }
    }


    // 모달 바깥 영역을 클릭하면 모달을 닫습니다.
    window.onclick = function(event) {
        if (event.target == modal) { // 클릭된 요소가 모달 배경 자체일 경우
            modal.style.display = "none"; // 모달을 숨김
        }
    }

    // '선택 완료' 버튼 클릭 시
    selectDoneBtn.onclick = function() {
        const selectedAllergies = [];
        const checkedCheckboxes = allergyCheckboxesContainer.querySelectorAll('input[type="checkbox"]:checked');
        checkedCheckboxes.forEach(checkbox => {
            selectedAllergies.push(checkbox.value); // 알러지 이름 추가
        });
        allergyInput.value = selectedAllergies.join(', '); // 입력 필드에 콤마로 구분하여 표시
        modal.style.display = "none"; // 모달 닫기
    };

    // '취소' 버튼 클릭 시
    cancelSelectionBtn.onclick = function() {
        modal.style.display = "none"; // 모달 닫기
    };
});
</script>
</html>