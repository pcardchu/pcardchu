package com.ssafy.pickachu.domain.statistics.response;

import com.ssafy.pickachu.domain.statistics.dto.AverageGap;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class AverageComparisonRes {
    @Schema(description = "상태 코드", example = "200")
    private int status;
    @Schema(description = "상태 메세지", example = "Success")
    private String message;
    @Schema(description = "데이터")
    public AverageGap data;

    public static AverageComparisonRes createPeakTimeAgeResponse(int code, String message, AverageGap data){
        return AverageComparisonRes.builder()
                .status(code)
                .message(message)
                .data(data)
                .build();
    }
}
