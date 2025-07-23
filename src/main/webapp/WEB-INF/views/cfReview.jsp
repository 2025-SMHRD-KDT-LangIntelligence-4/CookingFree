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
<style type="text/css">
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
<!---------------------------------------------------------gnb 배너입니다.--------------------------------------------------------------------->
    .comment-input-box {
    width: 100%;
    position: relative;
}

.comment-input-box div {
    float: right;
    display: flex;
    flex-direction: row;
}

.comment-input-box input {
    width: 100%;
    height: 100%;
    background-color: transparent;
    border: none;
    color: #666;
    vertical-align: middle;
    box-sizing: border-box;
}

.comment-input-box input:focus {
    outline: none;
}

@keyframes inputAnimation {
    from {
        box-sizing: inherit;
        border-bottom: 1px solid #000;
        transform: scale3d(0, 1, 0);
    }
    to {
        box-sizing: inherit;
        border-bottom: 2px solid #000;
        transform: scale3d(1, 1, 1);
    }
}

.comment-line {
    position: absolute;
    top: 116.5%;
    height: 1px;
    width: 62%;
    background-color: lightgrey;
}

.comment-line-in-ani {
    position: absolute;
    top: 116.5%;
    height: 2px;
    width: 62%;
    background-color: black;
    animation-name: inputAnimation;
    animation-duration: 0.3s;
}

.comment-buttons-wrapper button {
    width: 72px;
    height: 37px;
    line-height: 37px;
    margin: 7px;
    text-align: center;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 999px; /* <라운딩,둥근원형px> */
    font-size: 13px;
    border: none;
    cursor: pointer;
    transition: all 0.2s ease;
    color: #909090;
}

.comment-btn1 {
    background-color: rgb(246, 246, 246);
    color: #000;
    font-weight: bold;
}

.comment-btn2 {
    background-color: rgb(225, 225, 225);
    color: #787878;
    font-weight: bold;
}

.comment-btn1:hover,
.comment-btn2:hover {
    filter: brightness(0.95);
}



</style>
</head>
<body>
	<div class="gnb">
		<div class="gnb-left">
			<a href="#"><img src="${cpath}/upload/Vector.png" class="icon" /></a>
		</div>
		<div class="gnb-center">
			<a href="${cpath}" style="text-decoration-line: none;"><div class="logo">CookIN(G)Free</div></a>
		</div>
		<div class="gnb-right">
			<a href="cfLogin"><img src="${cpath}/upload/Vectorinfo.svg"
				class="icon" /></a> <a href="#"><img
				src="${cpath}/upload/Vectorfood.svg" class="icon" /></a> <a href="#"><img
				src="${cpath}/upload/Vectorsetting.svg" class="icon" /></a>
		</div>
	</div>
<!---------------------------------------------------------gnb 배너입니다.--------------------------------------------------------------------->

	<div className={styles.Comment_input_box}>
		{ isFocus === false ?
		<div className={styles.Comment_line}></div>
		:
		<div className={styles.Comment_line_inAni}></div>
		} <input onFocus={()=> { setIsFocus(true) setFirstFocus(true)
		}} onBlur={() => setIsFocus(false)} placeholder='댓굴 추가...' />
		<div>
			{ firstFocus ? <>
			<div id={styles.Comment_btn1} className={styles.Comment_buttons}>취소</div>
			<div id={styles.Comment_btn2} className={styles.Comment_buttons}>댓글</div>
			</> :
			<div className={styles.Comment_buttons}></div>
			}
		</div>
	</div>
	<div class="comment-input-box">
    <div id="comment-line" class="comment-line"></div>
    
    <input 
        id="comment-input"
        type="text"
        placeholder="댓글 추가..."
        onfocus="handleFocus()" 
        onblur="handleBlur()"
    />

    <div id="comment-buttons" class="comment-buttons-wrapper">
        <!-- 버튼은 JS로 동적 렌더링 -->
    </div>
</div>

<script>
    let isFocus = false;
    let firstFocus = false;

    const line = document.getElementById("comment-line");
    const input = document.getElementById("comment-input");
    const buttonsWrapper = document.getElementById("comment-buttons");

    function handleFocus() {
        isFocus = true;
        firstFocus = true;
        line.className = "comment-line-in-ani";

        buttonsWrapper.innerHTML = `
            <button class="comment-btn1" onclick="cancelComment()">취소</button>
            <button class="comment-btn2">댓글</button>
        `;
    }

    function handleBlur() {
        isFocus = false;
        line.className = "comment-line";
    }

    function cancelComment() {
        input.value = "";
        buttonsWrapper.innerHTML = "";
    }
</script>
	
</body>
</html>