package com.smhrd.web.config;

import org.springframework.context.annotation.*;
import org.springframework.security.authentication.*;
import org.springframework.security.config.annotation.authentication.builders.*;
import org.springframework.security.config.annotation.web.configuration.*;
import org.springframework.security.crypto.password.NoOpPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import com.smhrd.web.service.CustomUserDetailsService;
import org.springframework.beans.factory.annotation.Autowired;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Autowired
    private CustomUserDetailsService userDetailsService;
    @Bean
    public WebSecurityCustomizer webSecurityCustomizer() {
        return (web) -> web.ignoring()
                .requestMatchers("/WEB-INF/**");
    }
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/", "/cfMain", "/css/**", "/js/**", "/upload/**", "/login", "/oauth2/**","/cfMyPage/**", "/cfJoinform/**")
                        .permitAll()   // 인증 없이 접근 허용
                        .anyRequest().authenticated()  // 나머지는 인증 필수
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
                        .defaultSuccessUrl("/cfMain", true)
                );





        return http.build();
    }
    @Bean
    public AuthenticationSuccessHandler customSuccessHandler() {
        return (request, response, authentication) -> {
            // 로그인한 UserDetails 꺼내기
            var userDetails = (org.springframework.security.core.userdetails.User) authentication.getPrincipal();
            String username = userDetails.getUsername();

            // DB에서 nick 조회 (매퍼 호출 필요)
            // 여기서 간단 예를 들어 세션에 nick을 넣는 로직을 추가하거나
            // 직접 DB 매퍼 호출 가능 (빈 주입 필요)

            // 임시 nick 설정
            String nick = "001"; // 이 부분을 DB 조회 결과로 바꾸세요
            String pw = userDetails.getPassword();

            // 자바스크립트 alert 띄우고 cfMain으로 이동
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().write("<script>alert('로그인 성공!\\nID:"+username+"\\nPW:"+pw+"\\nNick:"+nick+"'); location.href='"+request.getContextPath()+"/cfMain';</script>");
            response.getWriter().flush();
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

    @SuppressWarnings("deprecation")
	@Bean
    public PasswordEncoder passwordEncoder() {
    	  return NoOpPasswordEncoder.getInstance(); //이걸 해주면 패스워드 암호화 없이 평문으로 사용하겠다는것. 테스트용이라 씀
    }
}
