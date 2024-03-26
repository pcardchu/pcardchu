package com.ssafy.pickachu.global.exception;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Slf4j
@Component
public class ExceptionUtil {
    public void setErrorResponse(HttpServletResponse response, ErrorCode errorCode) throws IOException {
        ObjectMapper objectMapper = new ObjectMapper();
        ErrorResponse errorResponse = new ErrorResponse(errorCode);

        response.setContentType("application/json;charset=UTF-8");
        response.setStatus(errorCode.getStatus());
        response.getWriter().write(objectMapper.writeValueAsString(errorResponse));
        log.error(errorResponse.getMessage());
    }
}
