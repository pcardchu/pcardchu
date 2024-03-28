package com.ssafy.pickachu.domain.user.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

@Schema(description = "유저 정보 조회에 대한 응답 DTO")
@Builder
@Data
public class UserInfoRes {
    private String nickname;
    private String birth;
    private String gender;
    private int flagBiometrics;
}
