package com.ssafy.pickachu.global.exception;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum ErrorCode {
    // JWT Token
    EXPIRED_TOKEN(403, "JWT-ERR-404", "ExpiredJwtException: 만료된 토큰입니다."),
    INVALID_SIGNATURE_TOKEN(403, "JWT-ERR-404", "SignatureException: 서명 검증에 실패하였습니다."),
    MALFORMED_TOKEN(403, "JWT-ERR-404", "MalformedJwtException: 잘못된 형식입니다."),
    UNSUPPORTED_TOKEN(403, "JWT-ERR-404", "UnsupportedJwtException: 지원하지 않는 토큰 형식입니다."),
    ILLEGAL_ARG_TOKEN(403, "JWT-ERR-404", "IllegalArgumentException: 토큰 값이 비었거나 null 입니다."),

    // User
    USER_NOT_FOUND(404, "USER-ERR", "UserNotFoundException: 잘못된 유저 정보입니다.");

    private int status;
    private String code;
    private String message;
}
