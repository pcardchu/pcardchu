package com.ssafy.pickachu.domain.statistics.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class AverageComparisonRes {
    @Schema(description = "상태 코드", example = "200")
    private int code;
    @Schema(description = "상태 메세지", example = "Success")
    private String message;
    @Schema(description = "데이터")
    public int data;

    public static AverageComparisonRes createPeakTimeAgeResponse(int code, String message, int data){
        return AverageComparisonRes.builder()
                .code(code)
                .message(message)
                .data(data)
                .build();
    }
}
