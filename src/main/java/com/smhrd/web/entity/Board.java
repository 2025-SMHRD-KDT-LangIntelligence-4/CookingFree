package com.smhrd.web.entity;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Board {

    // ================== 기존 사용자 관련 필드 (유지) ==================
    private Integer user_idx;        // 사용자 식별자
    private String email;            // 이메일
    private String pw;               // 비밀번호
    private String nick;             // 닉네임
    private String auth_type;        // 인증타입
    private String social_id;        // 소셜 아이디
    private String alg_code;         // 보유 알러지
    private String prefer_taste;     // 선호하는 맛
    private String cooking_skill;    // 요리 실력
    private Timestamp joined_at;     // 가입 일자
    private String profile_img; 	 // 프로필 이미지 URL
    public String getProfile_img() { return profile_img; }
    public void setProfile_img(String profile_img) { this.profile_img = profile_img; }
    // ================== 기존 레시피 관련 필드 (확장) ==================
    private Integer recipe_idx;      // 레시피 식별자
    private String recipe_name;      // 레시피 명
    private String recipe_i;         // 레시피 초성
    private String n_title;          // 정규화 제목
    private String recipe_desc;      // 레시피 설명
    private String recipe_img;       // 대표 이미지
    private String cook_type;        // 요리 분류
    private String recipe_difficulty; // 난이도
    private Integer cooking_time;    // 조리 시간
    private Integer servings;        // 인분
    private String tags;             // 태그
    private Integer view_count;      // 조회수 ✅ NEW
    private Timestamp created_at;    // 등록 일자
    
    // ================== 기존 레시피 상세 관련 필드 (유지) ==================
    private Integer detail_idx;      // 상세 식별자
    private Integer step_order;      // 조리 순서
    private String cooking_desc;     // 조리 설명
    private String img;             // 조리 이미지
    
    // ================== 기존 식재료 관련 필드 (유지) ==================
    private Integer input_idx;       // 투입 식별자
    private Integer ingre_idx;       // 식재료 식별자
    private BigDecimal input_amount; // 투입 량
    private String ingre_name;       // 식재료 명
    private String ingre_category;   // 카테고리
    private String ingre_unit;       // 단위
    private BigDecimal calories;     // 칼로리
    private BigDecimal fat;          // 지방
    private BigDecimal protain;      // 단백질
    private BigDecimal carbohydrate; // 탄수화물
    private Timestamp updated_at;    // 수정 일자
    
    // ================== NEW: 리뷰 관련 필드 ==================
    private Integer review_idx;      // 리뷰 식별자 ✅ NEW
    private String cmt_content;      // 댓글 내용 ✅ NEW
    private Integer super_idx;       // 상위 댓글 (대댓글용) ✅ NEW
    private Integer review_count;    // 리뷰 개수 ✅ NEW
    private String review_img;       // 리뷰 이미지 ✅ NEW
    
    // ================== 기존 즐겨찾기/보상 관련 필드 (유지) ==================
    private Integer fav_idx;         // 즐찾 식별자
    private Integer ur_idx;          // 사보리 식별자
    private Integer reward_idx;      // 리워드 식별자
    private String user_action;      // 사용자 행동
    private Integer reward_point;    // 보상 포인트
    private String reward_descc;     // 보상 설명
    
    // ================== 기존 알레르기 관련 필드 (유지) ==================
    private Integer ial_idx;         // 식알 식별자
    private Integer alergy_idx;      // 알레르기 식별자
    private String alergy_name;      // 알레르기 명
    private String alergy_info;      // 알레르기 설명
    
    // ================== NEW: 챗봇 관련 필드 ==================
    private Integer session_idx;     // 세션 식별자 ✅ NEW
    private String session_id;       // 세션 ID ✅ NEW
    private String session_type;     // 세션 타입 ✅ NEW
    private Integer message_idx;     // 메시지 식별자 ✅ NEW
    private String message_type;     // 메시지 타입 ('user' 또는 'bot') ✅ NEW
    private String message_content;  // 메시지 내용 ✅ NEW
    private String response_source;  // 응답 소스 ('openai', 'stored', 'rule') ✅ NEW
    private Integer message_tokens;  // 토큰 수 ✅ NEW
    
    // ================== NEW: 검색 결과용 필드들 ==================
    private String user_message;     // 사용자 메시지 (검색 시 사용) ✅ NEW
    private String bot_response;     // 봇 응답 (검색 시 사용) ✅ NEW
    private String author_nick;      // 작성자 닉네임 (JOIN 시 사용) ✅ NEW
}
