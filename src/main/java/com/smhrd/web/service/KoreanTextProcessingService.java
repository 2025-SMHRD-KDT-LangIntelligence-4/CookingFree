package com.smhrd.web.service;

import org.openkoreantext.processor.KoreanTokenJava;
import org.openkoreantext.processor.OpenKoreanTextProcessorJava;
import org.openkoreantext.processor.tokenizer.KoreanTokenizer;
import org.springframework.stereotype.Service;
import scala.collection.Seq;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class KoreanTextProcessingService {
    
    // 불용어 (Stopwords) 리스트
    private static final Set<String> STOPWORDS = new HashSet<>(Arrays.asList(
        "은", "는", "이", "가", "을", "를", "에", "의", "로", "으로", "에서", "와", "과", 
        "도", "만", "부터", "까지", "하고", "그리고", "또는", "그런데", "하지만"
    ));
    
    // 음식 관련 키워드
    private static final Set<String> FOOD_KEYWORDS = new HashSet<>(Arrays.asList(
        "라면", "치킨", "짜장면", "짬뽕", "김치찌개", "된장찌개", "비빔밥", "볶음밥", 
        "파스타", "피자", "햄버거", "샐러드", "스테이크", "돈까스", "카레", "떡볶이", 
        "순대", "냉면", "칼국수", "만두", "전", "부침개", "갈비", "불고기", "삼겹살",
        "김치", "된장", "고추장", "간장", "설탕", "소금", "후추", "마늘", "양파", 
        "당근", "감자", "고구마", "배추", "무", "콩나물", "시금치", "계란", "우유",
        "닭고기", "돼지고기", "소고기", "생선", "새우", "오징어", "두부"
    ));
    
    /**
     * 한국어 텍스트에서 키워드 추출
     */
    public List<String> extractKeywords(String text) {
        if (text == null || text.trim().isEmpty()) {
            return Collections.emptyList();
        }
        
        // 텍스트 정규화
        CharSequence normalized = OpenKoreanTextProcessorJava.normalize(text);
        
        // 토큰화
        Seq<KoreanTokenizer.KoreanToken> tokens = OpenKoreanTextProcessorJava.tokenize(normalized);
        List<KoreanTokenJava> koreanTokens = OpenKoreanTextProcessorJava.tokensToJavaKoreanTokenList(tokens);
        
        return koreanTokens.stream()
                .filter(token -> isValidKeyword(token))
                .map(KoreanTokenJava::getStem)
                .distinct()
                .collect(Collectors.toList());
    }
    
    /**
     * 음식명 키워드 추출 (우선순위)
     */
    public String extractFoodKeyword(String text) {
        List<String> keywords = extractKeywords(text);
        
        // 1순위: 직접 매칭되는 음식 키워드
        Optional<String> directMatch = keywords.stream()
                .filter(FOOD_KEYWORDS::contains)
                .findFirst();
        
        if (directMatch.isPresent()) {
            return directMatch.get();
        }
        
        // 2순위: 부분 매칭
        for (String keyword : keywords) {
            for (String foodKeyword : FOOD_KEYWORDS) {
                if (foodKeyword.contains(keyword) || keyword.contains(foodKeyword)) {
                    return foodKeyword;
                }
            }
        }
        
        return null;
    }
    
    /**
     * 텍스트 유사도 계산 (코사인 유사도)
     */
    public double calculateSimilarity(String text1, String text2) {
        List<String> keywords1 = extractKeywords(text1);
        List<String> keywords2 = extractKeywords(text2);
        
        if (keywords1.isEmpty() || keywords2.isEmpty()) {
            return 0.0;
        }
        
        Set<String> allKeywords = new HashSet<>(keywords1);
        allKeywords.addAll(keywords2);
        
        double[] vector1 = createTfIdfVector(keywords1, allKeywords);
        double[] vector2 = createTfIdfVector(keywords2, allKeywords);
        
        return calculateCosineSimilarity(vector1, vector2);
    }
    
    private boolean isValidKeyword(KoreanTokenJava token) {
        String pos = token.getPos().name();
        String text = token.getStem();
        
        // 명사, 형용사, 동사만 추출
        if (!pos.equals("Noun") && !pos.equals("Adjective") && !pos.equals("Verb")) {
            return false;
        }
        
        // 불용어 제외
        if (STOPWORDS.contains(text)) {
            return false;
        }
        
        // 길이 2 이상
        return text.length() >= 2 && !token.isUnknown();
    }
    
    private double[] createTfIdfVector(List<String> keywords, Set<String> vocabulary) {
        double[] vector = new double[vocabulary.size()];
        List<String> vocabList = new ArrayList<>(vocabulary);
        
        Map<String, Long> termFreq = keywords.stream()
                .collect(Collectors.groupingBy(k -> k, Collectors.counting()));
        
        for (int i = 0; i < vocabList.size(); i++) {
            String term = vocabList.get(i);
            double tf = termFreq.getOrDefault(term, 0L).doubleValue() / keywords.size();
            vector[i] = tf; // 단순 TF만 사용 (IDF는 레시피 컬렉션 전체가 필요)
        }
        
        return vector;
    }
    
    private double calculateCosineSimilarity(double[] vector1, double[] vector2) {
        double dotProduct = 0.0;
        double norm1 = 0.0;
        double norm2 = 0.0;
        
        for (int i = 0; i < vector1.length; i++) {
            dotProduct += vector1[i] * vector2[i];
            norm1 += Math.pow(vector1[i], 2);
            norm2 += Math.pow(vector2[i], 2);
        }
        
        if (norm1 == 0.0 || norm2 == 0.0) {
            return 0.0;
        }
        
        return dotProduct / (Math.sqrt(norm1) * Math.sqrt(norm2));
    }
}
