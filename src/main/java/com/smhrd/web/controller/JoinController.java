package com.smhrd.web.controller;

import java.sql.Timestamp;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.smhrd.web.entity.Board;
import com.smhrd.web.mapper.BoardMapper;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class JoinController {

    @Autowired
    private BoardMapper boardMapper;

    private static final Logger log = LoggerFactory.getLogger(JoinController.class);
    // 회원가입 폼 보여주기(GET)
    @GetMapping("/cfJoinform")
    public String showJoinForm(HttpSession session, HttpServletRequest request, Model model, @RequestParam(required=false) String mode) {
        if ("local".equals(mode)) {
            session.invalidate();
            session = request.getSession(true);
            session.setAttribute("authType", "L"); // 일반 회원가입 모드
        }
        // 이하 모델 세팅 및 폼 리턴// 소셜 로그인 시 세션에 저장된 정보 모델에 담아서 JSP에 전달
        model.addAttribute("socialId", session.getAttribute("socialId"));
        model.addAttribute("authType", session.getAttribute("authType") != null ? session.getAttribute("authType") : "L");
        model.addAttribute("email", session.getAttribute("email") != null ? session.getAttribute("email") : "");
        model.addAttribute("nickname", session.getAttribute("nickname") != null ? session.getAttribute("nickname") : "");
        return "cfJoinform";
    }

    // 회원가입 처리(POST)
    @PostMapping("/cfjoinId")
    public String doJoin(
            @RequestParam String nickname,
            @RequestParam String userId,
            @RequestParam(required = false) String userPW,
            @RequestParam(required = false) String checkPW,
            @RequestParam String authType,
            @RequestParam(required = false, defaultValue = "") String socialId,
            Model model) {

        // 이메일 중복 체크
        log.debug("▶▶ 회원가입 진입");
        if (boardMapper.selectUserByEmail(userId) != null) {
            model.addAttribute("msg", "이미 사용 중인 이메일입니다.");
            return "cfJoinform";
        }

        // 로컬 가입일 때 비밀번호 확인 검사
        if ("L".equalsIgnoreCase(authType)) {
            if (userPW == null || !userPW.equals(checkPW)) {
                model.addAttribute("msg", "비밀번호가 일치하지 않습니다.");
                return "cfJoinform";
            }
        } else {
            userPW = "";  // 소셜 가입자는 비밀번호 빈 문자열 처리
        }

        // 신규 회원 DB 저장 : 최초 소셜 로그인 시에는 저장하지 않았기에, 여기서 저장
        Board newUser = Board.builder()
                .email(userId)
                .pw(userPW)
                .nick(nickname)
                .auth_type(authType)
                .social_id(socialId)
                .joined_at(new Timestamp(System.currentTimeMillis()))
                .build();

        boardMapper.insertSocialUser(newUser);

        // 회원가입 완료 후 세션 초기화 (필요시)
        model.addAttribute("msg", "회원가입 완료!");
        return "redirect:/cfMain";  // 메인 페이지로 리다이렉트
    }
}
