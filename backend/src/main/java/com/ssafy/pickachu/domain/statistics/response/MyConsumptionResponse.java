package com.ssafy.pickachu.domain.statistics.response;

import com.ssafy.pickachu.domain.statistics.dto.MyConsumption;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class MyConsumptionResponse {
    @Schema(description = "상태 코드", example = "200")
    private int code;
    @Schema(description = "상태 메세지", example = "Success")
    private String message;
    @Schema(description = "데이터")
    public MyConsumption data;

    public static MyConsumptionResponse createMyConsumptionResponse(int code, String message, MyConsumption data){
        return MyConsumptionResponse.builder()
                .code(code)
                .message(message)
                .data(data)
                .build();
    }
}
