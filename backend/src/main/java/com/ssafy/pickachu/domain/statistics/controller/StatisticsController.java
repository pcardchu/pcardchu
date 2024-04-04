package com.ssafy.pickachu.domain.statistics.controller;

import com.ssafy.pickachu.domain.auth.PrincipalDetails;
import com.ssafy.pickachu.domain.statistics.response.*;
import com.ssafy.pickachu.domain.statistics.service.CardHistoryService;
import com.ssafy.pickachu.domain.statistics.service.StatisticsService;
import com.ssafy.pickachu.global.result.SuccessCode;
import com.ssafy.pickachu.global.result.SuccessResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@CrossOrigin("*")
@RequestMapping("/statistics")
@Tag(name = "Statistics API", description = "빅데이터 분산 처리 통계 API")
public class StatisticsController {

    private final StatisticsService statisticsService;
    private final CardHistoryService cardHistoryService;

    @Operation(summary = "전체 트렌드 통계", description = "연령별 상위 3개 업종 카테고리")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "(message : \"Success\", code : 200)",
                    content = @Content(schema = @Schema(implementation = Top3CategoryRes.class)))
    })
    @GetMapping("/top3category")
    public ResponseEntity<Top3CategoryRes> getTop3Categories() {
        return statisticsService.getTop3Categories();
    }

    @Operation(summary = "전체 트렌드 통계", description = "현재 시간대 많이 소비하는 나이대")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "(message : \"Success\", code : 200)",
                    content = @Content(schema = @Schema(implementation = PeakTimeAgeRes.class)))
    })
    @GetMapping("/peaktimeage")
    public ResponseEntity<PeakTimeAgeRes> getPeakTimeAge(){
        return statisticsService.getPeakTimeAge();
    }

    @Operation(summary = "codef 연동 전 데이터 삽입용임", description = "건들지마시오")
    @GetMapping("/airflow")
    public ResponseEntity<CardHistoryRes> insertData(@RequestHeader("AIRFLOW-API-KEY") String apiKey){return cardHistoryService.saveCardHistoriesByAirflow(apiKey);}

    @Operation(summary = "개인 소비 통계", description = "지난달 소비 내역과 업종 분석, 일자별 소비 금액 합계")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "(message : \"Success\", code : 200)",
                    content = @Content(schema = @Schema(implementation = MyConsumptionRes.class)))
    })
    @GetMapping("/consumption")
    public ResponseEntity<MyConsumptionRes> getConsumption(@AuthenticationPrincipal PrincipalDetails principalDetails){return statisticsService.getMyConsumption(principalDetails);}

    @Operation(summary = "내 또래와 나의 평균 결제금액 차이(%)", description = "지난달 소비내역 기준으로 비교함")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "(message : \"Success\", code : 200)",
                    content = @Content(schema = @Schema(implementation = AverageComparisonRes.class))),
            @ApiResponse(responseCode = "404", description = "(message: \"성별 또는 나이를 찾을 수 없음\", cdoe : 404)")
    })
    @GetMapping("/averagecomparison")
    public ResponseEntity<AverageComparisonRes> getAverageComparison(@AuthenticationPrincipal PrincipalDetails principalDetails){return statisticsService.getAverageComparison(principalDetails);}

    @GetMapping("/popular/card-rank")
    public ResponseEntity<SuccessResponse> GetAgePopularCardRank(){
        return ResponseEntity.ok(SuccessResponse.of(SuccessCode.GET_CARD_AGE_RANK_SUCCESS, cardHistoryService.PopularRank()));
    }
}
