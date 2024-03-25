package com.ssafy.pickachu.service;

import com.ssafy.pickachu.dto.top3category.response.PeakTimeAgeResponse;
import com.ssafy.pickachu.dto.top3category.response.Top3CategoryResponse;
import org.springframework.http.ResponseEntity;

public interface StatisticsService {

    ResponseEntity<Top3CategoryResponse> getTop3Categories();

    ResponseEntity<PeakTimeAgeResponse> getPeakTimeAge();
}
