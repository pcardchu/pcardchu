package com.ssafy.pickachu.domain.user.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Pattern;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Schema(description = "성별 수정에 대한 요청 DTO")
@Data
public class GenderDto {
	
	@Schema(description = "성별", nullable = false, example = "M")
	@NotEmpty(message = "성별을 입력해주세요. (M, F)")
	private String gender;
}
