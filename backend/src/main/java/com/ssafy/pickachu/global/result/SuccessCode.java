package com.ssafy.pickachu.global.result;


import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum SuccessCode {

    // 테스트용
    TEST_SUCCESS(200, "테스트 응답 코드 입니다."),

    //PersonalCards
    PERSONAL_CARDS_LIST_SUCCESS(200, "개인 카드 리스트 조회 성공하였습니다."),
    //RecommendCards
    GET_CATEGORY_CARDS_LIST_SUCCESS(200, "카테고리 카드 리스트 조회에 성공하였습니다.")

    ;
    private final int status;
    private final String message;
}