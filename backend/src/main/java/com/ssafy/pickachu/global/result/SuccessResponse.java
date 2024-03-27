package com.ssafy.pickachu.global.result;

public class SuccessResponse {

    private final int status;
    private final String message;
    private final Object data;

    public SuccessResponse(SuccessCode successCode, Object data) {
        this.status = successCode.getStatus();
        this.message = successCode.getMessage();
        this.data = data;
    }
    public static SuccessResponse of(SuccessCode successCode, Object data) {return new SuccessResponse(successCode, data);}
    public static SuccessResponse of(SuccessCode successCode) {return new SuccessResponse(successCode, "");}
}
