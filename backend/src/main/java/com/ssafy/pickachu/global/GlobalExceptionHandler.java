package com.ssafy.pickachu.global;

import com.ssafy.pickachu.domain.user.exception.TokenNotMatchedException;
import com.ssafy.pickachu.domain.user.exception.UserNotFoundException;
import com.ssafy.pickachu.global.exception.ErrorCode;
import com.ssafy.pickachu.global.exception.ErrorException;
import com.ssafy.pickachu.global.exception.ErrorResponse;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.MalformedJwtException;
import io.jsonwebtoken.UnsupportedJwtException;
import io.jsonwebtoken.security.SignatureException;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import jakarta.validation.ConstraintViolationException;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.validation.BindException;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MissingRequestCookieException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.multipart.support.MissingServletRequestPartException;

import static com.ssafy.pickachu.global.exception.ErrorCode.*;
import static org.springframework.http.HttpStatus.BAD_REQUEST;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(UserNotFoundException.class)
    protected ResponseEntity<?> handleUserNotFoundException(UserNotFoundException ex) {
        ErrorResponse response = new ErrorResponse(USER_NOT_FOUND);
        return new ResponseEntity<>(response, HttpStatusCode.valueOf(response.getStatus()));
    }

    @ExceptionHandler(TokenNotMatchedException.class)
    protected ResponseEntity<?> handleTokenNotMatchedException(TokenNotMatchedException ex) {
        ErrorResponse response = new ErrorResponse(TOKEN_NOT_MATCHED);
        return new ResponseEntity<>(response, HttpStatusCode.valueOf(response.getStatus()));
    }

    @ExceptionHandler(ExpiredJwtException.class)
    protected ResponseEntity<?> handleExpiredJwtException(ExpiredJwtException ex) {
        ErrorResponse response = new ErrorResponse(EXPIRED_TOKEN);
        return new ResponseEntity<>(response, HttpStatusCode.valueOf(response.getStatus()));
    }

    @ExceptionHandler(SignatureException.class)
    protected ResponseEntity<?> handleSignatureException(SignatureException ex) {
        ErrorResponse response = new ErrorResponse(INVALID_SIGNATURE_TOKEN);
        return new ResponseEntity<>(response, HttpStatusCode.valueOf(response.getStatus()));
    }

    @ExceptionHandler(MalformedJwtException.class)
    protected ResponseEntity<?> handleMalformedJwtException(MalformedJwtException ex) {
        ErrorResponse response = new ErrorResponse(MALFORMED_TOKEN);
        return new ResponseEntity<>(response, HttpStatusCode.valueOf(response.getStatus()));
    }

    @ExceptionHandler(UnsupportedJwtException.class)
    protected ResponseEntity<?> handleUnsupportedJwtException(UnsupportedJwtException ex) {
        ErrorResponse response = new ErrorResponse(UNSUPPORTED_TOKEN);
        return new ResponseEntity<>(response, HttpStatusCode.valueOf(response.getStatus()));
    }

    @ExceptionHandler(IllegalArgumentException.class)
    protected ResponseEntity<?> handleIllegalArgumentException(IllegalArgumentException ex) {
        ErrorResponse response = new ErrorResponse(ILLEGAL_ARG_TOKEN);
        return new ResponseEntity<>(response, HttpStatusCode.valueOf(response.getStatus()));
    }

    @ExceptionHandler
    protected ResponseEntity<ErrorResponse> handleMissingServletRequestParameterException(
        //http요청 파라미터 누락
        MissingServletRequestParameterException e) {
        final ErrorResponse response = ErrorResponse.of(INPUT_VALUE_INVALID);
        return new ResponseEntity<>(response, BAD_REQUEST);
    }

    @ExceptionHandler
    protected ResponseEntity<ErrorResponse> handleConstraintViolationException(
        ConstraintViolationException e) {  //객체 제약조건 위반
        final ErrorResponse response = ErrorResponse.of(INPUT_VALUE_INVALID);
        return new ResponseEntity<>(response, BAD_REQUEST);
    }

    @ExceptionHandler
    protected ResponseEntity<ErrorResponse> handleBindException(
        BindException e) { //매개변수 타입 불일치 등 데이터 바인딩 실패
        final ErrorResponse response = ErrorResponse.of(INPUT_VALUE_INVALID);
        return new ResponseEntity<>(response, BAD_REQUEST);
    }

    @ExceptionHandler
    protected ResponseEntity<ErrorResponse> handleMissingServletRequestPartException(
        //@RequestPart(파일업로드) 에서 기대한 파트 누락
        MissingServletRequestPartException e) {
        final ErrorResponse response = ErrorResponse.of(INPUT_VALUE_INVALID);
        return new ResponseEntity<>(response, BAD_REQUEST);
    }

    @ExceptionHandler
    protected ResponseEntity<ErrorResponse> handleMissingServletRequestPartException(
        //@CookieValue에서 기대한 쿠키 누락
        MissingRequestCookieException e) {
        final ErrorResponse response = ErrorResponse.of(INPUT_VALUE_INVALID);
        return new ResponseEntity<>(response, BAD_REQUEST);
    }

    @ExceptionHandler
    protected ResponseEntity<ErrorResponse> handleMethodArgumentTypeMismatchException(
        //컨트롤러 메서드의 매개변수에 전달된 인자의 유형이 예상한 유형과 일치하지 않을 때
        MethodArgumentTypeMismatchException e) {
        final ErrorResponse response = ErrorResponse.of(e);
        return new ResponseEntity<>(response, BAD_REQUEST);
    }

    @ExceptionHandler
    protected ResponseEntity<ErrorResponse> handleHttpMessageNotReadableException(
        HttpMessageNotReadableException e) {  //요청바디 역직렬화 실패
        final ErrorResponse response = ErrorResponse.of(HTTP_MESSAGE_NOT_READABLE);
        return new ResponseEntity<>(response, BAD_REQUEST);
    }

    @ExceptionHandler
    protected ResponseEntity<ErrorResponse> handleHttpRequestMethodNotSupportedException(
        //지원하지 않는 http메서드로 요청 시
        HttpRequestMethodNotSupportedException e) {
        final ErrorResponse response = ErrorResponse.of(METHOD_NOT_ALLOWED);
        return new ResponseEntity<>(response, BAD_REQUEST);
    }

    @ExceptionHandler
    protected ResponseEntity<ErrorResponse> handleBusinessException(
        ErrorException e) { //기타 개발자 정의 예외
        final ErrorCode errorCode = e.getErrorCode();
        final ErrorResponse response = ErrorResponse.of(errorCode);
        return new ResponseEntity<>(response, HttpStatus.valueOf(errorCode.getStatus()));
    }

    @ExceptionHandler
    protected ResponseEntity<ErrorResponse> handleException(Exception e) {
        e.printStackTrace();
        final ErrorResponse response = ErrorResponse.of(INTERNAL_SERVER_ERROR);
        return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
    }
}
