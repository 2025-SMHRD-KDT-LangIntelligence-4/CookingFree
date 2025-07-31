package com.smhrd.web.config;

import org.apache.coyote.ProtocolHandler;
import org.apache.coyote.http11.Http11NioProtocol;
import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory;
import org.springframework.boot.web.server.WebServerFactoryCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class TomcatConfig {

	@Bean
	public WebServerFactoryCustomizer<TomcatServletWebServerFactory> tomcatCustomizer() {
	    return factory -> factory.addConnectorCustomizers(connector -> {
	        // HTTP 본문 크기 제한 해제
	        connector.setMaxPostSize(-1);

	        // multipart 파츠 개수·헤더 크기 설정
	        connector.setProperty("maxPartCount", "-1");        // 파츠 개수 무제한
	        connector.setProperty("maxPartHeaderSize", "10240"); // 헤더 최대 10KB

	        // protocol handler swallow size 해제
	        if (connector.getProtocolHandler() instanceof Http11NioProtocol nio) {
	            nio.setMaxSwallowSize(-1);
	        }
	    });
	}
}
