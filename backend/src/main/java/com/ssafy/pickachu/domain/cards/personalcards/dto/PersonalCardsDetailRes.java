package com.ssafy.pickachu.domain.cards.personalcards.dto;


import com.ssafy.pickachu.domain.statistics.dto.SimpleCardHistory;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.Map;

@Getter
@Setter
@Builder
public class PersonalCardsDetailRes {
    String cardImage; // Cards.imageUrl > 이미지 주소
    String cardName;  // Cards.cardName > 신세계 THE S VIP
    String cardCompany; // Cards.organization_id > 삼성카드
    int useMoneyMonth; // 이번달 사용 금액
    List<SimpleCardHistory> todayUseHistory; // 어제 00시 ~ 지금 사용 내역
    Map<String, Integer> useBenefit;    //  사용중 카드 혜택 가지고 와서 이번달 혜택 금액 나타내주기


}
