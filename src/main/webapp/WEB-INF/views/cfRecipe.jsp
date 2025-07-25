<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <style>
        .recipe-img{
            width: 400px;
            height: 317.2px;
            background-color: white;
            border: 3px solid gray;
            border-radius : 10px;
            
        }
        .voice-btn{
            width: 200px;
            height: 150px;
            background-color: white;
            border: 3px solid gray;
            border-radius : 10px;
            margin-left: 10px;
            margin-bottom: 10px;
        }
        .touch-btn{
            width: 200px;
            height: 150px;
            background-color: white;
            border: 3px solid gray;
            border-radius : 10px;
            margin-left: 10px;
        }
        .container{
            display: flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            margin-top:50px;
        }
        .btn-container{
            flex-direction: column;
        }
        .title-container{
            display: flex;
            justify-content: center;
            margin-top: 100px;
        }
        .title{
            font-size: 30px;
            background-color: white;
            border: 3px solid gray;
            border-radius : 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 600px;
            margin-top:50px;
        }
        .recipe-img2{
            width: 200px;
            height: 150px;
            background-color: white;
            border: 3px solid gray;
            border-radius : 10px;
        }
        .container2{
            display: flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            
        }
        .btn-container2{
            flex-direction: column;
        }
        .recipe-step-title{
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-top:200px;            
        }
        .scroll{
            display: flex;
            justify-content: center;
            margin-top:200px; 
            width: 100%;
            height: 50px;
            background-color: gray;
        }
        .scroll img{
            width: 40px;
	        transform: rotate(180deg);
        }
        .ingredient{
            display: flex;
            justify-content: center;
            margin-top: 50px;
        }
        .ingre-text{
            width: 99%; 
            height: 99%; 
            box-sizing: border-box;
            padding: 10px;
            margin: 2px 3px;
            border: none;  
        }
        .recipe-step{
            width: 200px;
            height: 317.2px;
            background-color: white;
            border: 3px solid gray;
            border-radius : 10px;
            margin-left: 10px;
        }
        .ingre-container{
            border: 3px solid gray;
            border-radius : 10px;
            width: 600px;
            height: 300px;
        }
/*--------------------------------------------------------------------------------------------------------*/
 /*---------------------------------------------------gnb배너입니다-----------------------------------------------*/
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
                <a href="${cpath}/login"><img src="${cpath}/upload/Vectorinfo.svg" class="icon" /></a>
                <a href="${cpath}/cfMyPage"><img src="${cpath}/upload/Vectorfood.svg" class="icon" /></a>
                <a href="#"><img src="${cpath}/upload/Vectorsetting.svg" class="icon" /></a>
            </div>
        </div>
<!---------------------------------------------------gnb배너입니다.--------------------------------------------------->
    <div class="title-container">
        <div class="title">레시피 이름</div>
    </div>
    <div class="container">
        <div class="recipe-img">
             레시피 이미지
         </div>
         <div class="btn-container">
             <div class="voice-btn">
                 음성 인식 버튼
             </div>
             <div class="touch-btn">
                 터치 조작 버튼
             </div> 
         </div>
    </div>

    <div class="scroll">
    		<img src="${cpath}/upload/ic_baseline-keyboard-arrow-up.svg" />
    </div>

    <div class="title-container">
        <div class="title">재료 준비</div>
    </div>
    <div class="ingredient">
        <div class="ingre-container">
            <textarea class="ingre-text">출력</textarea>
        </div>
    </div>

    <div class="scroll">
        <img src="${cpath}/upload/ic_baseline-keyboard-arrow-up.svg" />
    </div>

    <div class="title-container">
        <div class="title">단계(요리)</div>
    </div>
    <div class="container">
        <div class="recipe-img">
             레시피 이미지
         </div>
        <div class="btn-container">
             <div class="recipe-step">
                 레시피 설명
             </div>
         </div>
    </div>
1
</body>
</html>