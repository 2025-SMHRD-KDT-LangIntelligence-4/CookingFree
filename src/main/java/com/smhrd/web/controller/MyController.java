package com.smhrd.web.controller;

import com.smhrd.web.entity.Board;
import com.smhrd.web.mapper.BoardMapper;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.util.StringUtils;
import org.springframework.validation.BindingResult;

import jakarta.servlet.http.HttpSession;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Controller
public class MyController {
	
	

    private static final Logger logger = LoggerFactory.getLogger(MyController.class);

    private final BoardMapper boardMapper;

    @Value("${app.upload.base-dir}")
    private String uploadDir;

    @Value("${server.servlet.context-path}")
    private String contextPath;
    @Value("${app.upload.base-dir}")
    private String appUploadBaseDir;
    public MyController(BoardMapper boardMapper) {
        this.boardMapper = boardMapper;
    }

    @GetMapping({"/", "/cfMain"})
    public String cf_main(Model model) {
        List<Board> hot_recipes = boardMapper.getTopRecipesByViewCount(3);
        model.addAttribute("hotRecipes", hot_recipes);
        logger.info("메인 페이지 - HOT 레시피 개수: {}", hot_recipes.size());
        return "cfMain";
    }

    @GetMapping("/login")
    public String cf_login() {
        return "cfLogin";
    }

    @GetMapping("/cfSearchRecipe")
    public String cf_search_recipe() {
        return "cfSearchRecipe";
    }
    @PostMapping("/searchRecipe")
    public String searchRecipe(
            @RequestParam("searchText") String keyword,
            HttpSession session,
            Model model) {
        // 로그인 여부에 따른 알레르기 조회
        Integer userIdx = (Integer) session.getAttribute("user_idx");
        List<Integer> allergyIds = Collections.emptyList();
        if (userIdx != null) {
            Board user = boardMapper.selectUserByIdx(userIdx);
            if (user != null && user.getAlg_code() != null) {
                allergyIds = Arrays.stream(user.getAlg_code().split(","))
                        .filter(s -> s.matches("\\d+"))
                        .map(Integer::parseInt)
                        .toList();
            }
        }

        // Mapper를 통해 알레르기 제외 + 키워드 검색
        List<Board> recipes = boardMapper.searchAllergyFreeRecipes(keyword, allergyIds, 50);

        model.addAttribute("searchResults", recipes);
        model.addAttribute("searchText", keyword);
        return "cfSearchRecipe";
    }


    @GetMapping("/cfRecipeinsert")
    public String cf_recipe_insert() {
        return "cfRecipeinsert";
    }
    @GetMapping("/cfRecipe")
    public String cf_recipe() {
        return "cfRecipe";
    }

    @GetMapping({"/recipe/detail/{recipe_idx}", "/recipe/detail"})
    public String recipe_detail(
            @PathVariable(value = "recipe_idx", required = false) Integer path_idx,
            @RequestParam(value = "recipe_idx", required = false) Integer query_idx,
            @RequestParam(defaultValue = "1") int page,
            HttpSession session,
            Model model) {

        Integer recipe_idx = (path_idx != null) ? path_idx : query_idx;
        if (recipe_idx == null) {
            return "redirect:/cfRecipeIndex";
        }

        String view_key = "recipe_view_" + recipe_idx;
        if (session.getAttribute(view_key) == null) {
            boardMapper.updateRecipeViewCount(recipe_idx);
            session.setAttribute(view_key, true);
            session.setMaxInactiveInterval(24*60*60);
        }

        Board recipe = boardMapper.getRecipeDetailWithViewCount(recipe_idx);
        if (recipe == null) {
            return "redirect:/cfRecipeIndex";
        }

        int page_size = 10;
        int total_reviews = boardMapper.getRecipeReviewCount(recipe_idx);
        int total_pages = (total_reviews + page_size - 1) / page_size;
        int offset = (page - 1) * page_size;
        List<Board> reviews = boardMapper.getRecipeReviews(recipe_idx, page_size, offset);

        model.addAttribute("recipe", recipe);
        model.addAttribute("reviews", reviews);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", total_pages);
        model.addAttribute("totalReviews", total_reviews);
        model.addAttribute("currentUserIdx", session.getAttribute("user_idx"));

        return "cfRecipeDetail";
    }

    @GetMapping("/cfMyPage")
    public String cf_my_page(HttpSession session, Model model) {
        Integer user_idx = (Integer) session.getAttribute("user_idx");
        if (user_idx == null) {
            return "redirect:/login";
        }
        Board user = boardMapper.selectUserByIdx(user_idx);
        model.addAttribute("user", user);
        return "cfMyPage";
    }

    @GetMapping("/cfMyPageUpdate")
    public String cf_my_page_update(HttpSession session, Model model) {
        Integer user_idx = (Integer) session.getAttribute("user_idx");
        if (user_idx == null) {
            return "redirect:/login";
        }
        Board user = boardMapper.selectUserByIdx(user_idx);
        model.addAttribute("user", user);
        return "cfMyPageUpdate";
    }

    @InitBinder
    public void initBinder(WebDataBinder binder) {
        // profile_img 파라미터는 updated_user에 바인딩되지 않도록 설정
        binder.setDisallowedFields("profile_img");
    }

    @PostMapping("/mypageUpdate")
    public String mypage_update(
            @RequestParam(value = "profile_img", required = false) MultipartFile profile_img,
            @ModelAttribute Board updated_user,
            BindingResult bindingResult,
            HttpSession session) throws IOException {

        // 세션 체크
        Integer user_idx = (Integer) session.getAttribute("user_idx");
        if (user_idx == null) {
            return "redirect:/login";
        }

        // 바인딩 오류 체크
        if (bindingResult.hasErrors()) {
            bindingResult.getAllErrors()
                         .forEach(err -> System.out.println("Binding error: " + err));
            return "cfMyPageUpdate";
        }

        // 파일 업로드 처리
        if (profile_img != null && !profile_img.isEmpty()) {
            // 1) 프로젝트 루트 기준으로 상대경로를 절대경로로 변환
            Path projectRoot = Paths.get("").toAbsolutePath();
            Path base = projectRoot.resolve(appUploadBaseDir).normalize();
            File uploadDir = base.toFile();
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // 2) 저장할 파일명 생성
            String ext = StringUtils.getFilenameExtension(profile_img.getOriginalFilename());
            String filename = UUID.randomUUID().toString() + (ext != null && !ext.isEmpty() ? "." + ext : "");

            // 3) 파일 저장
            File dest = base.resolve(filename).toFile();
            profile_img.transferTo(dest);

            // 4) DB에 저장할 URL 세팅
            String contextPath = session.getServletContext().getContextPath();
            updated_user.setProfile_img(contextPath + "/upload/profile/" + filename);

            System.out.println("파일 저장 경로: " + dest.getAbsolutePath());
        }

        // 나머지 필드 처리
        updated_user.setUser_idx(user_idx);
        boardMapper.updateUserInfo(updated_user);

        // 처리 완료 후 홈으로 리다이렉트
        return "redirect:/";
    }


    @GetMapping("/cfRecipeIndex")
    public String cf_recipe_index(Model model) {
        List<Board> recipe_list = boardMapper.getRecipesSortedByViewCount(20);
        model.addAttribute("recipeList", recipe_list);
        return "cfRecipeIndex";
    }

//    @PostMapping("/searchRecipe")
//    public String search_recipe(@RequestParam("searchText") String keyword, Model model) {
//        List<Integer> allergy_ids = java.util.Collections.emptyList();
//        List<Board> results = boardMapper.searchAllergyFreeRecipes(keyword, allergy_ids, 50);
//        model.addAttribute("searchResults", results);
//        model.addAttribute("searchText", keyword);
//        return "cfSearchRecipe";
//    }

    @PostMapping("/recipe/review/add")
    @ResponseBody
    public Map<String,Object> recipe_review_add(
            @RequestParam("recipe_idx") Integer recipe_idx,
            @RequestParam("cmt_content") String cmt_content,
            @RequestParam(value="super_idx", required=false) Integer super_idx,
            HttpSession session) {

        Map<String,Object> response = new java.util.HashMap<>();
        Integer user_idx = (Integer) session.getAttribute("user_idx");
        if (user_idx == null) {
            response.put("success", false);
            response.put("message", "로그인이 필요합니다.");
            return response;
        }
        if (cmt_content == null || cmt_content.trim().isEmpty()) {
            response.put("success", false);
            response.put("message", "리뷰 내용을 입력해주세요.");
            return response;
        }
        boardMapper.insertRecipeReview(recipe_idx, user_idx, cmt_content.trim(), super_idx);
        response.put("success", true);
        response.put("message", "리뷰가 등록되었습니다.");
        logger.info("리뷰 등록: recipe_idx={}, user_idx={}", recipe_idx, user_idx);
        return response;
    }

    @PostMapping("/recipe/review/delete")
    @ResponseBody
    public Map<String,Object> recipe_review_delete(
            @RequestParam("review_idx") Integer review_idx,
            HttpSession session) {

        Map<String,Object> response = new java.util.HashMap<>();
        Integer user_idx = (Integer) session.getAttribute("user_idx");
        if (user_idx == null) {
            response.put("success", false);
            response.put("message", "로그인이 필요합니다.");
            return response;
        }
        int deleted = boardMapper.deleteRecipeReview(review_idx, user_idx);
        if (deleted > 0) {
            response.put("success", true);
            response.put("message", "리뷰가 삭제되었습니다.");
            logger.info("리뷰 삭제: review_idx={}, user_idx={}", review_idx, user_idx);
        } else {
            response.put("success", false);
            response.put("message", "삭제 권한이 없거나 존재하지 않는 리뷰입니다.");
        }
        return response;
    }

    @PostMapping("/recipe/review/update")
    @ResponseBody
    public Map<String,Object> recipe_review_update(
            @RequestParam("review_idx") Integer review_idx,
            @RequestParam("cmt_content") String cmt_content,
            HttpSession session) {

        Map<String,Object> response = new java.util.HashMap<>();
        Integer user_idx = (Integer) session.getAttribute("user_idx");
        if (user_idx == null) {
            response.put("success", false);
            response.put("message", "로그인이 필요합니다.");
            return response;
        }
        if (cmt_content == null || cmt_content.trim().isEmpty()) {
            response.put("success", false);
            response.put("message", "리뷰 내용을 입력해주세요.");
            return response;
        }
        int updated = boardMapper.updateRecipeReview(review_idx, user_idx, cmt_content.trim());
        if (updated > 0) {
            response.put("success", true);
            response.put("message", "리뷰가 수정되었습니다.");
            logger.info("리뷰 수정: review_idx={}, user_idx={}", review_idx, user_idx);
        } else {
            response.put("success", false);
            response.put("message", "수정 권한이 없거나 존재하지 않는 리뷰입니다.");
        }
        return response;
    }
}
