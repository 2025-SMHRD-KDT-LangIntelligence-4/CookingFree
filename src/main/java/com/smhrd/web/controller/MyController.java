package com.smhrd.web.controller;
import org.springframework.util.StringUtils;

import java.util.Date;
import java.text.SimpleDateFormat;
import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.smhrd.web.entity.Board;
import com.smhrd.web.mapper.BoardMapper;

import jakarta.servlet.http.HttpSession;

@Controller
public class MyController {

    @Autowired
    BoardMapper mapper;

    @Autowired
    private BoardMapper boardMapper;

    @Value("${spring.servlet.multipart.location:}")
    private String multipartLocation;

    private Logger logger = LoggerFactory.getLogger(getClass());

    @Value("${app.upload.base-dir}")
    private String uploadDir;      // physical path

    @Value("${server.servlet.context-path}")
    private String contextPath;    // “/web”

    // OpenAI API 사용 가능 여부 추적
    private boolean openAIAvailable = true;
    private LocalDateTime lastApiCallTime = LocalDateTime.now();

    // ================== 기존 페이지 매핑 (유지) ==================



    @GetMapping({ "/", "/cfMain" })
    public String mainPage(Model model) {
        // 조회수 기준 상위 레시피 3개 조회
        List<Board> hotRecipes = boardMapper.getTopRecipesByViewCount(3);
        model.addAttribute("hotRecipes", hotRecipes);

        logger.info("메인 페이지 - HOT 레시피 개수: {}", hotRecipes.size());
        return "cfMain";
    }

    @GetMapping("/login")
    public String loginPage() {
        return "cfLogin";
    }

    @GetMapping("/cfSearchRecipe")
    public String cfSearchRecipe() {
        return "cfSearchRecipe";
    }

    @GetMapping("/cfRecipeinsert")
    public String cfRecipeinsert() {
        return "cfRecipeinsert";
    }
    @GetMapping("/cfReview")
    public String cfReview() {
        return "cfReview";
    }

    @GetMapping("/cfRecipe")
    public String cfRecipe() {
        return "cfRecipe";
    }
    // recipe_idx 파라미터를 받아서 모델에 실어주는 핸들러 추가
    @GetMapping(value = "/cfRecipe", params = "recipe_idx")
    public String cfRecipeWithIdx(
            @RequestParam("recipe_idx") Integer recipe_idx,
            Model model) {
        // 1) 레시피 기본 정보
        Board recipe = boardMapper.getRecipeDetailWithViewCount(recipe_idx);
        model.addAttribute("recipe", recipe);

        // 2) 조리 단계 정보 (cf_recipe_detail 테이블)
        List<Board> steps = boardMapper.getRecipeSteps(recipe_idx);
        model.addAttribute("steps", steps);

        return "cfRecipe";
    }

    @GetMapping({"/recipe/detail/{recipeIdx}", "/recipe/detail"})
    public String recipeDetail(
            @PathVariable(value = "recipeIdx", required = false) Integer pathIdx,
            @RequestParam(value = "recipe_idx", required = false) Integer queryIdx,
            @RequestParam(defaultValue = "1") int page,
            HttpSession session,
            Model model) {

        // PathVariable 값이 우선, 없으면 queryParam 사용
        Integer recipeId = (pathIdx != null ? pathIdx : queryIdx);
        if (recipeId == null) {
            return "redirect:/cfRecipeIndex";
        }

        // 조회수 증가 (세션 중복 방지)
        String viewKey = "recipe_view_" + recipeId;
        if (session.getAttribute(viewKey) == null) {
            boardMapper.updateRecipeViewCount(recipeId);
            session.setAttribute(viewKey, true);
            session.setMaxInactiveInterval(24 * 60 * 60);
        }

        // 레시피 상세 정보 조회
        Board recipe = boardMapper.getRecipeDetailWithViewCount(recipeId);
        if (recipe == null) {
            return "redirect:/cfRecipeIndex";
        }

        // 리뷰 페이징 처리
        int pageSize = 10;
        int totalReviews = boardMapper.getRecipeReviewCount(recipeId);
        int totalPages = (totalReviews + pageSize - 1) / pageSize;
        int offset = (page - 1) * pageSize;
        List<Board> reviews = boardMapper.getRecipeReviews(recipeId, pageSize, offset);

        // 모델에 데이터 바인딩
        model.addAttribute("recipe", recipe);
        model.addAttribute("reviews", reviews);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalReviews", totalReviews);
        model.addAttribute("currentUserIdx", session.getAttribute("user_idx"));

        return "cfRecipeDetail";
    }



    // ─────────────────────────────────────────────────────────────────
    // 마이페이지 조회
    @GetMapping("/cfMyPage")
    public String showMyPage(HttpSession session, Model model) {
        Integer userIdx = (Integer) session.getAttribute("user_idx");
        if (userIdx == null) {
            return "redirect:/login";
        }
        Board user = boardMapper.selectUserByIdx(userIdx);
        model.addAttribute("user", user);
        return "cfMyPage";
    }

    // 마이페이지 수정 폼
    @GetMapping("/cfMyPageUpdate")
    public String editMyPage(HttpSession session, Model model) {
        Integer userIdx = (Integer) session.getAttribute("user_idx");
        if (userIdx == null) {
            return "redirect:/login";
        }
        Board user = boardMapper.selectUserByIdx(userIdx);
        model.addAttribute("user", user);
        return "cfMyPageUpdate";
    }


    @PostMapping("/mypageUpdate")
    public String updateUserInfo(
            @ModelAttribute Board updatedUser,
            @RequestParam(name = "profileImgFile", required = false) MultipartFile profileImgFile,
            HttpSession session) throws IOException {

        System.out.println("Working directory(user.dir): " + System.getProperty("user.dir"));
        System.out.println("uploadDir (원본): " + uploadDir);
        System.out.println("uploadDir 절대경로: " + new File(uploadDir).getAbsolutePath());

        Integer userIdx = (Integer) session.getAttribute("user_idx");
        if (userIdx == null) {
            return "redirect:/login";
        }

        File uploadPath = new File(uploadDir).getAbsoluteFile();
        if (!uploadPath.exists()) {
            if (!uploadPath.mkdirs()) {
                throw new IOException("업로드 디렉토리 생성 실패: " + uploadPath.getAbsolutePath());
            }
        }

        if (profileImgFile != null && !profileImgFile.isEmpty()) {
            String ext = org.springframework.util.StringUtils.getFilenameExtension(profileImgFile.getOriginalFilename());
            String filename = java.util.UUID.randomUUID().toString() + (ext != null ? "." + ext : "");
            File dest = new File(uploadPath, filename);

            System.out.println("파일 저장 위치 (절대경로): " + dest.getAbsolutePath());

            profileImgFile.transferTo(dest);

            // 웹에서 접근 가능한 이미지 URL (컨텍스트 경로 포함)
            String imgUrl = contextPath + "/upload/profile/" + filename;
            updatedUser.setProfile_img(imgUrl);
        }

        updatedUser.setUser_idx(userIdx);
        boardMapper.updateUserInfo(updatedUser);

        return "redirect:/cfMyPage";
    }




    @GetMapping("/cfRecipeIndex")
    public String cfRecipeIndex(Model model) {
        // 조회수 기준으로 정렬된 레시피 목록 조회
        List<Board> recipeList = boardMapper.getRecipesSortedByViewCount(20);
        model.addAttribute("recipeList", recipeList);
        return "cfRecipeIndex";
    }

    @PostMapping("/searchRecipe")
    public String searchRecipe(@RequestParam("searchText") String keyword, Model model) {
        // 알레르기 제외 검색(필요시 allergyIds 구하기)
        List<Integer> allergyIds = Collections.emptyList();
        // 키워드+알레르기 제외 레시피 조회
        List<Board> results = boardMapper.searchAllergyFreeRecipes(keyword, allergyIds, 50);
        model.addAttribute("searchResults", results);
        model.addAttribute("searchText", keyword);
        return "cfSearchRecipe";  // 같은 JSP에서 결과 렌더링
    }





    // ================== 리뷰 시스템 ==================

    @PostMapping("/recipe/review/add")
    @ResponseBody
    public Map<String, Object> addReview(
            @RequestParam("recipe_idx") Integer recipe_idx,
            @RequestParam("cmt_content") String cmt_content,
            @RequestParam("rating") Integer rating,
            HttpSession session) {
        Integer userIdx = (Integer) session.getAttribute("user_idx");
        boardMapper.insertReview(recipe_idx, userIdx, cmt_content, rating);
        Board user = boardMapper.selectUserByIdx(userIdx);

        Map<String, Object> res = new HashMap<>();
        res.put("success", true);
        res.put("nick", user.getNick());
        res.put("created_at", new SimpleDateFormat("yyyy-MM-dd HH:mm").format(new Date()));
        res.put("cmt_content", cmt_content);
        res.put("rating", rating);
        return res;
    }

//
//    @PostMapping("/recipe/review/add")
//    @ResponseBody
//    public Map<String, Object> addRecipeReview(@RequestParam Integer recipeIdx,
//                                              @RequestParam String cmtContent,
//                                              @RequestParam(required = false) Integer superIdx,
//                                              HttpSession session) {
//
//        Map<String, Object> response = new HashMap<>();
//
//        try {
//            Integer userIdx = (Integer) session.getAttribute("user_idx");
//            if (userIdx == null) {
//                response.put("success", false);
//                response.put("message", "로그인이 필요합니다.");
//                return response;
//            }
//
//            if (cmtContent == null || cmtContent.trim().isEmpty()) {
//                response.put("success", false);
//                response.put("message", "리뷰 내용을 입력해주세요.");
//                return response;
//            }
//
//            // 리뷰 저장
//            boardMapper.insertRecipeReview(recipeIdx, userIdx, cmtContent.trim(), superIdx);
//
//            response.put("success", true);
//            response.put("message", "리뷰가 등록되었습니다.");
//            logger.info("리뷰 등록: recipeIdx={}, userIdx={}", recipeIdx, userIdx);
//
//        } catch (Exception e) {
//            logger.error("리뷰 등록 중 오류 발생", e);
//            response.put("success", false);
//            response.put("message", "리뷰 등록 중 오류가 발생했습니다.");
//        }
//
//        return response;
//    }
//
//    @PostMapping("/recipe/review/delete")
//    @ResponseBody
//    public Map<String, Object> deleteRecipeReview(@RequestParam Integer reviewIdx,
//                                                 HttpSession session) {
//
//        Map<String, Object> response = new HashMap<>();
//
//        try {
//            Integer userIdx = (Integer) session.getAttribute("user_idx");
//            if (userIdx == null) {
//                response.put("success", false);
//                response.put("message", "로그인이 필요합니다.");
//                return response;
//            }
//
//            // 리뷰 삭제 (작성자만 삭제 가능)
//            int deletedRows = boardMapper.deleteRecipeReview(reviewIdx, userIdx);
//
//            if (deletedRows > 0) {
//                response.put("success", true);
//                response.put("message", "리뷰가 삭제되었습니다.");
//                logger.info("리뷰 삭제: reviewIdx={}, userIdx={}", reviewIdx, userIdx);
//            } else {
//                response.put("success", false);
//                response.put("message", "삭제 권한이 없거나 존재하지 않는 리뷰입니다.");
//            }
//
//        } catch (Exception e) {
//            logger.error("리뷰 삭제 중 오류 발생", e);
//            response.put("success", false);
//            response.put("message", "리뷰 삭제 중 오류가 발생했습니다.");
//        }
//
//        return response;
//    }
//
//    @PostMapping("/recipe/review/update")
//    @ResponseBody
//    public Map<String, Object> updateRecipeReview(@RequestParam Integer reviewIdx,
//                                                 @RequestParam String cmtContent,
//                                                 HttpSession session) {
//
//        Map<String, Object> response = new HashMap<>();
//
//        try {
//            Integer userIdx = (Integer) session.getAttribute("user_idx");
//            if (userIdx == null) {
//                response.put("success", false);
//                response.put("message", "로그인이 필요합니다.");
//                return response;
//            }
//
//            if (cmtContent == null || cmtContent.trim().isEmpty()) {
//                response.put("success", false);
//                response.put("message", "리뷰 내용을 입력해주세요.");
//                return response;
//            }
//
//            // 리뷰 수정 (작성자만 수정 가능)
//            int updatedRows = boardMapper.updateRecipeReview(reviewIdx, userIdx, cmtContent.trim());
//
//            if (updatedRows > 0) {
//                response.put("success", true);
//                response.put("message", "리뷰가 수정되었습니다.");
//                logger.info("리뷰 수정: reviewIdx={}, userIdx={}", reviewIdx, userIdx);
//            } else {
//                response.put("success", false);
//                response.put("message", "수정 권한이 없거나 존재하지 않는 리뷰입니다.");
//            }
//
//        } catch (Exception e) {
//            logger.error("리뷰 수정 중 오류 발생", e);
//            response.put("success", false);
//            response.put("message", "리뷰 수정 중 오류가 발생했습니다.");
//        }
//
//        return response;
//    }

    // ================== 챗봇 기능 ==================


}
