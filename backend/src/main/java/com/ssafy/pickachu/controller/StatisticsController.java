package com.ssafy.pickachu.controller;

import com.ssafy.pickachu.dto.top3category.response.PeakTimeAgeResponse;
import com.ssafy.pickachu.dto.top3category.response.Top3CategoryResponse;
import com.ssafy.pickachu.service.StatisticsService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@CrossOrigin("*")
@RequestMapping("api/statistics")
public class StatisticsController {

    private final StatisticsService statisticsService;

    @Operation(summary = "전체 트렌드 통계", description = "연령별 상위 3개 업종 카테고리")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "(message : \"Success\", code : 200)",
                    content = @Content(schema = @Schema(implementation = Top3CategoryResponse.class)))
    })
    @GetMapping("/top3category")
    public ResponseEntity<Top3CategoryResponse> getTop3Categories() {
        return statisticsService.getTop3Categories();
    }

    @Operation(summary = "전체 트렌드 통계", description = "현재 시간대 많이 소비하는 나이대")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "(message : \"Success\", code : 200)",
                    content = @Content(schema = @Schema(implementation = PeakTimeAgeResponse.class)))
    })
    @GetMapping("/peaktimeage")
    public ResponseEntity<PeakTimeAgeResponse> getPeakTimeAge(){
        return statisticsService.getPeakTimeAge();
    }
}
