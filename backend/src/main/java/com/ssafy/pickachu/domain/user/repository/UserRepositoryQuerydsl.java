package com.ssafy.pickachu.domain.user.repository;

import com.ssafy.pickachu.domain.user.dto.UserInfoDto;

public interface UserRepositoryQuerydsl {
    UserInfoDto getUserInfo(Long id);
}
