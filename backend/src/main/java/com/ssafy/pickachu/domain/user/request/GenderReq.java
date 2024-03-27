package com.ssafy.pickachu.domain.user.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

@Schema(description = "성별 수정에 대한 요청 DTO")
@Data
public class GenderReq {
	
	@Schema(description = "성별", nullable = false, example = "M")
	@NotEmpty(message = "성별을 입력해주세요. (M, F)")
	private String gender;
}
