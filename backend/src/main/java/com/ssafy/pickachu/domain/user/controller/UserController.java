package com.ssafy.pickachu.domain.user.controller;

import com.ssafy.pickachu.domain.auth.PrincipalDetails;
import com.ssafy.pickachu.domain.user.request.*;
import com.ssafy.pickachu.domain.user.response.TokenRes;
import com.ssafy.pickachu.domain.user.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RequiredArgsConstructor
@RestController
@RequestMapping("/user")
@Tag(name = "User API", description = "User 관련 API")
public class UserController {

    private final UserService userService;

    @Operation(summary = "카카오 로그인", description = "기존 회원일 경우 로그인, 신규 회원일 경우 회원가입 후 로그인")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "로그인 성공, 초기 정보 입력 완료"),
            @ApiResponse(responseCode = "201", description = "로그인 성공, 초기 정보 입력 필요"),
            @ApiResponse(responseCode = "400", description = "로그인 실패") })
    @PostMapping("/login/kakao")
    public ResponseEntity<?> loginWithKakao(@RequestBody IdTokenReq idTokenReq){

        Map<String, Object> result = userService.loginWithKakao(idTokenReq);


        if (!(boolean) result.get("flag_basicInfo")){
            return new ResponseEntity<>(result.get("token"), HttpStatus.CREATED);
        }else{
            return new ResponseEntity<>(result.get("token"), HttpStatus.OK);
        }
    }

    @Operation(summary = "비밀번호 로그인", description = "앱 내 6자리 비밀번호 로그인")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "로그인 성공"),
            @ApiResponse(responseCode = "400", description = "로그인 실패") })
    @PostMapping("/login/password")
    public ResponseEntity<?> loginWithPassword(@AuthenticationPrincipal PrincipalDetails principalDetails, @RequestBody PasswordReq shortPw){

        Long id = principalDetails.getUserDto().getId();

        Map<String, Object> result = userService.loginWithPassword(id, shortPw.getPassword());

        if ((boolean) result.get("result")){
            return new ResponseEntity<>(result.get("token"), HttpStatus.OK);
        }else{
            return new ResponseEntity<>(result.get("wrongCount"), HttpStatus.BAD_REQUEST);
        }
    }

    @Operation(summary = "JWT 재발급", description = "1차 또는 2차 리프레시 토큰을 받아 JWT 재발급")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "JWT 재발급 성공"),
            @ApiResponse(responseCode = "404", description = "JWT 재발급 실패 - 리프레시 토큰 만료")})
    @PostMapping("/refresh")
    public ResponseEntity<?> reissueToken(@RequestBody TokenReissueReq tokenReissueReq){

        TokenRes tokenRes = userService.reissueToken(tokenReissueReq);

        return new ResponseEntity<>(tokenRes, HttpStatus.OK);

    }


    @Operation(summary = "초기 정보 입력", description = "회원 가입 후 성별, 생일, 비밀번호 입력")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "초기 정보 입력 성공"),
            @ApiResponse(responseCode = "400", description = "초기 정보 입력 실패") })
    @PatchMapping("/basic-info")
    public ResponseEntity<?> updateBasicInfo(@AuthenticationPrincipal PrincipalDetails principalDetails, @RequestBody BasicInfoReq basicInfoReq){

        Long id = principalDetails.getUserDto().getId();

        boolean result = userService.updateBasicInfo(id, basicInfoReq);

        if (result){
            return new ResponseEntity<>(HttpStatus.OK);
        }else{
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }

    }

    @Operation(summary = "6자리 비밀번호 수정", description = "앱 내 6자리 비밀번호 수정")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "초기 정보 입력 성공"),
            @ApiResponse(responseCode = "400", description = "초기 정보 입력 실패") })
    @PatchMapping("/short-pw")
    public ResponseEntity<?> updateShortPw(@AuthenticationPrincipal PrincipalDetails principalDetails, @RequestBody PasswordReq passwordReq){

        Long id = principalDetails.getUserDto().getId();

        boolean result = userService.updateShortPw(id, passwordReq.getPassword());

        if (result){
            return new ResponseEntity<>(HttpStatus.OK);
        }else{
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }

    }

    @Operation(summary = "성별 수정", description = "회원 정보 수정 - 성별")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "성별 수정 성공"),
            @ApiResponse(responseCode = "400", description = "성별 수정 실패") })
    @PatchMapping("/gender")
    public ResponseEntity<?> updateGender(@AuthenticationPrincipal PrincipalDetails principalDetails, @RequestBody GenderReq genderReq){

        Long id = principalDetails.getUserDto().getId();

        boolean result = userService.updateGender(id, genderReq.getGender());

        if (result){
            return new ResponseEntity<>(HttpStatus.OK);
        }else{
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }

    }

    @Operation(summary = "생년월일 수정", description = "회원 정보 수정 - 생년월일")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "생년월일 수정 성공"),
            @ApiResponse(responseCode = "400", description = "생년월일 수정 실패") })
    @PatchMapping("/birth")
    public ResponseEntity<?> updateBirth(@AuthenticationPrincipal PrincipalDetails principalDetails, @RequestBody BirthReq birthReq){

        Long id = principalDetails.getUserDto().getId();

        boolean result = userService.updateBirth(id, birthReq.getBirth());

        if (result){
            return new ResponseEntity<>(HttpStatus.OK);
        }else{
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }

    }
}
