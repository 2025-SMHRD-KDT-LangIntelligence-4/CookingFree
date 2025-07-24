package com.smhrd.web.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.*;
import org.springframework.stereotype.Service;
import com.smhrd.web.mapper.BoardMapper;
import com.smhrd.web.entity.Board;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private BoardMapper boardMapper;

    // 이메일(username)으로 DB에서 사용자 정보 조회 후 UserDetails 객체 반환
    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        System.out.println("loadUserByUsername 호출됨, 이메일 : " + email);
        Board user = boardMapper.selectUserByEmail(email);
        if (user == null) {
            throw new UsernameNotFoundException("사용자 없음: " + email);
        }
        // ...
    
        // Spring Security User 객체 생성: username, 암호화된 password, 권한(예: ROLE_USER)
        return User.builder()
                .username(user.getEmail())
                .password(user.getPw())  // DB는 bcrypt로 암호화된 비밀번호 저장해야 함, SecurityConfig 수정으로 잡아주기
                .roles("USER")
                .build();
    }
}
