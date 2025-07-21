<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
    <c:set var="cpath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
 	<title>Document</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">

    <!-- jQuery library -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

    <!-- Latest compiled JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
</head>
<body>
	 <div class="jumbotron text-center">
        <h1>위대한 사람들의 모임</h1>
        <p>영웅호걸들의 게시판이다!!</p>
    </div>
    <div class="container panel panel-default">
        <div class="panel-heading">영웅호걸의 장</div>
        <div class="panel-body">
            <div class="table-responsive-sm">
            <table class="table" items="${board}" var="board">
            	<tr>
            		<th>번호</th>
            		<td>${board.idx}</td>
            		
            		<th>작성자</th>
            		<td>${board.writer}</td>
            	</tr>
            	<tr>
            		<th>작성일</th>
            		<td><fmt:formatDate value="${board.indate}" pattern="yyyy-MM-dd hh:mm"/></td>
            		
            		<th>조회수</th>
            		<td>${board.count+1}</td>
            	</tr>    
            	<tr>
            		<th>제목</th>
            		<td colspan="3">${board.title}</td>
            	</tr>
            	<tr>
					<td colspan="4">
					  <c:if test="${not empty board.img_url}">
					    	<img src="${cpath}/upload/${board.img_url}" style="max-width: 300px;">
					  </c:if>
					</td>  
            	</tr>
            	<tr>
            		<th>내용</th>
            		<td colspan="3">${board.content}</td>
            	</tr>
            	<tr>
            		<td colspan="4">
            			<button onclick="location.href='${cpath}/update/${board.idx}'">글수정</button>
            			<button onclick="location.href='${cpath}/delete/${board.idx}'">글삭제</button>
            			<button onclick="location.href='/web/'">글목록</button>
            		</td>
            	</tr>    
            </table>
     		</div>
        <div class="panel-footer"></div>
        
    	</div>
    </div>
    <script>
        // 비동기 통신으로 요청 보내기
        //게시글 내용을 보는 페이지로 들어왔을 때
       	//boardCount라는 요청
        // => 현재 게시글의 조회수를 1증가
	    $(function(){
		    $.ajax({
		       url : "${cpath}/boardCount",
		       data : {
		           idx : ${board.idx}
		       },
		       success : (res)=>{
		           console.log("조회수 증가 성공",res)
		       },
		       error : ()=>{
			       console.log("조회수증가 실패")
		       } 
		   })
	    })
   </script>
</body>
</html>