package com.ssafy.pickachu.domain.cards.recommend.dto;


import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class SimpleCard {
    String cardId;      // cards
    String cardImg;     // cards
    String cardName;    // cards
    String cardCompany; // cards
    String cardContent; // cardInfo
    int useMoney;
}
