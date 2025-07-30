package com.smhrd.web.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import jakarta.annotation.PostConstruct;

import java.io.File;

@Component
public class UploadFolderInitializer {

	@Value("${spring.servlet.multipart.location:}")
    private String multipartLocation;

    @Value("${app.upload.base-dir}")
    private String uploadDir;
    
    // 리뷰 이미지 디렉토리 추가
    @Value("${app.upload.review-dir:src/main/webapp/upload/reviews}")
    private String reviewUploadDir;

    @PostConstruct
    public void init() {
        // 기존 multipart temp 폴더 초기화
        if (multipartLocation == null || multipartLocation.trim().isEmpty()) {
            System.out.println("Multipart temp folder location is empty - OS temp dir will be used");
        } else {
            File multipartTempDir = new File(multipartLocation);
            if (!multipartTempDir.exists()) {
                if (multipartTempDir.mkdirs()) {
                    System.out.println("Multipart temp folder 생성: " + multipartTempDir.getAbsolutePath());
                } else {
                    System.err.println("Multipart temp folder 생성 실패: " + multipartTempDir.getAbsolutePath());
                }
            } else {
                System.out.println("Multipart temp folder 존재: " + multipartTempDir.getAbsolutePath());
            }
        }

        // 기존 프로필 업로드 폴더 초기화
        File uploadPath = new File(uploadDir);
        if (!uploadPath.exists()) {
            if (uploadPath.mkdirs()) {
                System.out.println("Upload 폴더 생성: " + uploadPath.getAbsolutePath());
            } else {
                System.err.println("Upload 폴더 생성 실패: " + uploadPath.getAbsolutePath());
            }
        } else {
            System.out.println("Upload 폴더 존재: " + uploadPath.getAbsolutePath());
        }
        
        // 리뷰 이미지 업로드 폴더 초기화
        File reviewUploadPath = new File(reviewUploadDir);
        if (!reviewUploadPath.exists()) {
            if (reviewUploadPath.mkdirs()) {
                System.out.println("Review Upload 폴더 생성: " + reviewUploadPath.getAbsolutePath());
            } else {
                System.err.println("Review Upload 폴더 생성 실패: " + reviewUploadPath.getAbsolutePath());
            }
        } else {
            System.out.println("Review Upload 폴더 존재: " + reviewUploadPath.getAbsolutePath());
        }
    }
}
