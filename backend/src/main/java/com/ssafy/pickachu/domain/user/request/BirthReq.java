package com.ssafy.pickachu.domain.user.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.sql.Date;

@Schema(description = "생일 수정에 대한 요청 DTO")
@Data
public class BirthReq {
	
	@Schema(description = "생일", nullable = false)
	private Date birth;
}