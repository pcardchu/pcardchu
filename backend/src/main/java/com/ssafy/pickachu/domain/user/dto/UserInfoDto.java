package com.ssafy.pickachu.domain.user.dto;

import com.ssafy.pickachu.domain.user.response.UserInfoRes;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;
import java.text.SimpleDateFormat;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class UserInfoDto {
    private String nickname;
    private Date birth;
    private String gender;
    private int flagBiometrics;

    public UserInfoRes toUserInfoRes() {

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy.MM.dd");
        String birthRes = dateFormat.format(birth);

        UserInfoRes userInfoRes = UserInfoRes.builder()
                .nickname(nickname)
                .birth(birthRes)
                .gender(gender)
                .flagBiometrics(flagBiometrics).build();

        return userInfoRes;
    }
}
