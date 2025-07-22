<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

    <c:set var="cpath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="en">
 	<head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
        <link rel="stylesheet" type="text/css" href="/CookingFree/src/main/webapp/cfMain.css">
    </head>
    <style>
/* 기본 설정 */
* {
	box-sizing: border-box; /*패딩과 테두리까지 포함한 크기로 설정함*/
	margin: 0;
	padding: 0;
}

body {
	font-family: 'Inter', sans-serif;
}

.container {
	background: #fff;
	position: relative; /*화면이 유동적으로 반응할때*/
	overflow: hidden; /*화면 줄어들때 오버되는 컨텐츠 자르기*/
	max-width: 1200px; /* 전체 화면크기 제한*/
	margin: 0 auto; /*화면 수평정렬*/
	padding: 0 20px;
}

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

/* Hero Section */
.hero {
	height: 500px;
	background-size: cover;
	background-position: center;
	padding: 60px 60px;
	color: white;
	display: flex;
	flex-direction: column;
	/* 오른쪽 정렬 */
	align-items: flex-end;
	text-align: right;
	margin-top: 80px;
}
/*폰트설정*/
.hero h1 {
	font-size: 48px;
	margin-bottom: 10px;
}

.hero p {
	font-size: 24px;
}

/* Intro */
.intro {
	padding: 100px 80px;
}

.intro h2 {
	font-size: 32px;
	margin-bottom: 20px;
}

.desc p {
	font-size: 20px;
	line-height: 1.6;
}

/* 검색 버튼 */
.search {
	text-align: center;
	padding: 30px 0;
}

.search a {
	background: #ffffff;
	color: #000000;
	padding: 16px 32px;
	border-radius: 12px;
	text-decoration: none;
	display: inline-flex;
	align-items: center;
	gap: 10px;
}

.search img {
	width: 40px;
	transform: rotate(90deg);
}
/*마우스 올렸을 때 반응*/
.search a:hover {
	background-color: #000000;
	color: #ffffff;
}
/*이미지도 같이*/
.search a:hover img {
	filter: grayscale(100%) brightness(0) invert(1);
}
/* 섹션 타이틀 */
.section-title {
	font-size: 28px;
	font-weight: bold;
	padding: 20px 0;
}

/* 레시피 카드 */
.recipes {
	display: flex;
	flex-wrap: wrap;
	gap: 20px;
}

.card {
	flex: 1 1 calc(33.33% - 20px);
	background-size: cover;
	background-position: center;
	color: white;
	padding: 20px;
	min-height: 250px;
	display: flex;
	flex-direction: column;
	justify-content: flex-end;
	border-radius: 12px;
}

.card h3 {
	font-size: 20px;
	margin-bottom: 8px;
}

.card p {
	font-size: 14px;
	margin-bottom: 12px;
}

.card a {
	background: rgba(255, 255, 255, 0.8);
	color: #000;
	padding: 8px 16px;
	border-radius: 8px;
	text-decoration: none;
	font-size: 14px;
	align-self: flex-start;
}

/* 푸터 */
.footer {
	height: 300px;
	background: #9f9f9f;
	margin-top: 40px;
}

/* ✅ 반응형 미디어 쿼리 */
@media ( max-width : 1024px) {
	.card {
		flex: 1 1 calc(50% - 20px);
	}
	.hero h1 {
		font-size: 36px;
	}
}

@media ( max-width : 768px) {
	.hero {
		height: 400px; /* 모바일에서는 높이 줄임 */
	}
	.gnb {
		flex-direction: column;
		align-items: flex-start;
		gap: 10px;
	}
	.logo {
		font-size: 24px;
	}
	.hero h1 {
		font-size: 28px;
	}
	.hero p {
		font-size: 18px;
	}
	.recipes {
		flex-direction: column;
	}
	.card {
		flex: 1 1 100%;
	}
	.intro h2 {
		font-size: 24px;
	}
	.desc p {
		font-size: 16px;
	}
}
/*스크롤 top버튼입니다.*/
.top-button {
	position: fixed;
	bottom: 40px;
	right: 20px;
	padding: 10px 16px;
	background-color: #333;
	color: white;
	font-size: 14px;
	border: none;
	border-radius: 20px;
	cursor: pointer;
	display: none; /* 스크롤 전에는 숨김 */
	z-index: 1000;
	transition: opacity 0.3s ease;
}

.top-button:hover {
	background-color: #555;
}
</style>
<body>
	<div class="container">
        <div class="gnb">
            <div class="gnb-left">
                <a href="#"><img src="${cpath}/upload/Vector.png" class="icon" /></a>
            </div>
           <div class="gnb-center">
                <a href="${cpath}" style="text-decoration-line: none;"><div class="logo">CookIN(G)Free</div></a>
            </div>
            <div class="gnb-right">
                <a href="/login"><img src="${cpath}/upload/Vectorinfo.svg" class="icon" /></a>
                <a href="/MyPage"><img src="${cpath}/upload/Vectorfood.svg" class="icon" /></a>
                <a href="#"><img src="${cpath}/upload/Vectorsetting.svg" class="icon" /></a>
            </div>
        </div>

	    <div class="hero" style="background-image: url('${cpath}/upload/050d46bc-70b3-4458-a049-aa14fc90f696_일러스트23.jpg');">
	        <h1>야, 너도 <br /> 요리할 수 있어</h1>
	        <p>알러지는 내가 처리할게</p>
	    </div>

	    <div class="intro">
	        <h2>알러지 걱정 없이 간편하게!</h2>
	        <div class="desc">
	            <p>쿠킹 프리에서는</p>
	            <p>알러지의 위협으로부터</p>
	            <p>자유로운</p>
	            <p>식탁을 약속드립니다.</p>
	        </div>
	    </div>

	    <div class="search">
	        <a href="cfSearchRecipe">레시피 검색하기 <img src="${cpath}/upload/ic_baseline-keyboard-arrow-up.svg" /></a>
	    </div>

	    <div class="section-title">HOT 레시피</div>

	    <div class="recipes">
	        <div class="card" style="background-image: url('${cpath}/upload/불고기.jpg');">
	            <h3>돼지고기 불고기</h3>
	            <p>가성비 돼지고기 불고기</p>
	            <a href="#">레시피 확인하기</a>
	        </div>
	        <div class="card" style="background-image: url('${cpath}/upload/간계밥.jpg');">
	            <h3>간장계란 볶음밥</h3>
	            <p>간단하게 만드는 간계밥</p>
	            <a href="#">레시피 확인하기</a>
	        </div>
	        <div class="card" style="background-image: url('${cpath}/upload/참치마요유부초밥.jpg');">
	            <h3>참치 마요 유부초밥</h3>
	            <p>특별한 유부초밥</p>
	            <a href="#">레시피 확인하기</a>
	        </div>
	    </div>
		<button id="topBtn" class="top-button">TOP</button>
		<footer class="footer"></footer>
	</div>

<script>
  const topBtn = document.getElementById("topBtn");

  window.addEventListener("scroll", () => {
    if (window.scrollY > 200) {
      topBtn.style.display = "block";
    } else {
      topBtn.style.display = "none";
    }
  });

  topBtn.addEventListener("click", () => {
    window.scrollTo({
      top: 0,
      behavior: "smooth"
    });
  });
</script>

</body>
</html>