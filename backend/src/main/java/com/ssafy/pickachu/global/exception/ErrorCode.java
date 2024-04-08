package com.ssafy.pickachu.global.exception;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum ErrorCode {
    //global
    INTERNAL_SERVER_ERROR(500, "GLOBAL-ERR-500","내부 서버 오류입니다."),
    METHOD_NOT_ALLOWED(405, "GLOBAL-ERR-405","허용되지 않은 HTTP method입니다."),
    INPUT_VALUE_INVALID(400, "GLOBAL-ERR-400","유효하지 않은 입력입니다."),
    INPUT_TYPE_INVALID(400, "GLOBAL-ERR-400","입력 타입이 유효하지 않습니다."),
    HTTP_MESSAGE_NOT_READABLE(400, "GLOBAL-ERR-400","request message body가 없거나, 값 타입이 올바르지 않습니다."),
    HTTP_HEADER_INVALID(400, "GLOBAL-ERR-400","request header가 유효하지 않습니다."),
    ENTITY_NOT_FOUNT(500, "GLOBAL-ERR-500","존재하지 않는 Entity입니다."),
    FORBIDDEN_ERROR(403, "GLOBAL-ERR-403","작업을 수행하기 위한 권한이 없습니다."),
    IS_NOT_IMAGE(400, "GLOBAL-ERR-400","이미지가 아닙니다."),
    HANDLE_ACCESS_DENIED(403, "GLOBAL-ERR-403", "접근이 차단 되었습니다."),
    ILLEGAL_STATE(400, "GLOBAL-ERR-400", "작업에 적절한 상태가 아닙니다."),
    ILLEGAL_ARGUMENT(400, "GLOBAL-ERR-400", "적절한 값이 아닙니다."),
    EXCEPTION(500, "GLOBAL-ERR-500", "exception"),

    // JWT Token
    EXPIRED_TOKEN(401, "JWT-ERR-401", "ExpiredJwtException: 만료된 토큰입니다."),
    INVALID_SIGNATURE_TOKEN(403, "JWT-ERR-403", "SignatureException: 서명 검증에 실패하였습니다."),
    MALFORMED_TOKEN(403, "JWT-ERR-403", "MalformedJwtException: 잘못된 형식입니다."),
    UNSUPPORTED_TOKEN(403, "JWT-ERR-403", "UnsupportedJwtException: 지원하지 않는 토큰 형식입니다."),
    ILLEGAL_ARG_TOKEN(403, "JWT-ERR-403", "IllegalArgumentException: 토큰 값이 비었거나 null 입니다."),
    TOKEN_NOT_MATCHED(404, "JWT-ERR-404", "TokenNotMatchedException: 토큰이 일치하지 않습니다."),

    // User
    USER_NOT_FOUND(404, "USER-ERR", "UserNotFoundException: 잘못된 유저 정보입니다."),

    // Cards
    EXIST_BANK_INFO(400, "CARDS-REGISTER-ERR", "ApiRequest.class : 이미 등록된 은행 입니다."),
    CARDS_NOT_FOUND(400, "FIND-CARDS-ERR", "카드를 찾을 수 없습니다."),
    CARDINFO_NOT_FOUND(400, "FIND-CARDINFO-ERR", "카드 정보를 찾을 수 없습니다."),
    PERSONAL_CARD_NOT_FOUND(400, "FIND-PERSONAL-CARDS-ERR", "개인 카드를 찾을 수 없습니다."),
    USER_DATA_NOT_FOUND(404, "NOT-FOUND-CONSUMPTION-HISTORY", "카드 사용내역이 없습니다."),
    DUPLICATE_CARD_NO(409 , "DUPLICATE-CARD-ERR", "중복된 카드 번호입니다."),
    NOT_MY_CARDS(400, "NOT-MY-CARD", "내 카드가 아닙니다"),
    
    ;
    private int status;
    private String code;
    private String message;
}






