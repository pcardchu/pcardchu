package com.ssafy.pickachu.domain.cards.recommend.dto;


import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@Builder
public class CardsRes {
    private String id;
    private String cardName;
    private String imageUrl;
    private String simpleBenefit;


}
