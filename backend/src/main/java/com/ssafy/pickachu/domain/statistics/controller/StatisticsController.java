package com.ssafy.pickachu.domain.statistics.controller;

import com.ssafy.pickachu.domain.auth.PrincipalDetails;
import com.ssafy.pickachu.domain.statistics.response.AverageComparisonRes;
import com.ssafy.pickachu.domain.statistics.response.MyConsumptionRes;
import com.ssafy.pickachu.domain.statistics.response.PeakTimeAgeRes;
import com.ssafy.pickachu.domain.statistics.response.Top3CategoryRes;
import com.ssafy.pickachu.domain.statistics.service.CardHistoryService;
import com.ssafy.pickachu.domain.statistics.service.StatisticsService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@CrossOrigin("*")
@RequestMapping("/statistics")
public class StatisticsController {

    private final StatisticsService statisticsService;
    private final CardHistoryService service;

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
    @GetMapping("/testinsert")
    public String insertData(){return service.saveCardHistories();}

    @Operation(summary = "개인 소비 통계", description = "지난달 소비 내역과 업종 분석, 일자별 소비 금액 합계")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "(message : \"Success\", code : 200)",
                    content = @Content(schema = @Schema(implementation = MyConsumptionRes.class)))
    })
    @GetMapping("/consumption")
    public ResponseEntity<MyConsumptionRes> getConsumption(){return statisticsService.getMyConsumption();}

    @GetMapping("/averagecomparison")
    public ResponseEntity<AverageComparisonRes> getAverageComparison(@AuthenticationPrincipal PrincipalDetails principalDetails){return statisticsService.getAverageComparison(principalDetails);}

}
