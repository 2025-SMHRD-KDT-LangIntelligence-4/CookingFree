package com.smhrd.web.entity;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

//STS lombok라이브러리가 제대로 설치되지 않는다면?
// google에서 lombok 다운로드 검색 jar파일 실행
// 현재 작업중인 IDE 경로에 해당하는 lombok install
// 만약 압축이 풀려버리면 cmd창을 사용해서 java -jar "경로" 작성후 실행


@Data
@AllArgsConstructor
@NoArgsConstructor
public class Board {
	
	// 사용자 식별자 
    private Integer user_idx;

    // 이메일 
    private String email;

    // 비밀번호 
    private String pw;

    // 닉네임 
    private String nick;

    // 인증타입 
    private String auth_type;

    // 소셜 아이디 
    private String social_id;

    // 보유 알러지 
    private String alg_code;

    // 선호하는 맛 
    private String prefer_taste;

    // 요리 실력 
    private String cooking_skill;

    // 가입 일자 
    private Timestamp joined_at;
    
    // 상세 식별자 
    private Integer detail_idx;

    // 레시피 식별자 
    private Integer recipe_idx;

    // 조리 순서 
    private Integer step_order;

    // 조리 설명 
    private String cooking_desc;

    // 조리 이미지1 
    private String img1;

    // 조리 이미지2 
    private String img2;

    // 조리 이미지3 
    private String img3;

    // 조리 이미지4 
    private String img4;

    // 조리 이미지5 
    private String img5;

    // 조리 동영상 1 
    private String cooking_video;
    
    // 등록 일자 
    private Timestamp created_at;
    
    // 투입 식별자 
    private Integer input_idx;


    // 식재료 식별자 
    private Integer ingre_idx;

    // 투입 량 
    private BigDecimal input_amount;
    

    // 식재료 명 
    private String ingre_name;

    // 카테고리 
    private String ingre_category;

    // 단위 
    private String ingre_unit;

    // 칼로리 
    private BigDecimal calories;

    // 지방 
    private BigDecimal fat;

    // 단백질 
    private BigDecimal protain;

    // 탄수화물 
    private BigDecimal carbohydrate;


    // 수정 일자 
    private Timestamp updated_at;

    // 식알 식별자 
    private Integer ial_idx;
    
    // 리뷰 식별자 
    private Integer review_idx;


    // 댓글 내용 
    private String cmt_content;


    // 상위 댓글 
    private Integer super_idx;

    // 즐찾 식별자 
    private Integer fav_idx;
    
    // 사보리 식별자 
    private Integer ur_idx;


    // 리워드 식별자 
    private Integer reward_idx;


    // 사용자 행동 
    private String user_action;

    // 보상 포인트 
    private Integer reward_point;

    // 보상 설명 
    private String reward_descc;


    // 레시피 명 
    private String recipe_name;

    // 레시피 초성 
    private String recipe_i;

    // 정규화 제목 
    private String n_title;

    // 레시피 설명 
    private String recipe_desc;

    // 대표 이미지 
    private String recipe_img;


    // 요리 분류 
    private String cook_type;

    // 난이도 
    private String recipe_difficulty;

    // 조리 시간 
    private Integer cooking_time;

    // 인분 
    private Integer servings;

    // 태그 
    private String tags;

}
