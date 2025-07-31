package com.smhrd.web.controller;
import org.springframework.util.StringUtils;

import java.util.Date;
import java.text.SimpleDateFormat;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
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
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
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
import jakarta.servlet.http.HttpServletRequest;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Controller
public class MyController {

    @Autowired
    BoardMapper mapper;

    @Autowired
    private BoardMapper boardMapper;

    @Value("${spring.servlet.multipart.location:}")
    private String multipartLocation;

    private Logger logger = LoggerFactory.getLogger(getClass());
    
    
    @Value("${server.servlet.context-path}")
    private String contextPath;    // “/web”
    
    @Value("${app.upload.profile-dir}")
    private String profileSubDir;

    @Value("${app.upload.review-dir}")
    private String reviewSubDir;
    
    @Value("${app.upload.base-dir}")
    private String uploadBaseDir;            // "src/main/webapp/upload"


    // OpenAI API 사용 가능 여부 추적
    private boolean openAIAvailable = true;
    private LocalDateTime lastApiCallTime = LocalDateTime.now();

    // ================== 기존 페이지 매핑 (유지) ==================



    @GetMapping({ "/", "/cfMain" })
    public String mainPage(Model model, HttpServletRequest request, HttpSession session) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        logger.debug("[cfMain] Session ID: {}", session != null ? session.getId() : "null");
        logger.debug("[cfMain] Authentication: {}, authenticated={}", auth,
            auth != null ? auth.isAuthenticated() : "null");

        // 1) 모든 알러지 키워드 조회
        List<String> allergyKeywords = boardMapper.selectAllAllergyKeywords();

        // 2) 조회수 기준 상위 레시피 3개 조회
        List<Board> hotRecipes = boardMapper.getTopRecipesByViewCount(3);

        // 3) 알러지 키워드 필터링
        List<Board> filtered = hotRecipes.stream()
            .filter(r -> allergyKeywords.stream().noneMatch(kw ->
                (r.getRecipe_name() != null && r.getRecipe_name().contains(kw)) ||
                (r.getRecipe_desc() != null && r.getRecipe_desc().contains(kw)) ||
                (r.getTags()        != null && r.getTags().contains(kw))
            ))
            .collect(Collectors.toList());

        model.addAttribute("hotRecipes", filtered);
        logger.info("메인 페이지 - 필터링 후 HOT 레시피 개수: {}", filtered.size());
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
        
        // 3) 재료 추가
        List<Board> ingredients = boardMapper.getRecipeIngredients(recipe_idx);
        model.addAttribute("ingredients", ingredients);

        return "cfRecipe";
    }

    @GetMapping("/recipe/detail/{recipeIdx}")
    public String recipeDetail(
            @PathVariable Integer recipeIdx,
            @RequestParam(defaultValue = "1") int page,
            HttpSession session,
            Model model) {

        // 조회수 증가 (세션 중복 방지)
        String viewKey = "recipe_view_" + recipeIdx;
        if (session.getAttribute(viewKey) == null) {
            boardMapper.updateRecipeViewCount(recipeIdx);
            session.setAttribute(viewKey, true);
            session.setMaxInactiveInterval(24 * 60 * 60);
        }

        // 레시피 상세 정보 조회
        Board recipe = boardMapper.getRecipeDetailWithViewCount(recipeIdx);
        if (recipe == null) {
            return "redirect:/cfRecipeIndex";
        }

        // 리뷰 페이징 처리
        int pageSize = 10;
        int totalReviews = boardMapper.getRecipeReviewCount(recipeIdx);
        int totalPages = (totalReviews + pageSize - 1) / pageSize;
        int offset = (page - 1) * pageSize;
        List<Board> reviews = boardMapper.getRecipeReviews(recipeIdx, pageSize, offset);

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

    
    // 공통 파일 저장 메서드
    private String saveFile(MultipartFile file, String subDir) throws IOException {
        // 1) 프로젝트 루트 경로
        String projectRoot = System.getProperty("user.dir");
        File dir = new File(projectRoot, subDir);
        if (!dir.exists() && !dir.mkdirs()) {
            throw new IOException("업로드 디렉터리 생성 실패: " + dir.getAbsolutePath());
        }
        // 2) 파일명 랜덤 생성
        String ext = StringUtils.getFilenameExtension(file.getOriginalFilename());
        String newName = UUID.randomUUID().toString() + (ext != null ? "." + ext : "");
        // 3) 실제 쓰기
        File dest = new File(dir, newName);
        file.transferTo(dest);
        // 4) 클라이언트에서 사용할 상대 URL
        //    예: /upload/profile/xxxxx.png 또는 /upload/reviews/yyyy.jpg
        String folder = new File(subDir).getName();
        return "/upload/" + folder + "/" + newName;
    }

    @PostMapping("/mypageUpdate")
    public String updateUserInfo(
            @ModelAttribute Board updatedUser,
            @RequestParam(name = "profileImgFile", required = false) MultipartFile profileImgFile,
            HttpSession session) throws IOException {

        Integer userIdx = (Integer) session.getAttribute("user_idx");
        if (userIdx == null) {
            return "redirect:/login";
        }

        // 1) 기존 사용자 정보 조회
        Board existingUser = boardMapper.selectUserByIdx(userIdx);

        // 2) 새 파일 업로드 여부 판단
        if (profileImgFile != null && !profileImgFile.isEmpty()) {
            // 새 이미지 저장
            String imgUrl = saveFile(profileImgFile, profileSubDir);
            updatedUser.setProfile_img(imgUrl);
        } else {
            // 파일 미선택 시 기존 이미지 유지
            updatedUser.setProfile_img(existingUser.getProfile_img());
        }

        updatedUser.setUser_idx(userIdx);
        boardMapper.updateUserInfo(updatedUser);
        return "redirect:/cfMyPage";
    }




    @GetMapping("/cfRecipeIndex")
    public String cfRecipeIndex(Model model, HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        Integer userIdx = (session != null) ? (Integer) session.getAttribute("user_idx") : null;

        // final 혹은 effectively final 키워드 리스트 선언
        final List<String> keywords;
        if (userIdx != null) {
            List<Integer> allergyIdxs = boardMapper.getUserAllergyIdxs(userIdx);
            keywords = boardMapper.selectKeywordsByAlergyIdxs(allergyIdxs);
        } else {
            keywords = Collections.emptyList();
        }

        List<Board> recipes = boardMapper.getRecipesSortedByViewCount(20);

        // 람다에서 참조할 때 keywords 가 변경되지 않으므로 effectively final
        List<Board> filtered = keywords.isEmpty()
            ? recipes
            : recipes.stream()
                .filter(r -> keywords.stream().noneMatch(kw ->
                    (r.getRecipe_name() != null && r.getRecipe_name().contains(kw)) ||
                    (r.getRecipe_desc() != null && r.getRecipe_desc().contains(kw)) ||
                    (r.getTags()        != null && r.getTags().contains(kw))
                ))
                .collect(Collectors.toList());

        model.addAttribute("recipeList", filtered);
        return "cfRecipeIndex";
    }

    @PostMapping("/searchRecipe")
    public String searchRecipe(
            @RequestParam("searchText") String keyword,
            HttpServletRequest request,
            Model model) {

        // 1) 세션에서 사용자 식별자 가져오기
        HttpSession session = request.getSession(false);
        Integer userIdx = (session != null) ? (Integer) session.getAttribute("user_idx") : null;

        // 2) final 키워드 리스트 선언 및 초기화
        final List<String> keywords;
        if (userIdx != null) {
            List<Integer> allergyIdxs = boardMapper.getUserAllergyIdxs(userIdx);
            keywords = boardMapper.selectKeywordsByAlergyIdxs(allergyIdxs);
        } else {
            keywords = Collections.emptyList();
        }

        // 3) 키워드 기반 레시피 검색
        List<Board> results = boardMapper.searchAllergyFreeRecipes(keyword, Collections.emptyList(), 50);

        // 4) 알러지 키워드가 있을 때만 필터링
        List<Board> filtered = keywords.isEmpty()
            ? results
            : results.stream()
                .filter(r -> keywords.stream().noneMatch(kw ->
                    (r.getRecipe_name() != null && r.getRecipe_name().contains(kw)) ||
                    (r.getRecipe_desc() != null && r.getRecipe_desc().contains(kw)) ||
                    (r.getTags()        != null && r.getTags().contains(kw))
                ))
                .collect(Collectors.toList());

        // 5) 모델에 결과 바인딩
        model.addAttribute("searchResults", filtered);
        model.addAttribute("searchText", keyword);
        return "cfSearchRecipe";
    }






    // ================== 리뷰 시스템 ==================

    // --------------------------------------------------
    //  리뷰 작성 (이미지 포함, AJAX)
    // --------------------------------------------------
    @PostMapping("/cfReview/addReview")
    @ResponseBody
    public Map<String, Object> addCookingReview(
            @RequestParam("recipe_idx") Integer recipeIdx,
            @RequestParam("content") String content,
            @RequestParam(value = "image", required = false) MultipartFile image,
            HttpSession session) throws IOException {

        Map<String, Object> result = new HashMap<>();
        Integer userIdx = (Integer) session.getAttribute("user_idx");
        if (userIdx == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }

        String imagePath = null;
        if (image != null && !image.isEmpty()) {
            // saveFile 호출 시 subDir에 reviewSubDir 사용
            imagePath = saveFile(image, reviewSubDir);
        }

        boardMapper.insertRecipeReview(recipeIdx, userIdx, content, imagePath, null);
        result.put("success", true);
        result.put("imagePath", imagePath);
        return result;
    }
    
    // cfReview 페이지 매핑
    @GetMapping("/cfReview")
    public String cfReview(
            @RequestParam("recipe_idx") Integer recipeIdx,
            Model model, HttpSession session) {

        Board recipe = boardMapper.getRecipeDetailWithViewCount(recipeIdx);
        List<Board> steps   = boardMapper.getRecipeSteps(recipeIdx);
        List<Board> reviews = boardMapper.getRecipeReviews(recipeIdx, 10, 0);
        Integer userIdx     = (Integer) session.getAttribute("user_idx");

        model.addAttribute("recipe", recipe);
        model.addAttribute("steps", steps);
        model.addAttribute("totalSteps", steps.size());
        model.addAttribute("reviews", reviews);
        model.addAttribute("userIdx", userIdx);
        model.addAttribute("achievementRate", 100);

        return "cfReview";
    }

    
 
   
    
    // 후기 삭제 (기존과 동일)
    @PostMapping("/cfReview/deleteReview")
    @ResponseBody
    public Map<String, Object> deleteCookingReview(
            @RequestParam("review_idx") Integer review_idx,
            HttpSession session) {
        
        Map<String, Object> result = new HashMap<>();
        
        try {
            Integer userIdx = (Integer) session.getAttribute("user_idx");
            if (userIdx == null) {
                result.put("success", false);
                result.put("message", "로그인이 필요합니다.");
                return result;
            }
            
            int deletedRows = boardMapper.deleteRecipeReview(review_idx, userIdx);
            
            if (deletedRows > 0) {
                result.put("success", true);
                result.put("message", "후기가 삭제되었습니다.");
            } else {
                result.put("success", false);
                result.put("message", "삭제 권한이 없거나 후기를 찾을 수 없습니다.");
            }
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "후기 삭제 중 오류가 발생했습니다.");
        }
        
        return result;
    }

    // 타이머 모달창
    @GetMapping("/timer")
    public String timerView(
            @RequestParam(name="duration", required=false, defaultValue="0") int duration,
            Model model
    ) {
        model.addAttribute("duration", duration);
        return "inc/timer";
    }
    
    // 레시피등록
    
    @PostMapping("/cfRecipeinsert")
    public String insertRecipe(
            @RequestParam String title,
            @RequestParam String writer,
            @RequestParam String difficulty,
            @RequestParam Integer servings,
            @RequestParam("image") MultipartFile imageFile,
            @RequestParam String description,
            @RequestParam String ingredients,
            @RequestParam String tags,
            @RequestParam("details") List<String> details,
            @RequestParam(value = "stepImages", required = false) List<MultipartFile> stepImages
    ) throws IOException {

        // 1) 레시피 대표 이미지 저장
        String imgPath = "";
        if (!imageFile.isEmpty()) {
            String filename = System.currentTimeMillis() + "_" + imageFile.getOriginalFilename();
            File dest = new File("src/main/webapp/upload/" + filename);
            imageFile.transferTo(dest);
            imgPath = "/upload/" + filename;
        }

        // 2) 레시피 기본 정보 저장
        Board recipe = Board.builder()
                .recipe_name(title)
                .cook_type(writer)
                .recipe_difficulty(difficulty)
                .servings(servings)
                .recipe_img(imgPath)
                .recipe_desc(description)
                .tags(tags)
                .build();
        boardMapper.insertRecipe(recipe);
        Integer recipeIdx = recipe.getRecipe_idx();

        // 3) 식재료 저장 (기존 로직)

        String[] lines = ingredients.split("\\r?\\n");
        for (String line : lines) {
            String ingreName = line.trim();
            if (ingreName.isEmpty()) continue;
            Integer ingreIdx = boardMapper.getIngreIdxByName(ingreName);
            if (ingreIdx == null) {
                boardMapper.insertIngredient(ingreName);
                ingreIdx = boardMapper.getIngreIdxByName(ingreName);
            }
            boardMapper.insertRecipeInput(recipeIdx, ingreIdx, BigDecimal.ONE);
        }

        // 4) 상세 단계 저장
        if (details != null && !details.isEmpty()) {
            for (int i = 0; i < details.size(); i++) {
                String stepDesc = details.get(i).trim();
                String stepImgPath = "";

                // stepImages가 null이 아니고, 해당 인덱스의 파일이 존재하면 저장
                if (stepImages != null
                        && stepImages.size() > i
                        && stepImages.get(i) != null
                        && !stepImages.get(i).isEmpty()) {

                    MultipartFile stepImgFile = stepImages.get(i);
                    String fname = System.currentTimeMillis() + "_" + stepImgFile.getOriginalFilename();
                    File dst = new File("src/main/webapp/upload/" + fname);
                    stepImgFile.transferTo(dst);
                    stepImgPath = "/upload/" + fname;
                }

                boardMapper.insertRecipeDetail(
                    recipeIdx,
                    i + 1,
                    stepDesc,
                    stepImgPath
                );
            }
        }

        // 5) 등록 완료 후 상세 페이지로 리다이렉트
        return "redirect:/recipe/detail/" + recipeIdx;
    }
}
