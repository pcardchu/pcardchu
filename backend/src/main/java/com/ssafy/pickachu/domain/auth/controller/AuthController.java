package com.ssafy.pickachu.domain.auth.controller;

import com.ssafy.pickachu.domain.auth.jwt.JwtUtil;
import com.ssafy.pickachu.domain.auth.response.TestTokenRes;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RequiredArgsConstructor
@RestController
@RequestMapping("/auth-test")
@Tag(name = "Auth Test", description = "테스트용 JWT 발급")
public class AuthController {

    private final JwtUtil jwtUtil;

    @GetMapping("/first")
    @Operation(summary = "1차 JWT 발급", description = "1차 JWT 발급")
    @ApiResponses(value={
            @ApiResponse(responseCode = "200", description = "테스트 성공", content = @Content(mediaType = "application/json"))
    })
    public ResponseEntity<?> test1(){
        TestTokenRes tokenRes = TestTokenRes.builder()
                .accessToken(jwtUtil.createJwtForAccess(1L, true))
                .build();
        return new ResponseEntity<>(tokenRes, HttpStatus.OK);
    }

    @GetMapping("/second")
    @Operation(summary = "2차 JWT 발급", description = "2차 JWT 발급")
    @ApiResponses(value={
            @ApiResponse(responseCode = "200", description = "테스트 성공", content = @Content(mediaType = "application/json"))
    })
    public ResponseEntity<?> test2(){
        TestTokenRes tokenRes = TestTokenRes.builder()
                .accessToken(jwtUtil.createJwtForAccess(1L, false))
                .build();
        return new ResponseEntity<>(tokenRes, HttpStatus.OK);
    }

}
