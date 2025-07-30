package com.smhrd.web.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.io.File;

@Configuration
public class WebConfig implements WebMvcConfigurer {

	@Value("${app.upload.profile-dir}")
    private String profileSubDir;

    @Value("${app.upload.review-dir}")
    private String reviewSubDir;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        String projectRoot = System.getProperty("user.dir");
        registry.addResourceHandler("/upload/profile/**")
                .addResourceLocations("file:" + projectRoot + "/" + profileSubDir + "/");
        registry.addResourceHandler("/upload/reviews/**")
                .addResourceLocations("file:" + projectRoot + "/" + reviewSubDir + "/");
    }
    
}
