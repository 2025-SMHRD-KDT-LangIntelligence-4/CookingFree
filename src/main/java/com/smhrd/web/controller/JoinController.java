package com.smhrd.web.controller;

import java.sql.Timestamp;
import java.util.Arrays;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.smhrd.web.entity.Board;
import com.smhrd.web.mapper.BoardMapper;
import com.smhrd.web.service.CustomUserDetailsService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class JoinController {
	
	private final BoardMapper boardMapper;
	
    @Autowired
    private CustomUserDetailsService customUserDetailsService;

    public JoinController(BoardMapper boardMapper) {
        this.boardMapper = boardMapper;
    }

    private static final Logger log = LoggerFactory.getLogger(JoinController.class);
 // 회원가입 폼 보여주기(GET)
    @GetMapping("/cfJoinform")
    public String showJoinForm(
            HttpSession session,
            HttpServletRequest request,
            Model model,
            @RequestParam(required = false) String mode) {

        // 로컬 가입 모드 처리
        if ("local".equals(mode)) {
            session.invalidate();
            session = request.getSession(true);
            session.setAttribute("authType", "L"); // 일반 회원가입 모드
        }

        // 알러지 목록 조회
        List<Board> allergies = boardMapper.getAllAllergies();
        model.addAttribute("allergies", allergies);

        // 소셜 로그인 시 세션에 저장된 정보 모델에 담아서 JSP에 전달
        model.addAttribute("socialId",
                session.getAttribute("socialId") != null
                        ? session.getAttribute("socialId")
                        : "");
        model.addAttribute("authType",
                session.getAttribute("authType") != null
                        ? session.getAttribute("authType")
                        : "L");
        model.addAttribute("email",
                session.getAttribute("email") != null
                        ? session.getAttribute("email")
                        : "");
        model.addAttribute("nickname",
                session.getAttribute("nickname") != null
                        ? session.getAttribute("nickname")
                        : "");

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
            @RequestParam(required = false, defaultValue = "") String userAlgCode,       // e.g. "난류, 우유"
            @RequestParam(required = false, defaultValue = "") String userPreferTaste,    // e.g. "매운맛, 한식"
            @RequestParam(required = false, defaultValue = "초급") String userCookingSkill, // "초급", "중급", "고급"
            HttpServletRequest request,
            HttpSession session,         
            Model model) {
        log.debug("▶▶ 회원가입 진입");

        // 1) 필수 입력 검증
        if (nickname == null || nickname.trim().isEmpty() || userId == null || userId.trim().isEmpty()) {
            model.addAttribute("msg", "닉네임과 이메일은 필수 입력입니다.");
            return "cfJoinform";
        }

        // 2) 이메일 중복 체크
        if (boardMapper.selectUserByEmail(userId) != null) {
            model.addAttribute("msg", "이미 사용 중인 이메일입니다.");
            return "cfJoinform";
        }

        // 3) 로컬 가입 시 비밀번호 확인 검증
        if ("L".equalsIgnoreCase(authType)) {
            // 로컬가입인 경우 소셜ID를 null로 명확히 세팅
            socialId = null;
            if (userPW == null || userPW.trim().isEmpty()) {
                model.addAttribute("msg", "비밀번호를 입력해주세요.");
                return "cfJoinform";
            }
            if (!userPW.equals(checkPW)) {
                model.addAttribute("msg", "비밀번호가 일치하지 않습니다.");
                return "cfJoinform";
            }
        } else {
            if (socialId == null || socialId.trim().isEmpty()) {
                model.addAttribute("msg", "소셜ID가 존재하지 않습니다.");
                return "cfJoinform";
            }
            userPW = "";  // 소셜가입자는 PW 빈 문자열 처리
        }

        // 4) 요리실력 값 검사
        if (!userCookingSkill.matches("초급|중급|고급")) {
            model.addAttribute("msg", "요리실력은 초급, 중급, 고급 중 하나여야 합니다.");
            return "cfJoinform";
        }

        // 5) 신규 회원 정보 객체 생성
        Board newUser = Board.builder()
                .nick(nickname.trim())
                .email(userId.trim())
                .pw(userPW)
                .auth_type(authType)
                .social_id(socialId)
                .alg_code(userAlgCode.trim())
                .prefer_taste(userPreferTaste.trim())
                .cooking_skill(userCookingSkill)
                .joined_at(new Timestamp(System.currentTimeMillis()))
                .build();

        try {
            // 6) 사용자 정보 등록 (자동 생성된 PK user_idx는 newUser.user_idx에 세팅됨)
            int inserted = boardMapper.insertSocialUser(newUser);
            if (inserted != 1) {
                model.addAttribute("msg", "회원가입 처리에 실패했습니다.");
                return "cfJoinform";
            }

            // 7) 알러지 매핑 처리 (복수 선택: 컴마+띄어쓰기로 분리하여 DB 매핑)
            if (userAlgCode != null && !userAlgCode.trim().isEmpty()) {
                List<String> allergyNameList = Arrays.asList(userAlgCode.split(",\\s*"));
                List<Integer> allergyIdxList = boardMapper.getAllergyIdxListByNames(allergyNameList);

                if (!allergyIdxList.isEmpty()) {
                    boardMapper.insertUserAllergies(newUser.getUser_idx(), allergyIdxList);
                }
            }
         
        } catch (Exception e) {
            log.error("회원가입 중 오류 발생", e);
            model.addAttribute("msg", "회원가입 중 오류가 발생했습니다: " + e.getMessage());
            return "cfJoinform";
        }
        session.setAttribute("user_idx", newUser.getUser_idx());
        UserDetails userDetails = customUserDetailsService.loadUserByUsername(newUser.getEmail());
        UsernamePasswordAuthenticationToken auth = 
            new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());

        SecurityContextHolder.getContext().setAuthentication(auth);

        // 세션이 변경될 수 있으니, 명시적으로 세션에 SecurityContext 저장
        request.getSession(true).setAttribute("SPRING_SECURITY_CONTEXT", SecurityContextHolder.getContext());
        // 8) 회원가입 성공 시 메인 페이지로 리다이렉트
        session.removeAttribute("socialId");
        session.removeAttribute("authType");
        session.removeAttribute("email");
        return "redirect:/cfMain";
    }
}
