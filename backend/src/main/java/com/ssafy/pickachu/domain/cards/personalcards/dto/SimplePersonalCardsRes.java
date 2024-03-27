package com.ssafy.pickachu.domain.cards.personalcards.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class SimplePersonalCardsRes {
    String cardsId;
    String name;
    String cardNo;
    String cardImage;
}
