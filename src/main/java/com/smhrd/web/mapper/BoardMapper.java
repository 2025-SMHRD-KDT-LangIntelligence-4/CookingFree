package com.smhrd.web.mapper;

import java.math.BigDecimal;
import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.smhrd.web.entity.Board;

@Mapper
public interface BoardMapper {
	
	/*
	 * BoardMapper 인터페이스
	 * 
	 * MyBatis를 사용한 데이터 액세스 레이어
	 * Board 엔티티의 필드명과 데이터베이스 컬럼이 직접 매핑됩니다.
	 * 
	 * 장점:
	 * - 데이터베이스 컬럼명과 Java 필드명이 완전히 일치
	 * - 매핑 오류 가능성 제거
	 * - mapUnderscoreToCamelCase 설정 불필요
	 * - 직관적인 필드-컬럼 관계
	 * 
	 * 주의사항:
	 * - Java 네이밍 컨벤션과는 다르지만 데이터베이스 일관성 확보
	 * 
	 * @author CookingFree Team
	 * @version 1.0
	 * @since 2025-07-25
	 */
    
    // ================== 사용자 관리 메서드 ==================
    
    /*
     * 사용자 ID로 사용자 정보를 조회합니다.
     * 
     * 반환되는 Board 객체의 사용자 관련 필드들:
     * - user_idx: 사용자 고유 ID
     * - alg_code: 알레르기 코드 (쉼표 구분)
     * - auth_type: 인증 타입
     * - social_id: 소셜 로그인 ID
     * - prefer_taste: 선호 맛
     * - cooking_skill: 요리 실력
     * - joined_at: 가입 일시
     * - profile_img: 프로필 이미지
     * 
     * @param user_idx 사용자 고유 ID
     * @return 사용자 상세 정보
     */
    Board selectUserByIdx(@Param("user_idx") Integer user_idx);
    
    /*
     * 이메일로 사용자를 조회합니다.
     * 
     * @param email 사용자 이메일 주소
     * @return 사용자 정보 (user_idx, auth_type 등 필드 포함)
     */
     Board selectUserByEmail(@Param("email") String email);
    
    /*
     * 소셜 ID로 사용자를 조회합니다.
     * 
     * @param social_id 소셜 플랫폼에서 제공하는 사용자 고유 ID
     * @param auth_type 인증 타입 ("google", "kakao", "naver" 등)
     * @return 해당하는 사용자 정보
     */
    @Select("SELECT * FROM cf_user WHERE social_id = #{social_id} AND auth_type = #{auth_type}")
    Board selectUserBySocialId(@Param("social_id") String social_id, @Param("auth_type") String auth_type);

    // ================== 레시피 관련 메서드==================
    
    /*
     * 레시피 조회수를 1 증가시킵니다.
     * 
     * Board 엔티티의 view_count 필드와 직접 매핑
     * 
     * @param recipe_idx 조회수를 증가시킬 레시피 ID
     */
    void updateRecipeViewCount(@Param("recipe_idx") Integer recipe_idx);
    
    /*
     * 조회수 기준 인기 레시피를 조회합니다.
     * 
     * 반환되는 Board 객체의 레시피 관련 필드들:
     * - recipe_idx: 레시피 ID
     * - recipe_name: 레시피 이름
     * - recipe_desc: 레시피 설명
     * - recipe_img: 대표 이미지
     * - cook_type: 요리 분류
     * - recipe_difficulty: 난이도
     * - cooking_time: 조리 시간
     * - servings: 인분 수
     * - view_count: 조회수
     * - created_at: 등록 일시
     * 
     * @param limit 조회할 레시피 개수
     * @return 조회수 순으로 정렬된 레시피 목록 
     */
    List<Board> getTopRecipesByViewCount(@Param("limit") Integer limit);
    


    // ================== 리뷰/댓글 시스템 메서드 ==================
    
    /*
     * 레시피에 리뷰(댓글)를 작성합니다.
     * 
     * Board 엔티티의 리뷰 관련 필드들과 매핑:
     * - review_idx: 리뷰 ID
     * - recipe_idx: 레시피 ID
     * - user_idx: 작성자 ID
     * - cmt_content: 댓글 내용
     * - super_idx: 상위 댓글 ID (대댓글인 경우)
     * - created_at: 작성 일시
     * 
     * @param recipe_idx 리뷰를 작성할 레시피 ID
     * @param user_idx 리뷰 작성자 ID
     * @param cmt_content 리뷰 내용 
     * @param super_idx 상위 댓글 ID (대댓글인 경우)
     */
    void insertRecipeReview(@Param("recipe_idx") Integer recipe_idx,
                           @Param("user_idx") Integer user_idx,
                           @Param("cmt_content") String cmt_content,
                           @Param("review_img") String review_img,
                           @Param("super_idx") Integer super_idx);
    
    /*
     * 특정 레시피의 리뷰 목록을 조회합니다.
     * 
     * @param recipe_idx 레시피 ID
     * @param limit 페이지당 리뷰 개수
     * @param offset 페이지 오프셋
     * @return 리뷰 목록 (review_idx, cmt_content, user_idx 등 필드 포함)
     */
    List<Board> getRecipeReviews(@Param("recipe_idx") Integer recipe_idx,
                                @Param("limit") Integer limit,
                                @Param("offset") Integer offset);
    
    /*
     * 리뷰를 삭제합니다.
     * 
     * @param review_idx 삭제할 리뷰 ID
     * @param user_idx 삭제 요청자 ID (권한 검증용)
     * @return 삭제된 행 수
     */
    int deleteRecipeReview(@Param("review_idx") Integer review_idx,
                          @Param("user_idx") Integer user_idx);

    // ================== 챗봇 시스템 메서드==================
    
    /*
     * 새로운 챗봇 대화 세션을 생성합니다.
     * 
     * Board 엔티티의 챗봇 관련 필드들:
     * - session_idx: 세션 테이블 ID
     * - session_id: 세션 고유 식별자
     * - session_type: 세션 타입
     * - user_idx: 사용자 ID
     * 
     * @param session_id 고유한 세션 식별자 (UUID)
     * @param user_idx 사용자 ID
     * @param session_type 세션 타입 ("general", "recipe", "support" 등)
     */
    void insertChatSession(@Param("session_id") String session_id, 
                          @Param("user_idx") Integer user_idx, 
                          @Param("session_type") String session_type);
    
    /*
     * 대화 메시지를 저장합니다.
     * 
     * Board 엔티티의 메시지 관련 필드들:
     * - message_idx: 메시지 ID
     * - session_id: 세션 ID
     * - user_idx: 사용자 ID
     * - message_type: 메시지 타입 ("user" 또는 "bot")
     * - message_content: 메시지 내용
     * - response_source: 응답 생성 방식 ("openai", "stored", "rule")
     * - message_tokens: 추정 토큰 수
     * - created_at: 생성 일시
     * 
     * @param session_id 대화 세션 ID 
     * @param user_idx 사용자 ID 
     * @param message_type "user" (사용자 메시지) 또는 "bot" (봇 응답)
     * @param message_content 메시지 내용 
     * @param response_source 응답 생성 방식 
     * @param message_tokens 추정 토큰 수 
     */
    void insertChatMessage(@Param("session_id") String session_id,
                          @Param("user_idx") Integer user_idx,
                          @Param("message_type") String message_type,
                          @Param("message_content") String message_content,
                          @Param("response_source") String response_source,
                          @Param("message_tokens") Integer message_tokens);
    
    /*
     * 키워드와 유사한 과거 대화를 검색합니다.
     * 
     * 반환되는 Board 객체들에는 다음 필드들이 포함됩니다:
     * - user_message: 사용자가 입력한 메시지
     * - bot_response: 봇이 생성한 응답
     * - message_content: 메시지 내용
     * - response_source: 응답 생성 방식
     * - created_at: 대화 일시
     * 
     * @param keyword 검색할 키워드
     * @param user_idx 사용자 ID (개인화된 검색)
     * @param limit 검색 결과 제한 개수
     * @return 유사한 대화 목록 (user_message, bot_response 등 필드 포함)
     */
    List<Board> findSimilarConversations(@Param("keyword") String keyword,
                                        @Param("user_idx") Integer user_idx,
                                        @Param("limit") Integer limit);
    
    /*
     * 사용자별 대화 기록을 조회합니다.
     * 
     * @param user_idx 사용자 ID 
     * @param limit 조회할 대화 개수
     * @return 해당 사용자의 최근 대화 목록 (message_content, message_type 등 포함)
     */
    List<Board> getUserConversationHistory(@Param("user_idx") Integer user_idx,
                                          @Param("limit") Integer limit);
    
    /*
     * 오늘의 OpenAI API 사용량을 조회합니다.
     * 
     * @param date 조회 날짜 (YYYY-MM-DD 형식)
     * @return 해당 날짜의 API 호출 횟수
     */
    Integer getTodayApiUsage(@Param("date") String date);
    
    /*
     * 알레르기 정보를 고려한 안전한 레시피를 조회합니다.
     * 
     * 반환되는 Board 객체들의 레시피 필드들:
     * - recipe_idx, recipe_name, recipe_desc
     * - cook_type, recipe_difficulty, cooking_time
     * - servings, view_count, created_at
     * - tags: 레시피 태그 정보
     * 
     * @param allergy_ids 사용자의 알레르기 코드 목록 
     * @param limit 추천할 레시피 개수
     * @return 알레르기 안전 레시피 목록 
     */
    List<Board> getAllergyFreeRecipes(@Param("allergy_ids") List<Integer> allergy_ids, 
                                      @Param("limit") Integer limit);
    
    /*
     * 키워드 기반으로 알레르기 안전 레시피를 검색합니다.
     * 
     * 검색 대상 필드들 :
     * - recipe_name: 레시피 이름
     * - recipe_desc: 레시피 설명
     * - cook_type: 요리 카테고리
     * - tags: 레시피 태그
     * 
     * @param keyword 검색 키워드 (음식명, 재료명 등)
     * @param allergy_ids 제외할 알레르기 코드 목록
     * @param limit 검색 결과 제한 개수
     * @return 키워드에 맞는 알레르기 안전 레시피 목록
     */
    List<Board> searchAllergyFreeRecipes(@Param("keyword") String keyword,
                                         @Param("allergy_ids") List<Integer> allergy_ids,
                                         @Param("limit") Integer limit);


	void updateUserInfo(Board updatedUser);

	List<Board> getRecipesSortedByViewCount(int i);

	Board getRecipeDetailWithViewCount(Integer recipeId);

	int getRecipeReviewCount(Integer recipeId);

	int insertSocialUser(Board newUser);
	
	/**
	 * 레시피의 재료 목록 조회.
	 * 
	 * @param recipe_idx 레시피 ID
	 * @return 재료 목록 (재료명, 투입량, 단위 포함)
	 */
	List<Board> getRecipeIngredients(@Param("recipe_idx") Integer recipe_idx);


    /** 레시피 단계 전체 조회 */
    List<Board> getRecipeSteps(
            @Param("recipe_idx") Integer recipe_idx
    );




//    알레르기 조회해놓기1
     List<Board> getAllAllergies(); 
     

     // 3) 알러지 이름 목록으로 alergy_idx 리스트 조회
     List<Integer> getAllergyIdxListByNames(@Param("names") List<String> names);

     // 4) 사용자-알러지 매핑 테이블에 다중 insert
     int insertUserAllergies(@Param("user_idx") Integer userIdx, @Param("alergy_idx_list") List<Integer> alergy_idx_list);

     
  // 1) 사용자별 alergy_idx 리스트 조회
     @Select("SELECT alergy_idx FROM cf_user_alergy WHERE user_idx = #{user_idx}")
     List<Integer> getUserAllergyIdxs(@Param("user_idx") Integer user_idx);

     // 2) allergy_idx 리스트로 동의어 키워드 조회
     List<String> selectKeywordsByAlergyIdxs(@Param("alergyIdxs") List<Integer> alergyIdxs);
     
     // 레시피 삽입
     
  // 레시피 insert (useGeneratedKeys)
     @Insert("INSERT INTO cf_recipe (recipe_name, cook_type,user_idx ,recipe_difficulty, servings, recipe_img, cooking_time,recipe_desc, tags, created_at) "
           + "VALUES (#{recipe_name}, #{cook_type}, #{user_idx}, #{recipe_difficulty}, #{servings}, #{recipe_img},#{cooking_time}, #{recipe_desc}, #{tags}, NOW())")
     @Options(useGeneratedKeys=true, keyProperty="recipe_idx", keyColumn="recipe_idx")
     void insertRecipe(Board recipe);

     // 식재료 이름으로 조회
     @Select("SELECT ingre_idx FROM cf_ingredient WHERE ingre_name = #{ingreName}")
     Integer getIngreIdxByName(@Param("ingreName") String ingreName);

     // 신규 식재료 insert
     @Insert("INSERT INTO cf_ingredient (ingre_name, created_at) VALUES (#{ingreName}, NOW())")
     void insertIngredient(@Param("ingreName") String ingreName);

     // cf_input 매핑 insert
     @Insert("INSERT INTO cf_input (recipe_idx, ingre_idx, input_amount, created_at) "
           + "VALUES (#{recipeIdx}, #{ingreIdx}, #{inputAmount}, NOW())")
     void insertRecipeInput(@Param("recipeIdx") Integer recipeIdx,
                            @Param("ingreIdx") Integer ingreIdx,
                            @Param("inputAmount") BigDecimal inputAmount);
     
     @Insert("INSERT INTO cf_recipe_detail (recipe_idx, step_order, cooking_desc, img, created_at) "
    	      + "VALUES (#{recipeIdx}, #{stepOrder}, #{cookingDesc}, #{img}, NOW())")
    	void insertRecipeDetail(
    	    @Param("recipeIdx") Integer recipeIdx,
    	    @Param("stepOrder") Integer stepOrder,
    	    @Param("cookingDesc") String cookingDesc,
    	    @Param("img") String img
    	);



}
