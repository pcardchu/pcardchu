package com.ssafy.pickachu.domain.cards.recommend.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.util.List;
@Getter
@Setter
@AllArgsConstructor
public class CardsListPage {
    private List<CardsRes> cardsRes;
    private int pageNumber;
    private int pageSize;
    private boolean last; //다음 페이지 존재 여부
}
