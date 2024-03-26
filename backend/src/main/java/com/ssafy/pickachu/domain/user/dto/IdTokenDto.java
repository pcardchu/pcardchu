package com.ssafy.pickachu.domain.user.dto;

import lombok.Data;

@Data
public class IdTokenDto {
    private String encryptedIdToken;
    private String base64IV;
}
