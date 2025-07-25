<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
    <c:set var="cpath" value="${pageContext.request.contextPath}" />
<div class="gnb">
            <div class="gnb-left">
                <a href="${cpath}/cfJoinform"><img src="${cpath}/upload/Vector.png" class="icon" /></a>
            </div>
           <div class="gnb-center">
                <a href="${cpath}" style="text-decoration-line: none;"><div class="logo">CookIN(G)Free</div></a>
            </div>
			<div class="gnb-right">
				<!-- 로그인 상태일 때만 보이는 '마이페이지' 버튼 -->
				<sec:authorize access="isAuthenticated()">
					<a href="${cpath}/cfMyPage"> <img
						src="${cpath}/upload/Vectorinfo.svg" class="icon" />
					</a>
				</sec:authorize>

				<!-- 비로그인 상태일 때만 보이는 '로그인' 버튼 -->
				<sec:authorize access="!isAuthenticated()">
					<a href="${cpath}/login"> <img
						src="${cpath}/upload/Vectorinfo.svg" class="icon" />
					</a>
				</sec:authorize>

				<!-- 로그인 여부와 상관없이 항상 보이는 버튼들 -->
				<a href="${cpath}/cfRecipeinsert"><img src="${cpath}/upload/Vectorfood.svg" class="icon" />
				</a> <a href="#"><img src="${cpath}/upload/Vectorsetting.svg" class="icon" /></a> 
			</div>
		</div>