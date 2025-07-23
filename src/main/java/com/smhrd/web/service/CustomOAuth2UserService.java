package com.smhrd.web.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.oauth2.client.userinfo.*;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.*;
import org.springframework.security.oauth2.core.user.*;
import org.springframework.stereotype.Service;

import com.smhrd.web.mapper.BoardMapper;
import com.smhrd.web.entity.Board;

import java.sql.Timestamp;

@Service
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    @Autowired
    private BoardMapper boardMapper;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        OAuth2User oAuth2User = super.loadUser(userRequest);

        String provider = userRequest.getClientRegistration().getRegistrationId(); // google/naver/kakao
        Map<String, Object> attributes = oAuth2User.getAttributes();

        String email = null;
        String socialId = null;

        if ("google".equals(provider)) {
            email = (String) attributes.get("email");
            socialId = (String) attributes.get("sub");
        } else if ("naver".equals(provider)) {
            Map<String, Object> response = (Map<String, Object>) attributes.get("response");
            email = (String) response.get("email");
            socialId = (String) response.get("id");
        } else if ("kakao".equals(provider)) {
            Map<String, Object> kakaoAccount = (Map<String, Object>) attributes.get("kakao_account");
            email = (String) kakaoAccount.get("email");
            socialId = String.valueOf(attributes.get("id"));
        }

        Board existingUser = boardMapper.selectUserBySocialId(socialId, provider);

        if (existingUser == null) {
            Board newUser = Board.builder()
                    .email(email)
                    .pw("")  // 소셜 로그인은 비밀번호 비워두기
                    .nick("소셜회원")  // 이후 수정 가능
                    .auth_type(provider)
                    .social_id(socialId)
                    .alg_code("")
                    .prefer_taste("")
                    .cooking_skill("")
                    .joined_at(new Timestamp(System.currentTimeMillis()))
                    .build();

            boardMapper.insertSocialUser(newUser);
        }

        return oAuth2User;
    }
}
