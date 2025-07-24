package com.smhrd.web.config;

import org.springframework.context.annotation.*;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.password.NoOpPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import com.smhrd.web.service.CustomUserDetailsService;
import com.smhrd.web.mapper.BoardMapper;
import com.smhrd.web.entity.Board;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.security.oauth2.core.user.OAuth2User;

import java.util.Map;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Autowired
    private CustomUserDetailsService userDetailsService;

    @Autowired
    private BoardMapper boardMapper; // 반드시 주입

    // 정적 리소스 무시 설정
    @Bean
    public WebSecurityCustomizer webSecurityCustomizer() {
        return (web) -> web.ignoring().requestMatchers("/WEB-INF/**");
    }

    // Security Filter Chain 설정
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/", "/cfMain", "/css/**", "/js/**", "/upload/**", "/login", "/oauth2/**", "/cfMyPage/**", "/cfJoinform", "/cfJoinform/**")
                .permitAll()
                .anyRequest().authenticated()
            )
            .formLogin(form -> form
                .loginPage("/login")
                .loginProcessingUrl("/login")
                .defaultSuccessUrl("/cfMain", true)
                .successHandler(customSuccessHandler())
                .failureUrl("/login?error=true")
            )
            .oauth2Login(oauth2 -> oauth2
                .loginPage("/login")
                .successHandler(oAuth2SuccessHandler())
                .failureUrl("/login?error=true")
            );
        return http.build();
    }

    // 로컬 로그인 성공시 alert+cfMain 이동
    @Bean
    public AuthenticationSuccessHandler customSuccessHandler() {
        return (request, response, authentication) -> {
            var userDetails = (org.springframework.security.core.userdetails.User) authentication.getPrincipal();
            String username = userDetails.getUsername();

            // DB에서 nick 조회 (실제로는 아래처럼)
            Board user = boardMapper.selectUserByEmail(username);
            String nick = user != null ? user.getNick() : "";
            String pw = user != null ? user.getPw() : "";

            // alert로 로그인 정보 노출 후 이동
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().write(
                "<script>alert('로그인 성공!\\nID:" + username + "\\nPW:" + pw + "\\nNick:" + nick + "');" +
                "location.href='" + request.getContextPath() + "/cfMain';</script>"
            );
            response.getWriter().flush();
        };
    }

    // 소셜 로그인 성공시 신규면 회원가입 폼, 기존이면 메인으로 이동
    @Bean
    public AuthenticationSuccessHandler oAuth2SuccessHandler() {
        return (request, response, authentication) -> {
            // OAuth2 인증객체에서 provider/email/socialId 추출
            if (authentication instanceof OAuth2AuthenticationToken oauthToken) {
                String provider = oauthToken.getAuthorizedClientRegistrationId(); // google/naver/kakao
                OAuth2User oauth2User = oauthToken.getPrincipal();
                Map<String, Object> attributes = oauth2User.getAttributes();

                String email = null;
                String socialId = null;

                if ("google".equals(provider)) {
                    email = (String) attributes.get("email");
                    socialId = (String) attributes.get("sub");
                } else if ("naver".equals(provider)) {
                    Map<String, Object> res = (Map<String, Object>) attributes.get("response");
                    if (res != null) {
                        email = (String) res.get("email");
                        socialId = (String) res.get("id");
                    }
                } else if ("kakao".equals(provider)) {
                    Object idObj = attributes.get("id");
                    Map<String, Object> account = (Map<String, Object>) attributes.get("kakao_account");
                    email = account != null ? (String) account.get("email") : null;
                    socialId = idObj != null ? idObj.toString() : null;
                }

                // DB에서 소셜ID+provider로 회원 여부 체크 (이 부분 구현 필수!)
                Board existingUser = boardMapper.selectUserBySocialId(socialId, provider);
                boolean isNewUser = (existingUser == null);

                if (isNewUser) {
                    // 신규 회원이면 회원가입 폼으로 이동
                    response.sendRedirect(request.getContextPath() + "/cfJoinform");
                } else {
                    // 기존 회원이면 메인 페이지로 이동
                    response.sendRedirect(request.getContextPath() + "/cfMain");
                }
            } else {
                // 예외 상황: 그냥 메인으로
                response.sendRedirect(request.getContextPath() + "/cfMain");
            }
        };
    }

    @Bean
    public AuthenticationManager authManager(HttpSecurity http) throws Exception {
        return http.getSharedObject(AuthenticationManagerBuilder.class)
                .userDetailsService(userDetailsService)
                .passwordEncoder(passwordEncoder())
                .and()
                .build();
    }

    @Bean
    @SuppressWarnings("deprecation")
    public PasswordEncoder passwordEncoder() {
        return NoOpPasswordEncoder.getInstance(); // 테스트용: 평문비번 허용
    }
}
