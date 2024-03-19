package com.ssafy.pickachu.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

@Configuration
public class CorsConfig {

    @Bean
    public CorsFilter corsFilter(){
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        CorsConfiguration configuration = new CorsConfiguration();
        // 서버 응답 JSON을 JS에서 처리할 수 있게 할 것인가 -> false이면 JS로 요청 시 응답이 오지 않음
//        configuration.setAllowCredentials(true);
        // 모든 IP에 응답을 허용하겠다
        configuration.addAllowedOrigin("*");
        // 모든 헤더에 응답을 허용하겠다
        configuration.addAllowedHeader("*");
        // POST, GET, DELETE, PATCH 요청을 허용하겠다
        configuration.addAllowedMethod("*");
        source.registerCorsConfiguration("/api/**", configuration);
        return new CorsFilter(source);
    }
}
