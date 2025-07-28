package com.smhrd.web.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.smhrd.web.entity.Board;
import com.smhrd.web.entity.SearchCriteria;

@Mapper
public interface BoardMapper {
    
    // ================== 기존 CRUD 메서드 (유지) ==================
    public List<Board> selectAll();
    public Board boardContent(int idx);
    public void boardWrite();
    public void register(Board board);
    public void boardDelete(int idx);
    
    @Update("UPDATE BOARD SET COUNT= COUNT+1 WHERE IDX = #{idx}")
    public int boardCount(int idx);
    
    public void boardUpdate(Board board);
    public List<Board> searchTitle(String search);
    public List<Board> searchContent(SearchCriteria criteria);
    
    // ================== 사용자 관련 메서드 (유지) ==================
    public Board selectUserByEmail(@Param("email") String email);
    public int insertSocialUser(Board user);
    
    @Select("SELECT * FROM cf_user WHERE social_id = #{socialId} AND auth_type = #{authType}")
    Board selectUserBySocialId(@Param("socialId") String socialId, @Param("authType") String authType);
    
    Board selectUserByIdx(Integer userIdx);
    void updateUserInfo(Board updatedUser);
    List<Board> selectRecipesByIds(@Param("recipeIdxList") List<Integer> recipeIdxList);

    // ================== NEW: 레시피 조회수 관련 메서드 ==================
    
    /**
     * 레시피 조회수 증가
     */
    void updateRecipeViewCount(@Param("recipeIdx") Integer recipeIdx);
    
    /**
     * 조회수 기준 상위 레시피 조회 (메인페이지용)
     */
    List<Board> getTopRecipesByViewCount(@Param("limit") Integer limit);
    
    /**
     * 조회수 기준 정렬된 레시피 목록 조회
     */
    List<Board> getRecipesSortedByViewCount(@Param("limit") Integer limit);
    
    /**
     * 특정 레시피 상세 정보 조회 (조회수 포함)
     */
    Board getRecipeDetailWithViewCount(@Param("recipeIdx") Integer recipeIdx);

    // ================== NEW: 리뷰 관련 메서드 ==================
    
    /**
     * 레시피에 리뷰 작성
     */
    void insertRecipeReview(@Param("recipeIdx") Integer recipeIdx,
                           @Param("userIdx") Integer userIdx,
                           @Param("cmtContent") String cmtContent,
                           @Param("superIdx") Integer superIdx);
    
    /**
     * 특정 레시피의 리뷰 목록 조회
     */
    List<Board> getRecipeReviews(@Param("recipeIdx") Integer recipeIdx,
                                @Param("limit") Integer limit,
                                @Param("offset") Integer offset);
    
    /**
     * 리뷰 삭제 (작성자 확인 포함)
     */
    int deleteRecipeReview(@Param("reviewIdx") Integer reviewIdx,
                          @Param("userIdx") Integer userIdx);
    
    /**
     * 리뷰 수정 (작성자 확인 포함)
     */
    int updateRecipeReview(@Param("reviewIdx") Integer reviewIdx,
                          @Param("userIdx") Integer userIdx,
                          @Param("cmtContent") String cmtContent);
    
    /**
     * 특정 레시피의 리뷰 개수 조회
     */
    Integer getRecipeReviewCount(@Param("recipeIdx") Integer recipeIdx);

    // ================== NEW: 챗봇 관련 메서드 ==================
    
    /**
     * 대화 세션 저장
     */
    void insertChatSession(@Param("sessionId") String sessionId, 
                          @Param("userIdx") Integer userIdx, 
                          @Param("sessionType") String sessionType);
    
    /**
     * 대화 메시지 저장
     */
    void insertChatMessage(@Param("sessionId") String sessionId,
                          @Param("userIdx") Integer userIdx,
                          @Param("messageType") String messageType,
                          @Param("messageContent") String messageContent,
                          @Param("responseSource") String responseSource,
                          @Param("messageTokens") Integer messageTokens);
    
    /**
     * 유사한 대화 검색
     */
    List<Board> findSimilarConversations(@Param("keyword") String keyword,
                                        @Param("userIdx") Integer userIdx,
                                        @Param("limit") Integer limit);
    
    /**
     * 사용자별 대화 기록 조회
     */
    List<Board> getUserConversationHistory(@Param("userIdx") Integer userIdx,
                                          @Param("limit") Integer limit);
    
    /**
     * 오늘 API 사용량 조회
     */
    Integer getTodayApiUsage(@Param("date") String date);
    
    /**
     * 알레르기 제외 레시피 조회
     */
    List<Board> getAllergyFreeRecipes(@Param("allergyIds") List<Integer> allergyIds, 
                                      @Param("limit") Integer limit);
    
    /**
     * 키워드로 레시피 검색 (알레르기 제외)
     */
    List<Board> searchAllergyFreeRecipes(@Param("keyword") String keyword,
                                         @Param("allergyIds") List<Integer> allergyIds,
                                         @Param("limit") Integer limit);
    
    /**
     * 오래된 대화 메시지 삭제
     */
    void deleteOldChatMessages(@Param("days") Integer days);
}
