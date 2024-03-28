package com.ssafy.pickachu.domain.auth.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

@Schema(description = "테스트용 토큰 발급에 대한 응답 DTO")
@Builder
@Data
public class TestTokenRes {
    private String accessToken;
}
