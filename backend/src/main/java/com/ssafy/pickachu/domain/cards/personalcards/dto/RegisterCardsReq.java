package com.ssafy.pickachu.domain.cards.personalcards.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
@Builder
public class RegisterCardsReq {

    String cardCompany;     // 카드 회사
    String cardNo;          // 개인 카드 번호
    String cardCompanyId;   // 카드회사 아이디
    String cardCompanyPw;   // 카드회사 비밀번호

}
