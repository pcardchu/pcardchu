package com.ssafy.pickachu.domain.user.service;

import com.ssafy.pickachu.domain.user.dto.BasicInfoDto;
import com.ssafy.pickachu.domain.user.dto.IdTokenDto;

import java.sql.Date;
import java.util.Map;

public interface UserService {
    Map<String, Object> loginWithKakao(IdTokenDto idTokenDto);
    boolean updateBasicInfo(Long id, BasicInfoDto basicInfoDto);
    boolean updateGender(Long id, String gender);
    boolean updateBirth(Long id, Date birth);
}
