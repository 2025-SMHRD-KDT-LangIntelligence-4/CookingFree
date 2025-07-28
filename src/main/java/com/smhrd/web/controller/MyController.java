package com.smhrd.web.controller;
import org.springframework.util.StringUtils;

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

    // 마이페이지 업데이트 (프로필 이미지 포함)
    @PostMapping("/mypageUpdate")
    public String updateUserInfo(
            @ModelAttribute Board updatedUser,
            @RequestParam(required = false) MultipartFile profileImgFile,
            HttpSession session) throws IOException {

        Integer userIdx = (Integer) session.getAttribute("user_idx");
        if (userIdx == null) {
            return "redirect:/login";
        }

        // 프로필 이미지 업로드
        if (profileImgFile != null && !profileImgFile.isEmpty()) {
            String ext = StringUtils.getFilenameExtension(profileImgFile.getOriginalFilename());
            String filename = UUID.randomUUID().toString() + (ext != null ? "." + ext : "");
			File dest = new File(uploadDir, filename);
            dest.getParentFile().mkdirs();
            profileImgFile.transferTo(dest);
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
    public Map<String, Object> addRecipeReview(@RequestParam Integer recipeIdx,
                                              @RequestParam String cmtContent,
                                              @RequestParam(required = false) Integer superIdx,
                                              HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            Integer userIdx = (Integer) session.getAttribute("user_idx");
            if (userIdx == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }
            
            if (cmtContent == null || cmtContent.trim().isEmpty()) {
                response.put("success", false);
                response.put("message", "리뷰 내용을 입력해주세요.");
                return response;
            }
            
            // 리뷰 저장
            boardMapper.insertRecipeReview(recipeIdx, userIdx, cmtContent.trim(), superIdx);
            
            response.put("success", true);
            response.put("message", "리뷰가 등록되었습니다.");
            logger.info("리뷰 등록: recipeIdx={}, userIdx={}", recipeIdx, userIdx);
            
        } catch (Exception e) {
            logger.error("리뷰 등록 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "리뷰 등록 중 오류가 발생했습니다.");
        }
        
        return response;
    }

    @PostMapping("/recipe/review/delete")
    @ResponseBody
    public Map<String, Object> deleteRecipeReview(@RequestParam Integer reviewIdx,
                                                 HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            Integer userIdx = (Integer) session.getAttribute("user_idx");
            if (userIdx == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }
            
            // 리뷰 삭제 (작성자만 삭제 가능)
            int deletedRows = boardMapper.deleteRecipeReview(reviewIdx, userIdx);
            
            if (deletedRows > 0) {
                response.put("success", true);
                response.put("message", "리뷰가 삭제되었습니다.");
                logger.info("리뷰 삭제: reviewIdx={}, userIdx={}", reviewIdx, userIdx);
            } else {
                response.put("success", false);
                response.put("message", "삭제 권한이 없거나 존재하지 않는 리뷰입니다.");
            }
            
        } catch (Exception e) {
            logger.error("리뷰 삭제 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "리뷰 삭제 중 오류가 발생했습니다.");
        }
        
        return response;
    }

    @PostMapping("/recipe/review/update")
    @ResponseBody
    public Map<String, Object> updateRecipeReview(@RequestParam Integer reviewIdx,
                                                 @RequestParam String cmtContent,
                                                 HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            Integer userIdx = (Integer) session.getAttribute("user_idx");
            if (userIdx == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }
            
            if (cmtContent == null || cmtContent.trim().isEmpty()) {
                response.put("success", false);
                response.put("message", "리뷰 내용을 입력해주세요.");
                return response;
            }
            
            // 리뷰 수정 (작성자만 수정 가능)
            int updatedRows = boardMapper.updateRecipeReview(reviewIdx, userIdx, cmtContent.trim());
            
            if (updatedRows > 0) {
                response.put("success", true);
                response.put("message", "리뷰가 수정되었습니다.");
                logger.info("리뷰 수정: reviewIdx={}, userIdx={}", reviewIdx, userIdx);
            } else {
                response.put("success", false);
                response.put("message", "수정 권한이 없거나 존재하지 않는 리뷰입니다.");
            }
            
        } catch (Exception e) {
            logger.error("리뷰 수정 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "리뷰 수정 중 오류가 발생했습니다.");
        }
        
        return response;
    }

    // ================== 챗봇 기능 ==================

    @GetMapping("/cfChatbot")
    public String chatbotPage() {
        return "cfChatbot";
    }

    @PostMapping("/chatbot/message")
    @ResponseBody
    public Map<String, Object> processChatbotMessage(
            @RequestParam String message,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        Integer userIdx = (Integer) session.getAttribute("user_idx");
        String sessionId = session.getId();
        
        try {
            // 세션 생성 (최초 대화인 경우)
            ensureChatSession(sessionId, userIdx);
            
            // 사용자 메시지 저장
            saveChatMessage(sessionId, userIdx, "user", message, null, 0);
            
            // 1차: OpenAI API 시도 (사용량 체크)
            if (openAIAvailable && canUseOpenAI()) {
                response = processWithOpenAI(message, userIdx, sessionId);
            } 
            // 2차: 저장된 대화 데이터 기반 응답
            else if (hasStoredConversations(userIdx)) {
                response = processWithStoredData(message, userIdx, sessionId);
            } 
            // 3차: 규칙 기반 응답
            else {
                response = processWithRuleBase(message, userIdx, sessionId);
            }
            
            logger.info("챗봇 메시지 처리: userIdx={}, source={}", userIdx, response.get("source"));
            
        } catch (Exception e) {
            logger.error("챗봇 처리 중 오류 발생", e);
            
            // OpenAI API 실패 시 fallback
            if (e.getMessage() != null && 
                (e.getMessage().contains("quota") || e.getMessage().contains("rate_limit"))) {
                openAIAvailable = false;
                logger.warn("OpenAI API 사용량 초과, fallback 시스템 활성화");
                response = processWithStoredData(message, userIdx, sessionId);
            } else {
                response = createErrorResponse("일시적인 오류가 발생했습니다. 다시 시도해주세요.");
            }
        }
        
        return response;
    }

    @PostMapping("/chatbot/reset")
    @ResponseBody
    public Map<String, String> resetChatContext(HttpSession session) {
        String sessionId = session.getId();
        Integer userIdx = (Integer) session.getAttribute("user_idx");
        
        // 새로운 세션 생성
        ensureChatSession(sessionId + "_new", userIdx);
        
        Map<String, String> response = new HashMap<>();
        response.put("message", "대화 내용이 초기화되었습니다.");
        logger.info("챗봇 대화 초기화: sessionId={}", sessionId);
        return response;
    }

    // ================== 챗봇 헬퍼 메서드들 ==================

    private void ensureChatSession(String sessionId, Integer userIdx) {
        try {
            boardMapper.insertChatSession(sessionId, userIdx, "general");
        } catch (Exception e) {
            logger.debug("채팅 세션이 이미 존재합니다: " + sessionId);
        }
    }

    private void saveChatMessage(String sessionId, Integer userIdx, String messageType, 
                               String messageContent, String responseSource, Integer messageTokens) {
        try {
            boardMapper.insertChatMessage(sessionId, userIdx, messageType, 
                                        messageContent, responseSource, messageTokens);
        } catch (Exception e) {
            logger.error("챗봇 메시지 저장 실패", e);
        }
    }

    private boolean canUseOpenAI() {
        // 시간 기반 사용량 제한 체크 (3 RPM)
        LocalDateTime now = LocalDateTime.now();
        if (java.time.Duration.between(lastApiCallTime, now).toSeconds() < 20) {
            return false;
        }
        
        // 일일 사용량 체크
        String today = LocalDate.now().toString();
        Integer todayUsage = boardMapper.getTodayApiUsage(today);
        return todayUsage < 150; // 200 RPD 제한보다 여유있게 설정
    }

    private Map<String, Object> processWithOpenAI(String message, Integer userIdx, String sessionId) {
        // 실제 OpenAI API 호출 대신 고급 규칙 기반 처리
        lastApiCallTime = LocalDateTime.now();
        String response = generateAdvancedResponse(message, userIdx);
        
        // 봇 응답 저장
        saveChatMessage(sessionId, userIdx, "bot", response, "openai", estimateTokens(response));
        
        return createSuccessResponse(response, "openai");
    }

    private Map<String, Object> processWithStoredData(String message, Integer userIdx, String sessionId) {
        // 유사한 과거 대화 검색
        List<Board> similarConversations = findSimilarConversations(message, userIdx);
        
        String response;
        if (!similarConversations.isEmpty()) {
            // 가장 유사한 대화의 응답 활용
            response = generateResponseFromSimilar(message, similarConversations);
        } else {
            // 유사한 대화가 없으면 규칙 기반으로 fallback
            response = generateRuleBasedResponse(message, userIdx);
        }
        
        // 봇 응답 저장
        saveChatMessage(sessionId, userIdx, "bot", response, "stored", 0);
        
        return createSuccessResponse(response, "stored");
    }

    private Map<String, Object> processWithRuleBase(String message, Integer userIdx, String sessionId) {
        String response = generateRuleBasedResponse(message, userIdx);
        
        // 봇 응답 저장
        saveChatMessage(sessionId, userIdx, "bot", response, "rule", 0);
        
        return createSuccessResponse(response, "rule");
    }

    private boolean hasStoredConversations(Integer userIdx) {
        if (userIdx == null) return false;
        
        List<Board> conversations = boardMapper.getUserConversationHistory(userIdx, 1);
        return !conversations.isEmpty();
    }

    private List<Board> findSimilarConversations(String message, Integer userIdx) {
        // 키워드 추출
        List<String> keywords = extractKeywords(message);
        
        if (keywords.isEmpty()) {
            return Collections.emptyList();
        }
        
        // 가장 중요한 키워드로 검색
        String mainKeyword = keywords.get(0);
        return boardMapper.findSimilarConversations(mainKeyword, userIdx, 5);
    }

    private String generateResponseFromSimilar(String userMessage, List<Board> similarConversations) {
        if (similarConversations.isEmpty()) {
            return generateRuleBasedResponse(userMessage, null);
        }
        
        // 첫 번째 유사 대화의 응답을 현재 맥락에 맞게 수정
        Board bestMatch = similarConversations.get(0);
        String originalResponse = bestMatch.getBot_response();
        
        return adaptResponse(originalResponse, userMessage);
    }

    private String adaptResponse(String originalResponse, String currentMessage) {
        if (originalResponse == null) {
            return generateRuleBasedResponse(currentMessage, null);
        }
        
        // 키워드 기반 응답 수정
        if (currentMessage.contains("레시피") && !originalResponse.contains("레시피")) {
            originalResponse = originalResponse.replace("요리", "레시피");
        }
        
        if (currentMessage.contains("안녕") && !originalResponse.startsWith("안녕")) {
            originalResponse = "안녕하세요! " + originalResponse;
        }
        
        // 시간 정보 업데이트
        if (originalResponse.contains("오늘")) {
            LocalDate today = LocalDate.now();
            String todayStr = today.format(DateTimeFormatter.ofPattern("M월 d일"));
            originalResponse = originalResponse.replace("오늘", todayStr);
        }
        
        return originalResponse;
    }

    private String generateAdvancedResponse(String message, Integer userIdx) {
        // 레시피 추천 의도 파악
        if (containsRecipeKeywords(message)) {
            return generateRecipeRecommendation(message, userIdx);
        }
        
        // 감정 분석 기반 응답
        String emotion = analyzeEmotion(message);
        if (emotion != null) {
            return generateEmotionalResponse(message, emotion);
        }
        
        // 일반 규칙 기반 응답
        return generateRuleBasedResponse(message, userIdx);
    }

    private String generateRecipeRecommendation(String message, Integer userIdx) {
        // 사용자 알레르기 정보 조회
        List<Integer> userAllergyIds = getUserAllergyIds(userIdx);
        
        StringBuilder response = new StringBuilder();
        response.append("🍽️ 알레르기를 고려한 맞춤 레시피를 추천해드릴게요!\n\n");
        
        // 알레르기 제외 레시피 조회
        List<Board> recommendedRecipes = boardMapper.getAllergyFreeRecipes(userAllergyIds, 3);
        
        if (!recommendedRecipes.isEmpty()) {
            for (int i = 0; i < recommendedRecipes.size(); i++) {
                Board recipe = recommendedRecipes.get(i);
                response.append(String.format("%d. **%s** (%s)\n", 
                    i + 1, 
                    recipe.getRecipe_name() != null ? recipe.getRecipe_name() : "맛있는 레시피", 
                    recipe.getCook_type() != null ? recipe.getCook_type() : "일반"));
                    
                if (recipe.getCooking_time() != null) {
                    response.append(String.format("   ⏱️ %d분", recipe.getCooking_time()));
                }
                if (recipe.getServings() != null) {
                    response.append(String.format(" | 👥 %d인분", recipe.getServings()));
                }
                if (recipe.getRecipe_difficulty() != null) {
                    response.append(String.format(" | 📊 %s", recipe.getRecipe_difficulty()));
                }
                if (recipe.getView_count() != null) {
                    response.append(String.format(" | 👁️ %d회", recipe.getView_count()));
                }
                response.append("\n");
                
                if (recipe.getRecipe_desc() != null) {
                    String desc = recipe.getRecipe_desc();
                    if (desc.length() > 80) {
                        desc = desc.substring(0, 80) + "...";
                    }
                    response.append("   📝 ").append(desc).append("\n");
                }
                response.append("\n");
            }
            
            response.append("더 자세한 레시피를 보고 싶으시면 레시피 이름을 말씀해주세요! 🔍");
        } else {
            response.append("죄송합니다. 현재 추천할 수 있는 레시피가 없습니다. 😅\n");
            response.append("다른 종류의 요리나 구체적인 재료를 말씀해주시면 더 찾아보겠습니다!");
        }
        
        return response.toString();
    }

    private String generateRuleBasedResponse(String message, Integer userIdx) {
        // 인사말 처리
        if (message.contains("안녕") || message.contains("반가") || message.contains("처음")) {
            return "안녕하세요! 🤖 알레르기에서 자유로운 레시피를 추천해주는 쿠킹프리 봇입니다!\n" +
                   "어떤 요리를 만들어보고 싶으신가요?";
        }
        
        // 도움말 요청
        if (message.contains("도움") || message.contains("사용법") || message.contains("어떻게")) {
            return "저는 다음과 같은 도움을 드릴 수 있어요:\n\n" +
                   "🥘 알레르기를 고려한 안전한 레시피 추천\n" +
                   "🔍 요리 종류별 레시피 검색\n" +
                   "💬 간단한 요리 상담\n\n" +
                   "'레시피 추천해줘' 또는 구체적인 음식 이름을 말씀해주세요!";
        }
        
        // 감사 인사
        if (message.contains("고마워") || message.contains("감사") || message.contains("잘했어")) {
            return "도움이 되어서 정말 기뻐요! 😊 언제든 맛있는 레시피가 필요하시면 말씀해주세요.\n" +
                   "건강하고 맛있는 요리 되세요! 👨‍🍳";
        }
        
        // 레시피 관련 키워드
        if (containsRecipeKeywords(message)) {
            return generateRecipeRecommendation(message, userIdx);
        }
        
        // 기본 응답
        return "잘 이해하지 못했어요. 😅\n" +
               "'레시피 추천해줘', '도움말', '안녕하세요' 등으로 말씀해주세요!\n\n" +
               "타이머가 필요하시면 '/timer' 페이지를 이용해보세요! ⏰";
    }

    // ================== 타이머 기능 ==================
    
    @GetMapping("/timer")
    public String timerPage() {
        return "inc/timer";
    }

    // ================== 유틸리티 메서드들 ==================

    private boolean containsRecipeKeywords(String message) {
        String[] recipeKeywords = {"레시피", "요리", "음식", "만들기", "조리", "요리법", "뭐 먹을까", "추천"};
        return Arrays.stream(recipeKeywords)
                .anyMatch(keyword -> message.contains(keyword));
    }

    private List<Integer> getUserAllergyIds(Integer userIdx) {
        if (userIdx == null) {
            return Collections.emptyList();
        }
        
        Board user = boardMapper.selectUserByIdx(userIdx);
        if (user == null || user.getAlg_code() == null || user.getAlg_code().trim().isEmpty()) {
            return Collections.emptyList();
        }
        
        try {
            return Arrays.stream(user.getAlg_code().split(","))
                    .map(String::trim)
                    .filter(s -> !s.isEmpty())
                    .map(Integer::parseInt)
                    .collect(Collectors.toList());
        } catch (NumberFormatException e) {
            logger.warn("알레르기 코드 파싱 실패: " + user.getAlg_code(), e);
            return Collections.emptyList();
        }
    }

    private List<String> extractKeywords(String message) {
        String[] stopWords = {"은", "는", "이", "가", "을", "를", "에", "의", "로", "으로", "에서", "와", "과", "도", "만", "부터", "까지"};
        List<String> keywords = new ArrayList<>();
        
        String[] words = message.replaceAll("[^가-힣a-zA-Z0-9\\s]", "").split("\\s+");
        
        for (String word : words) {
            if (word.length() > 1 && !Arrays.asList(stopWords).contains(word)) {
                keywords.add(word);
            }
        }
        
        return keywords;
    }

    private String analyzeEmotion(String message) {
        if (message.contains("힘들") || message.contains("우울") || message.contains("슬프")) {
            return "sad";
        } else if (message.contains("기쁘") || message.contains("행복") || message.contains("좋아")) {
            return "happy";
        } else if (message.contains("화나") || message.contains("짜증") || message.contains("분노")) {
            return "angry";
        }
        return null;
    }

    private String generateEmotionalResponse(String message, String emotion) {
        switch (emotion) {
            case "sad":
                return "힘든 시간을 보내고 계시는군요. 😔 따뜻한 음식으로 기분을 달래보는 건 어떨까요?\n" +
                       "집에서 쉽게 만들 수 있는 comfort food 레시피를 추천해드릴게요!";
            case "happy":
                return "기분이 좋으시다니 저도 기뻐요! 😊 특별한 날을 축하할 만한 맛있는 요리는 어떠세요?\n" +
                       "파티나 축하용 레시피를 찾아드릴까요?";
            case "angry":
                return "스트레스 받는 일이 있으셨나요? 😤 요리를 하면서 마음을 진정시켜보세요.\n" +
                       "간단하면서도 만족감 있는 요리 레시피를 추천해드릴게요!";
            default:
                return "무엇을 도와드릴까요? 😊";
        }
    }

    private Integer estimateTokens(String text) {
        // 한국어 기준 대략적인 토큰 수 계산 (단어 수 * 1.5)
        return (int) (text.split("\\s+").length * 1.5);
    }

    private Map<String, Object> createSuccessResponse(String message, String source) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", message);
        response.put("source", source);
        return response;
    }

    private Map<String, Object> createErrorResponse(String message) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("message", message);
        return response;
    }
}
