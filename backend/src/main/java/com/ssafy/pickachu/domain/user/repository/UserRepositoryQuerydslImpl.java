package com.ssafy.pickachu.domain.user.repository;

import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.ssafy.pickachu.domain.cards.personalcards.entity.QPersonalCards;
import com.ssafy.pickachu.domain.user.dto.UserInfoDto;
import lombok.RequiredArgsConstructor;

import java.util.List;

import static com.ssafy.pickachu.domain.user.entity.QUser.user;

@RequiredArgsConstructor
public class UserRepositoryQuerydslImpl implements UserRepositoryQuerydsl {


    private final JPAQueryFactory jpaQueryFactory;

    @Override
    public UserInfoDto getUserInfo(Long id) {
        UserInfoDto userInfoDto = jpaQueryFactory
                .select(Projections.bean(UserInfoDto.class,
                        user.nickname.as("nickname"),
                        user.birth.as("birth"),
                        user.gender.as("gender"),
                        user.flagBiometrics.as("flagBiometrics")))
                .from(user)
                .where(user.id.eq(id))
                .fetchOne();

        return userInfoDto;
    }
}
