package com.ssafy.pickachu.domain.user.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Schema(description = "토큰 재발급에 대한 요청 DTO")
@Data
public class TokenReissueReq {
	private boolean flagFirst;
	private String refreshToken;
}
