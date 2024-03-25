package com.ssafy.pickachu.domain.cards.recommend.repository;

import com.ssafy.pickachu.domain.cards.recommend.dto.CardsListPage;
import com.ssafy.pickachu.domain.cards.recommend.dto.CardsListReq;

import java.util.List;

public interface CardsAggregation {

    CardsListPage GetCardsCategoryList(CardsListReq cardsListReq, List<String> cardsRanking);


}
