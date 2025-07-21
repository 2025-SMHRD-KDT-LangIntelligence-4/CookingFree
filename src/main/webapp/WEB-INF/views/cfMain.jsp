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
        <link rel="stylesheet" href="/CookingFree/src/main/webapp/WEB-INF/views/cfMain.css">
    </head>
<body>
	<div class="container">
        <div class="gnb">
            <div class="gnb-left">
                <a href="#"><img src="/CookingFree/src/main/webapp/upload/Vector.svg" class="icon" /></a>
            </div>
           <div class="gnb-center">
                <div class="logo">CookIN(G)Free</div>
            </div>
            <div class="gnb-right">
                <a href="#"><img src="/CookingFree/src/main/webapp/upload/Vectorinfo.svg" class="icon" /></a>
                <a href="#"><img src="/CookingFree/src/main/webapp/upload/Vectorfood.svg" class="icon" /></a>
                <a href="#"><img src="/CookingFree/src/main/webapp/upload/Vectorsetting.svg" class="icon" /></a>
            </div>
        </div>

	    <div class="hero" style="background-image: url('/CookingFree/src/main/webapp/upload/050d46bc-70b3-4458-a049-aa14fc90f696_일러스트23.jpg');">
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
	        <a href="cfSearchRecipe">레시피 검색하기 <img src="/CookingFree/src/main/webapp/upload/ic_baseline-keyboard-arrow-up.svg" /></a>
	    </div>

	    <div class="section-title">HOT 레시피</div>

	    <div class="recipes">
	        <div class="card" style="background-image: url('/Cookin(G)Free/이미지파일/불고기.jpg');">
	            <h3>돼지고기 불고기</h3>
	            <p>가성비 돼지고기 불고기</p>
	            <a href="#">레시피 확인하기</a>
	        </div>
	        <div class="card" style="background-image: url('/Cookin(G)Free/이미지파일/간계밥.jpg');">
	            <h3>간장계란 볶음밥</h3>
	            <p>간단하게 만드는 간계밥</p>
	            <a href="#">레시피 확인하기</a>
	        </div>
	        <div class="card" style="background-image: url('/Cookin(G)Free/이미지파일/참치마요유부초밥.jpg');">
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