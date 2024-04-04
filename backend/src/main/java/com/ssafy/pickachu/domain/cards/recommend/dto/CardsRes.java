package com.ssafy.pickachu.domain.cards.recommend.dto;


import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@Builder
public class CardsRes {
    private String cardId;
    private String cardName;
    private String cardImg;
    private String cardContent;
}
