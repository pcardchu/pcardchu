package com.ssafy.pickachu.domain.user.dto;

import lombok.Data;

@Data
public class KakaoPayloadDto {
    private String iss;
    private String aud;
    private String sub; // 회원번호
    private Integer iat;
    private Integer exp;
    private Integer auth_time;
    private String nonce;
    private String nickname;
    private String picture;
    private String email;
}
