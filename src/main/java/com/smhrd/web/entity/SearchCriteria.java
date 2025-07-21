package com.smhrd.web.entity;



import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class SearchCriteria {
	//검색 기준을 의미하는 자료형
	private String filter; // 작성자, 제목, 내용중 하나
	private String searchContent;//검색할 글자
	
}
