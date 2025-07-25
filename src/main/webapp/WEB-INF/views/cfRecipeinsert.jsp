<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>레시피 등록</title>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f7f7f7;
        margin: 0;
        padding: 40px;
    }

    .form-container {
        width: 600px;
        margin: 0 auto;
        background-color: #ffffff;
        padding: 30px;
        border-radius: 8px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    }

    .form-row {
        display: flex;
        margin-bottom: 15px;
    }

    .form-row label {
        width: 150px;
        font-weight: bold;
        padding-top: 8px;
    }

    .form-row input[type="text"],
    .form-row select,
    .form-row textarea {
        flex: 1;
        padding: 8px;
        border: 1px solid #ccc;
        border-radius: 4px;
        resize: none;
    }

    .form-row .radio-group {
        flex: 1;
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
        padding-top: 6px;
    }

    .btn-group {
        text-align: center;
        margin-top: 25px;
    }

    .btn-group button {
        background-color: #007bff;
        color: white;
        border: none;
        padding: 10px 20px;
        margin: 0 10px;
        border-radius: 5px;
        cursor: pointer;
    }

    .btn-group button:hover {
        background-color: #0056b3;
    }

    .btn-secondary {
        background-color: #6c757d;
    }

    .btn-secondary:hover {
        background-color: #5a6268;
    }
     
</style>
</head>
<body><!-- s --><jsp:include page="inc/header.jsp" />


<div class="form-container">
    <form action="register2" method="post">

        <div class="form-row">
            <label>레시피명</label>
            <input type="text" name="title">
        </div>

        <div class="form-row">
            <label>요리분류</label>
            <input type="text" name="writer">
        </div>

        <div class="form-row">
            <label>난이도</label>
            <div class="radio-group">
                <label><input type="radio" name="difficulty" value="high"> 상</label>
                <label><input type="radio" name="difficulty" value="middle"> 중</label>
                <label><input type="radio" name="difficulty" value="low"> 하</label>
                <label><input type="radio" name="difficulty" value="none"> 상관없음</label>
            </div>
        </div>

        <div class="form-row">
            <label>인분</label>
            <select name="servings">
                <option value="1">1인분</option>
                <option value="2">2인분</option>
                <option value="3">3인분</option>
                <option value="4">4인분</option>
            </select>
        </div>

        <div class="form-row">
            <label>레시피 이미지</label>
           <input type="file" name="image" style="height: 80px; padding: 80px; font-size: 14px; border: 1px solid #ccc; border-radius: 4px;">
        </div>

        <div class="form-row">
            <label>레시피 설명</label>
            <textarea name="description" cols="52" rows="10"></textarea>
        </div>

        <div class="form-row">
            <label>식재료</label>
            <textarea name="ingredients" rows="3"></textarea>
        </div>

        <div class="form-row">
            <label>태그</label>
            <textarea name="tags" rows="2"></textarea>
        </div>

        
     <div class="form-row">
    <label>레시피 상세내용</label>
    <div id="details-wrapper">
      <div class="detail-row">
      <textarea cols="52" rows="5" name="spk" value="recipe detail"></textarea>
      <textarea name="details[]" placeholder="다음단계를 입력해주세요"></textarea>
        <input type="file" name="stepImage[]" accept="image/*">
        <button type="button" class="remove-btn">삭제</button>
      </div>
    </div>

    <button type="button" class="add-btn" id="add-detail-btn">+추가하기</button>
  </div>



        

    </form>
</div>

<!-- 자바스크립트 기능 추가 -->
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const wrapper = document.getElementById('details-wrapper');
        const addBtn = document.getElementById('add-detail-btn');

        addBtn.addEventListener('click', function () {
            const div = document.createElement('div');
            div.className = 'detail-row';
            div.innerHTML = `
                <textarea name="details[]" cols="52" rows="5" placeholder="다음 단계를 입력하세요."></textarea>
                <input type="file" name="image">
                <button type="button" class="remove-btn">삭제</button>
            `;
            wrapper.appendChild(div);
        });

        wrapper.addEventListener('click', function (e) {
            if (e.target.classList.contains('remove-btn')) {
                e.target.parentElement.remove();
               
            }
        });
    });



</script>


        

        

    


</body>
</html>