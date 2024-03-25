package com.ssafy.pickachu.domain.user.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;

@RequiredArgsConstructor
@RestController
@RequestMapping("/user")
@Tag(name = "User API", description = "User 관련 API")
public class UserController {

    @GetMapping("/test")
    @Operation(summary = "테스트", description = "스웨거 테스트")
    @ApiResponses(value={
            @ApiResponse(responseCode = "200", description = "테스트 성공", content = @Content(mediaType = "application/json"))
    })
    public String test(){
        return "Test";
    }

//    @PostMapping("join")
//    public ResponseEntity<?> join(@RequestBody User user){
//        String result = userService.join(user);
//
//        return new ResponseEntity<>(result, HttpStatus.CREATED);
//    }
//
//    @GetMapping("login/google")
//    public ResponseEntity<?> login(HttpServletResponse response) throws IOException {
//        String redirectUri = "oauth2/authorization/google";
//
//        response.sendRedirect(redirectUri);
//        return new ResponseEntity<>(redirectUri, HttpStatus.CREATED);
//    }

}
