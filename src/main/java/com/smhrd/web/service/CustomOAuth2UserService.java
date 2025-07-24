package com.smhrd.web.service;

import java.sql.Timestamp;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.oauth2.client.userinfo.*;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.*;
import org.springframework.security.oauth2.core.user.*;
import org.springframework.stereotype.Service;

import com.smhrd.web.mapper.BoardMapper;
import com.smhrd.web.entity.Board;

@Service
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    @Autowired
    private BoardMapper boardMapper;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        OAuth2User oAuth2User = super.loadUser(userRequest);

        // 전체 attributes 로그 찍기 (디버깅용, 배포시 로그 레벨 조절 or 제거)
        System.out.println("OAuth2User attributes: " + oAuth2User.getAttributes());

        Map<String, Object> attributes = oAuth2User.getAttributes();

        String provider = userRequest.getClientRegistration().getRegistrationId(); // google, naver, kakao
        String socialId = null;
        String email = null;

        // provider 별로 id 와 email 파싱
        if ("google".equals(provider)) {
            socialId = (String) attributes.get("sub");          // 구글 고유 id
            email = (String) attributes.get("email");           // 구글 이메일
        } else if ("naver".equals(provider)) {
            Map<String, Object> response = (Map<String, Object>) attributes.get("response");
            if(response != null) {
                socialId = (String) response.get("id");          // 네이버 고유 id
                email = (String) response.get("email");          // 네이버 이메일
            }
        } else if ("kakao".equals(provider)) {
            socialId = String.valueOf(attributes.get("id"));    // 카카오 고유 id
            Object kakaoAccountObj = attributes.get("kakao_account");
            if (kakaoAccountObj instanceof Map) {
                Map<String, Object> kakaoAccount = (Map<String, Object>) kakaoAccountObj;
                email = (String) kakaoAccount.get("email");     // 카카오 이메일, 없을 수도 있음
            }
        } else {
            throw new OAuth2AuthenticationException(new OAuth2Error("unsupported_provider", "지원하지 않는 OAuth2 공급자입니다.", ""));
        }

        // socialId 없으면 예외 처리 (필수)
        if (socialId == null) {
            throw new OAuth2AuthenticationException(new OAuth2Error("invalid_token", "소셜 로그인 정보에서 ID를 받아오지 못했습니다.", ""));
        }

        // DB에서 해당 소셜아이디+provider로 사용자 조회
        Board existingUser = boardMapper.selectUserBySocialId(socialId, provider);

        if (existingUser == null) {
            // 신규 사용자라면 DB에 저장 (비밀번호는 빈 값 처리)
            Board newUser = Board.builder()
                    .email(email != null ? email : "")  // email 없으면 빈 문자열
                    .pw("")                            // 소셜로그인은 패스워드 빈 값
                    .nick("소셜 회원")                   // 초깃값 닉네임 (필요시 변경 UI 제공)
                    .auth_type(provider)
                    .social_id(socialId)
                    .alg_code("")
                    .prefer_taste("")
                    .cooking_skill("")
                    .joined_at(new Timestamp(System.currentTimeMillis()))
                    .build();

            boardMapper.insertSocialUser(newUser);

            // 신규 회원 가입 폼 페이지로 유도하는 로직은 별도의 SuccessHandler에서 처리 추천

        } else {
            // 기존 사용자는 필요 시 DB 정보로 nickname 등 갱신 가능
        }

        return oAuth2User;
    }
}
