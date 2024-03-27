package com.ssafy.pickachu.domain.user.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.sql.Date;

@Schema(description = "초기 정보 입력에 대한 요청 DTO")
@Data
public class BasicInfoReq {

	@Schema(example = "M")
	private String gender;
	private Date birth;
	private String shortPw;
}
