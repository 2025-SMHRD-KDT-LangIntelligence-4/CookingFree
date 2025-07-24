package com.smhrd.web.controller;


import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.security.SecureRandom;
import java.util.List;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ImportResource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.smhrd.web.entity.Board;
import com.smhrd.web.entity.SearchCriteria;
import com.smhrd.web.mapper.BoardMapper;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;


@Controller
public class MyController{
	
	// BoardMapper는 인터페이스 -> 직접 객체 생성 불가
	// SpringContainer가 알아서 객체를 생성해서 주입하는 형식으로 진행
	@Autowired
	BoardMapper mapper;
	
	
	//로그 찍는 도구 꺼내오기
	private Logger logger = LoggerFactory.getLogger(getClass());
	
	//Spring boot 에서는 RequestMapping 방식을 권장하지 않음
	//정확하게 전송방식을 지정해주는 형태를 사용
	@GetMapping({"/", "/cfMain"})
	public String mainPage() {
		return "cfMain";   // /WEB-INF/views/cfMain.jsp 뷰 렌더링
	}
	@GetMapping("/login")
	public String loginPage() {
		return "cfLogin";
	}






	@GetMapping("/cfSearchRecipe")
	public String cfSearchRecipe() {
		//콘솔 창에 출력 확인 해볼것. -> System. out.println("수집한 데이터 확인>>"+idx);
		// 수집한 데이터확인

		return "cfSearchRecipe";
	}
	
	@GetMapping("/cfRecipeinsert")
	public String cfRecipeinsert() {
		return "cfRecipeinsert";
	}



	@GetMapping("/cfMyPage")
	public String cfMyPage() {
		return "cfMyPage";
	}
//		Join 기능은 컨트롤러 따로 빼서 관리하는게 효율적이라 빼고함
//    @GetMapping("/cfJoinform")
//    public String joinForm() {
//        return "cfJoinform";  // /WEB-INF/views/cfJoinform.jsp 로 매핑
//    }
//
}