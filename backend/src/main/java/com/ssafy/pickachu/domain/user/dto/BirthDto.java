package com.ssafy.pickachu.domain.user.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

import java.sql.Date;

@Schema(description = "생일 수정에 대한 요청 DTO")
@Data
public class BirthDto {
	
	@Schema(description = "생일", nullable = false)
	private Date birth;
}
