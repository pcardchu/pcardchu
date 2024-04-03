package com.ssafy.pickachu.domain.cards.recommend.repository;

import com.ssafy.pickachu.domain.cards.recommend.dto.CardsListPage;
import com.ssafy.pickachu.domain.cards.recommend.dto.CardsListReq;
import com.ssafy.pickachu.domain.cards.recommend.entity.CardInfo;

import java.util.List;

public interface CardsAggregation {

    CardsListPage GetCardsCategoryPage(CardsListReq cardsListReq, List<String> cardsRanking);

    List<CardInfo> GetCardsCategoList(String category);
}
