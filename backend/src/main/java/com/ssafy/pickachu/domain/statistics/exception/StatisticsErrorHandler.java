package com.ssafy.pickachu.domain.statistics.exception;

import com.google.gson.Gson;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

@RestControllerAdvice
@RequiredArgsConstructor
public class StatisticsErrorHandler {

    private final Gson gson;
    private static final HttpHeaders JSON_HEADERS;
    static {
        JSON_HEADERS = new HttpHeaders();
        JSON_HEADERS.add(HttpHeaders.CONTENT_TYPE, "application/json");
    }

    // 에러 메시지와 에러 코드를 JSON으로 변환하는 메서드
    public String stringToGson(int errorCode, String message) {
        Map<String, String> response = new HashMap<>();
        response.put("status", String.valueOf(errorCode));
        response.put("message", message);
        return gson.toJson(response);
    }
    @ExceptionHandler(UserInfoUnavailableException.class)
    public ResponseEntity<String> handleUserInfoUnavailableException(UserInfoUnavailableException e) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
                .headers(JSON_HEADERS)
                .body(stringToGson(HttpStatus.NOT_FOUND.value(), e.getMessage()));
    }
}
