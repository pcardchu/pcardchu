package com.ssafy.pickachu.domain.user.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

@Schema(description = "성별 수정에 대한 요청 DTO")
@Data
public class GenderReq {
	
	@Schema(description = "성별", example = "남성")
	@NotEmpty(message = "성별을 입력해주세요. (남성, 여성)")
	private String gender;
}
