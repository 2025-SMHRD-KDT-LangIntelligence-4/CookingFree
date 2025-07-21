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
	            <form action="${cpath}/update/${idx}" method = "post">
	            <table class="table" items="${board}" var="board">
                	<tr>
                    	<td>제목</td><td><input type="text" class="form-control" name="title" value="${board.title}"/></td>
                	</tr>
	            	<tr>
                    	<td>글내용</td><td><textarea colspan="5" class="form-control" name="content" >"${board.content}"</textarea></td>
                	</tr>
                	<tr>
                    	<td>작성자</td><td><input type="text" class="form-control" name="writer" value="${board.writer}"/></td>
                	</tr>
                	<tr>
                    	<td>작성일</td><td><fmt:formatDate value="${board.indate}" pattern="yyyy-MM-dd hh:mm"/></td>
                	</tr>
	            </table>
	            	
	            	<div>
		            	<button onclick="submit">글수정</button>
	            	</div>
	            </form>
     		</div>
        <div class="panel-footer"></div>
    	</div>
    </div>
</body>
</html>