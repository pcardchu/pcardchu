package com.ssafy.pickachu.domain.user.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Schema(description = "1차 JWT 발급을 위한 요청 DTO")
@Data
public class IdTokenReq {
    private String encryptedIdToken;
    private String base64IV;
}
