package com.ssafy.pickachu.domain.cards.personalcards.dto;

import com.ssafy.pickachu.domain.cards.recommend.dto.SimpleCard;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@Builder
public class RecommendCard {
    String category;
    int total;
    List<SimpleCard> card;


}
