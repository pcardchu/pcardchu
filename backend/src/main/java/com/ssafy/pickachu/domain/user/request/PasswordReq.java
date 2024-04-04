package com.ssafy.pickachu.domain.user.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Schema(description = "비밀번호 수정에 대한 요청 DTO")
@Data
public class PasswordReq {
	
	@Schema(description = "비밀번호", example = "비밀번호 해시")
	private String password;
}
