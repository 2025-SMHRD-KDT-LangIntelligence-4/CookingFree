package com.smhrd.web.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

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

    // OAuth2 로그인 성공 핸들러 (소셜 로그인 전용)
    @Bean
    public AuthenticationSuccessHandler oAuth2SuccessHandler() {
        return (request, response, authentication) -> {
            System.out.println("[AuthSuccessHandler] OAuth2 로그인 성공: " + authentication.getName());
            SecurityContextHolder.getContext().setAuthentication(authentication);
            HttpSession session = request.getSession();
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

                // 신규 회원인 경우 회원가입 폼으로 이동
                if (existingUser == null) {
                    session.setAttribute("socialId", socialId);
                    session.setAttribute("authType", authType);
                    session.setAttribute("email", email != null ? email : "");

                    System.out.println("[AuthSuccessHandler] 신규 회원정보 세션저장, /cfJoinform으로 리다이렉트");
                    response.sendRedirect(request.getContextPath() + "/cfJoinform");
                    return;
                } else {
                    // 기존 회원이면 user_idx 세션 저장
                    session.setAttribute("user_idx", existingUser.getUser_idx());
                    System.out.println("OAuth2 로그인 성공 후 - sessionId: " + session.getId() + ", user_idx: " + session.getAttribute("user_idx"));

                    System.out.println("[AuthSuccessHandler] 기존 회원, /cfMain으로 리다이렉트");
                    response.sendRedirect(request.getContextPath() + "/cfMain");
                    return;
                }
            }
            response.sendRedirect(request.getContextPath() + "/cfMain");
        };
    }

    // OAuth2 로그인 실패 핸들러
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

    // 커스텀 폼 로그인 성공 핸들러 (로컬 로그인)
    @Bean
    public AuthenticationSuccessHandler customLoginSuccessHandler() {
        return (request, response, authentication) -> {
            String email = authentication.getName();
            Board user = boardMapper.selectUserByEmail(email);
            if (user != null) {
                request.getSession().setAttribute("user_idx", user.getUser_idx());
                System.out.println("로컬 로그인 성공 후 - sessionId: " + request.getSession().getId() +
                        ", user_idx: " + request.getSession().getAttribute("user_idx"));
            }
            response.sendRedirect(request.getContextPath() + "/cfMain");
        };
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/", "/cfMain", "/css/**", "/js/**", "/upload/**", "/login", "/oauth2/**", "/cfMyPage/**", "/cfJoinform/**").permitAll()
                .anyRequest().authenticated()
            )
            .formLogin(form -> form
                .loginPage("/login")
                .loginProcessingUrl("/login")
                .successHandler(customLoginSuccessHandler())
                .failureUrl("/login?error=true")
            )
            .oauth2Login(oauth2 -> oauth2
                .loginPage("/login")
                .successHandler(oAuth2SuccessHandler())
                .failureHandler(oAuth2FailureHandler())
            )
            .logout(logout -> logout
                .logoutUrl("/logout")
                .logoutSuccessUrl("/cfMain")
                .invalidateHttpSession(true)
                .deleteCookies("JSESSIONID")
            )
            .csrf(csrf -> csrf.ignoringRequestMatchers("/cfjoinId"));

        return http.build();
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
        // 실제 개발 시에는 BCryptPasswordEncoder 사용을 권장합니다.
        return NoOpPasswordEncoder.getInstance();
    }
}
