package com.ssafy.pickachu.service;

import com.ssafy.pickachu.dto.top3category.response.Top3CategoryResponse;
import org.springframework.http.ResponseEntity;

public interface Top3CategoryService {

    ResponseEntity<Top3CategoryResponse> getTop3Categories();
    // 추가 비즈니스 로직 구현
}
