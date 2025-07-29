package com.smhrd.web.controller;

import com.smhrd.web.entity.Board;
import com.smhrd.web.mapper.BoardMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

import org.apache.commons.text.similarity.CosineSimilarity;
import org.apache.lucene.search.similarities.ClassicSimilarity;
import org.apache.lucene.search.similarities.TFIDFSimilarity;
import org.openkoreantext.processor.tokenizer.KoreanTokenizer;
import org.openkoreantext.processor.OpenKoreanTextProcessorJava;
import org.openkoreantext.processor.tokenizer.KoreanTokenizer.KoreanToken;
import org.openkoreantext.processor.phrase_extractor.KoreanPhraseExtractor.KoreanPhrase;
import scala.collection.Seq;
import org.openkoreantext.processor.OpenKoreanTextProcessorJava;
import org.openkoreantext.processor.tokenizer.KoreanTokenizer;
import scala.collection.Seq;

@Controller
@Validated
public class EnhancedChatbotController {

    private static final Logger logger = LoggerFactory.getLogger(EnhancedChatbotController.class);

    @Autowired
    private BoardMapper boardMapper;

    private LocalDateTime last_api_call_time = LocalDateTime.now().minusHours(1);
    private static final int DAILY_API_LIMIT = 100;
    private static final int API_CALL_INTERVAL_SECONDS = 20;

    @GetMapping("/cfChatbot")
    public String chatbotPage() {
        logger.info("챗봇 페이지 접근");
        return "cfChatbot";
    }
    
    private List<Map<String, Object>> convertRecipesToDto(List<Board> recipes) {
        return recipes.stream()
            .map(r -> {
                Map<String, Object> map = new HashMap<>();
                map.put("recipe_idx", r.getRecipe_idx());
                map.put("title", r.getRecipe_name());
                map.put("category", r.getCook_type());
                map.put("cooking_time", r.getCooking_time());
                map.put("servings", r.getServings());
                map.put("difficulty", r.getRecipe_difficulty());
                map.put("view_count", r.getView_count());
                map.put("description", r.getRecipe_desc());
                return map;
            })
            .collect(Collectors.toList());
    }


    @PostMapping("/chatbot/message")
    @ResponseBody
    @Transactional
    public Map<String, Object> processChatbotMessage(
            @RequestParam @NotBlank @Size(max = 500) String message,
            HttpSession session) {

        logger.info("챗봇 메시지 처리 시작 - 메시지: {}", message);

        Integer user_idx = (Integer) session.getAttribute("user_idx");
        if (user_idx == null) {
            user_idx = 1;  // 비로그인 기본값
            logger.warn("비로그인 사용자, 기본 user_idx 사용: {}", user_idx);
        }

        String chat_session_id = ensureSession(session, user_idx);
        saveChatMessage(chat_session_id, user_idx, "user", message, null, 0);

        try {
            Map<String, Object> response;

            if (canUseOpenAI()) {
                logger.info("OpenAI 기반 응답 생성 시도");
                response = processWithAdvancedAI(message, user_idx, chat_session_id);
            } else {
                logger.info("AI 호출 불가, 저장된 대화 기반 응답 시도");
                response = processWithStoredData(message, user_idx, chat_session_id);

                if (response == null || isFallbackResponse(response)) {
                    logger.info("저장된 대화 기반 응답 없거나 기본 안내 메시지, 규칙 기반 폴백");
                    response = processWithEnhancedRules(message, user_idx, chat_session_id);
                }
            }

            logger.info("챗봇 응답 생성 완료 - 소스: {}", response.get("source"));
            return response;

        } catch (Exception e) {
            logger.error("챗봇 메시지 처리 중 오류", e);
            return createErrorResponse("죄송합니다. 일시적인 오류가 발생했습니다. 다시 시도해주세요.");
        }
    }

    /**
     * 규칙 기반 기본 안내 메시지 판단 헬퍼
     */
    private boolean isFallbackResponse(Map<String, Object> response) {
        if (response == null) return true;
        Boolean success = (Boolean) response.get("success");
        if (success == null || !success) return true;
        String message = (String) response.get("message");
        if (message == null) return true;

        String fallbackKeyword = "잘 이해하지 못했어요";
        return message.contains(fallbackKeyword);
    }


    @PostMapping("/chatbot/reset")
    @ResponseBody
    public Map<String, Object> resetChatContext(HttpSession session) {
        logger.info("챗봇 대화 세션 초기화 요청");
        session.invalidate();
        return createSuccessResponse("새로운 대화를 시작합니다! 🤖", "system");
    }

    private Map<String, Object> processWithAdvancedAI(String message, Integer user_idx, String session_id) {
        logger.debug("AI 기반 응답 생성 - 사용자: {}, 메시지: {}", user_idx, message);

        last_api_call_time = LocalDateTime.now();
        String responseMessage = generateAdvancedRecipeRecommendation(message, user_idx);

        // 음식 키워드 추출, 알레르기 목록 조회
        String foodKeyword = extractFoodKeyword(message);
        List<Integer> allergyIds = getUserAllergyIds(user_idx);
        List<Board> recipes = Collections.emptyList();

        if (foodKeyword != null && !foodKeyword.isBlank()) {
            recipes = boardMapper.searchAllergyFreeRecipes(foodKeyword, allergyIds, 5);
        }

        saveChatMessage(session_id, user_idx, "bot", responseMessage, "openai", estimateTokens(responseMessage));

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", responseMessage);
        result.put("source", "openai");
        result.put("recipes", convertRecipesToDto(recipes)); // 레시피 리스트 포함

        return result;
    }

    private Map<String, Object> processWithStoredData(String message, Integer user_idx, String session_id) {
        // 1) 형태소 분석(명사 추출)
        CharSequence normalized = OpenKoreanTextProcessorJava.normalize(message);
        Seq<KoreanTokenizer.KoreanToken> tokens = OpenKoreanTextProcessorJava.tokenize(normalized);
        List<String> nouns = OpenKoreanTextProcessorJava.tokensToJavaStringList(tokens).stream()
            .filter(tok -> tok.matches("[가-힣]+"))
            .collect(Collectors.toList());

        // 2) 저장된 대화(TF-IDF+코사인 유사도) 검색
        if (!nouns.isEmpty()) {
            List<Board> history = boardMapper.getUserConversationHistory(user_idx, 50);

            List<List<String>> docs = history.stream()
                .map(Board::getUser_message)
                .filter(Objects::nonNull)
                .map(text -> {
                    CharSequence norm = OpenKoreanTextProcessorJava.normalize(text);
                    Seq<KoreanTokenizer.KoreanToken> toks = OpenKoreanTextProcessorJava.tokenize(norm);
                    return OpenKoreanTextProcessorJava.tokensToJavaStringList(toks);
                })
                .collect(Collectors.toList());

            Set<String> vocabSet = new HashSet<>();
            docs.forEach(vocabSet::addAll);
            List<String> vocabulary = new ArrayList<>(vocabSet);
            int N = docs.size();

            Map<String, Integer> df = new HashMap<>();
            for (String term : vocabulary) {
                int count = 0;
                for (List<String> doc : docs) {
                    if (doc.contains(term)) count++;
                }
                df.put(term, count);
            }

            Map<String, Double> queryTf = new HashMap<>();
            for (String noun : nouns) {
                queryTf.merge(noun, 1.0, Double::sum);
            }
            queryTf.replaceAll((k, v) -> v / nouns.size());

            Map<CharSequence, Double> queryTfidf = new LinkedHashMap<>();
            for (String term : vocabulary) {
                double tf = queryTf.getOrDefault(term, 0.0);
                int docFreq = df.getOrDefault(term, 0);
                double idf = docFreq > 0 ? Math.log((double) N / docFreq) : 0.0;
                queryTfidf.put(term, tf * idf);
            }

            CosineSimilarity cosine = new CosineSimilarity();
            double bestScore = 0.0;
            Board bestMatch = null;

            for (int i = 0; i < docs.size(); i++) {
                List<String> docTokens = docs.get(i);
                Map<String, Double> docTf = new HashMap<>();
                for (String tok : docTokens) {
                    docTf.merge(tok, 1.0, Double::sum);
                }
                docTf.replaceAll((k, v) -> v / docTokens.size());

                Map<CharSequence, Double> docTfidf = new LinkedHashMap<>();
                for (String term : vocabulary) {
                    double tf = docTf.getOrDefault(term, 0.0);
                    int docFreq = df.getOrDefault(term, 0);
                    double idf = docFreq > 0 ? Math.log((double) N / docFreq) : 0.0;
                    docTfidf.put(term, tf * idf);
                }

                Map<CharSequence, Integer> queryVecInt = new LinkedHashMap<>();
                queryTfidf.forEach((k, v) -> queryVecInt.put(k, (int) Math.round(v * 1000)));
                Map<CharSequence, Integer> docVecInt = new LinkedHashMap<>();
                docTfidf.forEach((k, v) -> docVecInt.put(k, (int) Math.round(v * 1000)));

                double score = cosine.cosineSimilarity(docVecInt, queryVecInt);
                if (score > bestScore) {
                    bestScore = score;
                    bestMatch = history.get(i);
                }
            }

            // 3) 유사도 결과가 임계치 이상일 때 저장된 응답 사용
            if (bestMatch != null && bestScore >= 0.15) {
                String response = adaptStoredResponse(bestMatch.getBot_response(), message);
                saveChatMessage(session_id, user_idx, "bot", response, "stored", 0);
                return createSuccessResponse(response, "stored");
            }
        }

        // 4) 저장된 대화 없거나 임계치 미만일 경우 DB에서 키워드 기반 레시피 검색
        String foodKeyword = extractFoodKeyword(message);
        List<Integer> allergyIds = getUserAllergyIds(user_idx);

        if (foodKeyword != null && !foodKeyword.isBlank()) {
            List<Board> recipes = boardMapper.searchAllergyFreeRecipes(foodKeyword, allergyIds, 5);

            if (!recipes.isEmpty()) {
                StringBuilder response = new StringBuilder();
                response.append(String.format("'%s' 관련 맞춤 레시피를 추천해드릴게요!\n\n", foodKeyword));
                formatRecipeList(response, recipes);
                saveChatMessage(session_id, user_idx, "bot", response.toString(), "recipe_search", 0);
                return createSuccessResponse(response.toString(), "recipe_search");
            }
        }

        // 5) 그래도 검색 결과 없으면 인기 레시피 추천
        List<Board> popularRecipes = boardMapper.getAllergyFreeRecipes(allergyIds, 5);
        StringBuilder response = new StringBuilder();
        response.append("알레르기를 고려한 인기 레시피를 추천해드릴게요!\n\n");
        formatRecipeList(response, popularRecipes);
        saveChatMessage(session_id, user_idx, "bot", response.toString(), "popular_recipe", 0);
        return createSuccessResponse(response.toString(), "popular_recipe");
    }





    private Map<String, Object> processWithEnhancedRules(String message, Integer user_idx, String session_id) {
        logger.debug("규칙 기반 응답 생성 - 사용자: {}", user_idx);
        
        String response = generateEnhancedRuleBasedResponse(message, user_idx);
        saveChatMessage(session_id, user_idx, "bot", response, "rule", 0);
        return createSuccessResponse(response, "rule");
    }

    /**
     * 키워드를 기반으로 알레르기 고려해 레시피 추천
     */
    private String generateAdvancedRecipeRecommendation(String message, Integer user_idx) {
        List<Integer> allergy_ids = getUserAllergyIds(user_idx);
        String food_keyword = extractFoodKeyword(message);

        StringBuilder response = new StringBuilder();
        response.append("🍽️ ");

        if (food_keyword != null) {
            response.append(String.format("'%s' 관련 맞춤 레시피를 추천해드릴게요!\n\n", food_keyword));

            List<Board> recipes = boardMapper.searchAllergyFreeRecipes(food_keyword, allergy_ids, 5);
            if (recipes.isEmpty()) {
                recipes = findSimilarRecipes(food_keyword, allergy_ids);
            }

            if (!recipes.isEmpty()) {
                formatRecipeList(response, recipes);
            } else {
                response.append("죄송합니다. '").append(food_keyword)
                        .append("' 관련 레시피를 찾을 수 없어요. 😅\n")
                        .append("다른 음식명으로 다시 시도해보시거나, '레시피 추천해줘'라고 말씀해주세요!");
            }
        } else {
            // 키워드 없는 경우에는 인기 레시피 추천
            response.append("알레르기를 고려한 인기 레시피를 추천해드릴게요!\n\n");
            List<Board> recipes = boardMapper.getAllergyFreeRecipes(allergy_ids, 5);
            formatRecipeList(response, recipes);
        }

        response.append("\n\n더 자세한 레시피나 다른 요리가 궁금하시면 언제든 말씀해주세요! 👨‍🍳");
        return response.toString();
    }


    private void formatRecipeList(StringBuilder response, List<Board> recipes) {
        for (int i = 0; i < recipes.size(); i++) {
            Board recipe = recipes.get(i);
            
            response.append(String.format("%d. **%s**", i + 1, 
                recipe.getRecipe_name() != null ? recipe.getRecipe_name() : "맛있는 레시피"));
            
            if (recipe.getCook_type() != null) {
                response.append(String.format(" (%s)", recipe.getCook_type()));
            }
            response.append("\n");
            
            List<String> meta_info = new ArrayList<>();
            if (recipe.getCooking_time() != null) {
                meta_info.add(String.format("⏱️ %d분", recipe.getCooking_time()));
            }
            if (recipe.getServings() != null) {
                meta_info.add(String.format("👥 %d인분", recipe.getServings()));
            }
            if (recipe.getRecipe_difficulty() != null) {
                meta_info.add(String.format("📊 %s", recipe.getRecipe_difficulty()));
            }
            if (recipe.getView_count() != null) {
                meta_info.add(String.format("👁️ %,d회", recipe.getView_count()));
            }
            
            if (!meta_info.isEmpty()) {
                response.append("   ").append(String.join(" | ", meta_info)).append("\n");
            }
            
            if (recipe.getRecipe_desc() != null && !recipe.getRecipe_desc().trim().isEmpty()) {
                String desc = recipe.getRecipe_desc().trim();
                if (desc.length() > 80) {
                    desc = desc.substring(0, 80) + "...";
                }
                response.append("   📝 ").append(desc).append("\n");
            }
            response.append("\n");
        }
    }

    private String ensureSession(HttpSession session, Integer user_idx) {
        String chat_session_id = (String) session.getAttribute("chatSessionId");
        if (chat_session_id == null) {
            chat_session_id = UUID.randomUUID().toString();
            session.setAttribute("chatSessionId", chat_session_id);
            
            try {
                boardMapper.insertChatSession(chat_session_id, user_idx, "enhanced");
                logger.debug("새로운 챗봇 세션 생성: {}", chat_session_id);
            } catch (Exception e) {
                logger.debug("채팅 세션이 이미 존재합니다: {}", chat_session_id);
            }
        }
        return chat_session_id;
    }

    private List<Integer> getUserAllergyIds(Integer user_idx) {
        if (user_idx == null) {
            return Collections.emptyList();
        }
        
        try {
            Board user = boardMapper.selectUserByIdx(user_idx);
            if (user == null || user.getAlg_code() == null || user.getAlg_code().trim().isEmpty()) {
                return Collections.emptyList();
            }
            
            List<Integer> allergy_ids = Arrays.stream(user.getAlg_code().split(","))
                    .map(String::trim)
                    .filter(s -> s.matches("\\d+"))  // 숫자인 경우만 필터링
                    .map(Integer::parseInt)
                    .collect(Collectors.toList());
            
            logger.debug("사용자 {}의 알레르기 정보: {}", user_idx, allergy_ids);
            return allergy_ids;
            
        } catch (Exception e) {
            logger.warn("알레르기 코드 파싱 실패 - 사용자 ID: {}", user_idx, e);
            return Collections.emptyList();
        }
    }

    private void saveChatMessage(String session_id, Integer user_idx, String message_type, 
                               String message_content, String response_source, Integer message_tokens) {
        try {
            boardMapper.insertChatMessage(session_id, user_idx, message_type, 
                                        message_content, response_source, message_tokens);
            logger.debug("채팅 메시지 저장 완료 - 타입: {}, 길이: {}", message_type, message_content.length());
        } catch (Exception e) {
            logger.error("챗봇 메시지 저장 실패", e);
        }
    }

    private String generateEnhancedRuleBasedResponse(String message, Integer user_idx) {
        if (message.contains("안녕") || message.contains("반가")) {
            return "안녕하세요! 🤖 쿠킹프리 레시피 추천 봇입니다!\n" +
                   "어떤 요리를 만들어보고 싶으신가요?";
        }
        
        if (message.contains("도움") || message.contains("사용법")) {
            return "저는 다음과 같은 도움을 드릴 수 있어요:\n\n" +
                   "🥘 알레르기를 고려한 안전한 레시피 추천\n" +
                   "🔍 요리 종류별 레시피 검색\n" +
                   "'레시피 추천해줘' 또는 구체적인 음식 이름을 말씀해주세요!";
        }
        
        if (containsRecipeKeywords(message)) {
            return generateAdvancedRecipeRecommendation(message, user_idx);
        }
        
        return "잘 이해하지 못했어요. 😅\n" +
               "'레시피 추천해줘', '라면 요리법' 등으로 말씀해주세요!\n\n" +
               "타이머가 필요하시면 '/timer'라고 말씀해주세요! ⏰";
    }

    private boolean containsRecipeKeywords(String message) {
        String[] recipe_keywords = {"레시피", "요리", "음식", "만들기", "조리", "추천",
                                   "라면", "치킨", "짜장면", "김치찌개", "비빔밥"};
        return Arrays.stream(recipe_keywords).anyMatch(message::contains);
    }

    private String extractFoodKeyword(String message) {
        if (message == null || message.isBlank()) return null;

        CharSequence normalized = OpenKoreanTextProcessorJava.normalize(message);
        Seq<KoreanTokenizer.KoreanToken> tokens = OpenKoreanTextProcessorJava.tokenize(normalized);

        List<KoreanPhrase> phrases = OpenKoreanTextProcessorJava.extractPhrases(tokens, true, true);
        Optional<String> phraseOpt = phrases.stream()
            .map(KoreanPhrase::text)
            .filter(p -> p.length() >= 2)
            .findFirst();

        if (phraseOpt.isPresent()) {
            return phraseOpt.get();
        }

        List<String> nouns = OpenKoreanTextProcessorJava.tokensToJavaStringList(tokens).stream()
            .filter(tok -> tok.matches("[가-힣]+"))
            .collect(Collectors.toList());

        if (!nouns.isEmpty()) {
            return nouns.stream().max(Comparator.comparingInt(String::length)).orElse(null);
        }

        String trimmed = message.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private List<String> extractSimpleKeywords(String message) {
        return Arrays.stream(message.split("\\s+"))
                     .filter(word -> word.length() > 1)
                     .collect(Collectors.toList());
    }

    private boolean canUseOpenAI() {
        LocalDateTime now = LocalDateTime.now();
        if (last_api_call_time.plusSeconds(API_CALL_INTERVAL_SECONDS).isAfter(now)) {
            return false;
        }
        
        String today = LocalDate.now().toString();
        Integer today_usage = boardMapper.getTodayApiUsage(today);
        return today_usage < DAILY_API_LIMIT;
    }

    private boolean hasStoredConversations(Integer user_idx, String message) {
        List<String> keywords = extractSimpleKeywords(message);
        if (keywords.isEmpty()) return false;
        
        List<Board> conversations = boardMapper.findSimilarConversations(keywords.get(0), user_idx, 5);
        return !conversations.isEmpty();
    }

    private List<Board> findSimilarRecipes(String food_keyword, List<Integer> allergy_ids) {
        return boardMapper.getAllergyFreeRecipes(allergy_ids, 3);
    }

    private Board findBestMatchingConversation(String message, List<Board> conversations) {
        return conversations.get(0);
    }

    private String adaptStoredResponse(String bot_response, String message) {
        if (bot_response == null) return generateEnhancedRuleBasedResponse(message, null);
        return bot_response;
    }

    private int estimateTokens(String text) {
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
