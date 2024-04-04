package com.ssafy.pickachu.domain.user.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.sql.Date;

@Schema(description = "생체 인증 사용 여부 수정에 대한 요청 DTO")
@Data
public class FlagBiometricsReq {
	
	@Schema(description = "생체 인증 사용 여부")
	private boolean flagBiometrics;
}
