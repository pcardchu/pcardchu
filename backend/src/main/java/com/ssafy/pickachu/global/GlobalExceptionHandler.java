package com.ssafy.pickachu.global;

import com.ssafy.pickachu.domain.user.exception.UserNotFoundException;
import com.ssafy.pickachu.global.exception.ErrorCode;
import com.ssafy.pickachu.global.exception.ErrorResponse;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(UserNotFoundException.class)
    public ResponseEntity<?> handleUserNotFoundException(UserNotFoundException ex) {
        ErrorResponse response = new ErrorResponse(ErrorCode.USER_NOT_FOUND);
        return new ResponseEntity<>(response, HttpStatusCode.valueOf(response.getStatus()));
    }

}
