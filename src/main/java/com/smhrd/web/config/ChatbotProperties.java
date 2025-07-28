// src/main/java/com/smhrd/web/config/ChatbotProperties.java
package com.smhrd.web.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Component
@ConfigurationProperties(prefix = "chatbot")
public class ChatbotProperties {
    private int responseMaxLength;
    private int sessionTimeout;
    private RateLimit api = new RateLimit();

    public static class RateLimit {
        private boolean enabled;
        private int requestsPerMinute;
        private int requestsPerDay;
        // getters / setters
    }
    // getters / setters
}
