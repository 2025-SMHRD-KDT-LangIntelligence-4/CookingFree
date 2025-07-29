<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="cpath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>쿠킹프리 - 알레르기에서 자유로운 레시피</title>
    <link rel="stylesheet" href="${cpath}/css/cfMain.css">
</head>
    
<body>
<div class="container">
    <jsp:include page="inc/header.jsp" />
    <div class="hero">
    	<img src="${cpath}/upload/050d46bc-70b3-4458-a049-aa14fc90f696_일러스트23.jpg">
    	<div class="text-container">
	        <h1>야, 너도 <br /> 요리할 수 있어</h1>
	        <p>알러지는 내가 처리할게</p>
    	</div>
    </div>

    <div class="intro">
        <div class="intro-title">
            <h2>알러지 걱정 없이 간편하게!</h2>
            <div class="desc">
                <p>쿠킹 프리에서는</p>
                <p>알러지의 위협으로부터</p>
                <p>자유로운</p>
                <p>식탁을 약속드립니다.</p>
            </div>
        </div>
        <div class="logo-img-container">
            <img class="logo-img" src="${cpath}/upload/cookingfree로고.jpg">
        </div>
    </div>

    <div class="search">
        <a href="cfSearchRecipe">레시피 검색하기 <img src="${cpath}/upload/ic_baseline-keyboard-arrow-up.svg" /></a>
    </div>

    <div class="section-title">HOT 레시피 🔥</div>

    <div class="recipes">
        <c:choose>
            <c:when test="${not empty hotRecipes}">
                <c:forEach var="recipe" items="${hotRecipes}" varStatus="status">
                    <div class="card" 
                         style="background-image: linear-gradient(rgba(0,0,0,0.3), rgba(0,0,0,0.5)), url('${not empty recipe.recipe_img ? recipe.recipe_img : cpath.concat('/upload/default-recipe.jpg')}');" 
                         onclick="location.href='${cpath}/recipe/detail/${recipe.recipe_idx}'">
                        
                        <div class="view-count-badge">
                            👁️ <fmt:formatNumber value="${recipe.view_count}" pattern="#,###" />
                        </div>
                        
                        <div class="card-content">
                            <h3>${recipe.recipe_name}</h3>
                            <p>${recipe.recipe_desc != null && recipe.recipe_desc.length() > 50 ? 
                                recipe.recipe_desc.substring(0, 50).concat('...') : recipe.recipe_desc}</p>
                            
                            <div class="recipe-meta">
                                <c:if test="${recipe.cook_type != null}">
                                    <span class="meta-tag">${recipe.cook_type}</span>
                                </c:if>
                                <c:if test="${recipe.recipe_difficulty != null}">
                                    <span class="meta-tag">${recipe.recipe_difficulty}</span>
                                </c:if>
                                <c:if test="${recipe.cooking_time != null}">
                                    <span class="meta-tag">⏱️ ${recipe.cooking_time}분</span>
                                </c:if>
                            </div>
                            
                            <a href="${cpath}/recipe/detail/${recipe.recipe_idx}" class="recipe-link" onclick="event.stopPropagation();">
                                레시피 확인하기
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <!-- 기본 레시피 카드들 (데이터가 없을 때) -->
                <div class="card" style="background-image: linear-gradient(rgba(0,0,0,0.3), rgba(0,0,0,0.5)), url('${cpath}/upload/불고기.jpg');">
                    <div class="view-count-badge">👁️ 1,234</div>
                    <div class="card-content">
                        <h3>돼지고기 불고기</h3>
                        <p>가성비 돼지고기 불고기</p>
                        <a href="#" class="recipe-link">레시피 확인하기</a>
                    </div>
                </div>
                <div class="card" style="background-image: linear-gradient(rgba(0,0,0,0.3), rgba(0,0,0,0.5)), url('${cpath}/upload/간계밥.jpg');">
                    <div class="view-count-badge">👁️ 987</div>
                    <div class="card-content">
                        <h3>간장계란 볶음밥</h3>
                        <p>간단하게 만드는 간계밥</p>
                        <a href="#" class="recipe-link">레시피 확인하기</a>
                    </div>
                </div>
                <div class="card" style="background-image: linear-gradient(rgba(0,0,0,0.3), rgba(0,0,0,0.5)), url('${cpath}/upload/참치마요유부초밥.jpg');">
                    <div class="view-count-badge">👁️ 756</div>
                    <div class="card-content">
                        <h3>참치 마요 유부초밥</h3>
                        <p>특별한 유부초밥</p>
                        <a href="#" class="recipe-link">레시피 확인하기</a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
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
