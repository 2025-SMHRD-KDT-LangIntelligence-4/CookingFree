package com.smhrd.web.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.smhrd.web.entity.Board;
import com.smhrd.web.entity.SearchCriteria;


//Springboot에서는 Mapper 어노테이션 필수 
@Mapper
public interface BoardMapper {
	// 추상 메서드의 구현체를 만드는 역할은 개발자가 아닌 
	// SpringContainer 안의 Mybatis f/w 사용하는 객체들이 구현체를 알아서 만들어주고 연결하는 작업읗 수행한다.
	public List<Board> selectAll();

	// 글선택 이동 메서드
	public Board boardContent(int idx);
	
	//글작성 페이지 이동 메서드
	public void boardWrite();

	//글 작성 완료 메서드
	public void register(Board board);

	//글삭제 메서드
	public void boardDelete(int idx);
	//조회수 증가
	@Update("UPDATE BOARD SET COUNT= COUNT+1 WHERE IDX = #{idx}")
	public int boardCount(int idx);

	public void boardUpdate(Board board);

	public List<Board> searchTitle(String search);
	
	public List<Board> searchContent(SearchCriteria criteria);

	public Board selectUserByEmail(@Param("email") String email);


	public int insertSocialUser(Board user);
	
	@Select("SELECT * FROM cf_user WHERE social_id = #{socialId} AND auth_type = #{authType}")
	Board selectUserBySocialId(@Param("socialId") String socialId, @Param("authType") String authType);

	Board selectUserByIdx(Integer userIdx);

	void updateUserInfo(Board updatedUser) ;



}

