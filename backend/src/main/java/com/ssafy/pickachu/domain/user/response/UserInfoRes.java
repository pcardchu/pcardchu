package com.ssafy.pickachu.domain.user.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

@Schema(description = "유저 정보 조회에 대한 응답 DTO")
@Builder
@Data
public class UserInfoRes {
    @Schema(example = "곤이")
    private String nickname;
    @Schema(example = "1997-01-10")
    private String birth;
    @Schema(example = "남성")
    private String gender;
    @Schema(example = "0")
    private int flagBiometrics;
}
