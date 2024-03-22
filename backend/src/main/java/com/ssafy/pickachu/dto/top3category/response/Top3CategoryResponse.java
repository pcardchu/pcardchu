package com.ssafy.pickachu.dto.top3category.response;

import com.ssafy.pickachu.dto.top3category.dto.Top3Category;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class Top3CategoryResponse {
    @Schema(description = "상태 코드", example = "200")
    private int code;
    @Schema(description = "상태 메세지", example = "Success")
    private String message;
    @Schema(description = "데이터")
    public List<Top3Category> data;

    public static Top3CategoryResponse createTop3CategoryResponse(int code, String message, List<Top3Category> data){
        return Top3CategoryResponse.builder()
                .code(code)
                .message(message)
                .data(data)
                .build();
    }
}
