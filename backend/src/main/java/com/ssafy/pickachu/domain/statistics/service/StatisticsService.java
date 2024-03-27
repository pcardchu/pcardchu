package com.ssafy.pickachu.domain.statistics.service;

import com.ssafy.pickachu.domain.auth.PrincipalDetails;
import com.ssafy.pickachu.domain.statistics.response.AverageComparisonRes;
import com.ssafy.pickachu.domain.statistics.response.MyConsumptionRes;
import com.ssafy.pickachu.domain.statistics.response.PeakTimeAgeRes;
import com.ssafy.pickachu.domain.statistics.response.Top3CategoryRes;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;

public interface StatisticsService {

    ResponseEntity<Top3CategoryRes> getTop3Categories();

    ResponseEntity<PeakTimeAgeRes> getPeakTimeAge();

    ResponseEntity<MyConsumptionRes> getMyConsumption();

    ResponseEntity<AverageComparisonRes> getAverageComparison(@AuthenticationPrincipal PrincipalDetails principalDetails);
}
