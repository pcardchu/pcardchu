package com.ssafy.pickachu.domain.user.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

@Schema(description = "2차 토큰 발급에 대한 응답 DTO")
@Builder
@Data
public class SecondTokenRes {
    private String accessToken;
    private String refreshToken;
}
