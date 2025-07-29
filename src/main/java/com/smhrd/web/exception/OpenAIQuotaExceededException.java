package com.smhrd.web.exception;

    public class OpenAIQuotaExceededException extends RuntimeException {
        public OpenAIQuotaExceededException() {
            super("OpenAI API quota exceeded");
        }
        public OpenAIQuotaExceededException(String message) {
            super(message);
        }
        public OpenAIQuotaExceededException(String message, Throwable cause) {
            super(message, cause);
        }
    }
