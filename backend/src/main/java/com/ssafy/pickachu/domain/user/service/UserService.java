package com.ssafy.pickachu.domain.user.service;

import com.ssafy.pickachu.domain.user.request.BasicInfoReq;
import com.ssafy.pickachu.domain.user.request.IdTokenReq;
import com.ssafy.pickachu.domain.user.request.TokenReissueReq;
import com.ssafy.pickachu.domain.user.response.SecondTokenRes;
import com.ssafy.pickachu.domain.user.response.UserInfoRes;

import java.sql.Date;
import java.util.Map;

public interface UserService {
    Map<String, Object> loginWithKakao(IdTokenReq idTokenReq);
    Map<String, Object> loginWithPassword(Long id, String shortPw);
    Map<String, Object> loginWithBio(Long id);
    SecondTokenRes reissueToken(TokenReissueReq tokenReissueReq);
    boolean updateBasicInfo(Long id, BasicInfoReq basicInfoReq);
    UserInfoRes getUserInfo(Long id);
    boolean updateFlagBiometrics(Long id, boolean flagBiometrics);
    boolean updateShortPw(Long id, String shortPw);
    boolean updateGender(Long id, String gender);
    boolean updateBirth(Long id, Date birth);
    boolean sendEmail(Long id);
}
