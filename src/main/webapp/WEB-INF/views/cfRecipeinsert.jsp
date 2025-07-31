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
        background-color:white;
        margin: 0;
    }

    .form-container {
        width: 70%;
        margin: 5% auto;
        padding: 30px;
        border-radius: 8px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        background-color:white;
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

    /* 상세 레시피 단계에 대한 스타일 */
    .detail-row {
        align-items: flex-start; /* 아이템을 행의 시작 부분에 정렬 */
        margin-bottom: 15px; /* 상세 단계 행 사이의 간격 */
        gap: 10px; /* 텍스트 에어리어, 입력 필드, 버튼 사이의 간격 */
    }

    .detail-row textarea {
        flex: 2; /* 텍스트 에어리어가 더 많은 공간을 차지하도록 */
    }

    .detail-row input[type="file"] {
        flex: 1; /* 파일 입력이 사용 가능한 공간을 차지하도록 */
        padding: 8px;
        height: auto; /* 고정된 높이 제거 */
        font-size: 14px;
        border: 1px solid #ccc;
        border-radius: 4px;
    }

    .detail-row .remove-btn {
        background-color: #dc3545;
        color: white;
        border: none;
        padding: 8px 12px;
        border-radius: 4px;
        cursor: pointer;
        align-self: flex-start; /* 버튼을 시작 부분에 정렬 */
    }

    .detail-row .remove-btn:hover {
        background-color: #c82333;
    }

    /* 추가하기 버튼을 위한 스타일 (별도의 행에 배치) */
    .add-detail-btn-container {
        display: flex; /* flexbox 사용 */
        justify-content: flex-end; /* 오른쪽 정렬 */
        margin-top: -10px; /* 위쪽 마진 조정 (원하는 만큼) */
        margin-bottom: 15px; /* 아래쪽 마진 */
        width: calc(100% - 150px); /* 라벨 너비만큼 제외하고 폭 조정 */
        margin-left: 150px; /* 라벨 너비만큼 왼쪽 마진 */
    }
    .add-detail-btn-container button {
        background-color: #28a745;
        color: white;
        border: none;
        padding: 8px 15px;
        border-radius: 5px;
        cursor: pointer;
    }
    .add-detail-btn-container button:hover {
        background-color: #218838;
    }
    .form-row input{
 		width:50% !important;
    }
/* GNB */
.gnb {
  display: flex;
  flex-wrap: nowrap;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  background: #fff;
  overflow-x: auto;
  border-bottom: 1px solid #ddd;
  box-sizing: border-box;
  gap: 12px;
}
.gnb-left a, .gnb-right a {
  display: flex;
  align-items: center;
  margin-left: 10px;
  text-decoration: none;
}
.gnb-center {
  flex: 0 1 auto;
  min-width: 80px;
  margin-left: 30vw;
  left: 20%;
  transform: translateX(-50%);
  position: absolute;
}
.logo {
  font-size: clamp(18px, 4vw, 32px);
  font-weight: bold;
  font-family: 'Inter', sans-serif;
  color: #000;
}
.gnb-right {
  display: flex;
  gap: 12px;
}
.icon {
  width: clamp(18px, 5vw, 36px);
  height: clamp(18px, 5vw, 36px);
  min-width: 18px;
  min-height: 18px;
  object-fit: contain;
}
@media (max-width: 768px) {
  .gnb {
    padding: 12px;
    gap: 8px;
  }
  .gnb-right a {
    margin-left: 6px;
  }
}

</style>
</head>
<jsp:include page="inc/header.jsp" />
<body>

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

        <div class="form-row" style="align-items: flex-start;">
            <label>레시피 상세내용</label>
            <div id="details-wrapper" style="flex: 1;">
                <div class="detail-row">
                    <textarea name="details[]" cols="52" rows="10" placeholder="다음 단계를 입력하세요."></textarea>
                    <input type="file" name="image">
                    <button type="button" class="remove-btn">삭제</button>
                </div>
            </div>
        </div>

        <div class="add-detail-btn-container">
            <button type="button" class="add-btn" id="add-detail-btn">+추가하기</button>
        </div>

        <div class="btn-group">
            <button type="submit">레시피 등록</button>
            <button type="reset" class="btn-secondary">취소</button>
        </div>
    </form>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const wrapper = document.getElementById('details-wrapper');
        const addBtn = document.getElementById('add-detail-btn');

        addBtn.addEventListener('click', function () {
            const div = document.createElement('div');
            div.className = 'detail-row';
            div.innerHTML = `
                <textarea name="details[]" cols="52" rows="10" placeholder="다음 단계를 입력하세요."></textarea>
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