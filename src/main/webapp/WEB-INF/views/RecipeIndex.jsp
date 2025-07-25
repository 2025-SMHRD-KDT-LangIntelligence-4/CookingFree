<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
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
/*--------------------------------------------------------------------gnb배너입니다--------------------------------------------------------*/
.recipe-index-container{
    display: flex;
    justify-content: center;
    flex-wrap: wrap;
    margin-top: 50px;
}
.recipe-index{
    max-width: 90%;
    border: 3px solid rgb(161, 161, 161);
    max-width: 200px;
    min-height: 300px; 
    flex-shrink: 0;
    flex-grow: 0;
    margin: 10px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    text-align: center;
}
.recipe-image{
    width:200px;
    height:200px;
    background-color: aqua;
}
.title-container{
    display: flex;
    justify-content: left;
    margin-top: 100px;
    margin-left: 100px;
}
.title{
    font-size: 50px;
}
/*------------------------------------------------------모달창 디자인입니다.,-------------------------------------------------------*/
.recipe-info-modal {
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

.recipe-info-modal-content {
	background: white;
	padding: 2rem;
	border-radius: 12px;
	max-width: 600px;
	width: 80%;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
	text-align: center;
}

.recipe-info-container {
	display: flex;
	gap: 8px;
	margin-top: 1rem;
	max-width: 600px;
	flex-wrap: wrap;
	justify-content: center;
}

</style>
</head>
<body>
<!--------------------------------------------------------gnb 배너입니다.---------------------------------------------------------- -->
<div class="gnb">
	<div class="gnb-left">
		<a href="#"><img src="${cpath}/upload/Vector.png" class="icon" /></a>
	</div>
	<div class="gnb-center">
		<a href="${cpath}" style="text-decoration-line: none;"><div class="logo">CookIN(G)Free</div></a>
	</div>
	<div class="gnb-right">
		<a href="cfLogin"><img src="${cpath}/upload/Vectorinfo.svg"
			class="icon" /></a> <a href="#"><img
			src="${cpath}/upload/Vectorfood.svg" class="icon" /></a> <a href="#"><img
			src="${cpath}/upload/Vectorsetting.svg" class="icon" /></a>
	</div>
</div>
<!--------------------------------------------------------gnb배너입니다.---------------------------------------------------------- -->
<!---------------------------------------------------페이지 양식입니다.------------------------------------------------------------- -->
<div class="title-container">
    <div class="title">Free(G)recipe</div>
</div>
<div class="recipe-index-container">
    <div class="recipe-index">
        <div class="recipe-image">레시피 이미지공간입니다.</div>
        <div class="recipe-name">레시피 이름공간입니다.</div>
        <div class="recipe-date">레시피 등록일 공간입니다.</div>
        <button class="recipeInfo">레시피확인하기</button>
    </div>
    <div class="recipe-index">
        <div class="recipe-image">레시피 이미지공간입니다.</div>
        <div class="recipe-name">레시피 이름공간입니다.이버튼을 누르면 레시피정보로 이동합니다.</div>
        <div class="recipe-date">레시피 등록일 공간입니다.</div>
    </div>
    <div class="recipe-index">
        <div class="recipe-image">레시피 이미지공간입니다.</div>
        <div class="recipe-name">레시피 이름공간입니다.이버튼을 누르면 레시피정보로 이동합니다.</div>
        <div class="recipe-date">레시피 등록일 공간입니다.</div>
    </div>
    <div class="recipe-index">
        <div class="recipe-image">레시피 이미지공간입니다.</div>
        <div class="recipe-name">레시피 이름공간입니다.이버튼을 누르면 레시피정보로 이동합니다.</div>
        <div class="recipe-date">레시피 등록일 공간입니다.</div>
    </div>
    <div class="recipe-index">
        <div class="recipe-image">레시피 이미지공간입니다.</div>
        <div class="recipe-name">레시피 이름공간입니다.이버튼을 누르면 레시피정보로 이동합니다.</div>
        <div class="recipe-date">레시피 등록일 공간입니다.</div>
    </div>
    <div class="recipe-index">
        <div class="recipe-image">레시피 이미지공간입니다.</div>
        <div class="recipe-name">레시피 이름공간입니다.이버튼을 누르면 레시피정보로 이동합니다.</div>
        <div class="recipe-date">레시피 등록일 공간입니다.</div>
    </div>
    <div class="recipe-index">
        <div class="recipe-image">레시피 이미지공간입니다.</div>
        <div class="recipe-name">레시피 이름공간입니다.이버튼을 누르면 레시피정보로 이동합니다.</div>
        <div class="recipe-date">레시피 등록일 공간입니다.</div>
    </div>
</div>
<!---------------------------------------------------레시피정보출력창입니다------------------------------------------------------------>
<div class="recipe-info-modal" id="recipeModal">
		<div class="recipe-info-modal-content">
			<h2>레시피 이름입니다.</h2>
			<div class="recipe-info-container">
				<div class="recipe-image">레시피이미지입니다.</div>
				<div class="short-info">레시피간단 정보입니다.</div>
	            <button class="move-recipe">요리하러가기</button>   
			</div>
		</div>
	</div>
<footer class="footer"></footer>
<!---------------------------------------------------페이지 양식입니다.------------------------------------------------------------- -->
</body>
<script>
  const startBtn = document.querySelector('.recipeInfo');
  const modal = document.getElementById('recipeModal');
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