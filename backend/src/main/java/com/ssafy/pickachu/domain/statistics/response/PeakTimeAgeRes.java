package com.ssafy.pickachu.domain.statistics.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class PeakTimeAgeRes {
    @Schema(description = "상태 코드", example = "200")
    private int status;
    @Schema(description = "상태 메세지", example = "Success")
    private String message;
    @Schema(description = "데이터")
    public String data;

    public static PeakTimeAgeRes createPeakTimeAgeResponse(int code, String message, String data){
        return PeakTimeAgeRes.builder()
                .status(code)
                .message(message)
                .data(data)
                .build();
    }
}
