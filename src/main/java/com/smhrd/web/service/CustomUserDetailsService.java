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

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        System.out.println("loadUserByUsername 호출됨, 이메일 : " + email);
        Board user = boardMapper.selectUserByEmail(email);
        if (user == null) {
            throw new UsernameNotFoundException("사용자 없음: " + email);
        }

        // UserDetails 객체 리턴: username, (암호화된) password, 권한
        return User.builder()
                .username(user.getEmail())
                .password(user.getPw())  // password는 암호화된 상태여야 함 (예: bcrypt)
                .roles("USER")
                .build();
    }
}
