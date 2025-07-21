<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
    <c:set var="cpath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Document</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">

<!-- jQuery library -->
<script
   src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js">
</script>

<!-- Latest compiled JavaScript -->
<script
   src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js">
</script>

</head>
<body>
   <div class="jumbotron text-center">
      <h1>빅데이터 분석서비스 개발자 과정</h1>
      <p>스프링 부트를 활용하여 게시판을 만들어보자</p>
   </div>

	<div class="container panel panel-default">
		<div class="panel-heading">게시글</div>
		<div class="panel-body">
			<form action="${cpath}/gofile" enctype="multipart/form-data" method="post">
				<table class="table table-bordered table-hover">
					<tr>
						<th>제목</th>
						<td>
						   <input type="file"  name="file">
						</td>
					</tr>
				</table>
				<button onclick="location.href='/web/'">목록으로</button>
				<button onclick="submit">등록하기</button>
			</form>
		</div>
		<div class="panel-footer">panel footer</div>

	</div>

</body>
</html>