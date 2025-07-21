package com.smhrd.web.entity;

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
	
	private int idx;
	private String title;
	private String writer;
	private String content;
	private Date indate;
	private int count;
	private String img_url;
}
