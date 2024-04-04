package com.ssafy.pickachu.domain.user.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.sql.Date;

@Schema(description = "초기 정보 입력에 대한 요청 DTO")
@Data
public class BasicInfoReq {

	@Schema(example = "남성")
	private String gender;
	@Schema(example = "1997-01-10")
	private Date birth;
	@Schema(example = "비밀번호 해시")
	private String shortPw;
}
