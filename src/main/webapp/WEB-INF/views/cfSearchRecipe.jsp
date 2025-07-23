<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
   <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
       <c:set var="cpath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Document</title>
<style type="text/css">
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
/* ----------------------------------------------------------------모바일 대응--------------------------------------------------------------- */
@media ( max-width : 768px) {
	.gnb {
		padding: 12px;
		gap: 8px;
	}
	.gnb-right a {
		margin-left: 6px;
	}
}
/* -------------------------------------------------------------전체 검색 영역을 중앙 정렬 ----------------------------------------------------------*/
.search-Form {
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 1.5rem;
	margin-top: 50px;
	width: 100%;
	padding: 0 16px;
	box-sizing: border-box;
}

/*--------------------------------------------------------------- 로고 이미지 정렬--------------------------------------------------------------- */
.logo-img-wrapper {
	display: flex;
	justify-content: center;
	width: 100%;
}

.logo-img {
	width: clamp(200px, 60%, 400px);
	height: auto;
}

/*----------------------------------------------------------------- 검색창 영역------------------------------------------------------------------ */
.searchBar {
	display: flex;
	gap: 0.5rem;
	width: 100%;
	max-width: 600px;
	flex-wrap: wrap; /* 모바일에서 줄바꿈 허용 */
	justify-content: center;
}

.searchBar input {
	flex: 1 1 60%;
	min-width: 200px;
	padding: 1rem;
	font-size: 1rem;
	border: 3px solid #bababa;
	border-radius: 8px;
	box-sizing: border-box;
}

/* --------------------------------------------------------📱 모바일 대응 -----------------------------------------------------------------------*/
@media ( max-width : 600px) {
	.searchBar {
		flex-direction: column;
		align-items: stretch;
	}
	.searchBar input, .search-button {
		width: 100%;
	}
	.search-button {
		height: 50px;
	}
	.tart-gpt {
		height: 50px;
	}
}
/*-----------------------------------------------------버튼모음입니다.----------------------------------------------------------------------*/
.search-button {
	flex: 0 0 auto;
	width: 80px;
	height: 60px;
	font-size: 1rem;
	border: 3px solid #bababa;
	border-radius: 8px;
	background-color: #ffffff;
	cursor: pointer;
	transition: all 0.2s ease;
}

.start-gpt-container {
	display: flex;
	align-items: center;
	margin-top: 1rem;
	width: 100%;
	box-sizing: border-box;
	justify-content: center;
}

.start-gpt {
	flex: 0 0 auto;
	width: 200px;
	height: 60px;
	font-size: 1rem;
	border: 3px solid #bababa;
	border-radius: 8px;
	background-color: #ffffff;
	cursor: pointer;
	transition: all 0.2s ease;
}
/*-----------------------------------------------------------모달창 디자인입니다.----------------------------------------------------------*/
.gpt-modal-overlay {
	display: none; /* 기본은 숨김 */
	position: fixed;
	z-index: 999;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background-color: rgba(0, 0, 0, 0.5);
	justify-content: center;
	align-items: center;
}

.gpt-modal-content {
	background: white;
	padding: 2rem;
	border-radius: 12px;
	max-width: 600px;
	width: 80%;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
	text-align: center;
}

.gpt-container {
	display: flex;
	align-items: center;
	gap: 8px;
	margin-top: 1rem;
	max-width: 600px;
}

.gpt-close-btn {
	position: absolute;
	top: 1rem;
	right: 1rem;
	background: none;
	border: none;
	font-size: 1.2rem;
	cursor: pointer;
}

.gpt-send-btn {
	background: #fff;
	border: 3px solid #bababa;
	border-radius: 8px;
	padding: 0.3rem;
	cursor: pointer;
}

.gpt-input {
	flex: 1;
	padding: 1rem;
	font-size: 1rem;
	border: 3px solid #bababa;
	border-radius: 8px;
	box-sizing: border-box;
}
/*---------------------------------------------------------------호버기능입니다.--------------------------------------------------------------*/
.gpt-send-btn:hover {
	background-color: #000000;
	color: #ffffff;
}

.start-gpt:hover {
	background-color: #000000;
	color: #ffffff;
}

.search-button:hover {
	background-color: #000000;
	color: #ffffff;
}

.gpt-send-btn:hover img {
	filter: grayscale(100%) brightness(0) invert(1);
}
</style>
</head>
<body>
<!---------------------------------------------------gnb배너입니다.------------------------------------------------------------------------------------------>
	<div class="gnb">
		<div class="gnb-left">
			<a href="#"><img src="${cpath}/upload/Vector.png" class="icon" /></a>
		</div>
		<div class="gnb-center">
			<a href="${cpath}" style="text-decoration-line: none;">
			<div class="logo">CookIN(G)Free</div></a>
		</div>
		<div class="gnb-right">
			<a href="cfLogin"><img src="${cpath}/upload/Vectorinfo.svg"
				class="icon" /></a> <a href="#"><img
				src="${cpath}/upload/Vectorfood.svg" class="icon" /></a> <a href="#"><img
				src="${cpath}/upload/Vectorsetting.svg" class="icon" /></a>
		</div>
	</div>
<!---------------------------------------------------직접입력 검색창입니다.------------------------------------------------------------------------------->
	<form action="searchRecipe" method="post" class="search-Form">
        <div class="logo-img-wrapper">
        	<img class="logo-img" src="${cpath}/upload/cookingfree로고.jpg">
        </div>
        <div class="searchBar">
          <input id="searchtext" type="text" placeholder="검색어를 입력해주세요">
          <button class="search-button" type="submit">검색</button>
        </div>
    </form>
    <div class="start-gpt-container">
		<button class="start-gpt">프리G에게 물어보기</button>
    </div>
<!---------------------------------------------------GPT검색창 입니다.-------------------------------------------------------------------------------->
	<!-- GPT 검색화면이 전체화면 아래쪽에 있다고 가정 -->
	<div class="gpt-modal-overlay" id="gptModal">
		<div class="gpt-modal-content">
			<h2>프리G 검색</h2>
			<div class="gpt-container">
				<input class="gpt-input" type="text" placeholder="궁금한 내용을 입력하세요..."
					style="width:70%; font-size: 1rem;" />
				<button class="gpt-send-btn">
					<img src="${cpath}/upload/ic_baseline-keyboard-arrow-up.svg" style="width:40px; transform: rotate(90deg);"/>
				</button>
			</div>
		</div>
	</div>
</body>
<script>
  const startBtn = document.querySelector('.start-gpt');
  const modal = document.getElementById('gptModal');
  const closeBtn = modal.querySelector('.gpt-close-btn');

  // 1. 모달 열기
  startBtn.addEventListener('click', () => {
    modal.style.display = 'flex';
  });
  // 3. 모달 바깥 영역 클릭 시 닫기
  modal.addEventListener('click', (e) => {
    if (e.target === modal) {
      modal.style.display = 'none';
    }
  });

  // 4. ESC 키 누르면 닫기
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
      modal.style.display = 'none';
    }
  });
</script>

</html>