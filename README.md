# CookingFree - 알레르기 회피형 레시피 안내 서비스

> 사용자의 알레르기 정보를 기반으로 안전한 레시피를 추천하는 웹 서비스

## 프로젝트 개요

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
│   │   ├── SecurityConfig.java              # Spring Security + OAuth2 설정
│   │   ├── MultipartConfig.java             # 파일 업로드 설정
│   │   ├── WebConfig.java                   # 웹 리소스 매핑
│   │   ├── TomcatConfig.java                # 톰캣 대용량 파일 설정
│   │   └── ChatbotProperties.java           # 챗봇 프로퍼티
│   ├── controller/
│   │   ├── MyController.java                # 메인, 레시피, 마이페이지
│   │   ├── JoinController.java              # 회원가입/로그인
│   │   └── EnhancedChatbotController.java   # 챗봇 처리
│   ├── service/
│   │   ├── CustomUserDetailsService.java    # Spring Security 통합
│   │   └── KoreanTextProcessingService.java # 한국어 NLP 처리
│   ├── mapper/
│   │   └── BoardMapper.java                 # MyBatis Mapper (SQL 쿼리)
│   └── entity/
│       ├── Board.java                       # 통합 엔티티
│       └── SearchCriteria.java              # 검색 조건
├── src/main/webapp/WEB-INF/views/
│   ├── cfMain.jsp                           # 메인 페이지
│   ├── cfLogin.jsp                          # 로그인 페이지
│   ├── cfJoinform.jsp                       # 회원가입 페이지
│   ├── cfRecipeIndex.jsp                    # 레시피 목록
│   ├── cfRecipe.jsp                         # 레시피 상세 (조리 모드)
│   ├── cfRecipeDetail.jsp                   # 레시피 상세 (리뷰)
│   ├── cfRecipeinsert.jsp                   # 레시피 등록
│   ├── cfChatbot.jsp                        # 챗봇 페이지
│   ├── cfSearchRecipe.jsp                   # 검색 결과
│   ├── cfMyPage.jsp                         # 마이페이지
│   └── inc/header.jsp                       # 공통 헤더
├── src/main/resources/
│   ├── application.properties                # DB, API 설정
│   └── logback.xml                          # 로깅 설정
├── pom.xml                                  # Maven 의존성
└── README.md

```

---

## 🗄️ 데이터베이스 스키마 (주요 테이블)

### cf_user (사용자)
```sql
CREATE TABLE cf_user (
  user_idx INT PRIMARY KEY AUTO_INCREMENT,
  email VARCHAR(100) UNIQUE NOT NULL,
  pw VARCHAR(100),
  nick VARCHAR(50) NOT NULL,
  auth_type CHAR(1) NOT NULL,         -- 'L' (로컬), 'K' (카카오), 'N' (네이버)
  social_id VARCHAR(100),
  alg_code VARCHAR(500),              -- 보유 알레르기 (쉼표 분리)
  profile_img VARCHAR(255),
  joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### cf_recipe (레시피)  - 레시피 디테일 데이터 매핑 필요.
```sql
CREATE TABLE cf_recipe (
  recipe_idx INT PRIMARY KEY AUTO_INCREMENT,
  user_idx INT,
  recipe_name VARCHAR(255) NOT NULL,
  cook_type VARCHAR(100),
  recipe_difficulty VARCHAR(10),
  cooking_time INT,
  servings INT,
  recipe_img VARCHAR(255),
  recipe_desc TEXT,
  tags VARCHAR(500),
  view_count INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  FULLTEXT INDEX ft_recipe_name_desc (recipe_name, recipe_desc),
  INDEX idx_view_count (view_count DESC),
  FOREIGN KEY (user_idx) REFERENCES cf_user(user_idx)
);
```

### cf_alergy (알레르기 목록) - 16가지
```sql
CREATE TABLE cf_alergy (
  alergy_idx INT PRIMARY KEY AUTO_INCREMENT,
  alergy_name VARCHAR(100) NOT NULL UNIQUE
);
```

### cf_chatbot_message (챗봇 대화 기록)
```sql
CREATE TABLE cf_chatbot_message (
  message_idx INT PRIMARY KEY AUTO_INCREMENT,
  session_id VARCHAR(100),
  user_idx INT,
  message_type VARCHAR(10),           -- 'user', 'bot'
  message_content TEXT,
  response_source VARCHAR(50),        -- 'recipe_search', 'rule', 'stored'
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_idx) REFERENCES cf_user(user_idx)
);
```

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

-- 테이블 생성 (위의 스키마 참고)

-- 알레르기 마스터 데이터
INSERT INTO cf_alergy (alergy_name) VALUES
('난류'), ('우유'), ('견과류'), ('생선'), ('조개류'), ('새우'), 
('복숭아'), ('토마토'), ('초콜릿'), ('카페인'), ('MSG'), ('글루텐'),
('참깨'), ('콩'), ('돼지고기'), ('소고기');

-- 레시피 데이터 로드
-- LOAD DATA INFILE 또는 배치 스크립트로 import
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

# OAuth2 (선택)
spring.security.oauth2.client.registration.google.client-id=YOUR_CLIENT_ID
spring.security.oauth2.client.registration.google.client-secret=YOUR_SECRET

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

## 📖 주요 API 엔드포인트

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

## 🐛 트러블슈팅

### 1️⃣ 문제: 알레르기 필터링이 작동하지 않음

**증상**: 알레르기 설정을 했는데도 알레르기 포함 음식이 나타남

**원인 분석**:
- `cf_user_alergy` 테이블에 데이터가 없음
- 사용자가 선택한 알레르기가 DB에 저장되지 않음
- 검색 쿼리에서 알레르기 ID 조회 실패

**해결 방법**:
```sql
-- 1) 사용자 알레르기 확인
SELECT * FROM cf_user_alergy WHERE user_idx = 1;

-- 결과가 없으면, 알레르기 선택이 저장되지 않은 상태
-- 원인: JoinController.java의 회원가입 처리에서 
--       insertUserAllergies() 메서드가 호출되지 않았을 수 있음

-- 2) 수동으로 테스트 데이터 삽입
INSERT INTO cf_user_alergy (user_idx, alergy_idx) VALUES 
(1, 1), -- user_idx=1, 난류 알레르기
(1, 2); -- user_idx=1, 우유 알레르기

-- 3) 마이페이지에서 알레르기 재설정 후 저장
-- 또는 회원가입 폼의 알레르기 체크박스 확인 (JS 검증)
```

**예방책**:
```java
// JoinController.java - 회원가입 처리 부분
@PostMapping("/cfjoinId")
public String registerUser(Board user, String[] allergyIds) {
  // ... 사용자 저장 ...
  
  // 알레르기 저장 - 반드시 포함
  if (allergyIds != null && allergyIds.length > 0) {
    for (String allergyId : allergyIds) {
      boardMapper.insertUserAllergy(user.getUser_idx(), Integer.parseInt(allergyId));
    }
  }
  return "redirect:/cfMain";
}
```

---

### 2️⃣ 문제: 파일 업로드 실패 (HTTP 413 - Payload Too Large)

**증상**: 이미지 업로드 시 413 에러, 50MB 이상 파일 업로드 안 됨

**원인 분석**:
- Spring Servlet multipart 최대 파일 크기 설정 미설정
- Tomcat 커넥터의 `maxPostSize` 제한 (기본 2MB)
- Nginx 리버스 프록시를 사용할 경우 `client_max_body_size` 제한

**해결 방법**:
```properties
# application.properties에 다음 추가
spring.servlet.multipart.max-file-size=100MB
spring.servlet.multipart.max-request-size=100MB
spring.servlet.multipart.enabled=true
```

**추가 설정** (Tomcat 직접 배포 시):
```java
// TomcatConfig.java 또는 @Configuration 클래스
@Bean
public WebServerFactoryCustomizer<TomcatServletWebServerFactory> tomcatCustomizer() {
  return factory -> {
    factory.addConnectorCustomizers(connector -> {
      // 최대 파일 크기: 100MB
      connector.setMaxPostSize(100 * 1024 * 1024);
    });
  };
}
```

**Nginx 사용 시**:
```nginx
# /etc/nginx/nginx.conf
http {
    client_max_body_size 100M;
}
```

**예방책**:
```java
// MultipartConfig.java - 명시적 설정
@Configuration
public class MultipartConfig {
  @Bean
  public MultipartResolver multipartResolver() {
    StandardServletMultipartResolver resolver = new StandardServletMultipartResolver();
    return resolver;
  }
}
```

---

### 3️⃣ 문제: OAuth2 로그인 후 회원가입 페이지로 리다이렉트되지 않음

**증상**: 
- Kakao/Naver 로그인 → 홈 페이지로 이동하거나
- 신규 사용자인데 기존 사용자로 인식됨
- 로그인 루프 발생

**원인 분석**:
- HttpSession이 제대로 생성되지 않음 (`request.getSession(false)` 사용)
- OAuth2 principal에서 소셜 ID 추출 실패
- 데이터베이스에 socialId 저장 시 대소문자 불일치

**해결 방법**:
```java
// SecurityConfig.java - OAuth2 성공 핸들러 수정
@Bean
public AuthenticationSuccessHandler oAuth2SuccessHandler() {
  return (request, response, authentication) -> {
    OAuth2AuthenticationToken oauthToken = (OAuth2AuthenticationToken) authentication;
    String provider = oauthToken.getAuthorizedClientRegistrationId();
    
    // ← 중요: getSession(true) 사용 (false가 아님)
    HttpSession session = request.getSession(true);
    
    // 소셜 ID 추출 (제공자별 다름)
    String socialId = extractSocialId(provider, oauthToken.getPrincipal().getAttributes());
    
    // 기존 사용자 조회 (대소문자 구분 주의)
    Board existingUser = boardMapper.selectUserBySocialId(
      socialId.toLowerCase(),
      provider.substring(0,1).toUpperCase()
    );
    
    session.setAttribute("socialId", socialId);
    session.setAttribute("provider", provider);
    
    if (existingUser == null) {
      // 신규 사용자
      response.sendRedirect(request.getContextPath() + "/cfJoinform");
    } else {
      // 기존 사용자
      session.setAttribute("user_idx", existingUser.getUser_idx());
      response.sendRedirect(request.getContextPath() + "/cfMain");
    }
  };
}

// 소셜 ID 추출 함수
private String extractSocialId(String provider, Map<String, Object> attributes) {
  if ("kakao".equalsIgnoreCase(provider)) {
    return String.valueOf(attributes.get("id")); // Kakao는 "id"
  } else if ("naver".equalsIgnoreCase(provider)) {
    Map<String, Object> response = (Map<String, Object>) attributes.get("response");
    return (String) response.get("id"); // Naver는 "response.id"
  }
  return null;
}
```

**로그인 루프 문제 해결**:
```java
// SecurityConfig.java에서 /login, /cfJoinform 경로 permitAll()
.authorizeHttpRequests(auth -> auth
  .requestMatchers("/", "/cfMain", "/recipe/**", "/login", "/cfJoinform", "/cfjoinId")
  .permitAll()
  .requestMatchers("/chatbot/**", "/mypage/**", "/recipe/insert")
  .authenticated()
);
```

---

### 4️⃣ 문제: 챗봇이 응답을 안 함

**증상**: 챗봇 메시지 전송 후 무한 로딩 또는 "서버 오류" 반환

**원인 분석**:
- `EnhancedChatbotController`에서 예외 처리 미흡
- OpenKoreanText 형태소 분석 오류
- 데이터베이스 조회 실패 (쿼리 오류)
- 세션 정보 누락

**해결 방법**:
```java
// EnhancedChatbotController.java - 안정적 응답 처리
@PostMapping("/chatbot/message")
public ResponseEntity<Map<String, Object>> handleMessage(
    @RequestParam String message,
    HttpSession session) {
  
  try {
    Integer user_idx = (Integer) session.getAttribute("user_idx");
    
    if (user_idx == null) {
      return ResponseEntity.ok(Map.of(
        "success", false,
        "message", "로그인이 필요합니다."
      ));
    }
    
    // 1) 형태소 분석 (오류 처리)
    String foodKeyword = null;
    try {
      foodKeyword = extractFoodKeyword(message);
    } catch (Exception e) {
      log.warn("형태소 분석 실패: {}", e.getMessage());
      foodKeyword = null;
    }
    
    // 2) 레시피 검색 (폴백 있음)
    List<Board> recipes = new ArrayList<>();
    if (foodKeyword != null && !foodKeyword.isEmpty()) {
      try {
        recipes = boardMapper.searchAllergyFreeRecipes(
          foodKeyword,
          getUserAllergyIds(user_idx),
          5
        );
      } catch (Exception e) {
        log.error("레시피 검색 실패: {}", e.getMessage());
      }
    }
    
    // 3) 응답 구성
    String botResponse = generateResponse(recipes, foodKeyword);
    
    // 4) 대화 저장
    try {
      saveChatMessage(user_idx, message, botResponse, "recipe_search");
    } catch (Exception e) {
      log.warn("대화 저장 실패: {}", e.getMessage());
      // 저장 실패는 응답에 영향을 주지 않음
    }
    
    return ResponseEntity.ok(Map.of(
      "success", true,
      "message", botResponse,
      "recipes", recipes
    ));
    
  } catch (Exception e) {
    log.error("챗봇 처리 오류", e);
    return ResponseEntity.ok(Map.of(
      "success", false,
      "message", "일시적 오류가 발생했습니다. 다시 시도해주세요."
    ));
  }
}
```

**브라우저 콘솔에서 디버깅**:
```javascript
// cfChatbot.jsp - 자바스크립트 디버깅
document.getElementById('sendBtn').addEventListener('click', function() {
  const message = document.getElementById('userInput').value;
  
  console.log('메시지 전송:', message); // ← 로그 확인
  
  fetch('/chatbot/message', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: 'message=' + encodeURIComponent(message)
  })
  .then(res => res.json())
  .then(data => {
    console.log('응답:', data); // ← 응답 로그 확인
    if (data.success) {
      // 채팅 추가
    } else {
      alert(data.message);
    }
  })
  .catch(err => console.error('오류:', err)); // ← 네트워크 오류 확인
});
```

---

### 5️⃣ 문제: 데이터베이스 연결 실패

**증상**: "Unable to acquire a Connection from the DataSource" 에러

**원인 분석**:
- MySQL 서버가 실행되지 않음
- application.properties의 DB 설정 오류 (포트, 사용자, 비밀번호)
- UTF-8 인코딩 설정 누락
- 방화벽/네트워크 연결 문제

**해결 방법**:
```bash
# 1) MySQL 서버 실행 확인 (Windows)
net start MySQL80

# 2) MySQL 커맨드라인에서 접속 테스트
mysql -u root -p -h localhost -P 3306

# 3) 데이터베이스 존재 확인
SHOW DATABASES;
USE cookingfree;
SHOW TABLES;
```

```properties
# application.properties - 정확한 설정
spring.datasource.url=jdbc:mysql://localhost:3306/cookingfree?characterEncoding=UTF-8&serverTimezone=Asia/Seoul
spring.datasource.username=root
spring.datasource.password=YOUR_PASSWORD
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# 연결 풀 설정
spring.datasource.hikari.maximum-pool-size=5
spring.datasource.hikari.minimum-idle=2
spring.datasource.hikari.connection-timeout=30000
spring.datasource.hikari.idle-timeout=600000
```

**로그 확인**:
```bash
# 애플리케이션 실행 시 로그에서 다음 메시지 확인
# "HikariPool-1 - Starting..."  ← 연결 풀 정상
# "HikariPool-1 - Pool stats..." ← 연결 활성
```

---

## 📊 데이터 규모

- **레시피 수**: 20만 개
- **식재료 수**: 6만 개
- **알레르기 종류**: 16가지
- **MySQL FULLTEXT 인덱스**: 빠른 전문 검색

- [만개의레시피](https://www.10000recipe.com/) 사이트 크롤링하여 데이터 수집 및 정리하였습니다.

---

## 🧪 테스트

```bash
# JUnit 테스트 실행
mvn test

# 특정 테스트 클래스만 실행
mvn test -Dtest=CookingFreeTest
```

---

## 📝 라이선스

MIT License

---

## 👥 팀 정보

- **프로젝트명**: CookingFree
- **팀**: SMHRD KDT 언어지능 4팀
- **기간**: 2025.07.18 ~ 2025.08.01 (2주)
- **팀 규모**: 5명 팀장 : 이명준_백엔드 및 DB 총괄  팀원 : 배광한_프론트 총괄 , 유 선 , 김민준, 임하현 
- **GitHub**: [github.com/2025-SMHRD-KDT-LangIntelligence-4/CookingFree](https://github.com/2025-SMHRD-KDT-LangIntelligence-4/CookingFree)

---

---

**Happy Cooking! 🍳**
