package com.ssafy.pickachu.domain.cards.recommend.service;

import com.ssafy.pickachu.domain.cards.recommend.dto.CardDetailRes;
import com.ssafy.pickachu.domain.cards.recommend.dto.CardsListPage;
import com.ssafy.pickachu.domain.cards.recommend.dto.CardsListReq;

public interface RecommendService {
    public CardsListPage getCategoryCardsList(CardsListReq cardsListReq);

    public CardDetailRes getCardDetail(String cardsId);

}
