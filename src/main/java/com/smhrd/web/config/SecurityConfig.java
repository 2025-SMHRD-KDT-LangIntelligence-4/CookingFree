package com.smhrd.web.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.crypto.password.NoOpPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.core.context.SecurityContextHolder;

import com.smhrd.web.entity.Board;
import com.smhrd.web.mapper.BoardMapper;
import com.smhrd.web.service.CustomUserDetailsService;

import java.sql.Timestamp;

import org.springframework.beans.factory.annotation.Autowired;

@Configuration
public class SecurityConfig {

    @Autowired
    private CustomUserDetailsService userDetailsService;

    @Autowired
    private BoardMapper boardMapper;

    @Bean
    public WebSecurityCustomizer webSecurityCustomizer() {
        return (web) -> web.ignoring()
                .requestMatchers("/WEB-INF/**");
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/", "/cfMain", "/css/**", "/js/**", "/upload/**", "/login", "/oauth2/**", "/cfMyPage/**", "/cfJoinform/**").permitAll()
                .anyRequest().authenticated()
            )
            .formLogin(form -> form
                .loginPage("/login").loginProcessingUrl("/login")
                .defaultSuccessUrl("/cfMain", true)
                .failureUrl("/login?error=true")
            )
            .oauth2Login(oauth2 -> oauth2
                .loginPage("/login")
                .successHandler(oAuth2SuccessHandler())
                .failureHandler(oAuth2FailureHandler())
            )
            .csrf(csrf -> csrf.ignoringRequestMatchers("/cfjoinId"));

        return http.build();
    }

    @Bean
    public AuthenticationSuccessHandler oAuth2SuccessHandler() {
        return (request, response, authentication) -> {
            System.out.println("[AuthSuccessHandler] OAuth2 로그인 성공: " + authentication.getName());
            SecurityContextHolder.getContext().setAuthentication(authentication);

            if (authentication instanceof OAuth2AuthenticationToken oauthToken) {
                String provider = oauthToken.getAuthorizedClientRegistrationId();
                var attributes = oauthToken.getPrincipal().getAttributes();

                String socialId = null;
                String email = null;

                if ("google".equals(provider)) {
                    socialId = (String) attributes.get("sub");
                    email = (String) attributes.get("email");
                } else if ("naver".equals(provider)) {
                    var resp = (java.util.Map<String, Object>) attributes.get("response");
                    if (resp != null) {
                        socialId = (String) resp.get("id");
                        email = (String) resp.get("email");
                    }
                } else if ("kakao".equals(provider)) {
                    socialId = String.valueOf(attributes.get("id"));
                    Object kakaoAccountObj = attributes.get("kakao_account");
                    if (kakaoAccountObj instanceof java.util.Map) {
                        var kakaoAccount = (java.util.Map<String, Object>) kakaoAccountObj;
                        email = (String) kakaoAccount.get("email");
                    }
                }

                String authType = provider.substring(0, 1).toUpperCase();

                Board existingUser = boardMapper.selectUserBySocialId(socialId, authType);

                // 신규 회원이면 DB에 insert 하지 말고, 그냥 세션에만 저장하고 회원가입 폼으로 리다이렉트
                if (existingUser == null) {
                    // DB 저장은 회원가입 폼 제출 시점으로 미뤄놓음 (폼에서 가입 최종 완료 시 처리)

                    // 세션에 소셜 로그인 정보만 저장
                    request.getSession().setAttribute("socialId", socialId);
                    request.getSession().setAttribute("authType", authType);
                    request.getSession().setAttribute("email", email != null ? email : "");

                    System.out.println("[AuthSuccessHandler] 신규 회원정보 세션저장, /cfJoinform으로 리다이렉트");
                    response.sendRedirect(request.getContextPath() + "/cfJoinform");
                    return;
                }

                System.out.println("[AuthSuccessHandler] 기존 회원, /cfMain으로 리다이렉트");
                response.sendRedirect(request.getContextPath() + "/cfMain");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/cfMain");
        };
    }

    @Bean
    public AuthenticationFailureHandler oAuth2FailureHandler() {
        return (request, response, exception) -> {
            String msg = exception.getMessage();
            String code = (exception instanceof OAuth2AuthenticationException) ? ((OAuth2AuthenticationException) exception).getError().getErrorCode() : null;

            System.out.println("[AuthFailureHandler] 실패 메시지: " + msg + ", 코드: " + code);

            if ((msg != null && msg.contains("신규 회원")) || "new_user".equals(code)) {
                System.out.println("[AuthFailureHandler] 신규 회원 예외 처리 -> 회원가입 폼 이동");
                response.sendRedirect(request.getContextPath() + "/cfJoinform");
            } else {
                System.out.println("[AuthFailureHandler] 일반 로그인 실패 -> 로그인 페이지 이동");
                response.sendRedirect(request.getContextPath() + "/login?error=true");
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
        return NoOpPasswordEncoder.getInstance();
    }
}
