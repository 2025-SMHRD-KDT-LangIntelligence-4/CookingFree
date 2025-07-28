package com.smhrd.web;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;

import com.smhrd.web.config.ChatbotProperties;

@SpringBootApplication
@EnableConfigurationProperties(ChatbotProperties.class)
@MapperScan("com.smhrd.web.mapper")
public class CookingFreeApplication {

	public static void main(String[] args) {
		SpringApplication.run(CookingFreeApplication.class, args);
	}

}
