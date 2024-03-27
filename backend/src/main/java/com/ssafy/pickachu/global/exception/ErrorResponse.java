package com.ssafy.pickachu.global.exception;

import jakarta.validation.ConstraintViolation;
import lombok.AccessLevel;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.validation.BindingResult;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;


@NoArgsConstructor(access = AccessLevel.PROTECTED)
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

    public ErrorResponse(ErrorCode errorCode, String message){
        this.status = errorCode.getStatus();
        this.message = message;
        this.code = errorCode.getCode();
    }

    public static ErrorResponse of(final ErrorCode code, final String missingParameterName) {
        return new ErrorResponse(code, missingParameterName);
    }

    public static ErrorResponse of(final ErrorCode code) {
        return new ErrorResponse(code);
    }



    public static ErrorResponse of(MethodArgumentTypeMismatchException e) {
         return new ErrorResponse(ErrorCode.INPUT_TYPE_INVALID);
    }

}