<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

 <form action="register2" method="post">
					<div class="form-group">
						<label>레시피명:</label> <input name="title" type="text" class="form-control">
					</div>
					<div class="form-group">
						<label>요리분류:</label> <input name="writer" type="text" class="form-control">
					</div>
                     <div class="form-group">
						<label>난이도:</label> 
                         상 <input type="radio"  name="Difficulty level" value="award" >
                        중 <input type="radio"  name="Difficulty level" value="middle">
                        하 <input type="radio"  name="Difficulty level" value="under">
                        상관없음 <input type="radio"  name="Difficulty level" value="Doesn't matter">
					</div>
					<div class="form-group">
                        
                        <select name="bloodtype" value="How many servings">
						<label>인분:</label> 
                        <option>1인분</option>
                    <option>2인분</option>
                    <option>3인분</option>
                    <option>4인분</option>
					</div>
                    </select>
                    <div class="form-group">
						
                        <label>레시피이미지:</label>  
                        <br>
                         <height="35" bgcolor="whitesmoke">
                <td align="center" colspan="2">
                    <textarea cols="52" rows="5" name="spk" value=""></textarea>
                        
					</div>
					<div class="form-group">
						<label>레시피설명:</label> 
                        <br>
                         <height="35" bgcolor="whitesmoke">
                <td align="center" colspan="2">
                    <textarea cols="52" rows="5" name="spk" value=""></textarea>

					</div>
                    <div class="form-group">
						<label>식재료:</label> 
                        <br>
                        <height="35" bgcolor="whitesmoke" >
                <td align="center" colspan="2">
                    <textarea cols="52" rows="5" name="spk" value=""></textarea>
					</div>
					<div class="form-group">
						<label>태그:</label> 
                        <textarea cols="40" row="5" name="spk" ></textarea>
					</div>
                    <div class="form-group">
						<label>레시피 상세내용:</label> 
                        <br>
                        <height="35" bgcolor="whitesmoke">
                <td align="center" colspan="2">
                    <textarea cols="52" rows="5" name="spk" value="Recipe Details"></textarea>
					</div>
					
<button onclick="location.href='register'" class="btn btn-primary btn-sm">+추가하기</button>
    <br>
    <br>
<button onclick="location.href='register'" class="btn btn-primary btn-sm">레시피 등록</button>
   <button onclick="location.href='register'" class="btn btn-primary btn-sm">취소</button>
              

        </table>











    </form>






</body>
</html>           