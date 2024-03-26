package com.ssafy.pickachu.global.exception;

import lombok.Data;

@Data
public class ErrorResponse {
    private int status;
    private String message;
    private String code;

    public ErrorResponse(ErrorCode errorCode){
        this.status = errorCode.getStatus();
        this.message = errorCode.getMessage();
        this.code = errorCode.getCode();
    }
}
