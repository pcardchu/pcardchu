package com.ssafy.pickachu.domain.user.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

@Schema(description = "비밀번호 수정에 대한 요청 DTO")
@Data
public class PasswordDto {
	
	@Schema(description = "비밀번호", nullable = false, example = "해시")
	private String password;
}
