package com.smhrd.web.service;

import java.sql.Timestamp;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.*;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import com.smhrd.web.entity.Board;
import com.smhrd.web.mapper.BoardMapper;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

@Service
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    
    @Autowired
    private BoardMapper boardMapper;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        OAuth2User oAuth2User = super.loadUser(userRequest);

        Map<String, Object> attributes = oAuth2User.getAttributes();
        String provider = userRequest.getClientRegistration().getRegistrationId();

        System.out.println("[OAuth2UserService] provider: " + provider);
        System.out.println("[OAuth2UserService] attributes: " + attributes);

        String socialId = null;
        String email = null;

        if ("google".equals(provider)) {
            socialId = (String) attributes.get("sub");
            email = (String) attributes.get("email");
            if (socialId == null || email == null)
                throw new OAuth2AuthenticationException(new OAuth2Error("missing_user_info"), "구글 사용자 정보 누락");
        } else if ("naver".equals(provider)) {
            Map<String, Object> resp = (Map<String, Object>) attributes.get("response");
            if (resp == null)
                throw new OAuth2AuthenticationException(new OAuth2Error("missing_user_info"), "네이버 사용자 정보 누락");
            socialId = (String) resp.get("id");
            email = (String) resp.get("email");
            if (socialId == null)
                throw new OAuth2AuthenticationException(new OAuth2Error("missing_user_id"), "네이버 사용자 ID 누락");
        } else if ("kakao".equals(provider)) {
            socialId = String.valueOf(attributes.get("id"));
            Object kakaoAccountObj = attributes.get("kakao_account");
            if (kakaoAccountObj instanceof Map) {
                Map<String, Object> kakaoAccount = (Map<String, Object>) kakaoAccountObj;
                email = (String) kakaoAccount.get("email");
            }
            if (socialId == null)
                throw new OAuth2AuthenticationException(new OAuth2Error("missing_user_id"), "카카오 사용자 ID 누락");
        } else {
            throw new OAuth2AuthenticationException(new OAuth2Error("unsupported_provider"), "지원하지 않는 로그인 공급자입니다.");
        }

        // DB에 사용자 존재확인 (auth_type은 G, N, K처럼 한글자)
        String authType = provider.substring(0, 1).toUpperCase();
        Board existingUser = boardMapper.selectUserBySocialId(socialId, authType);

        if (existingUser == null) {
            // 신규 회원은 DB 등록은 성공 핸들러에서 하므로 여기서는 넘어갑니다.1
            System.out.println("[OAuth2UserService] 신규 회원정보 세션저장");
        } else {
            System.out.println("[OAuth2UserService] 기존 회원 로그인 socialId=" + socialId);
        }

        return oAuth2User;
    }
}
