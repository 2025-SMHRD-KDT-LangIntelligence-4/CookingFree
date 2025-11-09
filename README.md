# CookingFree - 알레르기 회피형 레시피 안내 서비스

사용자의 알레르기 정보를 기반으로 안전한 레시피를 추천하는 웹 서비스

## 프로젝트 개요
<img width="951" height="761" alt="2-cookingfree-architecture drawio" src="https://github.com/user-attachments/assets/2885349b-ebae-4999-827c-9b54808cd980" />

**CookingFree**는 만개의레시피 데이터를 활용하여 사용자의 알레르기 정보(16가지)에 따라 자동으로 안전한 요리를 검색·추천하는 서비스입니다.

### 핵심 기능

- **레시피 검색**: 알레르기 필터링을 적용한 레시피 검색
- **회원 관리**: 로컬 회원가입, OAuth2 (카카오/네이버) 소셜 로그인
- **챗봇**: 자연어 처리 기반 대화형 레시피 추천
- **리뷰 시스템**: 사용자가 작성한 레시피 리뷰 및 평점
- **파일 업로드**: 레시피 이미지 및 사용자 프로필 이미지 관리


---

## 🏗️ 기술 스택

### 백엔드

- **Framework**: Spring Boot 3.x
- **Language**: Java 17+
- **ORM**: MyBatis (SQL 기반)
- **Database**: MySQL 8.0+
- **Security**: Spring Security 6.x (OAuth2, 로컬 인증)

### 프론트엔드

- **Template Engine**: JSP (JSTL)
- **Styling**: CSS 3
- **Script**: JavaScript (jQuery 3.6+)

### 자연어 처리

- OpenKoreanText (한국어 형태소 분석)
- TF-IDF + 코사인 유사도 (벡터 기반 검색)

### 외부 연동

- 음성인식 API (Google Cloud Speech-to-Text)
- SNS 로그인 (Kakao Developers, Naver OAuth)

### 개발 도구

- **Build Tool**: Maven
- **IDE**: STS(Spring Tool Suite)
- **VCS**: Git / GitHub

---



## 📂 프로젝트 구조

```
CookingFree/
├── src/main/java/com/smhrd/web/
│   ├── config/
│   │   ├── SecurityConfig.java # Spring Security + OAuth2 설정
│   │   ├── MultipartConfig.java # 파일 업로드 설정
│   │   ├── WebConfig.java # 웹 리소스 매핑
│   │   ├── TomcatConfig.java # 톰캣 대용량 파일 설정
│   │   └── ChatbotProperties.java # 챗봇 프로퍼티
│   ├── controller/
│   │   ├── MyController.java # 메인, 레시피, 마이페이지
│   │   ├── JoinController.java # 회원가입/로그인
│   │   └── EnhancedChatbotController.java # 챗봇 처리
│   ├── service/
│   │   ├── CustomUserDetailsService.java # Spring Security 통합
│   │   └── KoreanTextProcessingService.java # 한국어 NLP 처리
│   ├── mapper/
│   │   └── BoardMapper.java # MyBatis Mapper (SQL 쿼리)
│   └── entity/
│       ├── Board.java # 통합 엔티티
│       └── SearchCriteria.java # 검색 조건
├── src/main/webapp/WEB-INF/views/
│   ├── cfMain.jsp # 메인 페이지
│   ├── cfLogin.jsp # 로그인 페이지
│   ├── cfJoinform.jsp # 회원가입 페이지
│   ├── cfRecipeIndex.jsp # 레시피 목록
│   ├── cfRecipe.jsp # 레시피 상세 (조리 모드)
│   ├── cfRecipeDetail.jsp # 레시피 상세 (리뷰)
│   ├── cfRecipeinsert.jsp # 레시피 등록
│   ├── cfChatbot.jsp # 챗봇 페이지
│   ├── cfSearchRecipe.jsp # 검색 결과
│   ├── cfMyPage.jsp # 마이페이지
│   └── inc/header.jsp # 공통 헤더
├── src/main/resources/
│   ├── application.properties # DB, API 설정
│   └── logback.xml # 로깅 설정
├── pom.xml # Maven 의존성
└── README.md
```

---

## 📊 주요 API 엔드포인트

### 사용자 관련

| 메서드 | 경로 | 설명 |
|--------|------|------|
| GET | `/login` | 로그인 페이지 |
| POST | `/login` | 로그인 처리 |
| GET | `/cfJoinform` | 회원가입 페이지 |
| POST | `/cfjoinId` | 회원가입 처리 |
| GET | `/cfMyPage` | 마이페이지 |

### 레시피 관련

| 메서드 | 경로 | 설명 |
|--------|------|------|
| GET | `/cfRecipeIndex` | 레시피 목록 (페이징) |
| POST | `/searchRecipe` | 레시피 검색 + 알레르기 필터링 |
| GET | `/recipe/detail/{recipeIdx}` | 레시피 상세 + 리뷰 |
| POST | `/cfRecipeinsert` | 레시피 등록 |

### 챗봇 관련

| 메서드 | 경로 | 설명 |
|--------|------|------|
| GET | `/cfChatbot` | 챗봇 페이지 |
| POST | `/chatbot/message` | 메시지 처리 (자연어 기반) |

---

## 🔧 핵심 구현 내용

### 1. Spring Security + OAuth2 설정

```java
@Configuration
public class SecurityConfig {
  @Bean
  public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
    http
      .oauth2Login(oauth2 -> oauth2
        .loginPage("/login")
        .successHandler(oAuth2SuccessHandler())
      )
      .formLogin(form -> form
        .loginPage("/login")
        .loginProcessingUrl("/login")
      )
      .authorizeHttpRequests(auth -> auth
        .requestMatchers("/", "/cfMain", "/recipe/**", "/login").permitAll()
        .anyRequest().authenticated()
      );
    return http.build();
  }
}
```

### 2. 알레르기 필터링 로직
<img width="803" height="692" alt="3-cookingfree-allergy-filtering drawio" src="https://github.com/user-attachments/assets/ae372185-7481-4c0f-aa09-140e6cf85391" />

```java
// MyController.java에서 검색 시 알레르기 필터 적용
ListInteger allergyIds = getUserAllergyIds(user_idx);
List<Board> recipes = boardMapper.searchAllergyFreeRecipes(
  searchText,
  allergyIds,
  pageSize
);

// 추가 필터링 (키워드 기반)
recipes = recipes.stream()
  .filter(r -> allergyKeywords.stream().noneMatch(kw ->
    r.getRecipename().contains(kw) ||
    r.getRecipedesc().contains(kw) ||
    r.getTags().contains(kw)
  ))
  .collect(Collectors.toList());
```

### 3. 챗봇 - OpenKoreanText 형태소 분석 + TF-IDF 검색
<img width="708" height="832" alt="4-cookingfree-chatbot-nlp-korean drawio" src="https://github.com/user-attachments/assets/8a526e98-6f81-4900-ae9f-dd0cb1abb252" />

```java
// EnhancedChatbotController.java - 자연어 처리
private String extractFoodKeyword(String message) {
  // 1) 한글 정규화
  CharSequence normalized = OpenKoreanTextProcessorJava.normalize(message);
  
  // 2) 형태소 분석
  Seq<KoreanToken> tokens = OpenKoreanTextProcessorJava.tokenize(normalized);
  
  // 3) 명사 추출
  List<String> nouns = OpenKoreanTextProcessorJava.tokensToJavaStringList(
    tokens.stream()
      .filter(tok -> tok.matches("-.*"))  // 명사만
      .collect(Collectors.toList())
  );
  
  return nouns.isEmpty() ? null : nouns.get(0);
}
```

**응답 우선순위**:
1. **키워드 기반 레시피 검색** (알레르기 필터링 적용)
2. **저장된 대화 검색** (TF-IDF 코사인 유사도 > 0.15)
3. **규칙 기반 응답** (폴백)

### 4. 파일 업로드

```java
private String saveFile(MultipartFile file, String subDir) throws IOException {
  String projectRoot = System.getProperty("user.dir");
  File dir = new File(projectRoot, subDir);
  if (!dir.exists()) dir.mkdirs();
  
  String newName = UUID.randomUUID() + "." + getExtension(file.getOriginalFilename());
  File dest = new File(dir, newName);
  file.transferTo(dest);
  
  return "/upload/" + new File(subDir).getName() + "/" + newName;
}
```

---
##  성과: 성능 최적화

### **성능 개선 결과**
| 항목 | 개선 전 | 개선 후 | 개선율 |
|------|--------|--------|--------|
| **검색 시간** | 10분 이상 | 0.3초 | 99.95% ↓ |
| **필터링 정확도** | - | 100% | 오류율 0% |
| **최대 동시 사용자** | - | 50명 | 안정적 |
---
##  데이터베이스 설계 및 최적화
<img width="673" height="682" alt="쿠킹프리1 drawio" src="https://github.com/user-attachments/assets/c3c9f98b-47be-431d-812a-4b3e936b0857" />

### 초기 설계: 완전 정규화 (성능 문제 발생)

```sql
-- 6개 테이블 정규화 모델
cf_recipe (레시피)
  ├── cf_recipe_input (레시피-식재료 매핑)
  └── cf_ingredient (식재료 목록)

-- 문제: 다중 JOIN으로 풀 테이블 스캔 발생
SELECT * FROM cf_recipe r
JOIN cf_recipe_input ri ON r.recipe_idx = ri.recipe_idx
JOIN cf_ingredient i ON ri.ingredient_idx = i.ingredient_idx
WHERE i.name LIKE '%우유%'

-- 결과: 10분 이상 소요 (사용자 경험 심각 저하)
```

### 최적화: 반정규화 모델 (성능 극적 개선)

```sql
-- 반정규화된 cf_recipe 테이블
CREATE TABLE cf_recipe (
  recipe_idx INT PRIMARY KEY AUTO_INCREMENT,
  recipe_name VARCHAR(255) NOT NULL,
  ingredients_list VARCHAR(2000),  -- 식재료를 '|'로 구분하여 저장
  recipe_desc TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  FULLTEXT INDEX ft_recipe_name_desc (recipe_name, recipe_desc),
  INDEX idx_view_count (view_count DESC),
  FOREIGN KEY (user_idx) REFERENCES cf_user(user_idx)
);

-- 개선 후: 조인 제거, 단순 텍스트 검색
SELECT * FROM cf_recipe
WHERE ingredients_list LIKE '%우유%'

-- 결과: 0.3초 (99.95% 성능 개선)
```

### 최적화 기법

1. **조인 제거**: cf_recipe_input 테이블 삭제, 식재료를 `|`로 구분하여 통합 저장
2. **FULLTEXT 인덱스**: recipe_name, recipe_desc에 전문 검색 인덱스 적용
3. **단순화 검색**: 정규표현식에서 LIKE 검색으로 변경
4. **메모리 효율**: 300MB 메모리 사용 → 5-10MB로 95% 감소

### 기술적 선택 근거

- **왜 반정규화?** 읽기 성능이 절대 우선이며, 쓰기는 드문 환경 (레시피는 자주 추가되지 않음)
- **왜 FULLTEXT 인덱스?** 대용량 텍스트 검색에 최적화되고 속도 우수
- **왜 MySQL?** 구조화된 데이터에 최적이며, 반정규화를 통해 엄청난 성능 향상 가능

---
## 🚀 설치 및 실행

### 사전 요구사항

- Java 17 이상
- MySQL 8.0 이상
- Maven 3.9.10 이상

### 1단계: 저장소 클론

```bash
git clone https://github.com/2025-SMHRD-KDT-LangIntelligence-4/CookingFree.git
cd CookingFree
```

### 2단계: 데이터베이스 설정

```sql
CREATE DATABASE cookingfree CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE cookingfree;

-- 테이블 생성 (아래 스키마 참고)

-- 알레르기 마스터 데이터
INSERT INTO cf_alergy (alergy_name) VALUES
('난류'), ('우유'), ('견과류'), ('생선'), ('조개류'), ('새우'),
('복숭아'), ('토마토'), ('초콜릿'), ('카페인'), ('MSG'), ('글루텐'),
('참깨'), ('콩'), ('돼지고기'), ('소고기');
```

### 3단계: application.properties 설정

```properties
# 데이터베이스
spring.datasource.url=jdbc:mysql://localhost:3306/cookingfree?characterEncoding=UTF-8&serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=YOUR_PASSWORD
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# 파일 업로드
app.upload.base-dir=src/main/webapp/upload
app.upload.profile-dir=src/main/webapp/upload/profile
app.upload.review-dir=src/main/webapp/upload/reviews

# 로깅
logging.level.root=INFO
logging.level.com.smhrd.web=DEBUG
```

### 4단계: 빌드 및 실행

```bash
# Maven 빌드
mvn clean install

# Spring Boot 실행
mvn spring-boot:run

# 또는 JAR 실행
java -jar target/CookingFree.jar
```

**접속**: http://localhost:8080/cfMain

---

## 🐛 트러블슈팅

### 알레르기 필터링이 작동하지 않음

**원인**: cf_user_alergy 테이블에 데이터가 없거나 저장되지 않음

**해결**:
```sql
-- 1) 사용자 알레르기 확인
SELECT * FROM cf_user_alergy WHERE user_idx = 1;

-- 2) 수동 삽입
INSERT INTO cf_user_alergy (user_idx, alergy_idx) VALUES (1, 1), (1, 2);

-- 3) 마이페이지에서 알레르기 재설정
```

### 파일 업로드 실패 (HTTP 413)

**원인**: multipart 최대 파일 크기 설정 미흡

**해결**:
```properties
spring.servlet.multipart.max-file-size=100MB
spring.servlet.multipart.max-request-size=100MB
```

### 데이터베이스 연결 실패

**원인**: MySQL 서버 미실행 또는 설정 오류

**해결**:
```bash
# MySQL 서버 실행 (Windows)
net start MySQL80

# 또는 Linux
sudo systemctl start mysql
```

---

## 📊 데이터 규모

- **레시피 수**: 20만 개
- **식재료 수**: 6만 개
- **알레르기 종류**: 16가지
- **MySQL FULLTEXT 인덱스**: 빠른 전문 검색

---

## 👥 팀 정보

- **프로젝트명**: CookingFree
- **팀**: SMHRD KDT 언어지능 4팀
- **기간**: 2025.07.18 ~ 2025.08.01 (2주)
- **팀 규모**: 5명
  - **팀장**: 이명준 (백엔드 총괄)
  - **팀원**: 배광한 (프론트엔드 총괄), 유선, 김민준, 임하현
- **GitHub**: https://github.com/2025-SMHRD-KDT-LangIntelligence-4/CookingFree

---

**Happy Cooking! **
