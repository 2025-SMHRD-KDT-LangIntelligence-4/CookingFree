package com.smhrd.web.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import jakarta.annotation.PostConstruct;

import java.io.File;

@Component
public class UploadFolderInitializer {

    @Value("${spring.servlet.multipart.location:}")
    private String multipartLocation; // 빈 값일 수도 있음

    @Value("${app.upload.base-dir}")
    private String uploadDir;

    @PostConstruct
    public void init() {
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
    }
}
