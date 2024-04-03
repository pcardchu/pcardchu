package com.ssafy.pickachu.domain.cards.personalcards.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@Builder
public class RecommendPersonalCardRes {
    String name;
    List<RecommendCard> discount;
}
