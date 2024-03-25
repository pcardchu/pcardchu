package com.ssafy.pickachu.domain.statistics.service;

import com.ssafy.pickachu.domain.statistics.response.PeakTimeAgeResponse;
import com.ssafy.pickachu.domain.statistics.response.Top3CategoryResponse;
import org.springframework.http.ResponseEntity;

public interface StatisticsService {

    ResponseEntity<Top3CategoryResponse> getTop3Categories();

    ResponseEntity<PeakTimeAgeResponse> getPeakTimeAge();
}
