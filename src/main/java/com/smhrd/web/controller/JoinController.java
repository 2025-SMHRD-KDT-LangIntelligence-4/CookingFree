package com.smhrd.web.controller;

import com.smhrd.web.mapper.BoardMapper;
import com.smhrd.web.entity.Board;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.ui.Model;
import java.sql.Timestamp;

@Controller
public class JoinController {
    @Autowired
    private BoardMapper boardMapper;

    @GetMapping("/cfJoinform")
    public String showJoinForm() {
        return "cfJoinform";
    }

    @PostMapping("/cfjoinId")
    public String doJoin(
            @RequestParam("nickname") String nickname,
            @RequestParam("userId") String userId,
            @RequestParam("userPW") String userPW,
            @RequestParam("userAuthType") String userAuthType,
            @RequestParam("userAlgCode") String userAlgCode,
            @RequestParam("userPreferTaste") String userPreferTaste,
            @RequestParam("userCookingSkill") String userCookingSkill,
            Model model
    ) {
        // 중복 이메일(ID) 체크
        Board existUser = boardMapper.selectUserByEmail(userId);
        if (existUser != null) {
            model.addAttribute("msg", "이미 사용중인 이메일(ID)입니다.");
            return "cfJoinform";
        }

        // Lombok Builder로 Board 객체 생성
        Board user = Board.builder()
                .email(userId)
                .pw(userPW)
                .nick(nickname)
                .auth_type(userAuthType)
                .social_id("") // 일반 회원가입
                .alg_code(userAlgCode)
                .prefer_taste(userPreferTaste)
                .cooking_skill(userCookingSkill)
                .joined_at(new Timestamp(System.currentTimeMillis()))
                .build();

        boardMapper.insertSocialUser(user);

        return "redirect:/cfMain";
    }
}
