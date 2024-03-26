package com.ssafy.pickachu.domain.user.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

import java.sql.Date;

@Schema(description = "초기 정보 수정에 대한 요청 DTO")
@Data
public class BasicInfoDto {

	@Schema(example = "M")
	private String gender;
	private Date birth;
	private String shortPw;
}
