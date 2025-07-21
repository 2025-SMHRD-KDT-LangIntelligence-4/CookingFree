package com.smhrd.web.controller;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.smhrd.web.entity.Board;
import com.smhrd.web.entity.SearchCriteria;
import com.smhrd.web.mapper.BoardMapper;

@Controller
public class MyController {
	
	// BoardMapper는 인터페이스 -> 직접 객체 생성 불가
	// SpringContainer가 알아서 객체를 생성해서 주입하는 형식으로 진행
	@Autowired
	BoardMapper mapper;
	
	
	//로그 찍는 도구 꺼내오기
	private Logger logger = LoggerFactory.getLogger(getClass());
	
	//Spring boot 에서는 RequestMapping 방식을 권장하지 않음
	//정확하게 전송방식을 지정해주는 형태를 사용
	@GetMapping("/")
	public String goBoard(Model model) {
		
		return "cfMain";
		//Spring boot 는 기본적으로 HTML 방식을 권장한다. 아래의 기본 설정으로 되어있음
		//경로가 prefix : resources/templates/(정적인 파일 반복문, 조건문 사용불가), 
		//     suffix : .html 
		
	}
	@GetMapping("/cfLogin")
	public String cfLogin(Model model) {
		
		return "cfLogin";
		//Spring boot 는 기본적으로 HTML 방식을 권장한다. 아래의 기본 설정으로 되어있음
		//경로가 prefix : resources/templates/(정적인 파일 반복문, 조건문 사용불가), 
		//     suffix : .html 
		
	}
	
}
