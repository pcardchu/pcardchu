package com.ssafy.pickachu.domain.cards.recommend.dto;


import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class CardsListReq {
    String category;
    int pageNumber;
    int pageSize;
}
