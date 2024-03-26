package com.ssafy.pickachu.domain.user.controller;

import com.ssafy.pickachu.domain.auth.PrincipalDetails;
import com.ssafy.pickachu.domain.user.dto.BasicInfoDto;
import com.ssafy.pickachu.domain.user.dto.BirthDto;
import com.ssafy.pickachu.domain.user.dto.GenderDto;
import com.ssafy.pickachu.domain.user.dto.IdTokenDto;
import com.ssafy.pickachu.domain.user.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
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
    public ResponseEntity<?> loginWithKakao(@RequestBody IdTokenDto idTokenDto){

        Map<String, Object> result = userService.loginWithKakao(idTokenDto);

        // 예외 처리 필요
        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer "+result.get("jwt"));

        if (!(boolean) result.get("flag_basicInfo")){
            return new ResponseEntity<>(headers, HttpStatus.CREATED);
        }else{
            return new ResponseEntity<>(headers, HttpStatus.OK);
        }
    }

    @Operation(summary = "초기 정보 입력", description = "회원 가입 후 성별, 생일, 비밀번호 입력")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "초기 정보 입력 성공"),
            @ApiResponse(responseCode = "400", description = "초기 정보 입력 실패") })
    @PatchMapping("/basic-info")
    public ResponseEntity<?> updateBasicInfo(@AuthenticationPrincipal PrincipalDetails principalDetails, @RequestBody BasicInfoDto  basicInfoDto){

        Long id = principalDetails.getUserDto().getId();

        Boolean result = userService.updateBasicInfo(id, basicInfoDto);

        if (result){
            return new ResponseEntity<>(HttpStatus.OK);
        }else{
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }

    }

    @Operation(summary = "비밀번호 입력", description = "앱 내 6자리 비밀번호 검증")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "로그인 성공"),
            @ApiResponse(responseCode = "400", description = "로그인 실패") })
    @PatchMapping("/login/password")
    public ResponseEntity<?> loginWithPassword(@RequestBody String shortPw){

        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Operation(summary = "성별 수정", description = "회원 정보 수정 - 성별")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "성별 수정 성공"),
            @ApiResponse(responseCode = "400", description = "성별 수정 실패") })
    @PatchMapping("/gender")
    public ResponseEntity<?> updateGender(@AuthenticationPrincipal PrincipalDetails principalDetails, @RequestBody GenderDto genderDto){

        Long id = principalDetails.getUserDto().getId();

        Boolean result = userService.updateGender(id, genderDto.getGender());

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
    public ResponseEntity<?> updateBirth(@AuthenticationPrincipal PrincipalDetails principalDetails, @RequestBody BirthDto birthDto){

        Long id = principalDetails.getUserDto().getId();

        Boolean result = userService.updateBirth(id, birthDto.getBirth());

        if (result){
            return new ResponseEntity<>(HttpStatus.OK);
        }else{
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }

    }
}
