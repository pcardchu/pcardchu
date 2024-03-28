package com.ssafy.pickachu.domain.statistics.response;

import com.ssafy.pickachu.domain.statistics.dto.Top3Category;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class Top3CategoryRes {
    @Schema(description = "상태 코드", example = "200")
    private int status;
    @Schema(description = "상태 메세지", example = "Success")
    private String message;
    @Schema(description = "데이터")
    public List<Top3Category> data;

    public static Top3CategoryRes createTop3CategoryResponse(int code, String message, List<Top3Category> data){
        return Top3CategoryRes.builder()
                .status(code)
                .message(message)
                .data(data)
                .build();
    }
}
